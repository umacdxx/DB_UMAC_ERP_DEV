CREATE TABLE [dbo].[TBL_SUREM_TEMPLATE] (
    [templateCode]          NVARCHAR (30)   NOT NULL,
    [templateName]          NVARCHAR (200)  NULL,
    [templateContent]       NVARCHAR (1000) NULL,
    [templateMessageType]   NVARCHAR (2)    NULL,
    [templateEmphasizeType] NVARCHAR (10)   NULL,
    [categoryCode]          NVARCHAR (10)   NULL,
    [IDATE]                 DATETIME        NULL,
    [UDATE]                 DATETIME        NULL,
    [USE_YN]                NVARCHAR (1)    NULL,
    CONSTRAINT [PK_TBL_SUREM_TEMPLATE] PRIMARY KEY CLUSTERED ([templateCode] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'템플릿 메시지 유형', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_TEMPLATE', @level2type = N'COLUMN', @level2name = N'templateMessageType';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'사용여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_TEMPLATE', @level2type = N'COLUMN', @level2name = N'USE_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'템플릿이름', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_TEMPLATE', @level2type = N'COLUMN', @level2name = N'templateName';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_TEMPLATE', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'템플릿코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_TEMPLATE', @level2type = N'COLUMN', @level2name = N'templateCode';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'템플릿카테고리코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_TEMPLATE', @level2type = N'COLUMN', @level2name = N'categoryCode';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_TEMPLATE', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'템플릿내용', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_TEMPLATE', @level2type = N'COLUMN', @level2name = N'templateContent';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'템플릿강조유형', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_TEMPLATE', @level2type = N'COLUMN', @level2name = N'templateEmphasizeType';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'슈어엠 알림톡 템플릿', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_TEMPLATE';


GO

