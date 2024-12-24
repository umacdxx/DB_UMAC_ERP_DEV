
/*
-- 생성자 :	이동호
-- 등록일 :	2023.04.02
-- 수정자 : -
-- 수정일 : - 
-- 설 명	: 암호화
-- 실행문 : 
*/
CREATE FUNCTION [dbo].[GET_ENCRYPT](
	@P_STR NVARCHAR(400)
)
RETURNS VARBINARY(256)
AS
BEGIN
	DECLARE @RESULT VARBINARY(256)

	IF @P_STR IS NULL OR @P_STR = '' 
		SET @RESULT = NULL
	ELSE
		SET @RESULT = EncryptByKey(Key_GUID('UMAC_CERT_KEY'), @P_STR)
	
RETURN @RESULT
END

GO

