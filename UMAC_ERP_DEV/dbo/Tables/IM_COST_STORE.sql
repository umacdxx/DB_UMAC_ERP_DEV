CREATE TABLE [dbo].[IM_COST_STORE] (
    [COST_VEN_CODE] NVARCHAR (20)  NOT NULL,
    [COST_VEN_NAME] NVARCHAR (50)  NULL,
    [BUSI_NO]       NVARCHAR (13)  NULL,
    [NOTE]          NVARCHAR (100) NULL,
    [REG_DTTM]      DATETIME       NULL,
    CONSTRAINT [PK_IM_COST_STORE] PRIMARY KEY CLUSTERED ([COST_VEN_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'제비용거래처', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_STORE', @level2type = N'COLUMN', @level2name = N'COST_VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'제비용거래처명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_STORE', @level2type = N'COLUMN', @level2name = N'COST_VEN_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'비용거래처', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_STORE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_STORE', @level2type = N'COLUMN', @level2name = N'REG_DTTM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'사업자번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_STORE', @level2type = N'COLUMN', @level2name = N'BUSI_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'적요', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_STORE', @level2type = N'COLUMN', @level2name = N'NOTE';


GO

