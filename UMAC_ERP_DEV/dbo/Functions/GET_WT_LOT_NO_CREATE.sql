


/*
-- 생성자 :	이동호
-- 등록일 :	2024.09.24
-- 수정자 : -
-- 수정일 : - 
-- 설 명	: 중량 제품 LOT 번호 생성 함수
-- 실행문 : 
	
	SELECT DBO.GET_WT_LOT_NO_CREATE('120008','UM20123','','')

*/
CREATE FUNCTION [dbo].[GET_WT_LOT_NO_CREATE](
	@P_SCAN_CODE			NVARCHAR(14) = '',		--제품코드
	@P_VEN_CODE				NVARCHAR(7) = '',		--주문 거래처코드
	@P_DELIVERY_DEC_DT		NVARCHAR(8) = '',		--LOT 생산일 (출고일)
	@P_EXPIRY_DAY			NVARCHAR(8) = ''		--강제 지정할 소비기한이 있을 경우
)
RETURNS VARCHAR(50)
AS
BEGIN

	DECLARE @LOT_NO NVARCHAR(50) = ''
	
	--제품정보
	DECLARE @ITM_CODE NVARCHAR(6) = '',			-- 관리코드
			@ITM_FORM NVARCHAR(3) = '',			-- 상품형태
			@WEIGHT_GB NVARCHAR(3) = '',		-- 수중량관리(QTY,WT)
			@LOT_OIL_GB NVARCHAR(6) = '',		-- LOT 유종 구분
			@LOT_PARTNER_GB NVARCHAR(6) = '',	-- LOT 거래처 구분
			@EXPIRY_CNT INT = 0					-- 소비기한계산일자(개월수)	

	--LOT 생성 필요 변수
	DECLARE @DELIVERY_DEC_DT NVARCHAR(8) = '',	--출고요청일
			@EXPIRY_DAY NVARCHAR(8) = '',		--LOT 소비기한 일자
			@CD_ID NVARCHAR(5) = '',			--LOT 거래처 구분
			@MGMT_ENTRY_2 NVARCHAR(50) = '',	--CODE 관리 > UM > 소비기한
			@MGMT_ENTRY_3 NVARCHAR(50) = ''		--CODE 관리 > UM > 옥배 정제유 제품코드


	--상품마스타 정보 검색
	SELECT 						
		@ITM_CODE = ITM_CODE,
		@ITM_FORM = ITM_FORM,							-- 상품형태						
		@LOT_OIL_GB = ISNULL(LOT_OIL_GB, ''),			-- LOT 유종 구분
		@LOT_PARTNER_GB = ISNULL(LOT_PARTNER_GB, ''),	-- LOT 거래처 구분
		@EXPIRY_CNT = ISNULL(EXPIRY_CNT, 0)				-- 소비기한계산일자(개월수)
	FROM CD_PRODUCT_CMN WITH(NOLOCK) WHERE SCAN_CODE = @P_SCAN_CODE


	--소비가한 날짜 출력
	SET @EXPIRY_DAY = FORMAT(DATEADD(MONTH, @EXPIRY_CNT, DATEADD(DAY, -1, GETDATE())), 'yyyyMMdd')


	--LOT 소비기한 계산 (벌크(기타) 제품은 소비기한 99999999 로 지정
	IF @ITM_FORM = '4' 	
	BEGIN
		
		SET @EXPIRY_DAY = '99999999'

		SET @DELIVERY_DEC_DT = '99999999'

	END
	ELSE	
	BEGIN
		SET @DELIVERY_DEC_DT = @P_DELIVERY_DEC_DT
	END 						

	IF @P_DELIVERY_DEC_DT != ''
		SET @DELIVERY_DEC_DT = @P_DELIVERY_DEC_DT

	--LOT 생성에 필요한 유종, LOT 생산일이 없을 경우 생성 불가능 처리
	IF @LOT_OIL_GB != '' AND @EXPIRY_DAY != ''
	BEGIN

		--LOT 생성 거래처 구분 DATA
		IF @LOT_PARTNER_GB = 'UM'
		BEGIN						
							
			SELECT	@CD_ID = ISNULL(CD_ID, '')	FROM TBL_COMM_CD_MST WITH(NOLOCK) WHERE CD_CL = 'LOT_PARTNER_GB' AND MGMT_ENTRY_1 = @P_VEN_CODE
							
			IF @CD_ID != '' 
			BEGIN
				SET @LOT_PARTNER_GB = @CD_ID
			END				
														
		END
		ELSE IF @LOT_PARTNER_GB = ''
		BEGIN
			SET @LOT_PARTNER_GB = 'UM'
		END

		--*********************************************************
		--UM > 옥배 정제유(벌크) 제품 일경우 소비기한 계산
		--*********************************************************
		IF @LOT_PARTNER_GB = 'UM'
		BEGIN
							
			SELECT 
				@MGMT_ENTRY_2 = ISNULL(MGMT_ENTRY_2,''),	--UM > 소비기한
				@MGMT_ENTRY_3 = ISNULL(MGMT_ENTRY_3, '')	--UM > 옥배 정제유 제품코드
			FROM TBL_COMM_CD_MST WITH(NOLOCK) WHERE CD_CL = 'LOT_PARTNER_GB' AND CD_ID = 'UM'

			IF @P_SCAN_CODE = @MGMT_ENTRY_3
			BEGIN									
				
				SET @EXPIRY_DAY = FORMAT(DATEADD(MONTH, CAST(@MGMT_ENTRY_2 AS INT), DATEADD(DAY, -1, GETDATE())), 'yyyyMMdd')

			END

		END
		
	END 

	IF ISNULL(@DELIVERY_DEC_DT, '') = ''
		SET @DELIVERY_DEC_DT = CONVERT(CHAR(8), GETDATE(), 112)

	--'99999999'
	IF ISNULL(@P_EXPIRY_DAY, '') != ''
	BEGIN
		SET @EXPIRY_DAY = @P_EXPIRY_DAY
	END 

	SET @LOT_NO = CONCAT(@DELIVERY_DEC_DT, '-', @LOT_OIL_GB, '-', @LOT_PARTNER_GB, '-', @ITM_CODE, '|', @EXPIRY_DAY);

RETURN @LOT_NO

END

GO

