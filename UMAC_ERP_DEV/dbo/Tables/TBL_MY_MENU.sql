CREATE TABLE [dbo].[TBL_MY_MENU] (
    [USER_ID]   NVARCHAR (20)  NOT NULL,
    [MENU_CODE] NVARCHAR (100) NOT NULL,
    [IDATE]     DATETIME       NULL,
    CONSTRAINT [PK_TBL_MY_MENU] PRIMARY KEY CLUSTERED ([USER_ID] ASC, [MENU_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'메뉴 즐겨찾기', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MY_MENU';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MY_MENU', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'사용자아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MY_MENU', @level2type = N'COLUMN', @level2name = N'USER_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'메뉴_CODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MY_MENU', @level2type = N'COLUMN', @level2name = N'MENU_CODE';


GO

