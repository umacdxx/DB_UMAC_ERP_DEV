/*
-- 생성자 :	강세미
-- 등록일 :	2024.01.10
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 사용자권한별 메뉴 초기화
-- 실행문 : EXEC PR_USER_ROLE_MST_DEL 'admin',
*/
CREATE PROCEDURE [dbo].[PR_USER_ROLE_MST_DEL]
	@P_USER_ID NVARCHAR(20)				-- 사용자ID
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	DECLARE @RETURN_CODE INT = 0			-- 리턴코드
	DECLARE @RETURN_MESSAGE NVARCHAR(10) = ''		-- 리턴메시지

	BEGIN TRY 
		DELETE TBL_USER_ROLE_MST
		 WHERE USER_ID = @P_USER_ID

		SET @RETURN_CODE = 0 -- 저장완료
		SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('0')

	END TRY
	BEGIN CATCH		
		--에러 로그 테이블 저장
		INSERT INTO TBL_ERROR_LOG 
		SELECT ERROR_PROCEDURE()	-- 프로시저명
		, ERROR_MESSAGE()			-- 에러메시지
		, ERROR_LINE()				-- 에러라인
		, GETDATE()	

		SET @RETURN_CODE = -1 -- 저장실패
		SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('-1')
	END CATCH
	
	
	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE
END

GO

