CREATE TABLE [dbo].[IV_DT_ITEM_LOT_COLL] (
    [INV_DT]       NVARCHAR (8)    NOT NULL,
    [ITM_CODE]     NVARCHAR (6)    NOT NULL,
    [LOT_NO]       NVARCHAR (30)   NOT NULL,
    [BASE_INV_QTY] NUMERIC (15, 2) NULL,
    [PUR_QTY]      NUMERIC (15, 2) NULL,
    [PROD_QTY]     INT             NULL,
    [SALE_QTY]     NUMERIC (15, 2) NULL,
    [RTN_QTY]      NUMERIC (15, 2) NULL,
    [INV_ADJ_QTY]  NUMERIC (15, 2) NULL,
    [INV_END_QTY]  NUMERIC (15, 2) NULL,
    [IDATE]        DATETIME        NULL,
    [UDATE]        DATETIME        NULL,
    CONSTRAINT [PK_IV_DT_ITEM_LOT_COLL] PRIMARY KEY CLUSTERED ([INV_DT] ASC, [ITM_CODE] ASC, [LOT_NO] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IDX_IV_DT_ITEM_LOT_COLL]
    ON [dbo].[IV_DT_ITEM_LOT_COLL]([ITM_CODE] ASC, [INV_DT] ASC)
    INCLUDE([BASE_INV_QTY], [PROD_QTY], [SALE_QTY], [RTN_QTY], [INV_ADJ_QTY], [INV_END_QTY]);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'전일재고수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_LOT_COLL', @level2type = N'COLUMN', @level2name = N'BASE_INV_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'재고조정 수량 [+,-]', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_LOT_COLL', @level2type = N'COLUMN', @level2name = N'INV_ADJ_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'LOT 번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_LOT_COLL', @level2type = N'COLUMN', @level2name = N'LOT_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입반품 수량 [-]', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_LOT_COLL', @level2type = N'COLUMN', @level2name = N'RTN_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_LOT_COLL', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'재고일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_LOT_COLL', @level2type = N'COLUMN', @level2name = N'INV_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_LOT_COLL', @level2type = N'COLUMN', @level2name = N'PROD_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'기말재고수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_LOT_COLL', @level2type = N'COLUMN', @level2name = N'INV_END_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입고(매입)수중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_LOT_COLL', @level2type = N'COLUMN', @level2name = N'PUR_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출수/중량 ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_LOT_COLL', @level2type = N'COLUMN', @level2name = N'SALE_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'관리코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_LOT_COLL', @level2type = N'COLUMN', @level2name = N'ITM_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_LOT_COLL', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품별 LOT 일 수불 (수량)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_LOT_COLL';


GO

