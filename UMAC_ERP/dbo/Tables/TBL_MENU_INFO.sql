CREATE TABLE [dbo].[TBL_MENU_INFO] (
    [SEQ]          INT             NOT NULL,
    [MENU_CODE]    NVARCHAR (100)  NOT NULL,
    [MENU_NM]      NVARCHAR (100)  NOT NULL,
    [MENU_GB]      INT             NULL,
    [MENU_ICON]    NVARCHAR (50)   NULL,
    [MENU_LINK]    NVARCHAR (150)  NULL,
    [UP_MENU_CODE] NVARCHAR (100)  NULL,
    [SORT_ORDER]   INT             NULL,
    [HELP]         NVARCHAR (4000) NULL,
    [DEL_YN]       CHAR (1)        NULL,
    [IDATE]        DATETIME        NULL,
    [IEMP_ID]      NVARCHAR (20)   NULL,
    [UDATE]        DATETIME        NULL,
    [UEMP_ID]      NVARCHAR (20)   NULL,
    CONSTRAINT [PK_TBL_MENU_INFO_1] PRIMARY KEY CLUSTERED ([SEQ] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록 사원아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MENU_INFO', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상위 메뉴 코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MENU_INFO', @level2type = N'COLUMN', @level2name = N'UP_MENU_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'순번', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MENU_INFO', @level2type = N'COLUMN', @level2name = N'SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'메뉴_아이콘', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MENU_INFO', @level2type = N'COLUMN', @level2name = N'MENU_ICON';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MENU_INFO', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'메뉴 링크 주소', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MENU_INFO', @level2type = N'COLUMN', @level2name = N'MENU_LINK';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'메뉴마스터', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MENU_INFO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정 사원아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MENU_INFO', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MENU_INFO', @level2type = N'COLUMN', @level2name = N'HELP';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'메뉴구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MENU_INFO', @level2type = N'COLUMN', @level2name = N'MENU_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'사제여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MENU_INFO', @level2type = N'COLUMN', @level2name = N'DEL_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'메뉴_CODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MENU_INFO', @level2type = N'COLUMN', @level2name = N'MENU_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MENU_INFO', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'정렬순서', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MENU_INFO', @level2type = N'COLUMN', @level2name = N'SORT_ORDER';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'메뉴_명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_MENU_INFO', @level2type = N'COLUMN', @level2name = N'MENU_NM';


GO

