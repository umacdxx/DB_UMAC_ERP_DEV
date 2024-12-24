CREATE TABLE [dbo].[PO_NO_DOC] (
    [SEQ]            INT             IDENTITY (1, 1) NOT NULL,
    [ORD_NO]         NVARCHAR (11)   NULL,
    [SCAN_CODE]      NVARCHAR (14)   NULL,
    [ORD_QTY]        NUMERIC (15, 2) NULL,
    [ORD_SPRC]       NUMERIC (17, 4) NULL,
    [ORD_SVAT]       NUMERIC (17, 4) NULL,
    [ORD_SAMT]       NUMERIC (17, 4) NULL,
    [PICKING_QTY]    NUMERIC (17, 4) NULL,
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
    CONSTRAINT [PK__PO_NO_DO__CA1938C085787E93] PRIMARY KEY CLUSTERED ([SEQ] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IDX_PO_NO_DOC_ORD_NO]
    ON [dbo].[PO_NO_DOC]([ORD_NO] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문 수중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC', @level2type = N'COLUMN', @level2name = N'ORD_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문 매가 합계', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC', @level2type = N'COLUMN', @level2name = N'ORD_SAMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출입내역 수정 비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC', @level2type = N'COLUMN', @level2name = N'REMARKS_SALES';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피킹 시작일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC', @level2type = N'COLUMN', @level2name = N'PICKING_SDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피킹 부가세', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC', @level2type = N'COLUMN', @level2name = N'PICKING_SVAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문 매가 부가세', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC', @level2type = N'COLUMN', @level2name = N'ORD_SVAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC', @level2type = N'COLUMN', @level2name = N'REMARKS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피킹 공급가', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC', @level2type = N'COLUMN', @level2name = N'PICKING_SPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피킹 사원아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC', @level2type = N'COLUMN', @level2name = N'PICKING_EMP_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SEQ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC', @level2type = N'COLUMN', @level2name = N'SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피킹 합계', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC', @level2type = N'COLUMN', @level2name = N'PICKING_SAMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'무자료', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC', @level2type = N'COLUMN', @level2name = N'ORD_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문 매가 공급가', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC', @level2type = N'COLUMN', @level2name = N'ORD_SPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피킹 수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC', @level2type = N'COLUMN', @level2name = N'PICKING_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피킹 완료일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_NO_DOC', @level2type = N'COLUMN', @level2name = N'PICKING_EDATE';


GO

