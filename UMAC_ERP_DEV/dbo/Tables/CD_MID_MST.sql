CREATE TABLE [dbo].[CD_MID_MST] (
    [MID_CODE] NVARCHAR (4)  NOT NULL,
    [LRG_CODE] NVARCHAR (2)  NULL,
    [MID_NAME] NVARCHAR (20) NULL,
    [IDATE]    DATETIME      NULL,
    [IEMP_ID]  NVARCHAR (20) NULL,
    [UDATE]    DATETIME      NULL,
    [UEMP_ID]  NVARCHAR (20) NULL,
    CONSTRAINT [PK_CD_MID_MST] PRIMARY KEY CLUSTERED ([MID_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'중분류명칭', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_MID_MST', @level2type = N'COLUMN', @level2name = N'MID_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록사원번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_MID_MST', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'중분류코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_MID_MST', @level2type = N'COLUMN', @level2name = N'MID_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_MID_MST', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'대분류코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_MID_MST', @level2type = N'COLUMN', @level2name = N'LRG_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_MID_MST', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정사원번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_MID_MST', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'중분류마스터', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_MID_MST';


GO

