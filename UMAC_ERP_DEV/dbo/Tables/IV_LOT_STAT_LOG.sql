CREATE TABLE [dbo].[IV_LOT_STAT_LOG] (
    [LOG_SEQ]   INT             NOT NULL,
    [SYS_NAME]  NVARCHAR (30)   NOT NULL,
    [SCAN_CODE] NVARCHAR (14)   NOT NULL,
    [LOT_NO]    NVARCHAR (30)   NOT NULL,
    [TRXN_NO]   NVARCHAR (6)    NULL,
    [BEFO_QTY]  NUMERIC (15, 2) NOT NULL,
    [CHG_QTY]   NUMERIC (15, 2) NOT NULL,
    [AFT_QTY]   NUMERIC (15, 2) NOT NULL,
    [IDATE]     DATETIME        NOT NULL,
    CONSTRAINT [PK_IV_LOT_STAT_LOG] PRIMARY KEY CLUSTERED ([LOG_SEQ] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품상태정보로그', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_LOT_STAT_LOG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_LOT_STAT_LOG', @level2type = N'COLUMN', @level2name = N'TRXN_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'LOT 번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_LOT_STAT_LOG', @level2type = N'COLUMN', @level2name = N'LOT_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_LOT_STAT_LOG', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'변경 테이블', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_LOT_STAT_LOG', @level2type = N'COLUMN', @level2name = N'SYS_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'변경 수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_LOT_STAT_LOG', @level2type = N'COLUMN', @level2name = N'CHG_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'변경 전 수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_LOT_STAT_LOG', @level2type = N'COLUMN', @level2name = N'BEFO_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'변경 후수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_LOT_STAT_LOG', @level2type = N'COLUMN', @level2name = N'AFT_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_LOT_STAT_LOG', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'로그 순번', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_LOT_STAT_LOG', @level2type = N'COLUMN', @level2name = N'LOG_SEQ';


GO

