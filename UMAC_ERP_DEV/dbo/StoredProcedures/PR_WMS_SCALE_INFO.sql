/*

-- 생성자 :	이동호
-- 등록일 :	2024.04.03
-- 수정자 : -
-- 설 명  : 입출고예정조회 > 계근대 정보 출력
-- 실행문 : 
EXEC PR_WMS_SCALE_INFO '2240320800'

*/
CREATE PROCEDURE [dbo].[PR_WMS_SCALE_INFO]
( 
	@P_ORD_NO					NVARCHAR(11) = ''	-- 주문(발주)번호	
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	BEGIN TRY 
	
		DECLARE @IO_GB INT = LEFT(@P_ORD_NO, 1)
	
		SELECT @IO_GB AS IO_GB
			, A.ORD_NO
			, A.ORD_DT						--주문/발주일
			, A.DELIVERY_DT					--입출고일자
			, A.ORD_AMT						--주문/발수 합계금액
			, A.VEN_CODE
			, A.GROUP_NO
			, A.ITM_PUR_GB					--상품매출입구분
			, A.SCALE_DT					--계량일자
			, A.CAR_GB						--차량구분
			, A.TRANS_COST					--운송비
			, A.RENT_COST					--용차비
			, A.CAR_NO						--차량번호
			, A.CENTER_GB					--창고구분
			, A.PLT_QTY11					--파렛트11형수량
			, A.PLT_QTY12					--파렛트12형수량
			, A.GROSS_WGHT					--총중량
			, A.UNLOAD_WGHT					--공차중량
			, A.NET_WGHT					--자차중량(순중량)
			, A.OFFICIAL_WGHT				--타차중량
			, A.GAP_WGHT					--차이중량
			, A.BAG_GB						--피중량 구분
			, A.BAG_QTY						--피중량 수량
			, A.BAG_WGHT					--피중량 무게(KG)
			, ISNULL(A.ENTRANCE_YN, 'N') AS ENTRANCE_YN									--입차여부
			, CONVERT(VARCHAR(10),GROSS_WGHT_DT,108) AS GROSS_WGHT_DT	--총중량 계근시간
			, CONVERT(VARCHAR(10),UNLOAD_WGHT_DT,108) AS UNLOAD_WGHT_DT	--공차중량 계근시간
			, A.REMARKS
			
		FROM PO_SCALE AS A WHERE A.ORD_NO = @P_ORD_NO
		
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

