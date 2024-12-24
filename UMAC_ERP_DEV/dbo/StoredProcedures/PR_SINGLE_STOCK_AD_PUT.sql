/*
-- 생성자 :	윤현빈
-- 등록일 :	2024.06.05
-- 수정자 : 2024.11.12 최수민 반품 LOT 로직 추가
			2024.11.26 최수민 알병 LOT 로직 추가
-- 설 명  : 단품재고조정 입력
-- 실행문 : EXEC PR_SINGLE_STOCK_AD_PUT '20240412','210001','B','003','20260412-CO-UM-21000','20','TEST',0,''
*/
CREATE PROCEDURE [dbo].[PR_SINGLE_STOCK_AD_PUT]
( 
	@P_SEQ			INT ,					-- SEQ
	@P_INV_DT		NVARCHAR(8) = '',		-- 조정일자
	@P_SCAN_CODE	NVARCHAR(14) = '',		-- 상품코드
	@P_INV_GB		NVARCHAR(2) = '',		-- 재고조정 구분
	@P_INV_GB_NM	NVARCHAR(7) = '',		-- 재고조정 구분명
	@P_LOT_NO		NVARCHAR(30) = '',		-- LOT 번호
	@P_CH_LOT_NO	NVARCHAR(30) = '',		-- 변경할 LOT 번호
	@P_REQ_QTY		NUMERIC(15,2) = '',		-- 조정요청수량
	@P_REMARKS		NVARCHAR(2000) = '',	-- 비고
	@P_EMP_ID	 	NVARCHAR(20) = '',		-- 세션 아이디
	@P_INDEX		INT						-- 엑셀 인덱스
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	DECLARE @V_INV_GB 		NVARCHAR(2) 	;		-- 재고조정 구분
	DECLARE @V_LOT_NO 		NVARCHAR(30) 	;		-- LOT 번호
	DECLARE @NEW_CH_SEQ 	INT				;		-- 변경할 LOT SEQ 번호
	DECLARE @RETURN_INV_GB	NVARCHAR(2)		;		-- 반품, 알병 재고조정 구분

	DECLARE @RETURN_CODE 	INT 			= 0		-- 리턴코드
	DECLARE @RETURN_MESSAGE NVARCHAR(10) 	= '' 	-- 리턴메시지

	BEGIN TRAN
	BEGIN TRY

		SET @V_INV_GB = @P_INV_GB;
		SET @V_LOT_NO = @P_LOT_NO;

		-- 반품, 알병 재고조정 코드 (변경할 LOT가 필요)
		SELECT @RETURN_INV_GB = CD_ID 
		  FROM TBL_COMM_CD_MST 
		 WHERE CD_CL = 'INV_ADJ_GB'
		   AND MGMT_ENTRY_1 = 'RETURN'
		   AND MGMT_ENTRY_2 = 'CH_SEQ'
		
------------------------------
/*	
	변경할 LOT가 있는 경우 CH_SEQ 저장, 조정 요청 수량 수정
	반품 LOT, 알병 LOT 음수
*/
------------------------------
		IF @P_CH_LOT_NO <> '' AND @P_INV_GB = @RETURN_INV_GB
		BEGIN
			SELECT @NEW_CH_SEQ = ISNULL(MAX(SEQ), 0) + 2 FROM IV_STOCK_ADJUST;
			SET @P_REQ_QTY = CASE WHEN @P_LOT_NO LIKE '11111111%' THEN -ABS(@P_REQ_QTY)
								  WHEN @P_LOT_NO LIKE '%-R' THEN -ABS(@P_REQ_QTY)
								  ELSE @P_REQ_QTY END;
		END
		ELSE
		BEGIN
			SET @NEW_CH_SEQ = NULL;
		END


------------------------------
/* 엑셀 업로드 시 validate
	1. @P_INV_GB_NM 체크, 유효성 맞지 않으면 패스
	2. @P_LOT_NO 체크, 유효성 맞지 않으면 패스
*/ 
------------------------------
		IF @P_INDEX != 0 
		BEGIN
			IF @P_INV_GB_NM != ''
			BEGIN
				IF NOT EXISTS (SELECT 1 FROM TBL_COMM_CD_MST WHERE CD_CL = 'INV_ADJ_GB' AND CD_NM = @P_INV_GB_NM)
				BEGIN
					SET @P_INV_GB = 'X'
				END
				ELSE 
				BEGIN
					SELECT @V_INV_GB = CD_ID FROM TBL_COMM_CD_MST WHERE CD_CL = 'INV_ADJ_GB' AND CD_NM = @P_INV_GB_NM
				END
			END

			IF @P_LOT_NO != ''
			BEGIN
				IF NOT EXISTS (SELECT 1 FROM IV_LOT_STAT WHERE SCAN_CODE = @P_SCAN_CODE AND LOT_NO = @P_LOT_NO)
				BEGIN
					SET @P_INV_GB = 'X'
				END
			END
		END
------------------------------
/* 저장
*/ 
------------------------------
		IF @P_INV_GB != 'X'
		BEGIN
			-- 신규
			IF @P_SEQ = 0 
			BEGIN
				INSERT INTO IV_STOCK_ADJUST
				(
					ITM_CODE
				  , SCAN_CODE
				  , INV_DT
				  , INV_GB
				  , LOT_NO
				  , CH_SEQ
				  , REQ_QTY
				  , CFM_FLAG
				  , CFM_DT
				  , APP_QTY
				  , REMARKS
				  , IDATE
				  , IEMP_ID
				  , UDATE
				  , UEMP_ID
				)
				SELECT A.ITM_CODE
					 , @P_SCAN_CODE
					 , @P_INV_DT
					 , @V_INV_GB
					 , @V_LOT_NO
					 , @NEW_CH_SEQ
					 , @P_REQ_QTY
					 , 'N'
					 , NULL
					 , NULL
					 , @P_REMARKS
					 , GETDATE()
					 , @P_EMP_ID
					 , NULL
					 , NULL
					FROM CD_PRODUCT_CMN AS A
				   WHERE A.SCAN_CODE = @P_SCAN_CODE
			END
	 
			-- 수정
			ELSE
			BEGIN
				UPDATE IV_STOCK_ADJUST
					SET INV_GB = @V_INV_GB
					  , LOT_NO = @V_LOT_NO
					  , REQ_QTY = @P_REQ_QTY
					  , REMARKS = @P_REMARKS
					  , UDATE = GETDATE()
					  , UEMP_ID = @P_EMP_ID
				   WHERE SEQ = @P_SEQ
				     AND CFM_FLAG = 'N'
			END

------------------------------
/*	
	변경할 LOT가 있는 경우 데이터 한 번 더 저장
*/
------------------------------
			IF @P_CH_LOT_NO <> '' AND @P_INV_GB = @RETURN_INV_GB
			BEGIN
				IF @P_SEQ = 0 
				BEGIN
					INSERT INTO IV_STOCK_ADJUST
					(
						ITM_CODE
					  , SCAN_CODE
					  , INV_DT
					  , INV_GB
					  , LOT_NO
					  , CH_SEQ
					  , REQ_QTY
					  , CFM_FLAG
					  , CFM_DT
					  , APP_QTY
					  , REMARKS
					  , IDATE
					  , IEMP_ID
					  , UDATE
					  , UEMP_ID
					)
					SELECT A.ITM_CODE
						 , @P_SCAN_CODE
						 , @P_INV_DT
						 , @V_INV_GB
						 , @P_CH_LOT_NO		-- 변경할 LOT로 저장
						 , @NEW_CH_SEQ-1	-- CH_SEQ
						 , @P_REQ_QTY * -1	-- 변경수량은 반대값
						 , 'N'
						 , NULL
						 , NULL
						 , @P_REMARKS
						 , GETDATE()
						 , @P_EMP_ID
						 , NULL
						 , NULL
						FROM CD_PRODUCT_CMN AS A
					   WHERE A.SCAN_CODE = @P_SCAN_CODE
				END
				ELSE
				BEGIN
					SET @P_SEQ = @P_SEQ + CASE WHEN @P_LOT_NO LIKE '11111111%' THEN 1 
											   WHEN @P_LOT_NO LIKE '%-R' THEN 1
											   ELSE -1 END;

					UPDATE IV_STOCK_ADJUST
						SET INV_GB = @V_INV_GB
						  , LOT_NO = @P_CH_LOT_NO		-- 변경할 LOT로 저장
						  , REQ_QTY = @P_REQ_QTY * -1	-- 변경수량은 반대값
						  , REMARKS = @P_REMARKS
						  , UDATE = GETDATE()
						  , UEMP_ID = @P_EMP_ID
					   WHERE SEQ = @P_SEQ
						 AND CFM_FLAG = 'N'
					
				END
			END


		
			SET @RETURN_CODE = 0; -- 저장완료
			SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('0');
		END;
		ELSE
		BEGIN
			
			SET @RETURN_CODE = -2; -- 엑셀업로드 validate 실패, @RETURN_MESSAGE에 실패 인덱스 담아서 화면에서 alert 처리
			SET @RETURN_MESSAGE = @P_INDEX+2;
		END;
		
		COMMIT;

	END TRY
	
	BEGIN CATCH		
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN

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

