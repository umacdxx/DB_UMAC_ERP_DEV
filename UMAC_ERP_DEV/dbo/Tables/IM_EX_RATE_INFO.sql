CREATE TABLE [dbo].[IM_EX_RATE_INFO] (
    [EXCHANGE_DATE] NVARCHAR (8)    NOT NULL,
    [USD_RATE]      NUMERIC (10, 2) NOT NULL,
    [EUR_RATE]      NUMERIC (10, 2) NOT NULL,
    [IDATE]         DATETIME        DEFAULT (getdate()) NULL
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'유료환율', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_EX_RATE_INFO', @level2type = N'COLUMN', @level2name = N'EUR_RATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_EX_RATE_INFO', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'달러환율', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_EX_RATE_INFO', @level2type = N'COLUMN', @level2name = N'USD_RATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'환율 정보', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_EX_RATE_INFO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'환율기준일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_EX_RATE_INFO', @level2type = N'COLUMN', @level2name = N'EXCHANGE_DATE';


GO

