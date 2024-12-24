CREATE TABLE [dbo].[TBL_BATCH_LOG] (
    [SEQ]          INT            IDENTITY (1, 1) NOT NULL,
    [BATCH_DT]     VARCHAR (8)    NULL,
    [BATCH_NM]     VARCHAR (255)  NULL,
    [BATCH_STATUS] CHAR (1)       NULL,
    [START_TIME]   DATETIME       NULL,
    [END_TIME]     DATETIME       NULL,
    [MSG]          VARCHAR (1000) NULL,
    [MENUAL_YN]    CHAR (1)       NULL,
    PRIMARY KEY CLUSTERED ([SEQ] ASC)
);


GO

-- =============================================
-- 생성자 :	윤현빈
-- 등록일 :	2024.05.29
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : INSERT HISTORY TBL_BATCH_LOG 트리거
-- =============================================
CREATE TRIGGER [dbo].[TRG_BATCH_LOG_INSERTED]
   ON  [dbo].[TBL_BATCH_LOG]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY

		IF EXISTS (SELECT 1 FROM INSERTED WHERE BATCH_STATUS = 'F')
		BEGIN
			--SERVICE BORKER 비동기 : 팀즈에 에러 메시지 발송 API
			DECLARE @MESSAGEBODY XML						
			SET @MESSAGEBODY = (SELECT BATCH_NM AS PROC_NM, MSG FROM INSERTED FOR XML AUTO, ELEMENTS)
			DECLARE @DIALOGHANDLE UNIQUEIDENTIFIER;              
			BEGIN DIALOG CONVERSATION @DIALOGHANDLE  				
			FROM SERVICE [API_SEND_ERROR_LOG_INITIATOR_SVC] TO SERVICE 'API_SEND_ERROR_LOG_TARGET_SVC'  			
			ON CONTRACT [API_SEND_ERROR_LOG_CONTRACT]  			
			WITH ENCRYPTION = OFF;  			
			SEND ON CONVERSATION @DIALOGHANDLE  			
			MESSAGE TYPE [API_SEND_ERROR_LOG_REQ_MSG](@MESSAGEBODY);
		END

	END TRY
	
    BEGIN CATCH
        
    END CATCH  
END

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'메시지', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_BATCH_LOG', @level2type = N'COLUMN', @level2name = N'MSG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'종료 시간', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_BATCH_LOG', @level2type = N'COLUMN', @level2name = N'END_TIME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'순번', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_BATCH_LOG', @level2type = N'COLUMN', @level2name = N'SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배치 로그', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_BATCH_LOG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수동여부(Y:수동, N:자동)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_BATCH_LOG', @level2type = N'COLUMN', @level2name = N'MENUAL_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배치 명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_BATCH_LOG', @level2type = N'COLUMN', @level2name = N'BATCH_NM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배치 일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_BATCH_LOG', @level2type = N'COLUMN', @level2name = N'BATCH_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'시작 시간', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_BATCH_LOG', @level2type = N'COLUMN', @level2name = N'START_TIME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배치 상태(S:성공, F:실패, R:실행중)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_BATCH_LOG', @level2type = N'COLUMN', @level2name = N'BATCH_STATUS';


GO

