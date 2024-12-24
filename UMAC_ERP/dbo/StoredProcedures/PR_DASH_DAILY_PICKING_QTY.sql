
/*
-- 생성자 :	최수민
-- 등록일 :	2024.06.20
-- 설 명  : 대시보드 금일 출고량
-- 수정자 :	최수민
-- 수정일 :	2024.06.20
-- 설 명  : 
-- 실행문 : EXEC PR_DASH_DAILY_PICKING_QTY
*/
CREATE PROCEDURE [dbo].[PR_DASH_DAILY_PICKING_QTY]
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT CASE
			 WHEN C.itm_name LIKE '대두유%' THEN '대두유'
			 WHEN C.itm_name LIKE '옥배유%' THEN '옥배유'
			 WHEN C.itm_name LIKE '카놀라유%' THEN '카놀라유'
			 WHEN C.itm_name LIKE '올리브유%' THEN '올리브유'
			 WHEN C.itm_name LIKE '포도씨유%' THEN '포도씨유'
			 ELSE '기타'
		   END                           AS ITM_NAME,
		   Sum(Isnull(B.picking_qty, 0)) AS PICKING_QTY
	FROM   po_order_hdr AS A
		   INNER JOIN po_order_dtl AS B
				   ON A.ord_no = B.ord_no
		   LEFT OUTER JOIN cd_product_cmn AS C
						ON B.scan_code = C.scan_code
	WHERE  A.ord_stat IN ( 35, 40 )
		   AND A.delivery_dec_dt BETWEEN CONVERT(DATE, Getdate() - 30) AND
										 CONVERT(DATE, Getdate())
	GROUP  BY CASE
				WHEN C.itm_name LIKE '대두유%' THEN '대두유'
				WHEN C.itm_name LIKE '옥배유%' THEN '옥배유'
				WHEN C.itm_name LIKE '카놀라유%' THEN '카놀라유'
				WHEN C.itm_name LIKE '올리브유%' THEN '올리브유'
				WHEN C.itm_name LIKE '포도씨유%' THEN '포도씨유'
				ELSE '기타'
			  END 

END

GO

