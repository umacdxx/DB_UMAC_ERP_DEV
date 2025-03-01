CREATE TABLE [dbo].[PO_ORDER_DTL] (
    [ORD_NO]         NVARCHAR (11)   NOT NULL,
    [SEQ]            INT             NOT NULL,
    [SCAN_CODE]      NVARCHAR (14)   NOT NULL,
    [ITM_GB]         NVARCHAR (1)    NULL,
    [IPSU_QTY]       INT             NULL,
    [ORD_QTY]        NUMERIC (15, 2) NULL,
    [ORD_SPRC]       NUMERIC (17, 4) NULL,
    [ORD_SVAT]       NUMERIC (17, 4) NULL,
    [ORD_SAMT]       NUMERIC (17, 4) NULL,
    [TAX_GB]         NVARCHAR (1)    NULL,
    [DOCUMENT_REQ]   NVARCHAR (2)    NULL,
    [PICKING_QTY]    NUMERIC (15, 2) NULL,
    [PICKING_SPRC]   NUMERIC (17, 4) NULL,
    [PICKING_SVAT]   NUMERIC (17, 4) NULL,
    [PICKING_SAMT]   NUMERIC (17, 4) NULL,
    [PICKING_EMP_NO] NVARCHAR (20)   NULL,
    [PICKING_SDATE]  DATETIME        NULL,
    [PICKING_EDATE]  DATETIME        NULL,
    [REMARKS]        NVARCHAR (2000) NULL,
    [REMARKS_SALES]  NVARCHAR (2000) NULL,
    [IDATE]          DATETIME        NULL,
    [IEMP_ID]        NVARCHAR (20)   NULL,
    [UDATE]          DATETIME        NULL,
    [UEMP_ID]        NVARCHAR (20)   NULL,
    CONSTRAINT [PK_PO_ORDER_DTL] PRIMARY KEY CLUSTERED ([ORD_NO] ASC, [SEQ] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IDX_PO_ORDER_DTL_ORD_NO]
    ON [dbo].[PO_ORDER_DTL]([ORD_NO] ASC, [SCAN_CODE] ASC, [ORD_QTY] ASC, [ORD_SAMT] ASC, [PICKING_QTY] ASC, [PICKING_SAMT] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문 수/중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'ORD_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매가합계', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'ORD_SAMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피킹완료일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'PICKING_EDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피킹합계', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'PICKING_SAMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피킹 수/중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'PICKING_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'ORD_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '주문/발주 매가 부가세', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'ORD_SVAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출입내역수정 비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'REMARKS_SALES';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문등록DTL', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피킹시작일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'PICKING_SDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'요청서류', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'DOCUMENT_REQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피킹부가세', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'PICKING_SVAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피킹공급가', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'PICKING_SPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'순번', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입수', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'IPSU_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'ITM_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매가(공급가)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'ORD_SPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'REMARKS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'과/면세 구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'TAX_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피킹사원아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'PICKING_EMP_NO';


GO

