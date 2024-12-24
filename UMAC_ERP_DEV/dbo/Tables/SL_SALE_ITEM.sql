CREATE TABLE [dbo].[SL_SALE_ITEM] (
    [SALE_DT]        NVARCHAR (8)    NOT NULL,
    [SCAN_CODE]      NVARCHAR (14)   NOT NULL,
    [ITM_CODE]       NVARCHAR (6)    NOT NULL,
    [ORD_CNT]        INT             NOT NULL,
    [SALE_EA]        INT             NOT NULL,
    [SALE_KG]        NUMERIC (15, 2) NOT NULL,
    [SALE_TOTAL_AMT] NUMERIC (17, 4) NULL,
    [TAX_GB]         NVARCHAR (1)    NOT NULL,
    CONSTRAINT [PK_SL_SALE_ITEM] PRIMARY KEY CLUSTERED ([SALE_DT] ASC, [SCAN_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문건수', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_ITEM', @level2type = N'COLUMN', @level2name = N'ORD_CNT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출 수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_ITEM', @level2type = N'COLUMN', @level2name = N'SALE_EA';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출 ITEM', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_ITEM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_ITEM', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출합계금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_ITEM', @level2type = N'COLUMN', @level2name = N'SALE_TOTAL_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출 중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_ITEM', @level2type = N'COLUMN', @level2name = N'SALE_KG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'판매일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_ITEM', @level2type = N'COLUMN', @level2name = N'SALE_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품 관리코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_ITEM', @level2type = N'COLUMN', @level2name = N'ITM_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'과세: 1, 면세: 2, 영세: 3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_ITEM', @level2type = N'COLUMN', @level2name = N'TAX_GB';


GO

