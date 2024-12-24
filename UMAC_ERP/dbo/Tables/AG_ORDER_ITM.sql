CREATE TABLE [dbo].[AG_ORDER_ITM] (
    [AGGR_DT]        NVARCHAR (8)    NOT NULL,
    [SCAN_CODE]      NVARCHAR (14)   NOT NULL,
    [LOT_PARTNER_GB] NVARCHAR (6)    NOT NULL,
    [WEIGHT_GB]      NVARCHAR (3)    NOT NULL,
    [AGGR_EA_QTY]    INT             NOT NULL,
    [AGGR_KG_QTY]    NUMERIC (15, 2) NOT NULL,
    [AGGR_AMT]       NUMERIC (17, 4) NULL,
    CONSTRAINT [AG_ORDER_ITM_PK] PRIMARY KEY CLUSTERED ([AGGR_DT] ASC, [SCAN_CODE] ASC, [LOT_PARTNER_GB] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '집계 수량 수', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AG_ORDER_ITM', @level2type = N'COLUMN', @level2name = N'AGGR_EA_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '매출 집계', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AG_ORDER_ITM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '집계일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AG_ORDER_ITM', @level2type = N'COLUMN', @level2name = N'AGGR_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '집계 중량 수', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AG_ORDER_ITM', @level2type = N'COLUMN', @level2name = N'AGGR_KG_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'LOT 거래처 구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AG_ORDER_ITM', @level2type = N'COLUMN', @level2name = N'LOT_PARTNER_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '제품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AG_ORDER_ITM', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '집계 금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AG_ORDER_ITM', @level2type = N'COLUMN', @level2name = N'AGGR_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '수중량관리', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AG_ORDER_ITM', @level2type = N'COLUMN', @level2name = N'WEIGHT_GB';


GO

