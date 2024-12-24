CREATE TABLE [dbo].[TBL_ROLE_MST] (
    [ROLE_ID] NVARCHAR (6)   NOT NULL,
    [ROLE_NM] NVARCHAR (100) NOT NULL,
    [ROLE_DC] NVARCHAR (100) NULL,
    [USE_YN]  NVARCHAR (1)   NOT NULL,
    [IDATE]   DATETIME       NULL,
    [IEMP_ID] NVARCHAR (20)  NULL,
    [UDATE]   DATETIME       NULL,
    [UEMP_ID] NVARCHAR (20)  NULL,
    CONSTRAINT [PK_TBL_ROLE_MST_1] PRIMARY KEY CLUSTERED ([ROLE_ID] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ROLE_MST', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ROLE_MST', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'권한그룹명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ROLE_MST', @level2type = N'COLUMN', @level2name = N'ROLE_NM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ROLE_MST', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'사용여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ROLE_MST', @level2type = N'COLUMN', @level2name = N'USE_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'권한그룹코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ROLE_MST', @level2type = N'COLUMN', @level2name = N'ROLE_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'권한설명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ROLE_MST', @level2type = N'COLUMN', @level2name = N'ROLE_DC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'기본권한마스터', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ROLE_MST';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ROLE_MST', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

