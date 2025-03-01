/*
-- 생성자 :	윤현빈
-- 등록일 :	2024.04.03
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : BOM 마스터 DTL 리스트 출력(팝업)
-- 실행문 : 
EXEC PR_BOM_MST_DTL_LIST_POPUP '210001'
*/
CREATE PROCEDURE [dbo].[PR_BOM_MST_DTL_LIST_POPUP]
( 
	@P_BOM_CD	NVARCHAR(3) = ''   -- BOM 코드
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	BEGIN TRY 
	
		SELECT ROW_NUMBER() OVER(ORDER BY A.BOM_CD ) AS ROW_NUM
		     , A.BOM_COMP_CD		     
		     , A.COMP_QTY
			 , CM.ITM_NAME_DETAIL AS BOM_COMP_NM
		FROM CD_BOM_DTL AS A
			INNER JOIN CD_PRODUCT_CMN AS CM ON A.BOM_COMP_CD = CM.SCAN_CODE
	   WHERE BOM_CD = @P_BOM_CD

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

