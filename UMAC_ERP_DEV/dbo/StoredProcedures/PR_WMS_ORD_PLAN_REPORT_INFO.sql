/*

-- 생성자 :	강세미
-- 등록일 :	2024.09.30
-- 수정자 : -
-- 설 명  : 입출고예정조회 > 출고예정리스트 리포트
-- 실행문 : 
EXEC PR_WMS_ORD_PLAN_REPORT_INFO '2241010005'

*/
CREATE PROCEDURE [dbo].[PR_WMS_ORD_PLAN_REPORT_INFO]
( 

	@P_ORD_NO				VARCHAR(11) = ''  -- 주문번호
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	BEGIN TRY 
		
		SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ROW_NUM,
			   A.SCAN_CODE,
			   B.ITM_NAME,
			   C.LOT_NO,
			   FORMAT(CONVERT(DATE, D.PROD_DT), 'yyyy.MM.dd') AS PROD_DT,
			   FORMAT(CONVERT(DATE, D.EXPIRATION_DT,112), 'yyyy.MM.dd') AS EXPIRATION_DT,
			   C.PICKING_QTY AS QTY,
			   (CASE WHEN B.ITM_FORM = '1' THEN C.PICKING_QTY / E.IPSU_QTY ELSE 0 END) AS BOX_QTY
		FROM PO_ORDER_DTL AS A
			INNER JOIN CD_PRODUCT_CMN AS B ON A.SCAN_CODE = B.SCAN_CODE
			LEFT OUTER JOIN PO_ORDER_LOT AS C ON C.ORD_NO = @P_ORD_NO AND C.SCAN_CODE = A.SCAN_CODE
			INNER JOIN CD_LOT_MST AS D ON C.LOT_NO = D.LOT_NO
			LEFT OUTER JOIN CD_BOX_MST AS E ON E.ITM_CODE = B.ITM_CODE
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
