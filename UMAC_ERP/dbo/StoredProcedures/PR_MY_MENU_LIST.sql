/*
-- 생성자 :	강세미
-- 등록일 :	2024.01.15
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 마이메뉴 리스트
-- 실행문 : EXEC PR_MY_MENU_LIST 'admin'
*/
CREATE PROCEDURE [dbo].[PR_MY_MENU_LIST]
	@P_USER_ID NVARCHAR(20) 				-- 사용자ID
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	BEGIN TRY 
		WITH TEMP_TBL
					AS (
						SELECT 							
							A.SEQ,
							A.MENU_CODE,
							A.MENU_NM,			
							A.MENU_GB,
							A.MENU_ICON,
							A.MENU_LINK,
							A.UP_MENU_CODE,
							A.SORT_ORDER,
							A.HELP,
							A.DEL_YN,
							CONVERT(VARCHAR(50), A.MENU_CODE) AS SORT
						FROM TBL_MENU_INFO AS A
						WHERE  UP_MENU_CODE = ''
						UNION ALL
						SELECT 
							DM.SEQ,
							DM.MENU_CODE,
							DM.MENU_NM,			
							DM.MENU_GB,
							DM.MENU_ICON,
							DM.MENU_LINK,
							DM.UP_MENU_CODE,
							DM.SORT_ORDER,
							DM.HELP,
							DM.DEL_YN,		
							CONVERT(VARCHAR(50), CONVERT(NVARCHAR, TT.SORT) + N' > ' + CONVERT(VARCHAR(255), dbo.FN_DEPT_CODE_SORT_CH(DM.MENU_CODE,DM.SORT_ORDER))) SORT
						FROM TBL_MENU_INFO AS DM,
							TEMP_TBL AS TT
						WHERE DM.UP_MENU_CODE = TT.MENU_CODE
					)
					SELECT 
							SEQ,
						   A.MENU_CODE,
							MENU_NM,			
							2 AS MENU_GB,
							MENU_ICON,
							MENU_LINK,
							'01' AS UP_MENU_CODE,
							SORT_ORDER,
							HELP,
							DEL_YN,
							'' AS LOW_MENU_CODE, 
							0 AS LOW_SORT_ORDER,
							'' AS UPPER_MENU_NM
					FROM TEMP_TBL AS A
		   INNER JOIN TBL_MY_MENU AS B
			        ON A.MENU_CODE = B.MENU_CODE
					 AND B.USER_ID = @P_USER_ID
					WHERE DEL_YN = 'N'
					ORDER  BY SORT
		
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

