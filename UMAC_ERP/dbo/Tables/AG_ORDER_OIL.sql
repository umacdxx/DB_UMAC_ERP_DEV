CREATE TABLE [dbo].[AG_ORDER_OIL] (
    [AGGR_DT]        NVARCHAR (8)    NOT NULL,
    [LOT_OIL_GB]     NVARCHAR (6)    NOT NULL,
    [LOT_PARTNER_GB] NVARCHAR (6)    NOT NULL,
    [AGGR_KG_QTY]    NUMERIC (15, 2) NOT NULL,
    [AGGR_AMT]       NUMERIC (17, 4) NULL,
    CONSTRAINT [AG_ORDER_OIL_PK] PRIMARY KEY CLUSTERED ([AGGR_DT] ASC, [LOT_OIL_GB] ASC, [LOT_PARTNER_GB] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '집계일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AG_ORDER_OIL', @level2type = N'COLUMN', @level2name = N'AGGR_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'LOT 거래처 구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AG_ORDER_OIL', @level2type = N'COLUMN', @level2name = N'LOT_PARTNER_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'LOT 유종 구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AG_ORDER_OIL', @level2type = N'COLUMN', @level2name = N'LOT_OIL_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '집계 중량 수', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AG_ORDER_OIL', @level2type = N'COLUMN', @level2name = N'AGGR_KG_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '집계 금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AG_ORDER_OIL', @level2type = N'COLUMN', @level2name = N'AGGR_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '유종별 출고량 집계', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AG_ORDER_OIL';


GO

