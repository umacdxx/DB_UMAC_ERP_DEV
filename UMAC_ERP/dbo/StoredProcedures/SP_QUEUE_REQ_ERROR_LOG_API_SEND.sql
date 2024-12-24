/*
-- 생성자 :	이동호
-- 등록일 :	2024.05.09
-- 수정자 : 
-- 수정일 : 
-- 설 명  : TBL_ERROR_LOG 테이블 INSERT 이벤트 발생시 서비스 브로커 : QUEUE REQUEST 실행
-- 실행문 : 

*/
CREATE PROCEDURE [dbo].[SP_QUEUE_REQ_ERROR_LOG_API_SEND]
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	

	BEGIN TRY 				
		
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
                    FROM API_SEND_ERROR_LOG_TARGET_Q ), TIMEOUT 1000   
                    IF (@@ROWCOUNT = 0)
                    BEGIN                                
                        BREAK
                    END
					
                    IF ( @MEG_NAME = 'API_SEND_ERROR_LOG_REQ_MSG' )
                    BEGIN;                    		
						--시간지연 설정 : 1초 후 출력
                        --WAITFOR DELAY '00:00:01'; 
						--QUEUE RESPONSE
                        SEND ON CONVERSATION @DIALOGHANDLE MESSAGE TYPE [API_SEND_ERROR_LOG_RES_MSG] (@MEG_BODY);
                    END
                    ELSE IF ( @MEG_NAME = 'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog')
                    BEGIN
                        END CONVERSATION @DIALOGHANDLE
                    END
                    ELSE IF ( @MEG_NAME = 'http://schemas.microsoft.com/SQL/ServiceBroker/Error')
                    BEGIN
                        END CONVERSATION @DIALOGHANDLE
                    END				               
            END

	END TRY
	BEGIN CATCH	
			
	END CATCH
	
END

GO

