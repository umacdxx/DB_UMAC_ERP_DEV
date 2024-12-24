CREATE TABLE [dbo].[PUR_ITEM] (
    [PUR_DT]        NVARCHAR (8)    NOT NULL,
    [SCAN_CODE]     NVARCHAR (14)   NOT NULL,
    [ITM_CODE]      NVARCHAR (6)    NOT NULL,
    [ORD_CNT]       INT             NULL,
    [PUR_EA]        INT             NULL,
    [PUR_KG]        NUMERIC (15, 2) NULL,
    [PUR_TOTAL_AMT] NUMERIC (15, 2) NULL,
    [TAX_GB]        NVARCHAR (1)    NOT NULL,
    CONSTRAINT [PK_PUR_ITEM] PRIMARY KEY CLUSTERED ([PUR_DT] ASC, [SCAN_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입 수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_ITEM', @level2type = N'COLUMN', @level2name = N'PUR_EA';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입합계금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_ITEM', @level2type = N'COLUMN', @level2name = N'PUR_TOTAL_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_ITEM', @level2type = N'COLUMN', @level2name = N'PUR_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품 관리코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_ITEM', @level2type = N'COLUMN', @level2name = N'ITM_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입 중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_ITEM', @level2type = N'COLUMN', @level2name = N'PUR_KG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문건수', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_ITEM', @level2type = N'COLUMN', @level2name = N'ORD_CNT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'과세: 1, 면세: 2, 영세: 3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_ITEM', @level2type = N'COLUMN', @level2name = N'TAX_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품 코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_ITEM', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입 ITEM', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_ITEM';


GO

