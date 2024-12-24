CREATE TABLE [dbo].[TBL_USER_ROLE_MST] (
    [USER_ID]   NVARCHAR (20)  NOT NULL,
    [MENU_CODE] NVARCHAR (100) NOT NULL,
    [IDATE]     DATETIME       NULL,
    [IEMP_ID]   NVARCHAR (20)  NULL,
    [UDATE]     DATETIME       NULL,
    [UEMP_ID]   NVARCHAR (20)  NULL,
    CONSTRAINT [PK_TBL_USER_ROLE_MST] PRIMARY KEY CLUSTERED ([USER_ID] ASC, [MENU_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'사용자권한마스터', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_ROLE_MST';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'메뉴코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_ROLE_MST', @level2type = N'COLUMN', @level2name = N'MENU_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_ROLE_MST', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_ROLE_MST', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'사용자ID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_ROLE_MST', @level2type = N'COLUMN', @level2name = N'USER_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_ROLE_MST', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_ROLE_MST', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

