
/*
-- 생성자 :	이동호
-- 등록일 :	2024.04.22
-- 설 명  : 모바일(앱) 지시서 상세 상품리스트
-- 수정자 : 최수민
-- 수정일 : 2024.08.26 제품명 -> 단축제품명 변경
-- 실행문 : 

EXEC PR_MO_WMS_ORD_PRODUCT_LIST '2240530001'

*/
CREATE PROCEDURE [dbo].[PR_MO_WMS_ORD_PRODUCT_LIST]
( 	
	@P_ORD_NO			NVARCHAR(11) = ''		-- 주문번호	
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	BEGIN TRY 
		
		DECLARE @IO_GB INT = LEFT(@P_ORD_NO, 1) -- 1 : 입고, 2 : 출고
				
		--REGION 출고
		IF @IO_GB = 2 
		BEGIN

			SELECT 
				ORD_NO,																									--주문번호
				ITM_CODE,																								--상품코드				
				SCAN_CODE,																								--상품스캔코드
				ITM_NAME,																								--상품명
				WEIGHT_GB,																								--상품 수/중량 구분 코드
				(CASE WHEN WEIGHT_GB = 'QTY' THEN 'EA' WHEN WEIGHT_GB = 'WT' THEN 'KG' ELSE '' END) AS  WEIGHT_GB_NM,	--상품 수/중량 구분 단위
				ITM_FORM,																								--상품형태	
				LOT_OIL_GB,																								--LOT유종
				LOT_PARTNER_GB,																							--LOT거래처구분						
				ISNULL(EXPIRY_CNT, 0) AS EXPIRY_CNT,																	--소비기한일자
				SET_GB,																									--SET구분
				ORD_QTY,																								--주문수량(지시서 수량)
				LOT_NO_CNT,																								--LOT수량(미사용 컬럼)
				PICKING_QTY_CNT,																						--검수수량(피킹수량)
				(CASE	WHEN PICKING_QTY_CNT > 0 AND ORD_QTY = PICKING_QTY_CNT THEN 'S' 
						WHEN PICKING_QTY_CNT > 0 AND ORD_QTY <> PICKING_QTY_CNT THEN 'M' 
						ELSE 'F' END) AS PICKING_STATE																	--완료 : S, 불일치 : M, 미처리 : F
			FROM (
				SELECT
					OHDR.ORD_NO,											
					CMN.ITM_CODE,								
					ODTL.SCAN_CODE,					
					CMN.ITM_NAME,
					CMN.WEIGHT_GB,
					CMN.ITM_FORM,					
					CMN.LOT_OIL_GB,
					CMN.LOT_PARTNER_GB,					
					CMN.EXPIRY_CNT,
					CMN.SET_GB,
					ISNULL(ODTL.ORD_QTY,0) AS ORD_QTY,						
					ISNULL(OLOT.LOT_NO_CNT, 0) AS LOT_NO_CNT,										
					(CASE WHEN CMN.WEIGHT_GB = 'QTY' THEN ISNULL(OLOT.PICKING_QTY_CNT,0) 
							WHEN CMN.WEIGHT_GB = 'WT' THEN ISNULL(ODTL.PICKING_QTY,0) 
						END) AS PICKING_QTY_CNT
				FROM PO_ORDER_HDR AS OHDR 											
					INNER JOIN VIEW_ORDER_DTL_SAMPLE_SUM AS ODTL ON ODTL.ORD_NO = OHDR.ORD_NO
					INNER JOIN CD_PRODUCT_CMN AS CMN ON CMN.SCAN_CODE = ODTL.SCAN_CODE	
					LEFT OUTER JOIN (
						SELECT ORD_NO, SCAN_CODE, SUM(CASE WHEN LOT_NO = '' THEN 0 ELSE 1 END) AS LOT_NO_CNT, SUM(PICKING_QTY) AS PICKING_QTY_CNT FROM PO_ORDER_LOT GROUP BY ORD_NO, SCAN_CODE
					) AS OLOT ON OLOT.ORD_NO = OHDR.ORD_NO AND OLOT.SCAN_CODE = ODTL.SCAN_CODE					
			) AS TBL

			WHERE TBL.ORD_NO = @P_ORD_NO
			
		END
		--ENDREGION 출고

		--REGION 입고
		ELSE IF @IO_GB = 1
		BEGIN

			SELECT 
				ORD_NO,																									--주문번호
				ITM_CODE,																								--상품코드
				SCAN_CODE,																								--상품스캔코드
				ITM_NAME,																								--상품명				
				WEIGHT_GB,																								--상품 수/중량 구분 코드
				(CASE WHEN WEIGHT_GB = 'QTY' THEN 'EA' WHEN WEIGHT_GB = 'WT' THEN 'KG' ELSE '' END) AS  WEIGHT_GB_NM,	--상품 수/중량 구분 단위
				ITM_FORM,																								--상품형태					
				LOT_OIL_GB,																								--LOT유종
				LOT_PARTNER_GB,																							--LOT거래처구분				
				ISNULL(EXPIRY_CNT, 0) AS EXPIRY_CNT,																	--소비기한일자
				SET_GB,																									--SET구분
				ORD_QTY,																								--주문수량(지시서 수량)
				LOT_NO_CNT,																								--LOT수량(미사용 컬럼)
				PICKING_QTY_CNT,																						--검수수량(피킹수량)
				(CASE	WHEN PICKING_QTY_CNT > 0 AND ORD_QTY = PICKING_QTY_CNT THEN 'S' 
						WHEN PICKING_QTY_CNT > 0 AND ORD_QTY <> PICKING_QTY_CNT THEN 'M' 
						ELSE 'F' END) AS PICKING_STATE																	--완료 : S, 불일치 : M, 미처리 : F
			FROM (
				SELECT
					OHDR.ORD_NO,
					CMN.ITM_CODE,
					ODTL.SCAN_CODE,
					CMN.ITM_NAME,
					CMN.WEIGHT_GB,
					CMN.ITM_FORM,					
					CMN.LOT_OIL_GB,
					CMN.LOT_PARTNER_GB,
					CMN.EXPIRY_CNT,
					CMN.SET_GB,
					ISNULL(ODTL.ORD_QTY,0) AS ORD_QTY,						
					0 AS LOT_NO_CNT,				
					ISNULL(ODTL.PUR_QTY,0) AS PICKING_QTY_CNT		
				FROM PO_PURCHASE_HDR AS OHDR 	
					INNER JOIN PO_PURCHASE_DTL AS ODTL ON ODTL.ORD_NO = OHDR.ORD_NO
					INNER JOIN CD_PRODUCT_CMN AS CMN ON CMN.SCAN_CODE = ODTL.SCAN_CODE					
			) AS TBL

			WHERE TBL.ORD_NO = @P_ORD_NO

		END
		--ENDREGION 입고
			
	END TRY
	
	BEGIN CATCH		
		--에러 로그 테이블 저장
		INSERT INTO TBL_ERROR_LOG 
		SELECT ERROR_PROCEDURE()	-- 프로시저명
		, ERROR_MESSAGE()			-- 에러메시지
		, ERROR_LINE()				-- 에러라인
		, GETDATE()	
	END CATCH
	
END

GO

