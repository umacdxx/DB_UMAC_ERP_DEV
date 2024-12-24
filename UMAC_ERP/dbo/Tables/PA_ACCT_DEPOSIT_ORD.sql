CREATE TABLE [dbo].[PA_ACCT_DEPOSIT_ORD] (
    [SALE_DT]        NVARCHAR (8)    NOT NULL,
    [ORD_NO]         NVARCHAR (11)   NOT NULL,
    [VEN_CODE]       NVARCHAR (7)    NOT NULL,
    [SALE_TOTAL_AMT] NUMERIC (17, 4) NULL,
    [DEPOSIT_GB]     NVARCHAR (2)    NOT NULL,
    [DEPOSIT_NO]     NVARCHAR (11)   NULL,
    [MOID]           NVARCHAR (100)  NULL,
    [DEPOSIT_AMT]    NUMERIC (17, 4) NULL,
    [DEPOSIT_DT]     NVARCHAR (8)    NULL,
    [DEPOSIT_FISH]   NVARCHAR (1)    NULL,
    [DEL_YN]         NVARCHAR (1)    NULL,
    [IDATE]          DATETIME        NOT NULL
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입금날자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_ORD', @level2type = N'COLUMN', @level2name = N'DEPOSIT_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PG 주문아이', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_ORD', @level2type = N'COLUMN', @level2name = N'MOID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입금금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_ORD', @level2type = N'COLUMN', @level2name = N'DEPOSIT_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입금번호 YYMMDD+001~999', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_ORD', @level2type = N'COLUMN', @level2name = N'DEPOSIT_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입금구분 N,Y', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_ORD', @level2type = N'COLUMN', @level2name = N'DEPOSIT_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_ORD', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'삭제여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_ORD', @level2type = N'COLUMN', @level2name = N'DEL_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입금완료여부 N,Y', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_ORD', @level2type = N'COLUMN', @level2name = N'DEPOSIT_FISH';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_ORD', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'판매금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_ORD', @level2type = N'COLUMN', @level2name = N'SALE_TOTAL_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문/발주/수입번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_ORD', @level2type = N'COLUMN', @level2name = N'ORD_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문별 입금처리내역', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_ORD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'판매일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_ORD', @level2type = N'COLUMN', @level2name = N'SALE_DT';


GO

