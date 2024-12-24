
/*
-- 생성자 :	이동호
-- 등록일 :	2024.08.30
-- 수정자 : -
-- 수정일 : - 
-- 설 명	: 유맥 서버 환경별 API 호출 주소 RETURN
-- 실행문 : 
*/
CREATE FUNCTION [dbo].[UMAC_API_URL](
)
RETURNS NVARCHAR(2000)
AS
BEGIN
	DECLARE @RESULT NVARCHAR(2000)

	DECLARE @SERVERNAME NVARCHAR(50)
	DECLARE @DB_NAME NVARCHAR(50)

	SET @SERVERNAME = @@SERVERNAME;
	SET @DB_NAME = DB_NAME();

	--운영서버
	IF @SERVERNAME = 'WIN-9OUKUT1FR5I'
	BEGIN 				
		 SET @RESULT = 'http://10.25.126.2:8080'
	END
	ELSE 
	--개발서버
	BEGIN
		IF @DB_NAME = 'UMAC_ERP_DEV'		
			SET @RESULT = 'http://erptest.umac.co.kr:8081'
		ELSE
			SET @RESULT = 'http://erptest.umac.co.kr:8080'
	END

RETURN @RESULT
END

GO

