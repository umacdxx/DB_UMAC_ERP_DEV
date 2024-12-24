CREATE TABLE [dbo].[PO_PURCHASE_DTL] (
    [ORD_NO]         NVARCHAR (11)   NOT NULL,
    [SEQ]            INT             NOT NULL,
    [SCAN_CODE]      NVARCHAR (14)   NOT NULL,
    [ITM_GB]         NVARCHAR (1)    NULL,
    [IPSU_QTY]       INT             NULL,
    [ORD_QTY]        NUMERIC (15, 2) NULL,
    [ORD_WPRC]       NUMERIC (15, 2) NULL,
    [ORD_WVAT]       NUMERIC (15, 2) NULL,
    [ORD_TOTAL_WPRC] NUMERIC (15, 2) NULL,
    [ORD_WAMT]       NUMERIC (15, 2) NULL,
    [PUR_QTY]        NUMERIC (15, 2) NULL,
    [PUR_WPRC]       NUMERIC (15, 2) NULL,
    [PUR_WVAT]       NUMERIC (15, 2) NULL,
    [PUR_TOTAL_WPRC] NUMERIC (15, 2) NULL,
    [PUR_WAMT]       NUMERIC (15, 2) NULL,
    [TAX_GB]         NVARCHAR (1)    NULL,
    [REMARKS]        NVARCHAR (2000) NULL,
    [REMARKS_SALES]  NVARCHAR (2000) NULL,
    [IDATE]          DATETIME        NULL,
    [IEMP_ID]        NVARCHAR (20)   NULL,
    [UDATE]          DATETIME        NULL,
    [UEMP_ID]        NVARCHAR (20)   NULL,
    CONSTRAINT [PK_PO_PURCHASE_DTL] PRIMARY KEY CLUSTERED ([ORD_NO] ASC, [SEQ] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IDX_PO_PURCHASE_DTL_ORD_NO]
    ON [dbo].[PO_PURCHASE_DTL]([ORD_NO] ASC, [SCAN_CODE] ASC, [ORD_QTY] ASC, [ORD_WAMT] ASC, [PUR_QTY] ASC, [PUR_WAMT] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문/발주 수/중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'ORD_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '주문/발주 원가 공급가', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'ORD_WPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '주문/발주 원가 부가세', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'ORD_WVAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문/발주 원가 공급가 합계', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'ORD_TOTAL_WPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '주문/발주 원가 합계', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'ORD_WAMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출입내역수정 비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'REMARKS_SALES';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '발주등록_DTL', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '주문/발주/수입번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'ORD_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '순번', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '상품구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'ITM_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '입수', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'IPSU_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입단가(공급가) 합계', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'PUR_TOTAL_WPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '매입합계금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'PUR_WAMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '과/면세 구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'TAX_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'REMARKS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입고 수/중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'PUR_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입단가(공급가)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'PUR_WPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입부가세', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_DTL', @level2type = N'COLUMN', @level2name = N'PUR_WVAT';


GO

