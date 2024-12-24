CREATE TABLE [dbo].[TBL_ERROR_LOG_WEB] (
    [SEQ]   INT             IDENTITY (1, 1) NOT NULL,
    [MSG]   NVARCHAR (2000) NULL,
    [IDATE] DATETIME        NULL,
    CONSTRAINT [PK_TBL_ERROR_LOG_WEB] PRIMARY KEY CLUSTERED ([SEQ] ASC)
);


GO


-- =============================================
-- 생성자 : 강세미
-- 등록일 :	2024.12.13
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : INSERT HISTORY TBL_ERROR_LOG_WEB 트리거
-- =============================================
CREATE TRIGGER [dbo].[TRG_TBL_ERROR_LOG_WEB_UPDATED]
   ON [dbo].[TBL_ERROR_LOG_WEB]
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
			DECLARE @MESSAGEBODY XML;			
			DECLARE @CleanedMSG NVARCHAR(MAX);

			SET @CleanedMSG = (
				SELECT MSG
				FROM INSERTED
			);

			-- 주요 특수 문자 처리
			SET @CleanedMSG = REPLACE(@CleanedMSG, '&', '&amp;');
			SET @CleanedMSG = REPLACE(@CleanedMSG, '<', '&lt;');
			SET @CleanedMSG = REPLACE(@CleanedMSG, '>', '&gt;');
			SET @CleanedMSG = REPLACE(@CleanedMSG, '"', '&quot;');

			-- 줄바꿈 및 백슬래시 처리
			--SET @CleanedMSG = REPLACE(@CleanedMSG, '\', '&#92;');
			SET @CleanedMSG = REPLACE(@CleanedMSG, '\', '\\');
			SET @CleanedMSG = REPLACE(@CleanedMSG, CHAR(13), ' '); -- Carriage Return (\r)
			SET @CleanedMSG = REPLACE(@CleanedMSG, CHAR(10), ' '); -- Line Feed (\n)
			SET @CleanedMSG = REPLACE(@CleanedMSG, CHAR(9), ' ');  -- Tab (\t)

			-- 중괄호, 대괄호 처리
			SET @CleanedMSG = REPLACE(@CleanedMSG, '{', '&#123;');
			SET @CleanedMSG = REPLACE(@CleanedMSG, '}', '&#125;');
			--SET @CleanedMSG = REPLACE(@CleanedMSG, '[', '&#91;');
			--SET @CleanedMSG = REPLACE(@CleanedMSG, ']', '&#93;');

			SET @MESSAGEBODY = (SELECT 'WEB_ERROR_LOG' AS PROC_NM, @CleanedMSG AS MSG FROM INSERTED FOR XML AUTO, ELEMENTS);
			
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

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'웹 에러 로그 관리', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ERROR_LOG_WEB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'기본 키', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ERROR_LOG_WEB', @level2type = N'COLUMN', @level2name = N'SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'에러 메시지', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ERROR_LOG_WEB', @level2type = N'COLUMN', @level2name = N'MSG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생성일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ERROR_LOG_WEB', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

