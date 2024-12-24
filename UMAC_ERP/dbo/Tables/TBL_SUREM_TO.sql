CREATE TABLE [dbo].[TBL_SUREM_TO] (
    [templateCode] NVARCHAR (30)   NULL,
    [USER_ID]      NVARCHAR (20)   NULL,
    [MOBIL_NO]     VARBINARY (256) NULL,
    [IDATE]        DATETIME        NULL,
    [UDATE]        DATETIME        NULL
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_TO', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'휴대폰번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_TO', @level2type = N'COLUMN', @level2name = N'MOBIL_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'템플릿코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_TO', @level2type = N'COLUMN', @level2name = N'templateCode';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'슈어엠 알림톡 수신자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_TO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_TO', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'사용자아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_TO', @level2type = N'COLUMN', @level2name = N'USER_ID';


GO

