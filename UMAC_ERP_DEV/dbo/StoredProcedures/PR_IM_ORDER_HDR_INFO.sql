/*
-- 생성자 :	강세미
-- 등록일 :	2024.05.17
-- 수정자 : 2024.12.04 강세미- B/L 관련 신규컬럼 추가
-- 설 명  : 수입발주등록 HDR 조회
-- 실행문 : 
EXEC PR_IM_ORDER_HDR_INFO 'PO240509'
*/
CREATE PROCEDURE [dbo].[PR_IM_ORDER_HDR_INFO]
( 
	@P_PO_NO	NVARCHAR(15) = ''   -- PO번호
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
 
	BEGIN TRY 
		SELECT A.PO_NO,
			   A.PO_NAME,
			   A.PO_ORD_DT,
			   A.VEN_CODE,
			   A.INCOTERMS,
			   A.LC_NO,
			   A.LC_GB,
			   A.LC_OPEN_DT,
			   A.LC_CLOSE_DT,
			   A.OPEN_BANK,
			   A.DEPARTURE_COUNTRY,
			   A.DEPARTURE_PORT,
			   A.ARRIVAL_COUNTRY,
			   A.ARRIVAL_PORT,
			   A.BL_NO,
			   A.BL_NO_2,
			   A.BL_NO_3,
			   A.BL_DT,
			   A.BL_DT_2,
			   A.BL_DT_3,
			   A.INVOICE_AMT,
			   A.INVOICE_AMT_2,
			   A.INVOICE_AMT_3,
			   A.CURRENCY_TYPE,
			   A.LC_EXCHANGE_RATE,
			   A.TT_EXCHANGE_RATE,
			   A.LC_AMT,
			   A.TT_AMT,
			   A.CUSTOMS_CL_DT,
			   A.NOT_DELIVERED_SLIP,
			   A.PUR_SLIP,
			   A.PUR_SLIP_NO,
			   A.PUR_SLIP_DT,
			   B.VEN_NAME
		  FROM IM_ORDER_HDR A 
			INNER JOIN CD_PARTNER_MST B ON A.VEN_CODE = B.VEN_CODE
  		 WHERE A.PO_NO = @P_PO_NO
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

