
/*
-- 생성자 :	이동호
-- 등록일 :	2023.04.02
-- 수정자 : -
-- 수정일 : - 
-- 설 명	: 복호화
-- 실행문 : 
*/
CREATE FUNCTION [dbo].[GET_DECRYPT](
	@P_STR VARBINARY(256)
)
RETURNS NVARCHAR(50)
AS
BEGIN
	DECLARE @RESULT NVARCHAR(50)

	SET @RESULT = CONVERT(Nvarchar, DecryptByKey(@P_STR)) 
	
RETURN @RESULT
END

GO

