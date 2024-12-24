CREATE TABLE [dbo].[SL_SALE_CHG_LOG] (
    [SEQ]       INT             NOT NULL,
    [ORD_NO]    NVARCHAR (11)   NOT NULL,
    [SCAN_CODE] NVARCHAR (14)   NOT NULL,
    [GUBUN]     NVARCHAR (1)    NOT NULL,
    [BEFO_QTY]  NUMERIC (15, 2) NOT NULL,
    [CHG_QTY]   NUMERIC (15, 2) NOT NULL,
    [BEFO_AMT]  NUMERIC (17, 4) NULL,
    [CHG_AMT]   NUMERIC (17, 4) NULL,
    [IDATE]     DATETIME        NOT NULL,
    [IEMP_ID]   NVARCHAR (20)   NOT NULL,
    CONSTRAINT [PK_SL_SALE_CHG_LOG] PRIMARY KEY CLUSTERED ([SEQ] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'변경수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_CHG_LOG', @level2type = N'COLUMN', @level2name = N'CHG_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_CHG_LOG', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'순번', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_CHG_LOG', @level2type = N'COLUMN', @level2name = N'SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'변경전금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_CHG_LOG', @level2type = N'COLUMN', @level2name = N'BEFO_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_CHG_LOG', @level2type = N'COLUMN', @level2name = N'ORD_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'본품:D 샘플:S', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_CHG_LOG', @level2type = N'COLUMN', @level2name = N'GUBUN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'변경금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_CHG_LOG', @level2type = N'COLUMN', @level2name = N'CHG_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_CHG_LOG', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'변경전수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_CHG_LOG', @level2type = N'COLUMN', @level2name = N'BEFO_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_CHG_LOG', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출입내역수정 변경 로그', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_CHG_LOG';


GO

