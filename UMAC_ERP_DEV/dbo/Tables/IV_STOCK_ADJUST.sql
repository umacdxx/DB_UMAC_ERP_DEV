CREATE TABLE [dbo].[IV_STOCK_ADJUST] (
    [SEQ]       INT             IDENTITY (1, 1) NOT NULL,
    [ITM_CODE]  NVARCHAR (6)    NOT NULL,
    [SCAN_CODE] NVARCHAR (14)   NOT NULL,
    [INV_DT]    NVARCHAR (8)    NOT NULL,
    [INV_GB]    NVARCHAR (2)    NOT NULL,
    [LOT_NO]    NVARCHAR (30)   NULL,
    [CH_SEQ]    INT             NULL,
    [REQ_QTY]   NUMERIC (15, 2) NOT NULL,
    [CFM_FLAG]  NVARCHAR (2)    NOT NULL,
    [CFM_DT]    NVARCHAR (8)    NULL,
    [APP_QTY]   NUMERIC (15, 2) NULL,
    [REMARKS]   NVARCHAR (2000) NULL,
    [IDATE]     DATETIME        NOT NULL,
    [IEMP_ID]   NVARCHAR (20)   NOT NULL,
    [UDATE]     DATETIME        NULL,
    [UEMP_ID]   NVARCHAR (20)   NULL,
    CONSTRAINT [PK__IV_STOCK__CA1938C0AF9390A1] PRIMARY KEY CLUSTERED ([SEQ] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'확정 일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_ADJUST', @level2type = N'COLUMN', @level2name = N'CFM_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록 아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_ADJUST', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'관리코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_ADJUST', @level2type = N'COLUMN', @level2name = N'ITM_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'LOT 번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_ADJUST', @level2type = N'COLUMN', @level2name = N'LOT_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록 일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_ADJUST', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'확정 구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_ADJUST', @level2type = N'COLUMN', @level2name = N'CFM_FLAG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'시퀀스', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_ADJUST', @level2type = N'COLUMN', @level2name = N'SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'조정 구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_ADJUST', @level2type = N'COLUMN', @level2name = N'INV_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_ADJUST', @level2type = N'COLUMN', @level2name = N'REMARKS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정 아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_ADJUST', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'조정 일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_ADJUST', @level2type = N'COLUMN', @level2name = N'INV_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'조정 확정 수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_ADJUST', @level2type = N'COLUMN', @level2name = N'APP_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_ADJUST', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정 일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_ADJUST', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'조정 요청 수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_ADJUST', @level2type = N'COLUMN', @level2name = N'REQ_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'재고조정', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_ADJUST';


GO

