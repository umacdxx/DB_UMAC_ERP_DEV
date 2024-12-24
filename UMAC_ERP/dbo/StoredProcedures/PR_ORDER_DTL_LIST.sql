/*
-- 생성자 :	강세미
-- 등록일 :	2024.02.15
-- 수정자 : 2024.07.31 강세미 - 벌크제품 현재고, 가용재고 0 처리
-- 수정일 : - 
-- 설 명  : 주문등록 DTL 조회
-- 실행문 : 
EXEC PR_ORDER_DTL_LIST '2240624001'
EXEC PR_ORDER_DTL_LIST '2240705001'
*/
CREATE PROCEDURE [dbo].[PR_ORDER_DTL_LIST]
( 
	@P_ORD_NO	NVARCHAR(11) = ''   -- 주문번호
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
 
	BEGIN TRY 
		SELECT ROW_NUMBER() OVER(ORDER BY SEQ) AS ROW_NUM,
				 A.ORD_NO,
				 A.SEQ,
				 A.SCAN_CODE,
				 A.ITM_GB,
				 A.IPSU_QTY,
				 A.ORD_QTY,				 				
				 A.ORD_SPRC,
				 (A.ORD_SPRC + A.ORD_SVAT) AS ORD_SALE,
				 A.ORD_SVAT,
				 A.ORD_SAMT,
				 A.TAX_GB,
				 A.DOCUMENT_REQ,
				 CAST(ISNULL(A.PICKING_QTY,0) AS DECIMAL(15,2)) AS PICKING_QTY,
				 CAST(ISNULL(A.PICKING_SAMT,0) AS DECIMAL(17,4)) AS PICKING_SAMT,
				 A.PICKING_EMP_NO,
				 A.PICKING_SDATE,
				 A.PICKING_EDATE,
				 A.PICKING_SPRC,
				 A.PICKING_SVAT,
				 B.WEIGHT_GB,
				 B.ITM_NAME,
				 B.ITM_NAME_DETAIL,
				 B.UNIT,
				 ISNULL(B.UNIT_CAPACITY, '') AS UNIT_CAPACITY,				 
				 C.CD_NM AS DOCUMENT_REQ_NM,
				 D.CD_NM AS TAX_GB_NM,
				 A.REMARKS,
				 E.CD_NM AS ITM_GB_NM,
				 F.CD_NM AS UNIT_NM,
				 --B.ITM_FORM,
				 --G.CUR_INV_QTY,
				 --H.NOT_DELIVERY_QTY,
				 --H.BOX_EACH_NOT_DELIVERY_QTY,
				 CASE WHEN B.ITM_FORM = '3' THEN 0 WHEN B.ITM_FORM = '2' THEN G.BOX_EACH_QTY ELSE G.CUR_INV_QTY END AS CUR_INV_QTY,
				 CASE WHEN B.ITM_FORM = '3' THEN 0 WHEN B.ITM_FORM = '2' THEN ISNULL(G.BOX_EACH_QTY,0) - ISNULL(H.TOTAL_ORD_QTY, 0) ELSE ISNULL(G.CUR_INV_QTY,0) - ISNULL(H.TOTAL_ORD_QTY, 0) END AS AVL_INV_QTY
		  FROM PO_ORDER_DTL AS A
		  INNER JOIN CD_PRODUCT_CMN AS B
					 ON B.SCAN_CODE = A.SCAN_CODE
		  LEFT OUTER JOIN TBL_COMM_CD_MST AS C
					 ON C.CD_CL = 'DOCUMENT_REQ' AND A.DOCUMENT_REQ = C.CD_ID
		  LEFT OUTER JOIN TBL_COMM_CD_MST AS D
					 ON D.CD_CL = 'TAX_GB' AND A.TAX_GB = D.CD_ID
		  INNER JOIN TBL_COMM_CD_MST AS E
					 ON E.CD_CL = 'ITM_GB' AND A.ITM_GB = E.CD_ID
		  INNER JOIN TBL_COMM_CD_MST AS F
					 ON F.CD_CL = 'UNIT' AND B.UNIT = F.CD_ID
		  LEFT OUTER JOIN (
									SELECT A.SCAN_CODE
									 	 , A.ITM_CODE
									 	 , D.CUR_INV_QTY
									 	 , C.CUR_INV_QTY AS BOX_EACH_QTY
									 FROM CD_PRODUCT_CMN AS A
									 LEFT OUTER JOIN IV_PRODUCT_STAT AS D ON A.SCAN_CODE = D.SCAN_CODE
									 LEFT OUTER JOIN CD_BOX_MST AS B ON A.ITM_CODE = B.BOX_CODE
									 LEFT OUTER JOIN IV_PRODUCT_STAT AS C ON B.ITM_CODE = C.ITM_CODE
								) AS G
		 ON A.SCAN_CODE = G.SCAN_CODE
		 LEFT OUTER JOIN VIEW_TOTAL_ORDER_QTY AS H ON B.ITM_CODE = H.ITM_CODE
		 WHERE A.ORD_NO = @P_ORD_NO

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
