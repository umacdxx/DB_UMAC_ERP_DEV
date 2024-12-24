/*
-- 생성자 :	이동호
-- 등록일 :	2024.05.09
-- 수정자 : 2024.12.16 강세미- MSG에 코드블럭 style 삽입
-- 수정일 : 
-- 설 명  : TBL_ERROR_LOG 테이블 INSERT 이벤트 발생시 서비스 브로커 :QUEUE RESPONSE 실행 (팀즈 알람 발송 API)
-- 실행문 : 


*/
CREATE PROCEDURE [dbo].[SP_QUEUE_RES_ERROR_LOG_API_SEND]
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	BEGIN TRY
		DECLARE @OBJECT AS INT;			
		DECLARE @URL AS NVARCHAR(400)		
		DECLARE @BODY AS NVARCHAR(MAX)
		DECLARE @MSG AS NVARCHAR(3000)
		DECLARE @TITLE AS NVARCHAR(50)
		DECLARE @RTMSG AS NVARCHAR(3000)
		DECLARE @PROC_NM AS NVARCHAR(150)
		DECLARE @MESSAGE_BODY_HANDLE INT
		DECLARE @RETURN_CODE 		INT
		DECLARE @RETURN_DATA 		NVARCHAR(MAX)
		DECLARE @DIALOGHANDLE UNIQUEIDENTIFIER
		DECLARE @MEG_NAME VARCHAR(256)
		DECLARE @MEG_BODY XML

        WHILE (1 = 1)
            BEGIN		
							
				WAITFOR (
					RECEIVE TOP(1)
						@DIALOGHANDLE = conversation_handle,
						@MEG_NAME = message_type_name,    
						@MEG_BODY = CAST(message_body AS XML)
					FROM API_SEND_ERROR_LOG_INITIATOR_Q), TIMEOUT 1000   
						
					IF (@@ROWCOUNT = 0)
					BEGIN                               
						BREAK
					END

					IF ( @MEG_NAME = 'API_SEND_ERROR_LOG_RES_MSG' )
					BEGIN
                                																	
						-- 에러발생 이벤트 팀즈에 API 발송##
						EXEC sp_xml_preparedocument @MESSAGE_BODY_HANDLE OUTPUT, @MEG_BODY 

						SELECT @PROC_NM = PROC_NM, @MSG = MSG
							FROM OPENXML(@MESSAGE_BODY_HANDLE, '/INSERTED',2)					
								WITH ( PROC_NM NVARCHAR(55), MSG NVARCHAR(2000));

						SET @TITLE = '[ '+ DBO.UMAC_ENV() +' - UMAC ERP ] ERROR_LOG 이벤트 발생'
						SET @RTMSG = 'PROC_NM : '+ @PROC_NM +'<br>'
						--SET @RTMSG += 'MSG : ' + REPLACE(@MSG, '"','''')
						SET @RTMSG += 'MSG : ' + REPLACE('```'  + @MSG + '```', '"','''')
						
						SET @BODY = 
						'
						{
							"title":"' + @TITLE + '",
							"message":"' + @RTMSG + '"
						}
						'		
						--API 전송
						SET @URL = dbo.UMAC_API_URL() + '/Api/Helper/GetTeamsSend'
						EXEC SP_SEND_API 'POST', @URL, @BODY, @RETURN_CODE OUT, @RETURN_DATA OUT

					END CONVERSATION @DIALOGHANDLE;
					END
					ELSE IF ( @MEG_NAME = 'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog' )
					BEGIN
						END CONVERSATION @DIALOGHANDLE ;
					END
					ELSE IF ( @MEG_NAME = 'http://schemas.microsoft.com/SQL/ServiceBroker/Error' )
					BEGIN
						END CONVERSATION @DIALOGHANDLE ;
					END									
	END
    END TRY
    BEGIN CATCH
		
    END CATCH
	
END

GO

