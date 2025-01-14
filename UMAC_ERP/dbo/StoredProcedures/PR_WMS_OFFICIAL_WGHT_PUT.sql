/*
-- 생성자 :	강세미
-- 등록일 :	2024.08.28
-- 수정자 : 2024.09.10 강세미 - 기존 40(매출입확정)상태에서 매출입데이터 분기 처리하는부분 제거
			2024.11.11 강세미 - 마감중량(CLOSE_WGHT) 처리 추가
			2024.11.29 강세미 - 주문별 입금처리내역 수정 추가
			2024.12.02 이동호 - PR_ACCT_DEPOSIT_ORD_HDR_PUT : 프로시저 추가(주문별 입금처리내역)
			2024.12.06 강세미 - LOT 수량 처리 추가
			2024.12.18 강세미 - 타차중량 최신 수정자 추가
-- 수정일 : - 
-- 설 명  : 타차중량 저장
-- 실행문 : EXEC PR_WMS_OFFICIAL_WGHT_PUT 2,'20240829','1240829001', '120001', 13000, '35', 'admin'
*/
CREATE PROCEDURE [dbo].[PR_WMS_OFFICIAL_WGHT_PUT]
	@P_IO_GB			INT,			-- 입출고구분
	@P_IO_DT			NVARCHAR(8),	-- 입출고일자
	@P_ORD_NO			NVARCHAR(11),	-- 주문(발주)번호
	@P_SCAN_CODE		NVARCHAR(14),	-- 제품코드
	@P_OFFICIAL_WGHT	INT,			-- 타차중량
	@P_STATUS_CD		NVARCHAR(2),	-- 상태코드
	@P_EMP_ID			NVARCHAR(20)	-- 아이디
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	 
	DECLARE @RETURN_CODE INT = 0						-- 리턴코드
	DECLARE @RETURN_MESSAGE NVARCHAR(10) = '저장되었습니다.'		-- 리턴메시지
	 
	DECLARE @BEFO_QTY			NUMERIC(15, 2)		-- 이전 입출고 수량
	DECLARE @BEFO_AMT			NUMERIC(17, 4)		-- 이전 입출고 금액
	DECLARE @MIN				INT = 0				-- WHILE 사용값
	DECLARE @MAX				INT = 0				-- WHILE 사용값

	BEGIN TRAN
	BEGIN TRY 

		--#### 타차중량 수정 ####
		UPDATE PO_SCALE 
			SET OFFICIAL_WGHT = @P_OFFICIAL_WGHT,
				CLOSE_WGHT = @P_OFFICIAL_WGHT,
				OFFICIAL_WGHT_DT = GETDATE(),
				OFFICIAL_WGHT_UEMP_ID = @P_EMP_ID
		 WHERE ORD_NO = @P_ORD_NO
		 
		-- ########### 입고 ###########
		IF @P_IO_GB = 1		
		BEGIN
			SELECT @BEFO_QTY = PUR_QTY
			  FROM PO_PURCHASE_DTL
			 WHERE ORD_NO = @P_ORD_NO AND SCAN_CODE = @P_SCAN_CODE

			--#### 입고수량, 금액 수정 ####
			UPDATE PO_PURCHASE_DTL 
				SET PUR_QTY = @P_OFFICIAL_WGHT,
					PUR_TOTAL_WPRC = PO_PURCHASE_DTL.PUR_WPRC * @P_OFFICIAL_WGHT,
					PUR_WAMT = (PO_PURCHASE_DTL.PUR_WPRC + PO_PURCHASE_DTL.PUR_WVAT) * @P_OFFICIAL_WGHT,
					UDATE = GETDATE(),
					UEMP_ID = @P_EMP_ID
				WHERE ORD_NO = @P_ORD_NO AND SCAN_CODE = @P_SCAN_CODE

			UPDATE PO_PURCHASE_HDR 
				SET PUR_TOTAL_AMT = (A.PUR_WPRC + A.PUR_WVAT) * @P_OFFICIAL_WGHT,
					PUR_TOTAL_WPRC = A.PUR_WPRC * @P_OFFICIAL_WGHT,
					UDATE = GETDATE(),
					UEMP_ID = @P_EMP_ID
				FROM (
					SELECT ISNULL(PUR_WPRC, 0) AS PUR_WPRC, ISNULL(PUR_WVAT, 0) AS PUR_WVAT
						FROM PO_PURCHASE_DTL
						WHERE ORD_NO = @P_ORD_NO AND SCAN_CODE = @P_SCAN_CODE
				) AS A
				WHERE ORD_NO = @P_ORD_NO

			--#### 매입내역 수정 ####
			UPDATE PUR_INFO 
				SET PUR_KG = @P_OFFICIAL_WGHT,
					PUR_TOTAL_AMT = (SELECT PUR_TOTAL_AMT FROM PO_PURCHASE_HDR WHERE ORD_NO = @P_ORD_NO),
					PUR_CFM_DT = FORMAT(GETDATE(), 'yyyyMMdd'),
					UDATE = GETDATE(),
					UEMP_ID = @P_EMP_ID
				WHERE ORD_NO = @P_ORD_NO AND SCAN_CODE = @P_SCAN_CODE
				 
			-- 일자별 거래처 매입 업데이트
			EXEC PR_PUR_VEN_PUT @P_IO_DT, @RETURN_CODE OUT, @RETURN_MESSAGE OUT


			-- 일자별 상품 매입 업데이트
			EXEC PR_PUR_ITEM_PUT @P_IO_DT, @RETURN_CODE OUT, @RETURN_MESSAGE OUT

		END
		-- ########### 출고 ###########
		ELSE IF @P_IO_GB = 2
		BEGIN
			SELECT @BEFO_QTY = PICKING_QTY,
				   @BEFO_AMT = PICKING_SAMT
			  FROM PO_ORDER_DTL
			 WHERE ORD_NO = @P_ORD_NO AND SCAN_CODE = @P_SCAN_CODE

			UPDATE PO_ORDER_DTL 
				SET PICKING_QTY = @P_OFFICIAL_WGHT,
					PICKING_SAMT = (PO_ORDER_DTL.PICKING_SPRC + PO_ORDER_DTL.PICKING_SVAT) * @P_OFFICIAL_WGHT,
					UDATE = GETDATE(),
					UEMP_ID = @P_EMP_ID
				WHERE ORD_NO = @P_ORD_NO AND SCAN_CODE = @P_SCAN_CODE

			UPDATE PO_ORDER_LOT 
			   SET PICKING_QTY = @P_OFFICIAL_WGHT
			 WHERE ORD_NO = @P_ORD_NO AND SCAN_CODE = @P_SCAN_CODE

			UPDATE PO_ORDER_HDR 
				SET PICKING_TOTAL_AMT = (A.PICKING_SPRC + A.PICKING_SVAT) * @P_OFFICIAL_WGHT,
					PICKING_TOTAL_SPRC = A.PICKING_SPRC * @P_OFFICIAL_WGHT,
					UDATE = GETDATE(),
					UEMP_ID = @P_EMP_ID
				FROM (
					SELECT ISNULL(PICKING_SPRC, 0) AS PICKING_SPRC, ISNULL(PICKING_SVAT, 0) AS PICKING_SVAT
						FROM PO_ORDER_DTL
						WHERE ORD_NO = @P_ORD_NO AND SCAN_CODE = @P_SCAN_CODE
				) AS A
				WHERE ORD_NO = @P_ORD_NO
				
			--#### 매출내역 수정 ####
			UPDATE SL_SALE 
				SET SALE_KG = @P_OFFICIAL_WGHT,
					SALE_TOTAL_AMT = (SELECT PICKING_TOTAL_AMT FROM PO_ORDER_HDR WHERE ORD_NO = @P_ORD_NO),
					SALE_CFM_DT = FORMAT(GETDATE(), 'yyyyMMdd'),
					BEFO_QTY = @BEFO_QTY,
					BEFO_AMT = @BEFO_AMT,
					UDATE = GETDATE(),
					UEMP_ID = @P_EMP_ID
				WHERE ORD_NO = @P_ORD_NO AND SCAN_CODE = @P_SCAN_CODE
			;
			
			--#### 주문별 입금처리내역 업데이트(PA_ACCT_DEPOSIT_ORD) ####
			DECLARE @ORD_NO_LIST NVARCHAR(MAX) = '[{"ORD_NO":"'+@P_ORD_NO+'"}]'
			EXEC PR_ACCT_DEPOSIT_ORD_HDR_PUT @ORD_NO_LIST, @P_EMP_ID, @RETURN_CODE OUT, @RETURN_MESSAGE OUT;

			--#### 일자별 거래처 매출 업데이트 ####
			EXEC PR_SL_SALE_VEN_PUT @P_IO_DT, @RETURN_CODE OUT, @RETURN_MESSAGE OUT


			--#### 일자별 상품 매출 업데이트 ####
			EXEC PR_SL_SALE_ITEM_PUT @P_IO_DT, @RETURN_CODE OUT, @RETURN_MESSAGE OUT

			SET @P_OFFICIAL_WGHT = -@P_OFFICIAL_WGHT
			SET @BEFO_QTY = -@BEFO_QTY

		END

		--#### 재고수정 ####
		EXEC PR_IV_PRODUCT_STAT_HDR_PUT @P_SCAN_CODE, @P_OFFICIAL_WGHT, 'PR_OFFICIAL_WGHT_PUT', @BEFO_QTY, '', '', '', @RETURN_CODE OUT, @RETURN_MESSAGE OUT
		
		SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE

		COMMIT
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
			, GETDATE()	

			SET @RETURN_CODE = -1 -- 저장실패
			SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('-1')
		END
	END CATCH
	
	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE
END

GO

