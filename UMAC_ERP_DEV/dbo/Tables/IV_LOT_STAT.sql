CREATE TABLE [dbo].[IV_LOT_STAT] (
    [SCAN_CODE]    NVARCHAR (14)   NOT NULL,
    [LOT_NO]       NVARCHAR (30)   NOT NULL,
    [ITM_CODE]     NVARCHAR (6)    NULL,
    [CUR_INV_QTY]  NUMERIC (15, 2) NULL,
    [LAST_SALE_DT] NVARCHAR (8)    NULL,
    [UDATE]        DATETIME        NULL,
    CONSTRAINT [PK_IV_LOT_STAT] PRIMARY KEY CLUSTERED ([SCAN_CODE] ASC, [LOT_NO] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품상태정보', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_LOT_STAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'최종 매출일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_LOT_STAT', @level2type = N'COLUMN', @level2name = N'LAST_SALE_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'현재고 수/중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_LOT_STAT', @level2type = N'COLUMN', @level2name = N'CUR_INV_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'LOT 번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_LOT_STAT', @level2type = N'COLUMN', @level2name = N'LOT_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_LOT_STAT', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'관리코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_LOT_STAT', @level2type = N'COLUMN', @level2name = N'ITM_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_LOT_STAT', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

