/*
-- 생성자 :	강세미
-- 등록일 :	2023.03.19
-- 수정자 : 임현태
-- 수정일 : 2024.11.25
			- 비고 수정 하도록 REMARKS 파라미터 추가
-- 설 명  : 배차관리등록
-- 실행문 : 
EXEC PR_TRANS_MANAGE_PUT '',0,0,'','','admin'
*/
CREATE PROCEDURE [dbo].[PR_TRANS_MANAGE_PUT]
( 
	@P_ORD_NO				NVARCHAR(11) = '',			-- 주문번호
	@P_CAR_GB				NVARCHAR(1) = '',			-- 차량구분
	@P_TRANS_COST			INT,						-- 운송비
	@P_RENT_COST			INT,						-- 용차비
	@P_CAR_NO				NVARCHAR(8),				-- 차량번호
	@P_MOBIL_NO				NVARCHAR(11),				-- 기사번호
	@P_ORD_DT				NVARCHAR(8) = '',			-- 주문일자
	@P_DELIVERY_DT			NVARCHAR(8) = '',			-- 입출고일자
	@P_ORD_AMT				NUMERIC(17,4), 				-- 주문/발주합계금액
	@P_VEN_CODE				NVARCHAR(7) = '',			-- 거래처코드
	@P_DELIVERY_CODE		NVARCHAR(7) = '',			-- 배송지코드
	@P_DELIVERY_PRICE_SEQ	INT,						-- 운송비마스터SEQ
	@P_R_POST_NO			NVARCHAR(5),				-- 우편번호
	@P_R_ADDR				NVARCHAR(100),				-- 주소
	@P_R_ADDR_DTL			NVARCHAR(50),				-- 상세주소
	@P_MANUAL_CHECK_YN		NVARCHAR(1),				-- 주소수기입력 여부
	@P_ENTRANCE_TIME		NVARCHAR(5),				-- 입차시간
	@P_DELIVERY_REQ_DT		NVARCHAR(8),				-- 출고요청일
	@P_DRIVER_NAME			NVARCHAR(20),				-- 기사명
	@P_EMP_ID				NVARCHAR(20),				-- 아이디
	@P_REMARKS				NVARCHAR(2000)				-- 비고
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
 	DECLARE @P_MOBIL_NO_ENCRYPT VARBINARY(256)
 	
	BEGIN TRAN
	BEGIN TRY
	EXEC UMAC_CERT_OPEN_KEY; -- OPEN
		DECLARE @RETURN_CODE INT = 0						-- 리턴코드(저장완료)
		DECLARE @RETURN_MESSAGE NVARCHAR(10) = DBO.GET_ERR_MSG('0')		-- 리턴메시지
		
		SET @P_MOBIL_NO_ENCRYPT = DBO.GET_ENCRYPT(@P_MOBIL_NO);
		
		IF EXISTS (
			SELECT 1 
			  FROM PO_SCALE
			 WHERE ORD_NO = @P_ORD_NO
		)
		BEGIN
			UPDATE PO_SCALE SET CAR_GB = @P_CAR_GB,
								TRANS_COST = @P_TRANS_COST,
								RENT_COST = @P_RENT_COST,
								CAR_NO = @P_CAR_NO,
								--MOBIL_NO = @P_MOBIL_NO,
								MOBIL_NO = @P_MOBIL_NO_ENCRYPT,
								UDATE = GETDATE(),
								ENTRANCE_TIME = @P_ENTRANCE_TIME,
								UEMP_ID = @P_EMP_ID
						  WHERE ORD_NO = @P_ORD_NO

			IF LEFT(@P_ORD_NO, 1) = 1 --입고
				BEGIN
					UPDATE PO_PURCHASE_HDR SET DELIVERY_CODE = @P_DELIVERY_CODE,
											   R_POST_NO = @P_R_POST_NO,
											   R_ADDR = @P_R_ADDR,
											   R_ADDR_DTL = @P_R_ADDR_DTL,
											   DELIVERY_PRICE_SEQ = @P_DELIVERY_PRICE_SEQ,
											   REMARKS = @P_REMARKS
										 WHERE ORD_NO = @P_ORD_NO
				END
			ELSE
				BEGIN
					UPDATE PO_ORDER_HDR SET DELIVERY_CODE = @P_DELIVERY_CODE,
											   R_POST_NO = @P_R_POST_NO,
											   R_ADDR = @P_R_ADDR,
											   R_ADDR_DTL = @P_R_ADDR_DTL,
											   DELIVERY_PRICE_SEQ = @P_DELIVERY_PRICE_SEQ,
											   DELIVERY_REQ_DT = @P_DELIVERY_REQ_DT,
											   REMARKS = @P_REMARKS
										 WHERE ORD_NO = @P_ORD_NO
				END
		END
		ELSE
		BEGIN
			INSERT INTO PO_SCALE(
								 ORD_NO,
								 ORD_DT,
								 DELIVERY_DT,
								 ORD_AMT,
								 VEN_CODE, 
								 ITM_PUR_GB,
								 CAR_GB,
								 TRANS_COST,
								 RENT_COST,
								 CAR_NO,
								 MOBIL_NO,
								 IDATE,
								 ENTRANCE_TIME,
								 IEMP_ID 
								 ) VALUES (
								 @P_ORD_NO,
								 @P_ORD_DT,
								 @P_DELIVERY_DT,
								 @P_ORD_AMT,
								 @P_VEN_CODE,
								 LEFT(@P_ORD_NO, 1),
								 @P_CAR_GB,
								 @P_TRANS_COST,
								 @P_RENT_COST,
								 @P_CAR_NO,
								 --@P_MOBIL_NO,
								 @P_MOBIL_NO_ENCRYPT,
								 GETDATE(),
								 @P_ENTRANCE_TIME,
								 @P_EMP_ID
								 );

			IF LEFT(@P_ORD_NO, 1) = 1 --입고
				BEGIN
					UPDATE PO_PURCHASE_HDR SET DELIVERY_CODE = @P_DELIVERY_CODE,
												R_POST_NO = @P_R_POST_NO,
												R_ADDR = @P_R_ADDR,
												R_ADDR_DTL = @P_R_ADDR_DTL,
												DELIVERY_PRICE_SEQ = @P_DELIVERY_PRICE_SEQ,
												REMARKS = @P_REMARKS
											WHERE ORD_NO = @P_ORD_NO
				END
			ELSE
				BEGIN
					UPDATE PO_ORDER_HDR SET DELIVERY_CODE = @P_DELIVERY_CODE,
												R_POST_NO = @P_R_POST_NO,
												R_ADDR = @P_R_ADDR,
												R_ADDR_DTL = @P_R_ADDR_DTL,
												DELIVERY_PRICE_SEQ = @P_DELIVERY_PRICE_SEQ,
											    DELIVERY_REQ_DT = @P_DELIVERY_REQ_DT,
												REMARKS = @P_REMARKS
											WHERE ORD_NO = @P_ORD_NO
				END

			--IF @P_MANUAL_CHECK_YN = 'Y' --주소 수기입력일 경우
			--	BEGIN
				
			--	END

		END

		-- 차량번호 등록
		IF NOT EXISTS (SELECT 1 FROM PO_CAR_INFO WHERE CAR_NO = @P_CAR_NO)
		BEGIN
			INSERT INTO PO_CAR_INFO(CAR_NO, CAR_GB, MOBIL_NO, DRIVER_NAME, IDATE, IEMP_ID)
			VALUES(@P_CAR_NO, @P_CAR_GB, @P_MOBIL_NO_ENCRYPT, @P_DRIVER_NAME, GETDATE(), @P_EMP_ID)
		END
		ELSE 
		BEGIN
			UPDATE PO_CAR_INFO SET 
						MOBIL_NO = @P_MOBIL_NO_ENCRYPT, 
						DRIVER_NAME = @P_DRIVER_NAME,
						UDATE = GETDATE(),
						UEMP_ID = @P_EMP_ID
			 WHERE CAR_NO = @P_CAR_NO
		END

	EXEC UMAC_CERT_CLOSE_KEY -- CLOSE
	COMMIT;
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

