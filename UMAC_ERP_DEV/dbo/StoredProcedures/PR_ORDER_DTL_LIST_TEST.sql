/*
-- 생성자 :	강세미
-- 등록일 :	2024.02.15
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 주문등록 DTL 조회
-- 실행문 : 
EXEC PR_ORDER_DTL_LIST '2240612001'
EXEC PR_ORDER_DTL_LIST_TEST '2240612001'
--단품
EXEC PR_ORDER_DTL_LIST '2240624004' 
EXEC PR_ORDER_DTL_LIST_TEST '2240705001' 
--박스
EXEC PR_ORDER_DTL_LIST '2240624003'
*/
CREATE PROCEDURE [dbo].[PR_ORDER_DTL_LIST_TEST]
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
				 CASE WHEN B.ITM_FORM = '2' THEN G.BOX_EACH_QTY ELSE G.CUR_INV_QTY END AS CUR_INV_QTY,
				 --CASE WHEN B.ITM_FORM = '2' THEN G.BOX_EACH_QTY - H.BOX_EACH_NOT_DELIVERY_QTY ELSE G.CUR_INV_QTY - ISNULL(H.NOT_DELIVERY_QTY,0) END AS AVL_INV_QTY
				 --CASE WHEN B.ITM_FORM = '2' THEN G.BOX_EACH_QTY - H.ORD_QTY ELSE G.CUR_INV_QTY - H.ORD_QTY END AS AVL_INV_QTY
				 CASE WHEN B.ITM_FORM = '2' THEN G.BOX_EACH_QTY - H.TOTAL_ORD_QTY ELSE G.CUR_INV_QTY - H.TOTAL_ORD_QTY END AS AVL_INV_QTY
		  FROM PO_ORDER_DTL AS A
		  INNER JOIN CD_PRODUCT_CMN AS B
					 ON B.SCAN_CODE = A.SCAN_CODE
		  LEFT OUTER JOIN TBL_COMM_CD_MST AS C
					 ON C.CD_CL = 'DOCUMENT_REQ' AND A.DOCUMENT_REQ = C.CD_ID
		  INNER JOIN TBL_COMM_CD_MST AS D
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


									--SELECT A.SCAN_CODE
									--     , A.CUR_INV_QTY
									--	 , C.CUR_INV_QTY AS BOX_EACH_QTY
									--	FROM IV_PRODUCT_STAT AS A
									--	LEFT OUTER JOIN CD_BOX_MST AS B ON A.ITM_CODE = B.BOX_CODE
									--	LEFT OUTER JOIN IV_PRODUCT_STAT AS C ON B.ITM_CODE = C.ITM_CODE
								) AS G
		  ON A.SCAN_CODE = G.SCAN_CODE
		  --LEFT OUTER JOIN (
									--SELECT B.SCAN_CODE
									--	 , SUM(B.ORD_QTY) AS NOT_DELIVERY_QTY
									--	 , SUM(B.ORD_QTY * C.IPSU_QTY) AS BOX_EACH_NOT_DELIVERY_QTY
									--	FROM PO_ORDER_HDR AS A
									--	INNER JOIN PO_ORDER_DTL B ON A.ORD_NO = B.ORD_NO
									--	LEFT OUTER JOIN (
									--						SELECT B.SCAN_CODE
									--							 , A.IPSU_QTY
									--							FROM CD_BOX_MST AS A
									--							INNER JOIN CD_PRODUCT_CMN AS B ON A.BOX_CODE = B.ITM_CODE

									--	) AS C ON B.SCAN_CODE = C.SCAN_CODE
									--   WHERE A.ORD_STAT IN (SELECT CD_ID 
									--							FROM TBL_COMM_CD_MST 
									--						   WHERE CD_CL = 'AVL_INV_STAT')
									--   GROUP BY B.SCAN_CODE
									
									--SELECT 
									--	B.SCAN_CODE,
									--	C.ITM_CODE,
									--	D.BOX_CODE,
									--	ISNULL(D.ORD_QTY, 0) AS ORD_QTY
									--FROM PO_ORDER_HDR AS A
									--INNER JOIN PO_ORDER_DTL AS B ON A.ORD_NO = B.ORD_NO
									--INNER JOIN CD_PRODUCT_CMN AS C ON B.SCAN_CODE = C.SCAN_CODE
									--LEFT OUTER JOIN (
									--	SELECT 
									--		DD.ITM_CODE,
									--		DD.BOX_CODE,
									--		SUM(CASE WHEN CC.ITM_FORM = '1' THEN ISNULL(BB.ORD_QTY,0) ELSE ISNULL(BB.ORD_QTY,0) * DD.IPSU_QTY END) AS ORD_QTY
									--	FROM PO_ORDER_HDR AS AA
									--	INNER JOIN PO_ORDER_DTL AS BB ON AA.ORD_NO = BB.ORD_NO
									--	INNER JOIN CD_PRODUCT_CMN AS CC ON BB.SCAN_CODE = CC.SCAN_CODE
									--	LEFT OUTER JOIN CD_BOX_MST AS DD ON  CC.ITM_CODE = (CASE WHEN CC.ITM_FORM = '1' THEN DD.ITM_CODE ELSE DD.BOX_CODE END)
									--	WHERE AA.ORD_STAT IN (SELECT CD_ID FROM TBL_COMM_CD_MST WHERE CD_CL = 'AVL_INV_STAT') 
									--	GROUP BY DD.ITM_CODE, DD.BOX_CODE
									--) AS D 
									--ON C.ITM_CODE = CASE WHEN ITM_FORM = '1' THEN D.ITM_CODE ELSE D.BOX_CODE END
									--WHERE A.ORD_NO = @P_ORD_NO

									--SELECT ISNULL(C.TOTAL_ORD_QTY, 0) AS TOTAL_ORD_QTY, A.SCAN_CODE
									--FROM PO_ORDER_DTL AS A
									--INNER JOIN CD_PRODUCT_CMN AS B ON A.SCAN_CODE = B.SCAN_CODE
									--LEFT OUTER JOIN VIEW_TOTAL_ORDER_QTY AS C ON B.ITM_CODE = C.ITM_CODE
									--GROUP BY A.SCAN_CODE, TOTAL_ORD_QTY
								--) AS H
		 LEFT OUTER JOIN VIEW_TOTAL_ORDER_QTY AS H ON B.ITM_CODE = H.ITM_CODE
		 --ON A.SCAN_CODE = H.SCAN_CODE
		 --ON B.ITM_CODE = (CASE WHEN B.ITM_FORM = '1' THEN H.ITM_CODE ELSE H.BOX_CODE END)
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
