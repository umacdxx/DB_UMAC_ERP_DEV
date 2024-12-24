

/*
-- 생성자 :	이동호
-- 등록일 :	2024.04.22
-- 설 명  : 모바일(앱) 주문 입출고 지시서 검수수량(피킹수량) 업데이트 처리
			
-- 수정자 : 2024.06.21 강세미 - 피킹 및 입고 공급가, 부가세 UPDATE 추가
-- 수정자 : 2024.09.24 이동호 - REGION (PD_TEST_REPORT) 벌크제품 PDA에서 생성된 LOT로 시험 성적서 등록 영역 추가
			2024.10.02 최수민 - 피킹수량 합산이 0이면 리턴
			2024.10.10 이동호 - 동일 제품에 본품, 샘플이 등록됐을 경우 피킹 업데이트 처리 추가
-- 실행문 : 

DECLARE @JSONDT NVARCHAR(MAX) = 
'{	
	"ordProductRQ": [
			{
				"ORD_NO": "string",
				"SCAN_CODE": "string",
				"LOT_NO": "string",
				"PICKING_QTY": 0
			}
		],
	"ordPLTRQ": {
		"STAT" : "",
		"ORD_NO": "string",
		"PLT_KPP_QTY11": 0,
		"PLT_KPP_QTY12": 0,
		"PLT_AJ_QTY11": 0,
		"PLT_AJ_QTY12": 0,
		"IEMP_ID": "string"
	}
}'
	EXEC PR_MO_ORDER_PRODUCT_PICKING_PUT @JSONDT

*/
CREATE PROCEDURE [dbo].[PR_MO_ORDER_PRODUCT_PICKING_PUT]
( 	
	@P_JSONDT		NVARCHAR(MAX) = ''
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	DECLARE @RETURN_CODE INT = 0									-- 리턴코드(저장완료)
	DECLARE @RETURN_MESSAGE NVARCHAR(100) = DBO.GET_ERR_MSG('0')	-- 리턴메시지

	BEGIN TRAN
	BEGIN TRY 

		DECLARE 			
			@ORD_NO NVARCHAR(11),
			@IO_GB INT = 0,
			@IEMP_ID NVARCHAR(20) = NULL,
			@STAT NVARCHAR(2) = ''

		DECLARE @ORDER_TBL TABLE (
			ORD_NO NVARCHAR(11),
			SCAN_CODE NVARCHAR(14),
			LOT_NO NVARCHAR(30),			
			PICKING_QTY NUMERIC(15,2)			
		)

		DECLARE @ORDER_PLT_TBL TABLE (
			STAT NVARCHAR(2),
			ORD_NO NVARCHAR(11),			
			PLT_KPP_QTY11 INT,
			PLT_KPP_QTY12 INT,
			PLT_AJ_QTY11 INT,
			PLT_AJ_QTY12 INT,
			IEMP_ID NVARCHAR(20)
		)

		DECLARE @CD_LOT_MST_TBL TABLE (
			PROD_DT NVARCHAR(8),
			SCAN_CODE NVARCHAR(14),
			PROD_GB NVARCHAR(1),
			LOT_NO NVARCHAR(30),
			PROD_GB_CD NVARCHAR(3),
			PROD_QTY NUMERIC(15,2)					
		)

		DECLARE @SET_CD NVARCHAR(3)
		DECLARE @MST_LOT_NO NVARCHAR(30) = ''
		DECLARE @PROD_QTY NUMERIC(15,2) = 0
		DECLARE @LOT_NO_INFO NVARCHAR(50)
		DECLARE @EXPIRY_DAY NVARCHAR(8) = ''
		
		DECLARE @ORD_QTY NUMERIC(15,2) = 0
		DECLARE @ORD_QTY_SAMPLE NUMERIC(15,2) = 0
		DECLARE	@PICKING_QTY NUMERIC(15,2) = 0
		DECLARE	@PICKING_QTY_SAMPLE NUMERIC(15,2) = 0
		
		DECLARE @ORD_SPRC NUMERIC(17,4) = 0,
				@ORD_SVAT NUMERIC(17,4) = 0,
				@ORD_SAMT NUMERIC(17,4) = 0,
				@PICKING_SDATE DATETIME = NULL,
				@PICKING_EDATE DATETIME = NULL

		--#해당 주문의 상품 LIST > LOT_NO, PICKING_QTY 정보 변수 테이블에 저장	
		INSERT INTO @ORDER_TBL
			SELECT ORD_NO, SCAN_CODE, LOT_NO, PICKING_QTY
				FROM OPENJSON ( @P_JSONDT, '$.ordProductRQ' )   
				WITH (    
					ORD_NO NVARCHAR(11)			'$.ORD_NO',					
					SCAN_CODE NVARCHAR(14)		'$.SCAN_CODE',
					LOT_NO NVARCHAR(30)			'$.LOT_NO',
					PICKING_QTY NUMERIC(15,2)	'$.PICKING_QTY'				
				)

		--#해당 주문의 PLT 종류별 수량 정보 변수 테이블에 저장	 
		INSERT INTO @ORDER_PLT_TBL
			SELECT STAT, ORD_NO, ISNULL(PLT_KPP_QTY11, 0), ISNULL(PLT_KPP_QTY12, 0), ISNULL(PLT_AJ_QTY11, 0), ISNULL(PLT_AJ_QTY12, 0), IEMP_ID
				FROM OPENJSON ( @P_JSONDT, '$.ordPLTRQ' )   
				WITH (    
					STAT NVARCHAR(2)		'$.STAT',
					ORD_NO NVARCHAR(11)		'$.ORD_NO',
					PLT_KPP_QTY11 INT		'$.PLT_KPP_QTY11',
					PLT_KPP_QTY12 INT		'$.PLT_KPP_QTY12',
					PLT_AJ_QTY11 INT		'$.PLT_AJ_QTY11',
					PLT_AJ_QTY12 INT		'$.PLT_AJ_QTY12',
					IEMP_ID NVARCHAR(20)	'$.IEMP_ID'
				)
			
		SELECT @STAT = STAT, @IEMP_ID = IEMP_ID FROM @ORDER_PLT_TBL
		
		SELECT @ORD_NO = ORD_NO FROM @ORDER_PLT_TBL

		SET @IO_GB = LEFT(@ORD_NO, 1)

		
		-- JSON DATA 테이블에 저장
		INSERT INTO TBL_PDA_PICKING_DATA (SEQ, DATA, IEMP_ID, IDATE)
		VALUES (NEXT VALUE FOR SEQ_PICKING_DATA, @P_JSONDT, @IEMP_ID, GETDATE());


		-- 총 피킹수량이 0인 경우 리턴
		IF (SELECT SUM(PICKING_QTY) FROM @ORDER_TBL) = 0
		BEGIN

			SET @RETURN_CODE = -1 -- 저장실패
			SET @RETURN_MESSAGE = '저장실패 검수수량이 0입니다.'

			--에러 로그 테이블 저장
			INSERT INTO TBL_ERROR_LOG 
			SELECT 'PR_MO_ORDER_PRODUCT_PICKING_PUT'			-- 프로시저명
					, @RETURN_MESSAGE							-- 에러메시지
					, NULL										-- 에러라인
					, GETDATE()
			;
			
			SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE;

			COMMIT;
			RETURN;
		END

		--******************************************************************************************************************************************************
		--출고(주문)
		--******************************************************************************************************************************************************
		IF @IO_GB = 2 
		BEGIN										
			
			--#########################################################################################
			--#REGION (PO_ORDER_DTL, PO_ORDER_SAMPLE) 주문(본품,샘플) 상품별 피킹 정보 업데이트 처리 ##
			--#########################################################################################

			--본품 제품 피킹 업데이트 
			--UPDATE PO_ORDER_DTL SET 				
			--	PICKING_QTY = ODT.PICKING_QTY,
			--	PICKING_SDATE = (CASE WHEN ODT.PICKING_SDATE IS NULL AND ODT.ORD_QTY = ODT.QTY THEN GETDATE()
			--							WHEN ODT.PICKING_SDATE IS NOT NULL AND ODT.ORD_QTY != ODT.QTY THEN GETDATE()
			--							ELSE ODT.PICKING_SDATE END ),	--피킹시작일시 업데이트 (피킹 수량이 주문 수량과 일치하지 않고 피킹 수량을 최초 등록시 업데이트)
			--	PICKING_EDATE = (CASE WHEN ODT.PICKING_EDATE IS NULL AND ODT.ORD_QTY = ODT.QTY THEN GETDATE()
			--							WHEN ODT.PICKING_EDATE IS NOT NULL AND ODT.ORD_QTY = ODT.QTY THEN GETDATE()
			--							ELSE ODT.PICKING_EDATE END ),	--피킹 완료일시 업데이트 (피킹 수량 과 주문 수량이 동일하면 업데이트)
			--	PICKING_EMP_NO = @IEMP_ID,
			--	PICKING_SAMT = (ISNULL(ODT.ORD_SPRC, 0) + ISNULL(ODT.ORD_SVAT, 0)) * ODT.PICKING_QTY,
			--	PICKING_SPRC = ODT.ORD_SPRC,		--피킹공급가
			--	PICKING_SVAT = ODT.ORD_SVAT,		--피킹부가세
			--	UDATE = GETDATE(),
			--	UEMP_ID = @IEMP_ID
			--	FROM (
			--		SELECT 
			--			OD.ORD_NO,
			--			OD.SCAN_CODE,
			--			OD.ORD_QTY,
			--			OD.ORD_SPRC,
			--			OD.PICKING_SPRC,
			--			OD.ORD_SVAT,
			--			OD.ORD_SAMT,
			--			OD.PICKING_SDATE,
			--			OD.PICKING_EDATE,
			--			(CASE WHEN OD.ORD_QTY < T1.PICKING_QTY THEN OD.ORD_QTY ELSE T1.PICKING_QTY END) AS QTY,
			--			T1.PICKING_QTY										
			--		FROM PO_ORDER_DTL AS OD 
			--			INNER JOIN (SELECT ORD_NO, SCAN_CODE, SUM(PICKING_QTY) AS PICKING_QTY FROM @ORDER_TBL GROUP BY ORD_NO, SCAN_CODE) AS T1
			--		ON OD.ORD_NO = T1.ORD_NO AND OD.SCAN_CODE = T1.SCAN_CODE
				
			--	) AS ODT WHERE ODT.ORD_NO = PO_ORDER_DTL.ORD_NO AND ODT.SCAN_CODE = PO_ORDER_DTL.SCAN_CODE
				
								
			--샘픔 제품 피킹 업데이트
			--UPDATE PO_ORDER_SAMPLE SET 
			--	PICKING_QTY = (CASE WHEN ODT.ORD_QTY > ODT.PICKING_QTY THEN ODT.PICKING_QTY ELSE ODT.PICKING_QTY - ODT.ORD_QTY END),
			--	PICKING_EMP_NO = @IEMP_ID,
			--	UDATE = GETDATE(),
			--	UEMP_ID = @IEMP_ID
			--FROM (
			--	SELECT 					
			--		OT.ORD_NO, OT.SCAN_CODE, OT.PICKING_QTY,
			--		CASE WHEN OD.ORD_NO IS NULL THEN OS.ORD_QTY ELSE OD.PICKING_QTY END AS ORD_QTY						
			--	FROM (SELECT ORD_NO, SCAN_CODE, SUM(PICKING_QTY) AS PICKING_QTY FROM @ORDER_TBL GROUP BY ORD_NO, SCAN_CODE) AS OT 
			--		LEFT OUTER JOIN PO_ORDER_SAMPLE AS OS ON OT.ORD_NO = OS.ORD_NO AND OT.SCAN_CODE = OS.SCAN_CODE
			--		LEFT OUTER JOIN PO_ORDER_DTL AS OD ON OT.ORD_NO = OD.ORD_NO AND OT.SCAN_CODE = OD.SCAN_CODE 
			--) AS ODT WHERE PO_ORDER_SAMPLE.ORD_NO = ODT.ORD_NO AND PO_ORDER_SAMPLE.SCAN_CODE = ODT.SCAN_CODE
							
			--#ENDREGION
						
			--##############################################################################
			--#REGION (PO_ORDER_HDR) 주문마스타 테이블에 피킹 합계급액, 주문상태 업데이트 ##
			--##############################################################################
			--UPDATE PO_ORDER_HDR SET 
			--	ORD_STAT = (CASE WHEN @STAT = '33' THEN @STAT ELSE PO_ORDER_HDR.ORD_STAT END),
			--	PICKING_TOTAL_AMT = (SELECT ISNULL(SUM(PICKING_SAMT), 0) FROM PO_ORDER_DTL WHERE ORD_NO = @ORD_NO),
			--	PICKING_TOTAL_SPRC = (SELECT ISNULL(SUM(PICKING_SPRC * PICKING_QTY), 0) FROM PO_ORDER_DTL WHERE ORD_NO = @ORD_NO),
			--	UDATE = GETDATE(),
			--	UEMP_ID = @IEMP_ID
			--WHERE ORD_NO = @ORD_NO
			--#ENDREGION
					
			DECLARE @C_ORD_NO NVARCHAR(11),
					@C_SCAN_CODE NVARCHAR(14),
					@C_LOT_NO NVARCHAR(30),			
					@C_PICKING_QTY NUMERIC(15,2),
					@C_SET_GB NVARCHAR(2),
					@C_VEN_CODE NVARCHAR(2),
					@C_DELIVERY_REQ_DT NVARCHAR(8)

			--**********************************************
			--CURSOR : PO_ORDER_DTL, PO_ORDER_SAMPLE : UPDATE
			--**********************************************
			DECLARE CURSOR_ORD CURSOR FOR			
				
				SELECT OP.ORD_NO, OP.SCAN_CODE, OP.PICKING_QTY, CD.SET_GB, OH.VEN_CODE , DELIVERY_REQ_DT
					FROM (
							SELECT ORD_NO, SCAN_CODE, SUM(PICKING_QTY) AS PICKING_QTY  FROM @ORDER_TBL GROUP BY ORD_NO, SCAN_CODE
						) AS OP 
						INNER JOIN CD_PRODUCT_CMN AS CD ON OP.SCAN_CODE = CD.SCAN_CODE
						INNER JOIN PO_ORDER_HDR AS OH ON OP.ORD_NO = OH.ORD_NO
						
			OPEN CURSOR_ORD
						
			FETCH NEXT FROM CURSOR_ORD INTO @C_ORD_NO, @C_SCAN_CODE, @C_PICKING_QTY, @C_SET_GB, @C_VEN_CODE, @C_DELIVERY_REQ_DT
			WHILE(@@FETCH_STATUS=0)
			BEGIN		
				
				--본품 제품 주문 수량
				SELECT 
					@ORD_QTY = ISNULL(ORD_QTY, 0), 
					@ORD_SPRC = ISNULL(ORD_SPRC, 0), 
					@ORD_SVAT = ISNULL(ORD_SVAT,0), 
					@ORD_SAMT = ISNULL(ORD_SAMT,0),
					@PICKING_SDATE = PICKING_SDATE,
					@PICKING_EDATE = PICKING_EDATE
					FROM PO_ORDER_DTL WHERE ORD_NO = @C_ORD_NO AND SCAN_CODE = @C_SCAN_CODE

				--샘플 제품 주문 수량 
				SELECT @ORD_QTY_SAMPLE = ISNULL(ORD_QTY, 0) FROM PO_ORDER_SAMPLE WHERE ORD_NO = @C_ORD_NO AND SCAN_CODE = @C_SCAN_CODE
							
				--본품 피킹 수량
				SET @PICKING_QTY = DBO.GET_M_PICKING_QTY(@ORD_QTY, @ORD_QTY_SAMPLE, @C_PICKING_QTY, '')

				--샘플 피킹 수량
				SET @PICKING_QTY_SAMPLE = DBO.GET_M_PICKING_QTY(@ORD_QTY, @ORD_QTY_SAMPLE, @C_PICKING_QTY, 'SAMPLE')

				IF @PICKING_QTY > 0 
					SET @C_PICKING_QTY = @PICKING_QTY
														
				-- **********************************************
				-- PO_ORDER_SAMPLE : 샘픔 제품일 경우 피킹 업데이트
				-- **********************************************
				IF @ORD_QTY_SAMPLE > 0 
				BEGIN				
					UPDATE PO_ORDER_SAMPLE SET 
						PICKING_QTY = @PICKING_QTY_SAMPLE,
						PICKING_SDATE = GETDATE(),
						PICKING_EMP_NO = @IEMP_ID,
						UDATE = GETDATE(),
						UEMP_ID = @IEMP_ID
					WHERE ORD_NO = @C_ORD_NO AND SCAN_CODE = @C_SCAN_CODE
				END
				
				-- **********************************************
				-- PO_ORDER_DTL : 본품 제품 피킹 업데이트 
				-- **********************************************
				UPDATE PO_ORDER_DTL SET 					
					PICKING_QTY = @C_PICKING_QTY,										
					PICKING_SDATE = (CASE WHEN PO_ORDER_DTL.PICKING_SDATE IS NULL AND @C_PICKING_QTY > 0 THEN GETDATE()
										WHEN PO_ORDER_DTL.PICKING_SDATE IS NOT NULL AND PO_ORDER_DTL.ORD_QTY != @C_PICKING_QTY THEN GETDATE()
										ELSE PO_ORDER_DTL.PICKING_SDATE END ), --피킹시작일시 업데이트 (피킹 수량이 주문 수량과 일치하지 않고 피킹 수량을 최초 등록시 업데이트)
					PICKING_EDATE = (CASE WHEN PO_ORDER_DTL.PICKING_EDATE IS NULL AND PO_ORDER_DTL.ORD_QTY = @C_PICKING_QTY THEN GETDATE()
										WHEN PO_ORDER_DTL.PICKING_EDATE IS NOT NULL AND PO_ORDER_DTL.ORD_QTY = @C_PICKING_QTY THEN GETDATE()
										ELSE PO_ORDER_DTL.PICKING_EDATE END ),	--피킹 완료일시 업데이트 (피킹 수량 과 주문 수량이 동일하면 업데이트)
					PICKING_EMP_NO = @IEMP_ID,
					PICKING_SAMT = (@ORD_SPRC + @ORD_SVAT) * @C_PICKING_QTY,
					PICKING_SPRC = @ORD_SPRC,		--피킹공급가
					PICKING_SVAT = @ORD_SVAT,		--피킹부가세
					UDATE = GETDATE(),
					UEMP_ID = @IEMP_ID
				WHERE ORD_NO = @C_ORD_NO AND SCAN_CODE = @C_SCAN_CODE

				

				SET @PICKING_QTY = 0
				SET @PICKING_QTY_SAMPLE = 0

				FETCH NEXT FROM CURSOR_ORD INTO @C_ORD_NO, @C_SCAN_CODE, @C_PICKING_QTY, @C_SET_GB, @C_VEN_CODE, @C_DELIVERY_REQ_DT
			END
			CLOSE CURSOR_ORD
			DEALLOCATE CURSOR_ORD
			

			--**********************************************
			--CURSOR : CD_LOT_MST, PO_ORDER_LOT : UPDATE
			--**********************************************
			DECLARE CURSOR_ORD2 CURSOR FOR			
				
				SELECT OP.ORD_NO, OP.SCAN_CODE, ISNULL(OP.LOT_NO, '') AS LOT_NO, OP.PICKING_QTY, CD.SET_GB, OH.VEN_CODE , DELIVERY_REQ_DT
					FROM @ORDER_TBL AS OP 
						INNER JOIN CD_PRODUCT_CMN AS CD ON OP.SCAN_CODE = CD.SCAN_CODE
						INNER JOIN PO_ORDER_HDR AS OH ON OP.ORD_NO = OH.ORD_NO
						
			OPEN CURSOR_ORD2

		
			FETCH NEXT FROM CURSOR_ORD2 INTO @C_ORD_NO, @C_SCAN_CODE, @C_LOT_NO, @C_PICKING_QTY, @C_SET_GB, @C_VEN_CODE, @C_DELIVERY_REQ_DT
			WHILE(@@FETCH_STATUS=0)
			BEGIN		
				
				--본품 제품 주문 수량
				SELECT 
					@ORD_QTY = ISNULL(ORD_QTY, 0), 
					@ORD_SPRC = ISNULL(ORD_SPRC, 0), 
					@ORD_SVAT = ISNULL(ORD_SVAT,0), 
					@ORD_SAMT = ISNULL(ORD_SAMT,0)				
					FROM PO_ORDER_DTL WHERE ORD_NO = @C_ORD_NO AND SCAN_CODE = @C_SCAN_CODE

				--샘플 제품 주문 수량 
				SELECT @ORD_QTY_SAMPLE = ISNULL(ORD_QTY, 0) FROM PO_ORDER_SAMPLE WHERE ORD_NO = @C_ORD_NO AND SCAN_CODE = @C_SCAN_CODE
							
				--본품 피킹 수량
				SET @PICKING_QTY = DBO.GET_M_PICKING_QTY(@ORD_QTY, @ORD_QTY_SAMPLE, @C_PICKING_QTY, '')
				--샘플 피킹 수량
				SET @PICKING_QTY_SAMPLE = DBO.GET_M_PICKING_QTY(@ORD_QTY, @ORD_QTY_SAMPLE, @C_PICKING_QTY, 'SAMPLE')

				IF @PICKING_QTY > 0 
					SET @C_PICKING_QTY = @PICKING_QTY

					
				-- 2024.10.15 최수민 윤현빈 - SET 99999999 로 넣던거 안하고 일단 주석 (세트에 박힌 소비기한으로 처리)
				--IF @C_LOT_NO = '' 
				--BEGIN
					
				--	-- **********************************************
				--	-- SET 제품일경우(SET_GB : 1) LOT번호 생성, 소비기안 : 99999999
				--	-- **********************************************
				--	IF @C_SET_GB = '1'
				--	BEGIN

				--		--SET LOT 생성
				--		SET @LOT_NO_INFO = DBO.GET_WT_LOT_NO_CREATE(@C_SCAN_CODE, @C_VEN_CODE, '99999999', '99999999')
						
				--		SET @C_LOT_NO = DBO.FN_GET_SPLIT(@LOT_NO_INFO,'|', 1)		--LOT 번호
				--		SET @EXPIRY_DAY = DBO.FN_GET_SPLIT(@LOT_NO_INFO,'|', 2)		--소비기한

				--		SELECT @SET_CD = SET_CD FROM CD_SET_HDR WHERE SET_PROD_CD = @C_SCAN_CODE

				--		IF NOT EXISTS(SELECT LOT_NO FROM VIEW_CD_LOT_MST WHERE SCAN_CODE = @C_SCAN_CODE AND LOT_NO = @C_LOT_NO)
				--		BEGIN
						
				--			-- CD_LOT_MST 등록
				--			INSERT INTO CD_LOT_MST (PROD_DT, SCAN_CODE, PROD_GB, LOT_NO, EXPIRATION_DT, PROD_GB_CD, PROD_QTY, IDATE, IEMP_ID)
				--			SELECT FORMAT(GETDATE(), 'yyyyMMdd'), 
				--					@C_SCAN_CODE, 
				--					'S', 
				--					@C_LOT_NO,
				--					@EXPIRY_DAY,
				--					@SET_CD, 
				--					0,
				--					GETDATE(), 
				--					@IEMP_ID 

				--		END 						
				--	END					
				--END
				
				-- **********************************************
				-- PO_ORDER_LOT : 해당 주문건의 LOT 정보 업데이트	
				-- **********************************************
				IF @C_LOT_NO <> '' 
				BEGIN

					IF EXISTS(SELECT ORD_NO FROM PO_ORDER_LOT WHERE ORD_NO = @C_ORD_NO AND SCAN_CODE = @C_SCAN_CODE AND LOT_NO = @C_LOT_NO)
					BEGIN
						UPDATE PO_ORDER_LOT SET PICKING_QTY = (@C_PICKING_QTY + @PICKING_QTY_SAMPLE), UDATE = GETDATE(), UEMP_ID = @IEMP_ID 
							WHERE ORD_NO = @C_ORD_NO AND SCAN_CODE = @C_SCAN_CODE AND LOT_NO = @C_LOT_NO
					END
					ELSE
					BEGIN
						INSERT INTO PO_ORDER_LOT (ORD_NO, SCAN_CODE, LOT_NO, PICKING_QTY, IDATE, IEMP_ID)
							SELECT @C_ORD_NO, @C_SCAN_CODE, @C_LOT_NO, (@C_PICKING_QTY + @PICKING_QTY_SAMPLE), GETDATE(), @IEMP_ID
					END
				END
			

				SET @PICKING_QTY = 0
				SET @PICKING_QTY_SAMPLE = 0

				FETCH NEXT FROM CURSOR_ORD2 INTO @C_ORD_NO, @C_SCAN_CODE, @C_LOT_NO, @C_PICKING_QTY, @C_SET_GB, @C_VEN_CODE, @C_DELIVERY_REQ_DT
			END
			CLOSE CURSOR_ORD2
			DEALLOCATE CURSOR_ORD2


			--**********************************************
			--(PO_ORDER_HDR) 주문마스타 테이블에 피킹 합계급액, 주문상태 업데이트
			--**********************************************
			UPDATE PO_ORDER_HDR SET 
				ORD_STAT = (CASE WHEN @STAT = '33' THEN @STAT ELSE PO_ORDER_HDR.ORD_STAT END),
				PICKING_TOTAL_AMT = (SELECT ISNULL(SUM(PICKING_SAMT), 0) FROM PO_ORDER_DTL WHERE ORD_NO = @ORD_NO),
				PICKING_TOTAL_SPRC = (SELECT ISNULL(SUM(PICKING_SPRC * PICKING_QTY), 0) FROM PO_ORDER_DTL WHERE ORD_NO = @ORD_NO),
				UDATE = GETDATE(),
				UEMP_ID = @IEMP_ID
			WHERE ORD_NO = @ORD_NO
			--**********************************************

			--**********************************************
			--(PO_ORDER_PLT) 해당 주문건의 PLT 정보 업데이트
			--**********************************************
			IF EXISTS(SELECT ORD_NO FROM PO_ORDER_PLT WHERE ORD_NO = @ORD_NO)			
			BEGIN
				--해당 주문건 PLT 업데이트
				UPDATE PO_ORDER_PLT SET 
					PLT_KPP_QTY11 = T1.PLT_KPP_QTY11, 
					PLT_KPP_QTY12 = T1.PLT_KPP_QTY12,
					PLT_AJ_QTY11 = T1.PLT_AJ_QTY11,
					PLT_AJ_QTY12 = T1.PLT_AJ_QTY12
					FROM @ORDER_PLT_TBL AS T1 
						WHERE T1.ORD_NO = PO_ORDER_PLT.ORD_NO
			END
			ELSE
			BEGIN
				-- 해당 주문건 PLT 등록
				IF EXISTS(SELECT ORD_NO FROM PO_ORDER_HDR WHERE ORD_NO = @ORD_NO)
				BEGIN
					INSERT INTO PO_ORDER_PLT (ORD_NO, PLT_KPP_QTY11, PLT_KPP_QTY12, PLT_AJ_QTY11, PLT_AJ_QTY12) 
						SELECT ORD_NO, PLT_KPP_QTY11, PLT_KPP_QTY12, PLT_AJ_QTY11, PLT_AJ_QTY12 FROM @ORDER_PLT_TBL 
				END
			END
			
			
			--**********************************
			--계근대 PLT 수량 업데이트(PO_SCALE)
			--**********************************
			UPDATE PO_SCALE SET 
					PLT_QTY11 = (SELECT SUM(T1.PLT_AJ_QTY11) + SUM(T1.PLT_KPP_QTY11) FROM @ORDER_PLT_TBL AS T1 WHERE T1.ORD_NO = PO_SCALE.ORD_NO), 
					PLT_QTY12 = (SELECT SUM(T1.PLT_AJ_QTY12) + SUM(T1.PLT_KPP_QTY12) FROM @ORDER_PLT_TBL AS T1 WHERE T1.ORD_NO = PO_SCALE.ORD_NO),
					UDATE = GETDATE(),
					UEMP_ID = @IEMP_ID
				WHERE ORD_NO = @ORD_NO
			

		END
		--******************************************************************************************************************************************************
		--입고(발주)
		--******************************************************************************************************************************************************
		ELSE IF @IO_GB = 1
		BEGIN
			
			--**********************************
			--PO_PURCHASE_DTL : 발주 상품별 입고 수량 업데이트 처리
			--**********************************
			UPDATE PO_PURCHASE_DTL SET 
				PUR_QTY = T1.PICKING_QTY,																					--입고수량
				PUR_TOTAL_WPRC = ISNULL(PO_PURCHASE_DTL.ORD_WPRC, 0) * T1.PICKING_QTY,										--매입합계금액(공급가합계)
				PUR_WAMT = (ISNULL(PO_PURCHASE_DTL.ORD_WPRC, 0) + ISNULL(PO_PURCHASE_DTL.ORD_WVAT, 0)) * T1.PICKING_QTY,	--매입합계금액
				PUR_WPRC = PO_PURCHASE_DTL.ORD_WPRC,																		--피킹
				PUR_WVAT = PO_PURCHASE_DTL.ORD_WVAT,
				UEMP_ID = @IEMP_ID,
				UDATE = GETDATE()
				FROM @ORDER_TBL AS T1 
					WHERE T1.ORD_NO = PO_PURCHASE_DTL.ORD_NO 
						AND T1.SCAN_CODE = PO_PURCHASE_DTL.SCAN_CODE
	
			
			--**********************************
			--PO_PURCHASE_HDR : 발주 테이블에 입고(매입) 합계급액 업데이트
			--**********************************
			UPDATE PO_PURCHASE_HDR SET 
				PUR_STAT = (CASE WHEN @STAT = '33' THEN @STAT ELSE PO_PURCHASE_HDR.PUR_STAT END),
				PUR_TOTAL_AMT = (SELECT ISNULL(SUM(PUR_WAMT), 0) FROM PO_PURCHASE_DTL WHERE ORD_NO = @ORD_NO),	--매입합계금액
				PUR_TOTAL_WPRC = (SELECT ISNULL(SUM(PUR_WPRC * PUR_QTY), 0) FROM PO_PURCHASE_DTL WHERE ORD_NO = @ORD_NO),	--매입단가합계금액
				UDATE = GETDATE(),
				UEMP_ID = @IEMP_ID
					WHERE ORD_NO = @ORD_NO
					

			--**********************************
			-- PO_ORDER_PLT : 해당 주문건의 PLT 정보 업데이트 
			--**********************************
			IF EXISTS(SELECT ORD_NO FROM PO_ORDER_PLT WHERE ORD_NO = @ORD_NO)			
			BEGIN
				--해당 주문건 PLT 업데이트
				UPDATE PO_ORDER_PLT SET 
					PLT_KPP_QTY11 = T1.PLT_KPP_QTY11, 
					PLT_KPP_QTY12 = T1.PLT_KPP_QTY12,
					PLT_AJ_QTY11 = T1.PLT_AJ_QTY11,
					PLT_AJ_QTY12 = T1.PLT_AJ_QTY12
					FROM @ORDER_PLT_TBL AS T1 
						WHERE T1.ORD_NO = PO_ORDER_PLT.ORD_NO
			END
			ELSE
			BEGIN
				-- 해당 주문건 PLT 등록
				IF EXISTS(SELECT ORD_NO FROM PO_PURCHASE_HDR WHERE ORD_NO = @ORD_NO)
				BEGIN
					INSERT INTO PO_ORDER_PLT (ORD_NO, PLT_KPP_QTY11, PLT_KPP_QTY12, PLT_AJ_QTY11, PLT_AJ_QTY12) 
						SELECT ORD_NO, PLT_KPP_QTY11, PLT_KPP_QTY12, PLT_AJ_QTY11, PLT_AJ_QTY12 FROM @ORDER_PLT_TBL 
				END
			END
			
			
			--**********************************
			--PO_SCALE : 계근대 PLT 수량 업데이트
			--**********************************
			UPDATE PO_SCALE SET 
					PLT_QTY11 = (SELECT SUM(T1.PLT_AJ_QTY11) + SUM(T1.PLT_KPP_QTY11) FROM @ORDER_PLT_TBL AS T1 WHERE T1.ORD_NO = PO_SCALE.ORD_NO), 
					PLT_QTY12 = (SELECT SUM(T1.PLT_AJ_QTY12) + SUM(T1.PLT_KPP_QTY12) FROM @ORDER_PLT_TBL AS T1 WHERE T1.ORD_NO = PO_SCALE.ORD_NO),
					UDATE = GETDATE(),
					UEMP_ID = @IEMP_ID
				WHERE ORD_NO = @ORD_NO
						
		END
						
	COMMIT;
	END TRY
	
	BEGIN CATCH		

		IF @@TRANCOUNT > 0
		BEGIN 
			ROLLBACK TRAN
			
			
			IF CURSOR_STATUS('global', 'CURSOR_ORD') >= 0
			BEGIN
				CLOSE CURSOR_ORD;
				DEALLOCATE CURSOR_ORD;
			END

			IF CURSOR_STATUS('global', 'CURSOR_ORD2') >= 0
			BEGIN
				CLOSE CURSOR_ORD2;
				DEALLOCATE CURSOR_ORD2;
			END
			
			--에러 로그 테이블 저장
			INSERT INTO TBL_ERROR_LOG 
			SELECT ERROR_PROCEDURE()			-- 프로시저명
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

