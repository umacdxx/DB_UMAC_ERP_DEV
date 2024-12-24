CREATE TABLE [dbo].[IV_DT_ITEM_COLL] (
    [INV_DT]        NVARCHAR (8)    NOT NULL,
    [ITM_CODE]      NVARCHAR (6)    NOT NULL,
    [BASE_INV_QTY]  NUMERIC (15, 2) NULL,
    [BASE_INV_WAMT] NUMERIC (17, 4) NULL,
    [BASE_INV_WPRC] NUMERIC (17, 4) NULL,
    [BASE_INV_WVAT] NUMERIC (17, 4) NULL,
    [PUR_QTY]       NUMERIC (15, 2) NULL,
    [PUR_WAMT]      NUMERIC (15, 2) NULL,
    [PUR_WPRC]      NUMERIC (15, 2) NULL,
    [PUR_WVAT]      NUMERIC (15, 2) NULL,
    [PROD_QTY]      NUMERIC (15, 2) NULL,
    [PROD_WAMT]     NUMERIC (13)    NULL,
    [PROD_WPRC]     NUMERIC (13)    NULL,
    [PROD_WVAT]     NUMERIC (13)    NULL,
    [SALE_QTY]      NUMERIC (15, 2) NULL,
    [SALE_WAMT]     NUMERIC (17, 4) NULL,
    [SALE_WPRC]     NUMERIC (17, 4) NULL,
    [SALE_WVAT]     NUMERIC (17, 4) NULL,
    [RTN_QTY]       NUMERIC (15, 2) NULL,
    [RTN_WAMT]      NUMERIC (13)    NULL,
    [RTN_WPRC]      NUMERIC (15, 2) NULL,
    [RTN_WVAT]      NUMERIC (13)    NULL,
    [INV_ADJ_QTY]   NUMERIC (15, 2) NULL,
    [INV_ADJ_WAMT]  NUMERIC (13)    NULL,
    [INV_ADJ_WPRC]  NUMERIC (15, 2) NULL,
    [INV_ADJ_WVAT]  NUMERIC (13)    NULL,
    [INV_END_QTY]   NUMERIC (15, 2) NULL,
    [INV_END_WAMT]  NUMERIC (17, 4) NULL,
    [INV_END_WPRC]  NUMERIC (17, 4) NULL,
    [INV_END_WVAT]  NUMERIC (17, 4) NULL,
    [IDATE]         DATETIME        NULL,
    [UDATE]         DATETIME        NULL,
    CONSTRAINT [PK_IV_DT_ITEM_COLL] PRIMARY KEY CLUSTERED ([INV_DT] ASC, [ITM_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '매입단가(공급가)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'PUR_WPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '판매원가합계', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'SALE_WAMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '판매원가부가세', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'SALE_WVAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '반품원가합계', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'RTN_WAMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '전일재고합계금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'BASE_INV_WAMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '반품원가부가세', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'RTN_WVAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산 수/중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'PROD_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '생산원가합계', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'PROD_WAMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'재고조정 수/중량 [+,-]', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'INV_ADJ_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'기말재고 수/중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'INV_END_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '재고조정 원가금액 [+,-]', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'INV_ADJ_WPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '생성일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입고(매입) 수/중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'PUR_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '생산원가부가세', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'PROD_WVAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '기말재고원가공급가', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'INV_END_WPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '관리코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'ITM_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '매출 원가금액 [-]', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'SALE_WPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'전일 재고 수/중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'BASE_INV_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입반품 수/중량 [-]', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'RTN_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '매입부가세', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'PUR_WVAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품 일 수불', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '전일재고원가공급가', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'BASE_INV_WPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '매입반품 원가금액 [-]', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'RTN_WPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '전일재고원가부가세', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'BASE_INV_WVAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '재고조정원가합계', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'INV_ADJ_WAMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '재고조정원가부가세', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'INV_ADJ_WVAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '재고일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'INV_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '생산원가공급가', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'PROD_WPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '기말재고원가합계', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'INV_END_WAMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '기말재고원가부가세', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'INV_END_WVAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '매입합계금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'PUR_WAMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출 수/중량 [-]', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_DT_ITEM_COLL', @level2type = N'COLUMN', @level2name = N'SALE_QTY';


GO

