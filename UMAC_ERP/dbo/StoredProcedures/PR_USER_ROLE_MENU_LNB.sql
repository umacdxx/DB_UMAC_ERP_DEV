/*
-- 생성자 :	강세미
-- 등록일 :	2023.01.10
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 사용자별 메뉴 LNB 출력
-- 실행문 : 
EXEC PR_USER_ROLE_MENU_LNB 'admin'
*/
CREATE PROCEDURE [dbo].[PR_USER_ROLE_MENU_LNB]
( @P_USER_ID NVARCHAR(20) = '' -- 사용자ID
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	BEGIN TRY 
		SELECT B.SEQ
			  , A.MENU_CODE
			  , B.MENU_NM
			  , B.MENU_GB
			  , B.MENU_ICON
			  , B.MENU_LINK
			  , B.UP_MENU_CODE
			  , B.SORT_ORDER
			  , B.HELP
			  , B.DEL_YN
			  , '' AS LOW_MENU_CODE 
			  , 0 AS LOW_SORT_ORDER
			  , '' AS UPPER_MENU_NM
		  FROM TBL_USER_ROLE_MST AS A
				INNER JOIN TBL_MENU_INFO AS B
					ON A.MENU_CODE = B.MENU_CODE
		 WHERE A.USER_ID = @P_USER_ID
		   AND B.DEL_YN = 'N'

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

