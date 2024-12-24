


/*
-- 생성자 :	이동호
-- 등록일 :	2024.09.03
-- 수정자 : -
-- 수정일 : - 
-- 설 명	: SPLIT 스칼라 변환 함수
-- 실행문 : 

	SELECT DBO.FN_GET_SPLIT('111-222-333', '-', 1)

*/
CREATE FUNCTION dbo.FN_GET_SPLIT
(
	@P_VALUE NVARCHAR(300),	-- 대상 문자열­
	@P_GUBUN NVARCHAR(1),	-- 구분자
	@P_INDEX INT			-- 위치 
)
RETURNS NVARCHAR(300)
AS

BEGIN

DECLARE @Index int
DECLARE @Pos int
DECLARE @Order int
DECLARE @Output varchar(max)

SET @Index = 1
SET @Pos = 1
SET @Order = 1

WHILE @Order < @P_INDEX+1 AND @Pos > 0
BEGIN
    SET @Pos = CHARINDEX(@P_GUBUN, @P_VALUE, @Index)

    IF @Pos = 0 OR @Order = @P_INDEX+1
    BEGIN
        SET @Output = RIGHT(@P_VALUE, LEN(@P_VALUE) - @Index + 1)
    END
    ELSE
    BEGIN
        SET @Output = SUBSTRING(@P_VALUE, @Index, @Pos - @Index)
    END

    SET @Index = @Pos + 1
    SET @Order = @Order + 1  
END

RETURN @Output

END

GO

