CREATE TABLE [dbo].[TBL_ERROR_LOG_APP] (
    [SEQ]     INT             IDENTITY (1, 1) NOT NULL,
    [MSG]     NVARCHAR (2000) NULL,
    [IDATE]   DATETIME        NULL,
    [URL]     NVARCHAR (200)  NULL,
    [IEMP_ID] NVARCHAR (20)   NULL,
    CONSTRAINT [PK_TBL_ERROR_LOG_APP] PRIMARY KEY CLUSTERED ([SEQ] ASC)
);


GO

-- =============================================
-- 생성자 :	최수민
-- 등록일 :	2024.09.19
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : INSERT HISTORY TBL_ERROR_LOG_APP 트리거
-- =============================================
CREATE TRIGGER [dbo].[TRG_TBL_ERROR_LOG_APP_UPDATED]
   ON [dbo].[TBL_ERROR_LOG_APP]
   AFTER INSERT
AS 
BEGIN
	
	SET NOCOUNT ON;

	BEGIN TRY

		--I : INSERTED
		--U : UPDATED
		--D : DELETED
		
		IF UPDATE(SEQ)
		BEGIN
			
			--SERVICE BORKER 비동기 : 팀즈에 에러 메시지 발송 API
			DECLARE @MESSAGEBODY XML						
			SET @MESSAGEBODY = (SELECT [URL] AS PROC_NM, MSG FROM INSERTED FOR XML AUTO, ELEMENTS)
			
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

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'URL', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ERROR_LOG_APP', @level2type = N'COLUMN', @level2name = N'URL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록 아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ERROR_LOG_APP', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'기본 키', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ERROR_LOG_APP', @level2type = N'COLUMN', @level2name = N'SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'앱 에러 로그 관리', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ERROR_LOG_APP';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'에러 메시지', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ERROR_LOG_APP', @level2type = N'COLUMN', @level2name = N'MSG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생성일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ERROR_LOG_APP', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

