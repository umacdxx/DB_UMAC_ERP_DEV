

/*
-- 생성자 :	이동호
-- 등록일 :	2024.05.17
-- 수정자 : -
-- 수정일 : - 
-- 설 명  :  SPLIT 테이블 함수
-- 실행문 : SELECT * FROM dbo.FN_SPLIT('111,2222',',')
*/
CREATE FUNCTION FN_SPLIT(  
	@Expression NVARCHAR(2000),  
	@Delimiter NVARCHAR(10)  
)    
RETURNS @TBLARRY TABLE  
(  	
	RVALUE VARCHAR(500)  
)  
AS  
  
BEGIN  
	DECLARE @RVALUE NVARCHAR(500)  
  
	SET @Expression = REPLACE(@Expression,', ',',')  
	SET @Expression = @Expression + @Delimiter  
	
	WHILE CHARINDEX(@Delimiter,@Expression) > 0  
	BEGIN  
	
		SET @RVALUE = LEFT(@Expression,CHARINDEX(@Delimiter,@Expression)-1)      		
		SET @Expression = SUBSTRING(@Expression,CHARINDEX(@Delimiter,@Expression)+1,LEN(@Expression))  
  
		IF (@RVALUE <> '')  
		BEGIN  	
			INSERT INTO @TBLARRY ( RVALUE ) VALUES ( RTRIM(@RVALUE) )  
		END  
	END  
  
	RETURN  
END

GO

