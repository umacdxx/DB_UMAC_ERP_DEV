/*
-- 생성자 :	이동호
-- 등록일 :	2024.05.17
-- 수정자 : 
-- 수정일 : 
-- 설 명  : (공통)상품LOT 재고 업데이트 처리
-- 실행문 : 

*/
CREATE PROCEDURE [dbo].[PR_IV_LOT_STAT_HDR_PUT]	
	@P_SCAN_CODE		VARCHAR(14),			-- #(필수)상품코드
	@P_LOT_NO			VARCHAR(30),			-- #(필수)LOT 번호
	@P_CHG_QTY			NUMERIC(15,2),			-- #(필수)변경수량
	@P_PROCEDUAL_NM		VARCHAR(30),			-- #(필수)프로시저 or 실행 히스토리 이름
	@P_PRE_PROD_QTY		NUMERIC(15,2),			-- 변경이전수량
	@R_RETURN_CODE 		INT 			OUTPUT,	-- 리턴코드
	@R_RETURN_MESSAGE 	NVARCHAR(10) 	OUTPUT 	-- 리턴메시지	
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	DECLARE @MAX_SEQ INT = 0
	DECLARE @ITM_CODE VARCHAR(6)				--상품 아이템코드
	DECLARE @SCAN_CODE NVARCHAR(14) = ''		--신규 재고 등록 상품 인지 판단 여부	
	DECLARE @CUR_INV_QTY NUMERIC(15,2) = 0		--업데이트 재고수량		
	DECLARE @LAST_PUR_DT VARCHAR(8) = ''		--최종 매입일자
	DECLARE @LAST_SALE_DT VARCHAR(8) = ''		--최종 매출일자	
	DECLARE @TRXN_NO VARCHAR(6) = ''			--거래번호
	
	BEGIN TRAN
	BEGIN TRY 
			
			
		--ERR 테스트
		--DECLARE @P INT = 0
		--SET @P = 1/0
		--ERR 테스트//

		--상품 정보
		SELECT @ITM_CODE = ITM_CODE FROM CD_PRODUCT_CMN WHERE SCAN_CODE = @P_SCAN_CODE;
				
		--현재LOT재고수량
		SELECT @CUR_INV_QTY = CUR_INV_QTY, @SCAN_CODE = SCAN_CODE FROM IV_LOT_STAT WHERE SCAN_CODE = @P_SCAN_CODE AND LOT_NO = @P_LOT_NO
		
		IF @P_PRE_PROD_QTY <> 0
		BEGIN					
			--생산관리 에서 생산 수량 변경시 재고 업데이트			
			SET @CUR_INV_QTY = @CUR_INV_QTY - (@P_PRE_PROD_QTY - @P_CHG_QTY)
		END
		ELSE
		BEGIN
			--주문/발주 재고 업데이트
			SET @CUR_INV_QTY = @CUR_INV_QTY + @P_CHG_QTY					
		END 
		
		IF @SCAN_CODE = ''
		BEGIN		
		
			--#재고 신규등록
			INSERT IV_LOT_STAT (
				ITM_CODE, 
				SCAN_CODE, 
				LOT_NO,			
				CUR_INV_QTY, 
				LAST_SALE_DT,
				UDATE 
			)
			VALUES(
				@ITM_CODE, 
				@P_SCAN_CODE, 
				@P_LOT_NO,				
				@P_CHG_QTY,
				@LAST_SALE_DT,				
				GETDATE()
			)

		END
		ELSE
		BEGIN				
			
			--#재고 업데이트
			UPDATE IV_LOT_STAT SET 
						CUR_INV_QTY = @CUR_INV_QTY,						
						LAST_SALE_DT = @LAST_SALE_DT,
						UDATE = GETDATE() 
				WHERE SCAN_CODE = @P_SCAN_CODE AND LOT_NO = @P_LOT_NO
		END
	

		SELECT @MAX_SEQ = ISNULL(MAX(LOG_SEQ) + 1, 1) FROM IV_LOT_STAT_LOG
		INSERT INTO IV_LOT_STAT_LOG
		(
			LOG_SEQ
		  , SYS_NAME
		  , SCAN_CODE
		  , LOT_NO
		  , TRXN_NO
		  , BEFO_QTY
		  , CHG_QTY
		  , AFT_QTY
		  , IDATE
		)
		VALUES
		(
		    @MAX_SEQ
		  , @P_PROCEDUAL_NM
		  , @P_SCAN_CODE
		  , @P_LOT_NO
		  , @TRXN_NO
		  , @CUR_INV_QTY - @P_CHG_QTY
		  , @P_CHG_QTY
		  , @CUR_INV_QTY
		  , GETDATE()
		)
			
		SET @R_RETURN_CODE = 0 -- 저장완료
		SET @R_RETURN_MESSAGE = DBO.GET_ERR_MSG('0')	
		
		COMMIT;

	END TRY
	BEGIN CATCH	
	
		IF @@TRANCOUNT > 0
		BEGIN 
			ROLLBACK TRAN
			
			--에러 로그 테이블 저장
			INSERT INTO TBL_ERROR_LOG 
			SELECT ERROR_PROCEDURE()			-- 프로시저명
					, ERROR_MESSAGE()			-- 에러메시지
					, ERROR_LINE()				-- 에러라인
					, GETDATE()	

			SET @R_RETURN_CODE = -92 -- 재고 실패
			SET @R_RETURN_MESSAGE = DBO.GET_ERR_MSG('-92')

		END 
	END CATCH
	

END

GO

