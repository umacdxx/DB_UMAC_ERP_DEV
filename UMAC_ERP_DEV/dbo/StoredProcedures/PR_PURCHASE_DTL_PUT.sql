/*
-- 생성자 :	강세미
-- 등록일 :	2024.02.29
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 발주등록 DTL 저장
-- 실행문 : EXEC PR_PURCHASE_DTL_PUT
*/
CREATE PROCEDURE [dbo].[PR_PURCHASE_DTL_PUT]
	@P_ORD_NO				NVARCHAR(11),			-- 주문번호
	@P_SEQ					INT, 					-- 순번
	@P_SCAN_CODE			NVARCHAR(14), 			-- 상품코드
	@P_ORD_QTY				NUMERIC(15,2),			-- 주문량
	@P_ORD_WPRC				NUMERIC(15,2),			-- 원가공급가
	@P_ORD_WVAT				NUMERIC(15,2),			-- 원가부가세
	@P_ORD_TOTAL_WPRC		NUMERIC(15,2),			-- 원가공급가 합계
	@P_ORD_WAMT				NUMERIC(15,2),			-- 원가합계
	@P_REMARKS				NVARCHAR(2000),			-- 비고
	@P_EMP_ID				NVARCHAR(20), 			-- 아이디
	@P_MODE					NVARCHAR(1)				-- I: 등록 U: 수정 D: 삭제
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	DECLARE @ITM_GB NVARCHAR(1) -- 상품구분
	DECLARE @IPSU_QTY INT		-- 입수
	DECLARE @TAX_GB NVARCHAR(1) -- 면과세구분

	DECLARE @RETURN_CODE INT = 0						-- 리턴코드(저장완료)
	DECLARE @RETURN_MESSAGE NVARCHAR(10) = DBO.GET_ERR_MSG('0')		-- 리턴메시지

	BEGIN TRY 

		-- 상태 값 확인(검수완료 이후 수정 불가)
		IF EXISTS (SELECT 1 FROM PO_PURCHASE_HDR WHERE ORD_NO = @P_ORD_NO AND PUR_STAT IN ('33', '35', '40'))
		BEGIN
			SET @RETURN_CODE = -1
			SET @RETURN_MESSAGE = '검수완료 후 수정 불가합니다.';
		END
		ELSE
		BEGIN
			-- 상품정보 SET
			SELECT @ITM_GB = ITM_GB, 
				   @IPSU_QTY = IPSU_QTY,
				   @TAX_GB = TAX_GB 
			  FROM CD_PRODUCT_CMN 
			 WHERE SCAN_CODE = @P_SCAN_CODE

			IF @P_MODE = 'I'
			BEGIN
				-- 신규 SEQ SET
				SELECT @P_SEQ = ISNULL(MAX(SEQ),0) + 1 FROM PO_PURCHASE_DTL WHERE ORD_NO = @P_ORD_NO

				INSERT INTO PO_PURCHASE_DTL(
								ORD_NO,
								SEQ,
								SCAN_CODE,
								ITM_GB,
								IPSU_QTY,
								ORD_QTY,
								ORD_WPRC,
								ORD_WVAT,
								ORD_TOTAL_WPRC,
								ORD_WAMT,
								TAX_GB,
								REMARKS,
								IDATE,
								IEMP_ID
								) VALUES (
								@P_ORD_NO,
								@P_SEQ,
								@P_SCAN_CODE,
								@ITM_GB,
								@IPSU_QTY,
								@P_ORD_QTY,
								@P_ORD_WPRC,
								@P_ORD_WVAT,
								@P_ORD_TOTAL_WPRC,
								@P_ORD_WAMT,
								@TAX_GB,
								@P_REMARKS,
								GETDATE(), 
								@P_EMP_ID
							) 
				END
			ELSE IF @P_MODE = 'U'
			BEGIN
				UPDATE PO_PURCHASE_DTL
					SET SCAN_CODE = @P_SCAN_CODE,
						ITM_GB = @ITM_GB,
						IPSU_QTY = @IPSU_QTY,
						ORD_QTY = @P_ORD_QTY,
						ORD_WPRC = @P_ORD_WPRC,
						ORD_WVAT = @P_ORD_WVAT,
						ORD_TOTAL_WPRC = @P_ORD_TOTAL_WPRC,
						ORD_WAMT = @P_ORD_WAMT,
						TAX_GB = @TAX_GB,
						REMARKS = @P_REMARKS,
						UDATE = GETDATE(), 
						UEMP_ID = @P_EMP_ID
					WHERE ORD_NO = @P_ORD_NO
					AND SEQ = @P_SEQ
			END
			ELSE
			BEGIN
				DELETE PO_PURCHASE_DTL
					WHERE ORD_NO = @P_ORD_NO
						AND SEQ = @P_SEQ
			END 

			-- 총 주문금액 수정
			UPDATE PO_PURCHASE_HDR 
			   SET ORD_AMT = (SELECT SUM(ORD_WAMT) 
									  FROM PO_PURCHASE_DTL
									 WHERE ORD_NO = @P_ORD_NO)
			 WHERE ORD_NO = @P_ORD_NO
		END
		

	END TRY
	BEGIN CATCH		
		--에러 로그 테이블 저장
		INSERT INTO TBL_ERROR_LOG 
		SELECT ERROR_PROCEDURE()	-- 프로시저명
		, ERROR_MESSAGE()			-- 에러메시지
		, ERROR_LINE()				-- 에러라인
		, GETDATE()	

		SET @RETURN_CODE = -1 -- 저장실패
		SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('-1')
	END CATCH
	
	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE, @P_ORD_NO AS ORD_NO 
END

GO

