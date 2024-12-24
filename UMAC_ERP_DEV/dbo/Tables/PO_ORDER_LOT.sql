CREATE TABLE [dbo].[PO_ORDER_LOT] (
    [ORD_NO]      NVARCHAR (11)   NOT NULL,
    [SCAN_CODE]   NVARCHAR (14)   NOT NULL,
    [LOT_NO]      NVARCHAR (30)   NOT NULL,
    [PICKING_QTY] NUMERIC (15, 2) NULL,
    [TEMP_QTY]    NUMERIC (15, 2) NULL,
    [IDATE]       DATETIME        NULL,
    [IEMP_ID]     NVARCHAR (20)   NULL,
    [UDATE]       DATETIME        NULL,
    [UEMP_ID]     NVARCHAR (20)   NULL,
    CONSTRAINT [PK_PO_ORDER_LOT_1] PRIMARY KEY CLUSTERED ([ORD_NO] ASC, [SCAN_CODE] ASC, [LOT_NO] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출수정을 위한 TEMP피킹수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_LOT', @level2type = N'COLUMN', @level2name = N'TEMP_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_LOT', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'LOT 번', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_LOT', @level2type = N'COLUMN', @level2name = N'LOT_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피킹수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_LOT', @level2type = N'COLUMN', @level2name = N'PICKING_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_LOT', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_LOT', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_LOT', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문등록_LOT정보', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_LOT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_LOT', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문/발주/수입번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_LOT', @level2type = N'COLUMN', @level2name = N'ORD_NO';


GO

