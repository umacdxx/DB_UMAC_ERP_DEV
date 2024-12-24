CREATE TABLE [dbo].[IM_COST_ITM] (
    [COST_ITM_CODE] NVARCHAR (3)   NOT NULL,
    [COST_NAME]     NVARCHAR (100) NULL,
    [ACCT_CD]       NVARCHAR (5)   NULL,
    CONSTRAINT [PK_IM_COST_ITM] PRIMARY KEY CLUSTERED ([COST_ITM_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'회계코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_ITM', @level2type = N'COLUMN', @level2name = N'ACCT_CD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'제비용이름', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_ITM', @level2type = N'COLUMN', @level2name = N'COST_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'제비용항목코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_ITM', @level2type = N'COLUMN', @level2name = N'COST_ITM_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'제비용항목', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_ITM';


GO

