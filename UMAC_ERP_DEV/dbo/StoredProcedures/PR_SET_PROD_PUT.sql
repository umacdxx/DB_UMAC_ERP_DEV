/*
-- 생성자 :	윤현빈
-- 등록일 :	2024.08.13
-- 수정자 : 최수민
-- 수정일 : 2024.08.21 - 삭제 로직 추가
			2024.11.20 강세미- 확정 로직 추가, LOT 생성
			2024.12.04 임현태 - 부자재 재고 조정 로직 추가
			2024.12.06 임현태 - 공박스 재고 처리 로직 추가
			2024.12.12 임현태 - SET 제품 하위 생산 결과 저장에서 ON 조건을 PRIMARY KEY로 수정
								PD_SET_RESULT_COMP 부자재 확정컬럼 'Y' 업데이트 로직 추가
			2024.12.19 임현태 - PR_IV_PRODUCT_STAT_HDR_PUT 파라미터 순서 오류 수정
-- 설 명  : SET 생산 등록
-- 실행문 : EXEC PR_SET_PROD_PUT_TEST '', ''
			EXEC PR_SET_PROD_PUT_TEST '[{"SET_PLAN_ID":"SET20241101","PROD_DT":"20241121","SCAN_CODE":"8801047865636","PROD_QTY":1000,"LOT_NO":"20241121-MX-DW-210119","CONFIRM_GB":"Y"}]', 'admin'
*/
CREATE PROCEDURE [dbo].[PR_SET_PROD_PUT]
( 
	@P_JSONDT			VARCHAR(8000) = '',
	@P_EMP_ID			NVARCHAR(20)				-- 아이디
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @OuterFetchStatus	INT
	DECLARE @InnerFetchStatus	INT
	DECLARE @PRE_QTY			INT				= 0
	DECLARE @RETURN_CODE 		INT 			= 0		-- 리턴코드
	DECLARE @RETURN_MESSAGE		NVARCHAR(10) 	= '' 	-- 리턴메시지
	
	DECLARE @V_PRE_QTY INT;
	DECLARE @SET_EXPIRY_DATE  NVARCHAR(8)			-- 소비기한
	DECLARE @LOT_INFO		  NVARCHAR(30)			-- LOT생성정보
	DECLARE @LOT_NO			  NVARCHAR(30)			-- LOT번호
	DECLARE @PROD_GB_CD		  NVARCHAR(3)			-- SET 코드

	BEGIN TRAN
	BEGIN TRY

		DECLARE @TMP_ITEM TABLE (
			PROD_DT NVARCHAR(8),
			SCAN_CODE NVARCHAR(14),
			PROD_QTY INT,
			SET_PLAN_ID NVARCHAR(11),
			MODE NVARCHAR(1),
			CONFIRM_GB NVARCHAR(1)
		)
		
		INSERT INTO @TMP_ITEM
		SELECT PROD_DT, SCAN_CODE, PROD_QTY, SET_PLAN_ID, MODE, CONFIRM_GB
			FROM 
				OPENJSON ( @P_JSONDT )   
					WITH (    
						PROD_DT NVARCHAR(8) '$.PROD_DT',
						SCAN_CODE NVARCHAR(14) '$.SCAN_CODE',
						PROD_QTY INT '$.PROD_QTY',
						SET_PLAN_ID NVARCHAR(11) '$.SET_PLAN_ID',
						MODE NVARCHAR(1) '$.MODE',
						CONFIRM_GB NVARCHAR(1) '$.CONFIRM_GB'
					)
				
		DECLARE CURSOR_SET_PLAN CURSOR FOR

			SELECT A.PROD_DT, A.SCAN_CODE, A.PROD_QTY, A.SET_PLAN_ID, A.MODE, A.CONFIRM_GB
				FROM @TMP_ITEM A
				INNER JOIN CD_PRODUCT_CMN AS B ON A.SCAN_CODE = B.SCAN_CODE
			
		OPEN CURSOR_SET_PLAN

		DECLARE @P_PROD_DT NVARCHAR(8),
		        @P_SCAN_CODE NVARCHAR(14),
				@P_PROD_QTY INT,
				@P_SET_PLAN_ID NVARCHAR(11),
				@P_MODE NVARCHAR(1),
				@P_CONFIRM_GB NVARCHAR(1)

		FETCH NEXT FROM CURSOR_SET_PLAN INTO @P_PROD_DT, @P_SCAN_CODE, @P_PROD_QTY, @P_SET_PLAN_ID, @P_MODE, @P_CONFIRM_GB
			set @OuterFetchStatus = @@FETCH_STATUS
			WHILE(@OuterFetchStatus=0)
			BEGIN
				SELECT @V_PRE_QTY = ISNULL(MAX(PROD_QTY), 0) FROM PD_SET_RESULT_PROD WHERE SET_PLAN_ID = @P_SET_PLAN_ID AND PROD_DT = @P_PROD_DT AND SCAN_CODE = @P_SCAN_CODE;	
				------------------------------------------------------------
				SELECT @SET_EXPIRY_DATE = SET_EXPIRY_DATE FROM PD_SET_PLAN_PROD WHERE SET_PLAN_ID = @P_SET_PLAN_ID AND SCAN_CODE = @P_SCAN_CODE
				SELECT @LOT_INFO = DBO.GET_WT_LOT_NO_CREATE(@P_SCAN_CODE,'',@P_PROD_DT, @SET_EXPIRY_DATE)
				SET @LOT_NO = DBO.FN_GET_SPLIT(@LOT_INFO,'|', 1)		--LOT 번호
				SELECT @PROD_GB_CD = SET_CD FROM CD_SET_HDR WHERE SET_PROD_CD = @P_SCAN_CODE
				------------------------------------------------------------

				-- 임시 테이블 생성
				--CREATE TABLE #Temp_W_SEQ (
				--	SET_PLAN_ID VARCHAR(11),
				--	SEQ INT,
				--	PROD_DT VARCHAR(8),
				--	SET_COMP_CD VARCHAR(14),
				--	PRE_COMP_QTY INT,
				--	COMP_QTY INT,
				--	New_SEQ INT
				--);
				IF OBJECT_ID('tempdb..#Temp_W_SEQ') IS NOT NULL
				BEGIN
					TRUNCATE TABLE #Temp_W_SEQ; -- 테이블 초기화
				END
				ELSE
				BEGIN
					CREATE TABLE #Temp_W_SEQ (
						SET_PLAN_ID VARCHAR(11),
						SEQ INT,
						PROD_DT VARCHAR(8),
						SET_COMP_CD VARCHAR(14),
						PRE_COMP_QTY INT,
						COMP_QTY INT,
						New_SEQ INT
					);
				END;

				-- 임시 테이블에 데이터 삽입
				INSERT INTO #Temp_W_SEQ (SET_PLAN_ID, SEQ, PROD_DT, SET_COMP_CD, PRE_COMP_QTY, COMP_QTY, New_SEQ)
				SELECT 
					B.SET_PLAN_ID,
					B.SEQ,
					B.PROD_DT,
					B.SET_COMP_CD,
					B.PRE_COMP_QTY,
					B.COMP_QTY,
					ROW_NUMBER() OVER (PARTITION BY B.SET_PLAN_ID ORDER BY B.SET_COMP_CD) 
					+ ISNULL((SELECT MAX(SEQ) FROM PD_SET_RESULT_COMP WHERE SET_PLAN_ID = B.SET_PLAN_ID), 0) AS New_SEQ
				FROM (
					SELECT 
						A.SET_PLAN_ID,
						ISNULL(B.SEQ, NULL) AS SEQ,
						@P_PROD_DT AS PROD_DT,
						DTL.SET_COMP_CD,
						ISNULL(B.COMP_QTY, 0) AS PRE_COMP_QTY,
						DTL.COMP_QTY * @P_PROD_QTY AS COMP_QTY
					FROM CD_SET_HDR AS HDR
					INNER JOIN CD_SET_DTL AS DTL ON HDR.SET_CD = DTL.SET_CD
					INNER JOIN PD_SET_PLAN_COMP AS A ON HDR.SET_PROD_CD = A.SCAN_CODE AND DTL.SET_COMP_CD = A.SET_COMP_CD AND A.SET_PLAN_ID = @P_SET_PLAN_ID
					LEFT OUTER JOIN PD_SET_RESULT_COMP AS B ON A.SET_PLAN_ID = B.SET_PLAN_ID AND B.PROD_DT = @P_PROD_DT AND HDR.SET_PROD_CD = B.SCAN_CODE AND A.SET_COMP_CD = B.SET_COMP_CD AND B.RESTORE_YN = 'N'
					LEFT OUTER JOIN (
						SELECT MAX(LOT_NO) AS LOT_NO, SCAN_CODE
						FROM CD_LOT_MST AS MST_LOT
						GROUP BY SCAN_CODE
					) AS LOT ON DTL.SET_COMP_CD = LOT.SCAN_CODE
					WHERE HDR.SET_PROD_CD = @P_SCAN_CODE
						AND LOT.LOT_NO IS NULL
				) B;

------------------------------------------------------------
-- 저장
------------------------------------------------------------
				IF @P_CONFIRM_GB = 'N' 
				BEGIN

				------------------------------------------------------------
				-- 1. SET 제품 생산 결과 및 LOT 저장
				------------------------------------------------------------
				MERGE INTO PD_SET_RESULT_PROD AS A
					USING (select 1 as dual) AS B
					ON A.SET_PLAN_ID = @P_SET_PLAN_ID AND A.PROD_DT = @P_PROD_DT AND A.SCAN_CODE = @P_SCAN_CODE
				WHEN MATCHED AND @P_MODE = 'D' THEN
					DELETE
				WHEN MATCHED AND @P_MODE <> 'D' THEN
					UPDATE 
						SET PROD_QTY = CASE WHEN @P_MODE = 'U' THEN @P_PROD_QTY
											WHEN @P_MODE = 'I' THEN PROD_QTY + @P_PROD_QTY
											ELSE PROD_QTY END
						  , UDATE = GETDATE()
						  , UEMP_ID = @P_EMP_ID
				WHEN NOT MATCHED AND @P_MODE <> 'D' THEN
					INSERT
					(
						SET_PLAN_ID
						, PROD_DT
						, SCAN_CODE
						, PROD_QTY
						, IDATE
						, IEMP_ID
						, UDATE
						, UEMP_ID
					)
					VALUES
					(
						@P_SET_PLAN_ID
						, @P_PROD_DT
						, @P_SCAN_CODE
						, @P_PROD_QTY
						, GETDATE()
						, @P_EMP_ID
						, NULL
						, NULL
					);
					 
				-- LOT 저장
				MERGE INTO CD_LOT_MST AS A
					USING (select 1 as dual) AS B
					ON A.LOT_NO = @LOT_NO AND A.PROD_DT = @P_PROD_DT AND A.SCAN_CODE = @P_SCAN_CODE
				WHEN MATCHED AND @P_MODE = 'D' THEN
					DELETE
				WHEN MATCHED AND @P_MODE <> 'D' THEN
					UPDATE 
						SET PROD_QTY = CASE WHEN @P_MODE = 'U' THEN @P_PROD_QTY
											WHEN @P_MODE = 'I' THEN PROD_QTY + @P_PROD_QTY
											ELSE PROD_QTY END
						  , UDATE = GETDATE()
						  , UEMP_ID = @P_EMP_ID
				WHEN NOT MATCHED AND @P_MODE <> 'D' THEN
					INSERT
					(
						PROD_DT
						, SCAN_CODE
						, LOT_NO
						, EXPIRATION_DT
						, PROD_GB
						, PROD_GB_CD
						, PROD_QTY
						, PROD_APP_QTY
						, CFM_FLAG
						, CFM_EMP_ID
						, CFM_DT
						, IDATE
						, IEMP_ID

					)
					VALUES(
						@P_PROD_DT
						, @P_SCAN_CODE
						, @LOT_NO
						, @SET_EXPIRY_DATE
						, 'S'
						, @PROD_GB_CD
						, @P_PROD_QTY
						, 0
						, 'N'
						, NULL
						, NULL
						, GETDATE()
						, @P_EMP_ID
					)
					;
				------------------------------------------------------------
				-- 2. SET 제품 하위 생산 결과 저장
				--  LOT없는 부자재류 만 처리, LOT 있는 제품들은 PDA에서 처리
				------------------------------------------------------------
				
				-- MERGE 문 실행
				MERGE INTO PD_SET_RESULT_COMP AS A
				USING #Temp_W_SEQ AS B
				ON (A.SET_PLAN_ID = B.SET_PLAN_ID AND A.SEQ = B.SEQ)
				--ON (A.SET_PLAN_ID = B.SET_PLAN_ID AND A.SEQ = B.SEQ AND A.LOT_NO IS NULL AND A.RESTORE_YN = 'N')
				WHEN MATCHED AND @P_MODE = 'D' THEN
					DELETE
				WHEN MATCHED AND @P_MODE <> 'D' THEN
					UPDATE 
						SET A.COMP_QTY = CASE WHEN @P_MODE = 'U' THEN B.COMP_QTY
											  WHEN @P_MODE = 'I' THEN A.COMP_QTY + B.COMP_QTY
											  ELSE A.COMP_QTY END,
							A.UDATE = GETDATE(),
							A.UEMP_ID = @P_EMP_ID
				WHEN NOT MATCHED AND @P_MODE <> 'D' THEN
					INSERT 
					(
						SET_PLAN_ID,
						SEQ,
						PROD_DT,
						SCAN_CODE,
						SET_COMP_CD,
						LOT_NO,
						RESTORE_YN,
						COMP_QTY,
						IDATE,
						IEMP_ID,
						UDATE,
						UEMP_ID
					)
					VALUES 
					(
						B.SET_PLAN_ID,
						B.New_SEQ,
						B.PROD_DT,
						@P_SCAN_CODE,
						B.SET_COMP_CD,
						NULL,
						'N',
						B.COMP_QTY,
						GETDATE(),
						@P_EMP_ID,
						NULL,
						NULL
					);
				------------------------------------------------------------
				-- 부자재 사용량 재고처리 CFM_FLAG = 'N'
				------------------------------------------------------------
				MERGE INTO PD_BOM_SET_HIST AS A
				USING #Temp_W_SEQ AS B
				ON (A.PROD_DT = B.PROD_DT AND A.PROD_GB = 'S' AND A.BOM_SET_CD = @PROD_GB_CD AND A.LOT_NO = @LOT_NO AND A.BOM_SET_COMP_CD = B.SET_COMP_CD)			
				WHEN MATCHED AND @P_MODE = 'D' THEN
					DELETE
				WHEN MATCHED AND @P_MODE <> 'D' THEN
					UPDATE 
						SET A.COMP_QTY = CASE WHEN @P_MODE = 'U' THEN -B.COMP_QTY
											  WHEN @P_MODE = 'I' THEN A.COMP_QTY - B.COMP_QTY
											  ELSE A.COMP_QTY END,
							A.COMP_APP_QTY = CASE WHEN @P_MODE = 'U' THEN -B.COMP_QTY
											  WHEN @P_MODE = 'I' THEN A.COMP_APP_QTY - B.COMP_QTY
											  ELSE A.COMP_QTY END,
							A.UDATE = GETDATE(),
							A.UEMP_ID = @P_EMP_ID
				WHEN NOT MATCHED AND @P_MODE <> 'D' THEN
					INSERT (
								PROD_DT, 
								PROD_GB, 
								BOM_SET_CD, 
								LOT_NO, 
								BOM_SET_COMP_CD, 
								COMP_QTY, 
								COMP_APP_QTY, 
								CFM_FLAG, 
								IDATE, 
								IEMP_ID
							)								 
					VALUES (
								B.PROD_DT,
								'S', 
								@PROD_GB_CD, 
								@LOT_NO,
								B.SET_COMP_CD, 
								-B.COMP_QTY,
								-B.COMP_QTY,
								'N',
								GETDATE(),
								@P_EMP_ID
							);
				END
				ELSE 
				BEGIN
------------------------------------------------------------
-- 확정
------------------------------------------------------------
				SELECT @LOT_NO = LOT_NO FROM CD_LOT_MST WHERE PROD_DT = @P_PROD_DT AND SCAN_CODE = @P_SCAN_CODE
				
				------------------------------------------------------------
				-- 1. SET 제품 생산 결과 재고처리
				------------------------------------------------------------
				DECLARE @V_ADJ_QTY INT;
				DECLARE @V_PRE_QTY_ADJ INT;

				--SET @V_ADJ_QTY = CASE WHEN @P_MODE = 'D' THEN 0 ELSE @P_PROD_QTY END;
				--SET @V_PRE_QTY_ADJ = CASE WHEN @P_MODE = 'D' THEN @P_PROD_QTY ELSE @V_PRE_QTY END;
				SET @V_ADJ_QTY = @P_PROD_QTY;

				--EXEC PR_IV_PRODUCT_STAT_HDR_PUT @P_SCAN_CODE, @V_ADJ_QTY, 'PR_SET_PROD_PUT', @V_PRE_QTY_ADJ, '', '', @LOT_NO, @RETURN_CODE, @RETURN_MESSAGE;
				EXEC PR_IV_PRODUCT_STAT_HDR_PUT @P_SCAN_CODE, @V_ADJ_QTY, 'PR_SET_PROD_PUT', 0, @LOT_NO, '', '', @RETURN_CODE, @RETURN_MESSAGE;

				------------------------------------------------------------
				-- SET 제품 생산에 의한 공박스 재고처리 (임현태)
				------------------------------------------------------------
				DECLARE @U_BOX_QTY INT;
				DECLARE @COMP_CODE NVARCHAR(14);

				SELECT @U_BOX_QTY = CEILING(CAST(@V_ADJ_QTY AS FLOAT)/CAST(A.IPSU_QTY AS FLOAT)),
				   	   @COMP_CODE = B.MGMT_ENTRY_1
				FROM CD_BOX_MST AS A 
				INNER JOIN TBL_COMM_CD_MST AS B ON A.ITM_CODE = B.CD_ID
				INNER JOIN CD_PRODUCT_CMN AS C ON A.ITM_CODE = C.ITM_CODE
				WHERE C.SCAN_CODE = @P_SCAN_CODE

				INSERT INTO 
				PD_MAT_USAGE (
								PROD_DT,
								SCAN_CODE,
								COMP_CODE,
								MAT_GB,
								YYYYMM,
								INPUT_QTY,
								IDATE,
								IEMP_ID
							 ) 
					 VALUES (
								@P_PROD_DT,
								@P_SCAN_CODE,
								@COMP_CODE,
								'5',
								SUBSTRING(@P_PROD_DT, 1, 6),
								@U_BOX_QTY,
								GETDATE(),
								@P_EMP_ID
					 	    )

				------------------------------------------------------------
				--2. SET 제품 하위 생산 결과 재고처리
				------------------------------------------------------------
				DECLARE CURSOR_TEMP_W_SEQ CURSOR FOR
				SELECT SET_PLAN_ID, SEQ, PROD_DT, SET_COMP_CD, PRE_COMP_QTY, COMP_QTY
				FROM #Temp_W_SEQ;

				OPEN CURSOR_TEMP_W_SEQ;

				DECLARE @T_SET_PLAN_ID VARCHAR(11) ,
						@T_SEQ INT,
						@T_PROD_DT VARCHAR(8),
						@T_SET_COMP_CD VARCHAR(14),
						@T_PRE_COMP_QTY INT,
						@T_COMP_QTY INT;

				FETCH NEXT FROM CURSOR_TEMP_W_SEQ INTO @T_SET_PLAN_ID, @T_SEQ, @T_PROD_DT, @T_SET_COMP_CD, @T_PRE_COMP_QTY, @T_COMP_QTY;
				SET @InnerFetchStatus = @@FETCH_STATUS

				WHILE @InnerFetchStatus = 0
				BEGIN
					--SET @V_ADJ_QTY = CASE WHEN @P_MODE = 'D' THEN 0 ELSE -@T_COMP_QTY END;
					--SET @V_PRE_QTY_ADJ = CASE WHEN @P_MODE = 'D' THEN -@T_COMP_QTY ELSE -@T_PRE_COMP_QTY END;
					SET @V_ADJ_QTY = -@T_COMP_QTY;
	        
					--EXEC PR_IV_PRODUCT_STAT_HDR_PUT @T_SET_COMP_CD, @V_ADJ_QTY, 'PR_SET_PROD_PUT', @V_PRE_QTY_ADJ, '', '', '', @RETURN_CODE, @RETURN_MESSAGE;
					EXEC PR_IV_PRODUCT_STAT_HDR_PUT @T_SET_COMP_CD, @V_ADJ_QTY, 'PR_SET_PROD_PUT', 0, '', '', '', @RETURN_CODE, @RETURN_MESSAGE;

					-- 부자재류 사용량 재고 처리 
					------------------------------------------------------------
					UPDATE PD_BOM_SET_HIST SET 	COMP_QTY = @V_ADJ_QTY, 
												COMP_APP_QTY = @V_ADJ_QTY, 
												CFM_FLAG = 'Y', 
												UDATE = GETDATE(), 
												UEMP_ID = @P_EMP_ID
										WHERE PROD_DT = @T_PROD_DT AND PROD_GB = 'S' AND BOM_SET_CD = @PROD_GB_CD AND LOT_NO = @LOT_NO AND BOM_SET_COMP_CD = @T_SET_COMP_CD;
					------------------------------------------------------------

					UPDATE PD_SET_RESULT_COMP SET COMP_CFM_FLAG = 'Y',
												  UDATE = GETDATE(), 
												  UEMP_ID = @P_EMP_ID
										WHERE SET_PLAN_ID = @T_SET_PLAN_ID AND SEQ = @T_SEQ

					FETCH NEXT FROM CURSOR_TEMP_W_SEQ INTO @T_SET_PLAN_ID, @T_SEQ, @T_PROD_DT, @T_SET_COMP_CD, @T_PRE_COMP_QTY, @T_COMP_QTY;
					set @InnerFetchStatus = @@FETCH_STATUS 
				END;

				------------------------------------------------------------
				-- 3. LOT 확정처리
				------------------------------------------------------------
				UPDATE CD_LOT_MST
				   SET CFM_DT = FORMAT(GETDATE(), 'yyyyMMdd')
				     , CFM_EMP_ID = @P_EMP_ID
					 , CFM_FLAG = 'Y'
					 , PROD_APP_QTY = PROD_QTY
				 WHERE PROD_DT = @P_PROD_DT AND SCAN_CODE = @P_SCAN_CODE AND LOT_NO = @LOT_NO

				UPDATE PD_SET_RESULT_PROD 
				   SET PROD_CFM_FLAG = 'Y',
					   UDATE = GETDATE(), 
					   UEMP_ID = @P_EMP_ID
				 WHERE SET_PLAN_ID = @P_SET_PLAN_ID
				   AND PROD_DT = @P_PROD_DT
				   AND SCAN_CODE = @P_SCAN_CODE

				CLOSE CURSOR_TEMP_W_SEQ;
				DEALLOCATE CURSOR_TEMP_W_SEQ;

			END
			
			-- 작업 완료 후 임시테이블 삭제
			DROP TABLE #Temp_W_SEQ;
		
		FETCH NEXT FROM CURSOR_SET_PLAN INTO @P_PROD_DT, @P_SCAN_CODE, @P_PROD_QTY, @P_SET_PLAN_ID, @P_MODE, @P_CONFIRM_GB
		set @OuterFetchStatus = @@FETCH_STATUS
		END


		CLOSE CURSOR_SET_PLAN
		DEALLOCATE CURSOR_SET_PLAN
		
		SET @RETURN_CODE = 0; -- 저장완료
		SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('0');
		COMMIT;
	END TRY
	
	BEGIN CATCH		
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN
			
			DROP TABLE IF EXISTS #Temp_W_SEQ;

			--에러 로그 테이블 저장
			INSERT INTO TBL_ERROR_LOG 
			SELECT ERROR_PROCEDURE()	-- 프로시저명
			, ERROR_MESSAGE()			-- 에러메시지
			, ERROR_LINE()				-- 에러라인
			, GETDATE();
		
			SET @RETURN_CODE = -1; -- 저장 실패
			SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('-1');
		END
			
	END CATCH

	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE

END

GO

