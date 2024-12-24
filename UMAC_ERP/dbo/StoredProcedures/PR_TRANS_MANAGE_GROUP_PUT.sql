/*
-- 생성자 :	강세미
-- 등록일 :	2023.04.02
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 배차그룹설정
-- 실행문 : 
EXEC PR_TRANS_MANAGE_GROUP_PUT '2240327004','1',123123,123123,'바바바바','01012341234',0,2,'admin','I'
*/
CREATE PROCEDURE [dbo].[PR_TRANS_MANAGE_GROUP_PUT]
( 
	@P_ORD_NO			NVARCHAR(11) = '',			-- 주문번호
	@P_CAR_GB			NVARCHAR(1) = '',			-- 차량구분
	@P_TRANS_COST		INT,						-- 운송비
	@P_RENT_COST		INT,						-- 용차비
	@P_CAR_NO			NVARCHAR(8),				-- 차량번호
	@P_MOBIL_NO			NVARCHAR(11),				-- 기사번호
	@P_GROUP_NO			INT = 0,					-- 그룹번호
	@P_LAND_GB			INT,						-- 착지구분
	@P_ORD_NO_PARENT	NVARCHAR(11) = '',			-- 부모주문번호
	@P_EMP_ID			NVARCHAR(20),				-- 아이디
	@P_MODE				NVARCHAR(1)					-- I: 등록 U: 수정 D: 삭제
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
 
	BEGIN TRY
	EXEC UMAC_CERT_OPEN_KEY; -- OPEN

		DECLARE @RETURN_CODE	INT = 0									-- 리턴코드(저장완료)
		DECLARE @RETURN_MESSAGE NVARCHAR(30) = DBO.GET_ERR_MSG('0')		-- 리턴메시지
		DECLARE @GROUP_NO		INT										-- 그룹번호
		DECLARE @ORD_DT			NVARCHAR(8)								-- 주문(발주)일자
		DECLARE @DELIVERY_DT NVARCHAR(8)								-- 입고(출고)일자
		DECLARE @ORD_AMT		NUMERIC(17,4)							-- 주문/발주 합계금액
		DECLARE @VEN_CODE		NVARCHAR(7)								-- 거래처코드
		DECLARE @ENC_MOBIL_NO	VARBINARY(256)

		SET @ENC_MOBIL_NO = DBO.GET_ENCRYPT(@P_MOBIL_NO);
		SELECT @GROUP_NO = ISNULL(MAX(GROUP_NO) + 1, 1) FROM PO_SCALE_GROUP

		-- 배차정보 저장
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
								   MOBIL_NO = @ENC_MOBIL_NO,
								   GROUP_NO = (CASE WHEN @P_GROUP_NO <> 0 THEN @P_GROUP_NO ELSE @GROUP_NO END),
								   UDATE = GETDATE(),
								   UEMP_ID = @P_EMP_ID
							WHERE ORD_NO = @P_ORD_NO
						END
						ELSE
						BEGIN
							IF LEFT(@P_ORD_NO, 1) = 1
								BEGIN
									SELECT @ORD_DT = ORD_DT
											,@DELIVERY_DT = DELIVERY_IN_DT
											,@ORD_AMT = ORD_AMT
											,@VEN_CODE = VEN_CODE
										FROM PO_PURCHASE_HDR
										WHERE ORD_NO = @P_ORD_NO
								END
							ELSE
								BEGIN
									SELECT @ORD_DT = ORD_DT
											,@DELIVERY_DT = DELIVERY_DEC_DT
											,@ORD_AMT = ORD_AMT
											,@VEN_CODE = VEN_CODE
										FROM PO_ORDER_HDR
										WHERE ORD_NO = @P_ORD_NO
								END

							INSERT PO_SCALE(
								ORD_NO,
							    ORD_DT,
								DELIVERY_DT,
								ORD_AMT,
								VEN_CODE, 
								GROUP_NO,
								ITM_PUR_GB,
								CAR_GB,
								TRANS_COST,
								RENT_COST,
								CAR_NO,
								MOBIL_NO,
								IDATE,
								IEMP_ID 
								) VALUES (
								@P_ORD_NO,
								@ORD_DT,
								@DELIVERY_DT,
								@ORD_AMT,
								@VEN_CODE,
							   (CASE WHEN @P_GROUP_NO <> 0 THEN @P_GROUP_NO ELSE @GROUP_NO END),
								LEFT(@P_ORD_NO, 1),
								@P_CAR_GB,
								@P_TRANS_COST,
								@P_RENT_COST,
								@P_CAR_NO,
								@ENC_MOBIL_NO,
								GETDATE(),
								@P_EMP_ID
								);

		END

		-- 배차그룹저장
		IF @P_MODE = 'I'
			BEGIN
				INSERT PO_SCALE_GROUP(
						GROUP_NO
						,ORD_NO
						,LAND_GB
						,IDATE
						,IEMP_ID
						) VALUES (
						(CASE WHEN @P_GROUP_NO <> 0 THEN @P_GROUP_NO ELSE @GROUP_NO END)
						,@P_ORD_NO 
						,@P_LAND_GB
						,GETDATE()
						,@P_EMP_ID
						)

				UPDATE PO_ORDER_HDR SET ORD_NO_PARENT = @P_ORD_NO_PARENT WHERE ORD_NO = @P_ORD_NO;
			END
		ELSE IF(@P_MODE = 'U')
			BEGIN
				UPDATE PO_SCALE_GROUP SET LAND_GB = @P_LAND_GB
										, UDATE = GETDATE()
										, UEMP_ID = @P_EMP_ID
					WHERE GROUP_NO = @P_GROUP_NO AND ORD_NO = @P_ORD_NO

				UPDATE PO_ORDER_HDR SET ORD_NO_PARENT = @P_ORD_NO_PARENT WHERE ORD_NO = @P_ORD_NO;
			END 
		 
	EXEC UMAC_CERT_CLOSE_KEY -- CLOSE
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

	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE, (CASE WHEN @P_GROUP_NO <> 0 THEN @P_GROUP_NO ELSE @GROUP_NO END) AS GROUP_NO
END

GO

