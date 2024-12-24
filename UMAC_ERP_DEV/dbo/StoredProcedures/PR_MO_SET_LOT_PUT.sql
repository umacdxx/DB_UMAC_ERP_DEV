
/*
-- 생성자 :	최수민
-- 등록일 :	2024.08.13
-- 설 명  : 모바일(API) SET 관련 메뉴 LOT 저장
			A. 생산자재등록 상세 LOT 저장
			C. 자재환원등록 상세 LOT 저장
-- 수정자 : -
-- 수정일 : 2024.12.05 임현태 - PD_SET_RESULT_COMP에 COMP_CFM_FLAG 로직 추가
			2024.12.09 임현태 - SET_PLAN_MST COMP_CFM_FLAG, RESTORE_CFM_FLAG 컬럼 삭제, 확정구분 변경에 CURSOR 적용
			2024.12.12 임현태 - PD_SET_RESULT_COMP 조회시 PRIMARY키를 통해 조회하도록 수정
			2024.12.16 최수민 - CD_LOT_MST에 데이터가 없으면 신규 데이터 삽입
			2024.12.17 임현태 - 소비기한을 투입 제품의 소비기한으로 계산하여 들어가도록 변경, 
								PD_SET_PLAN_MST 작업상태 부자재를 제외한 첫 데이터가 등록되는 경우로 조건 변경
-- 실행문 : 

DECLARE @JSONDT NVARCHAR(MAX) = 
'{	
	"setLotRQ": [
			{
			  "PROD_DT": "string",
			  "SEQ": 0,
			  "SET_COMP_CD": "string",
			  "LOT_NO": "string",
			  "COMP_QTY": 0,
			  "RESTORE_YN": "string"
			}
		],
	"setInfoRQ": {
		"SET_PLAN_ID": "string",
		"EMP_ID": "string",
		"MENU_GUBUN": "string",
		"MODE": "string" // (I:저장/U:수정/D:삭제/C:확정)
	}
}'
	EXEC PR_MO_SET_LOT_PUT @JSONDT
*/
CREATE PROCEDURE [dbo].[PR_MO_SET_LOT_PUT]
( 	
	@P_JSONDT			VARCHAR(8000) = ''
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @RETURN_CODE	INT = 0										-- 리턴코드(저장완료)
	DECLARE @RETURN_MESSAGE NVARCHAR(MAX) = DBO.GET_ERR_MSG('0')		-- 리턴메시지
	
	BEGIN TRAN
	BEGIN TRY 

		DECLARE
			@P_SET_PLAN_ID NVARCHAR(11),
			@P_EMP_ID NVARCHAR(20),
			@P_MENU_GUBUN NVARCHAR(1),
			@P_SEQ INT,
			@P_MODE NVARCHAR(1)
			;

		DECLARE @TMP_ITEM TABLE (
			PROD_DT NVARCHAR(8),
			SEQ INT,
			SET_COMP_CD NVARCHAR(14),
			LOT_NO NVARCHAR(30),
			COMP_QTY INT,
			RESTORE_YN NVARCHAR(1)
		);

		DECLARE @TMP_INFO TABLE (
			SET_PLAN_ID NVARCHAR(11),
			EMP_ID NVARCHAR(20),
			MENU_GUBUN NVARCHAR(1),
			MODE NVARCHAR(1)
		);

		--#SET 기본 정보
		INSERT INTO @TMP_INFO
		SELECT SET_PLAN_ID, EMP_ID, MENU_GUBUN, MODE
		  FROM OPENJSON ( @P_JSONDT, '$.setInfoRQ' )   
		  WITH ( SET_PLAN_ID NVARCHAR(11) '$.SET_PLAN_ID'
			   , EMP_ID NVARCHAR(20) '$.EMP_ID'
			   , MENU_GUBUN NVARCHAR(1) '$.MENU_GUBUN'
			   , MODE NVARCHAR(1) '$.MODE'
			   )
			   			   
		SELECT @P_SET_PLAN_ID = SET_PLAN_ID
			 , @P_EMP_ID = EMP_ID
			 , @P_MENU_GUBUN = MENU_GUBUN
			 , @P_MODE = MODE
		  FROM @TMP_INFO
		  ;

		--시퀀스
		SELECT @P_SEQ = COALESCE(MAX(SEQ), 0) + 1
		  FROM PD_SET_RESULT_COMP
		 WHERE SET_PLAN_ID = @P_SET_PLAN_ID
		 ;

		 --#SET 생산자재등록 LOT 정보
		INSERT INTO @TMP_ITEM
		SELECT PROD_DT
			 , CASE WHEN SEQ = 0 THEN ROW_NUMBER() OVER (ORDER BY SET_COMP_CD) + @P_SEQ - 1
					ELSE SEQ END AS SEQ
             , SET_COMP_CD
             , LOT_NO
             , COMP_QTY
             , RESTORE_YN
		  FROM OPENJSON ( @P_JSONDT, '$.setLotRQ' )   
		  WITH ( PROD_DT NVARCHAR(8) '$.PROD_DT'
			   , SEQ INT '$.SEQ'
			   , SET_COMP_CD NVARCHAR(14) '$.SET_COMP_CD'
			   , LOT_NO NVARCHAR(30) '$.LOT_NO'
			   , COMP_QTY INT '$.COMP_QTY'
			   , RESTORE_YN NVARCHAR(1) '$.RESTORE_YN'
			   );


------------------------------------------------------------
-- 1. @P_MENU_GUBUN 구분값에 따른 데이터 별도 저장 로직
------------------------------------------------------------

		--#생산자재등록
		--처음 데이터가 저장되는 경우, PD_SET_PLAN_MST의 STATUS를 변경 (작업 진행중)
		-- 2024.12.17 임현태 부자재를 제외한 첫 데이터가 등록되는 경우로 조건 변경
		UPDATE PD_SET_PLAN_MST
		   SET SET_STATUS = '2'
			 , UDATE = GETDATE()
			 , UEMP_ID = @P_EMP_ID
		  FROM PD_SET_PLAN_MST AS M
		 INNER JOIN @TMP_ITEM AS TMP ON M.SET_PLAN_ID = @P_SET_PLAN_ID
		 WHERE @P_MENU_GUBUN = 'A'
		   AND NOT EXISTS ( SELECT 1
							 FROM PD_SET_RESULT_COMP AS R
							WHERE R.SET_PLAN_ID = @P_SET_PLAN_ID
							  AND R.LOT_NO IS NOT NULL
						  );
		
------------------------------------------------------------
-- 2. SET 제품 하위 생산 결과 저장 (INSERT, UPDATE, DELETE)
------------------------------------------------------------

        MERGE INTO PD_SET_RESULT_COMP AS COMP
        USING (
			SELECT SEQ
				 , PROD_DT
				 , SET_COMP_CD
				 , LOT_NO
				 , COMP_QTY
				 , RESTORE_YN
			  FROM @TMP_ITEM
			) AS TMP 
		   ON COMP.SET_PLAN_ID = @P_SET_PLAN_ID
          AND COMP.SEQ = TMP.SEQ
         WHEN MATCHED AND @P_MODE = 'D' THEN
			  DELETE
         WHEN MATCHED AND @P_MODE <> 'D' THEN
			  UPDATE SET COMP.COMP_QTY = CASE WHEN @P_MODE = 'U' THEN TMP.COMP_QTY
											  WHEN @P_MODE = 'I' THEN COMP.COMP_QTY + TMP.COMP_QTY
											  ELSE COMP.COMP_QTY END
					   , COMP.UDATE = GETDATE()
					   , COMP.UEMP_ID = @P_EMP_ID
         WHEN NOT MATCHED AND @P_MODE <> 'D' THEN
			  INSERT (
					SET_PLAN_ID,
					SEQ,
					PROD_DT,
					SET_COMP_CD,
					LOT_NO,
					COMP_QTY,
					RESTORE_YN,
					IDATE,
					IEMP_ID
			   )
			   VALUES (
					@P_SET_PLAN_ID,
					TMP.SEQ,
					TMP.PROD_DT,
					TMP.SET_COMP_CD,
					TMP.LOT_NO,
					TMP.COMP_QTY,
					TMP.RESTORE_YN,
					GETDATE(),
					@P_EMP_ID
			   );


------------------------------------------------------------
-- 3. 재고조정 프로시저 실행 (INSERT, UPDATE, DELETE)
------------------------------------------------------------

		-- 재고 조정 프로시저 실행
		DECLARE CURSOR_TEMP_W_SEQ CURSOR FOR
		SELECT PROD_DT, SEQ, SET_COMP_CD, LOT_NO, COMP_QTY FROM @TMP_ITEM;

		DECLARE @FETCH_PROD_DT NVARCHAR(8),         -- 생산일자
				@FETCH_SEQ INT,						-- 순번
				@FETCH_SET_COMP_CD NVARCHAR(14),    -- 제품코드
				@FETCH_LOT_NO NVARCHAR(30),         -- LOT 번호
				@FETCH_COMP_QTY NUMERIC(15,2),      -- 수량
				@P_STOCK_SEQ INT = 0,               -- 재고조정 SEQ
				@P_INV_GB NVARCHAR(2)				-- 재고조정 사유코드
				;

		--재고조정 사유 상세코드 아이디
		SELECT @P_INV_GB = CD_ID
		  FROM TBL_COMM_CD_MST 
		 WHERE CD_CL = 'INV_ADJ_GB'
		   AND MGMT_ENTRY_1 = 'SET'
		   AND MGMT_ENTRY_2 = @P_MENU_GUBUN		 

		OPEN CURSOR_TEMP_W_SEQ
		FETCH NEXT FROM CURSOR_TEMP_W_SEQ INTO 
			@FETCH_PROD_DT,
			@FETCH_SEQ,
			@FETCH_SET_COMP_CD,
			@FETCH_LOT_NO,
			@FETCH_COMP_QTY;
			
			WHILE @@FETCH_STATUS = 0
			BEGIN

				SELECT @FETCH_COMP_QTY = CAST(CASE WHEN RESTORE_YN = 'N' THEN COMP_QTY * -1 ELSE COMP_QTY END AS NUMERIC(15,2))
				  FROM PD_SET_RESULT_COMP
				 WHERE SET_PLAN_ID = @P_SET_PLAN_ID
				   AND SEQ = @FETCH_SEQ


				-- 단품 재고 조정 SEQ 조회
				SELECT @P_STOCK_SEQ = SEQ
				  FROM IV_STOCK_ADJUST
				 WHERE SCAN_CODE = @FETCH_SET_COMP_CD
				   AND INV_DT = @FETCH_PROD_DT
				   AND INV_GB = @P_INV_GB
				   AND LOT_NO = @FETCH_LOT_NO
				   AND CFM_FLAG = 'N'
				   ;

				-- CD_LOT_MST에 데이터 넣기 위해 소비기한 조회
				-- 2024.12.17 임현태 소비기한을 투입 제품의 소비기한으로 계산하여 들어가도록 변경
				DECLARE @P_SET_EXPIRY_DATE NVARCHAR(8),		-- 소비기한
						@P_PROD_DT NVARCHAR(8);				-- 생산일자
				 
				SELECT @P_SET_EXPIRY_DATE = EXPIRATION_DT, @P_PROD_DT = PROD_DT FROM CD_LOT_MST WHERE LOT_NO = LEFT(@FETCH_LOT_NO, LEN(@FETCH_LOT_NO) - 2)	

				-- 단품 재고 조정 프로시저 호출
				IF @P_MODE IN ('I', 'U')
				BEGIN
					--2024.12.16 최수민 CD_LOT_MST에 데이터가 없으면 신규 데이터 삽입
					IF NOT EXISTS ( SELECT 1 FROM CD_LOT_MST WHERE LOT_NO = @FETCH_LOT_NO )
					BEGIN
						INSERT INTO CD_LOT_MST 
						(
							PROD_DT
							, SCAN_CODE
							, EXPIRATION_DT
							, PROD_GB
							, PROD_GB_CD
							, LOT_NO
							, PROD_QTY
							, PROD_APP_QTY
							, CFM_FLAG
							, CFM_EMP_ID
							, CFM_DT
							, IDATE
							, IEMP_ID
						)
						VALUES
						(
							  @P_PROD_DT
	 						, @FETCH_SET_COMP_CD
							, @P_SET_EXPIRY_DATE
	 						, 'B'
	 						, '1'
	 						, @FETCH_LOT_NO
	 						, 0
							, 0
							, 'Y'
							, @P_EMP_ID
							, CONVERT(NVARCHAR(8), GETDATE(), 112)
	 						, GETDATE()
	 						, @P_EMP_ID
						)
					END

					EXEC PR_SINGLE_STOCK_AD_PUT @P_STOCK_SEQ, @FETCH_PROD_DT, @FETCH_SET_COMP_CD, @P_INV_GB, '', @FETCH_LOT_NO, '', @FETCH_COMP_QTY, '', @P_EMP_ID, 0;
				END
				ELSE IF @P_MODE = 'C'
				BEGIN
					EXEC PR_SINGLE_STOCK_AD_CONFIRM @P_STOCK_SEQ, @P_EMP_ID, 'Y';
				END
				ELSE IF @P_MODE = 'D'
				BEGIN
					EXEC PR_SINGLE_STOCK_AD_CONFIRM @P_STOCK_SEQ, @P_EMP_ID, 'D';
				END


				FETCH NEXT FROM CURSOR_TEMP_W_SEQ INTO 
					@FETCH_PROD_DT,
					@FETCH_SEQ,
					@FETCH_SET_COMP_CD,
					@FETCH_LOT_NO,
					@FETCH_COMP_QTY;
			END;

		CLOSE CURSOR_TEMP_W_SEQ;

		
------------------------------------------------------------
-- 4. 확정 구분 변경
------------------------------------------------------------

		IF @P_MODE = 'C'
		BEGIN
			OPEN CURSOR_TEMP_W_SEQ
			FETCH NEXT FROM CURSOR_TEMP_W_SEQ INTO 
				@FETCH_PROD_DT,
				@FETCH_SEQ,
				@FETCH_SET_COMP_CD,
				@FETCH_LOT_NO,
				@FETCH_COMP_QTY;
 
				WHILE @@FETCH_STATUS = 0
				BEGIN
					UPDATE PD_SET_RESULT_COMP 
					   SET COMP_CFM_FLAG = 'Y'
						 , COMP_QTY = @FETCH_COMP_QTY
						 , UEMP_ID = @P_EMP_ID
						 , UDATE = GETDATE()
					 WHERE SET_PLAN_ID = @P_SET_PLAN_ID 
					   AND SEQ = @FETCH_SEQ

					FETCH NEXT FROM CURSOR_TEMP_W_SEQ INTO 
						@FETCH_PROD_DT,
						@FETCH_SEQ,
						@FETCH_SET_COMP_CD,
						@FETCH_LOT_NO,
						@FETCH_COMP_QTY;
				END
				 
			CLOSE CURSOR_TEMP_W_SEQ
		END
		DEALLOCATE CURSOR_TEMP_W_SEQ;

		
		SET @RETURN_CODE = 0; -- 저장완료
		SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('0');

	COMMIT
	END TRY
	
	BEGIN CATCH		
		
		IF @@TRANCOUNT > 0
		BEGIN 
			ROLLBACK TRAN
			SET @RETURN_CODE = -1
			SET @RETURN_MESSAGE = ERROR_MESSAGE()

			--에러 로그 테이블 저장
			INSERT INTO TBL_ERROR_LOG 
			SELECT ERROR_PROCEDURE()		-- 프로시저명
				, ERROR_MESSAGE()			-- 에러메시지
				, ERROR_LINE()				-- 에러라인
				, GETDATE()	
		END 
	

	END CATCH
	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE 
	
END

GO

