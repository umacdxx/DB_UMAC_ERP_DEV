

/*
-- 생성자 :	이동호
-- 등록일 :	2023.04.02
-- 수정자 : -
-- 수정일 : - 
-- 설 명	: API 호출 함수
-- 실행문 : 

SELECT dbo.FN_SEND_API('get', 'http://erp.umac.co.kr:8080/Api/TossPay/Settlements?startDate=2024-05-16&endDate=2024-05-16&dateType=soldDate&page=1&size=10', '')

*/
CREATE FUNCTION [dbo].[FN_SEND_API](
	@P_TYPE NVARCHAR(10),		--post, get
	@P_URL NVARCHAR(250),		--URL 주소	
	@P_BODY NVARCHAR(MAX)		--post : 전송 data
)
RETURNS VARCHAR(5000)
AS
BEGIN
	
	DECLARE @RESPONSETEXT AS VARCHAR(5000)
	DECLARE @OBJECT AS INT;	
	
	EXEC sp_OACreate 'MSXML2.XMLHttp', @Object OUT;
	EXEC sp_OAMethod @OBJECT, 'open', NULL, @P_TYPE,@P_URL, 'false'
	EXEC sp_OAMethod @OBJECT, 'setRequestHeader', NULL, 'Content-Type', 'application/json'
	--EXEC sp_OAMethod @OBJECT, 'setTimeouts', NULL, 500, 500, 500, 500
	
	IF @P_TYPE = 'post'
	BEGIN
		EXEC sp_OAMethod @OBJECT, 'send', NULL, @P_BODY
	END
	ELSE
		EXEC sp_OAMethod @OBJECT, 'send'

	EXEC sp_OAMethod @OBJECT, 'responseText', @RESPONSETEXT OUTPUT
	EXEC sp_OADestroy @OBJECT
		
	RETURN @RESPONSETEXT
END

GO

