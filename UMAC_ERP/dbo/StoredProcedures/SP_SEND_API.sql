
/*
-- 생성자 :	이동호
-- 등록일 :	2024.05.09
-- 수정자 : 
-- 수정일 : 
-- 설 명  : 공통 API 호출
-- 실행문 : 

DECLARE @R_RETURN_CODE 		INT
DECLARE @R_RETURN_DATA 		NVARCHAR(MAX)
EXEC SP_SEND_API 'GET', 
'http://erp.umac.co.kr:8080/Api/TossPay/Settlements?startDate=2024-05-16&endDate=2024-06-16&dateType=soldDate&page=1&size=10', 
'',
@R_RETURN_CODE OUT, @R_RETURN_DATA OUT
SELECT @R_RETURN_CODE, @R_RETURN_DATA

*/
CREATE PROCEDURE [dbo].[SP_SEND_API]
	@P_TYPE				NVARCHAR(10),			--POST, GET
	@P_URL				NVARCHAR(250),			--URL 주소	
	@P_BODY				NVARCHAR(4000),			--POST : 전송 DATA
	@R_RETURN_CODE 		INT 			OUTPUT,	--리턴코드
	@R_RETURN_DATA 		NVARCHAR(MAX) 	OUTPUT 	--리턴메시지
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	

	BEGIN TRY 				
				
		SET @R_RETURN_CODE = 0
		SET @R_RETURN_DATA = ''
				
		DECLARE @RESPONSETEXT_TABLE TABLE(RESPONSETEXT NVARCHAR(MAX));	
		DECLARE @OBJECT AS INT;
		DECLARE @RET INT;
		DECLARE @STATUS NVARCHAR(32);
		DECLARE @STATUSTEXT NVARCHAR(50); 
		DECLARE @RESTEXT NVARCHAR(50); 

		EXEC sp_OACreate 'MSXML2.ServerXMLHTTP', @OBJECT OUT;
		EXEC sp_OAMethod @OBJECT, 'open', NULL, @P_TYPE,@P_URL, 'false'

		EXEC sp_OAMethod @OBJECT, 'setRequestHeader', null, 'Content-Type', 'application/json'
		--Exec sp_OAMethod @OBJECT, 'setRequestHeader', null, 'Authorization', @Token
		EXEC sp_OAMethod @OBJECT, 'setTimeouts', NULL, 5000, 5000, 5000, 5000
		
		IF @P_TYPE = 'POST'		
			EXEC sp_OAMethod @OBJECT, 'send', NULL, @P_BODY		
		ELSE
			EXEC sp_OAMethod @OBJECT, 'send'


		INSERT INTO @RESPONSETEXT_TABLE (RESPONSETEXT)
		EXEC sp_OAMethod @OBJECT, 'RESPONSETEXT'
	
		--응답 결과 확인
		EXEC @RET = sp_OAGetProperty @OBJECT, 'status', @STATUS OUT;            --서버 상태
        EXEC @RET = sp_OAGetProperty @OBJECT, 'statusText', @STATUSTEXT OUT;	--서버 상태 내용
        EXEC @RET = sp_OAGetProperty @OBJECT, 'responseText', @RESTEXT OUT;     --응답 내용        
		
		--PRINT 'STATUS  : ' + @STATUS + ' (' + @STATUSTEXT + ')';
		--PRINT 'RESTEXT : ' + @RESTEXT;  

		IF @STATUS = 200
		BEGIN
			SELECT @R_RETURN_DATA = RESPONSETEXT FROM @RESPONSETEXT_TABLE
		END
		ELSE
		BEGIN
			SET @R_RETURN_CODE = -1
			SET @R_RETURN_DATA = @STATUSTEXT
		END
        
		--해당 토큰값의 OLE 인스턴스 개체 소멸
		EXEC @ret = sp_OADestroy @OBJECT;
						
	END TRY
	BEGIN CATCH	
				
		--에러 로그 테이블 저장
		INSERT INTO TBL_ERROR_LOG 
		SELECT ERROR_PROCEDURE()			-- 프로시저명
				, ERROR_MESSAGE()			-- 에러메시지
				, ERROR_LINE()				-- 에러라인
				, GETDATE()	
			
		SET @R_RETURN_CODE = -1
		SET @R_RETURN_DATA = ERROR_MESSAGE()

	END CATCH
	
END

GO

