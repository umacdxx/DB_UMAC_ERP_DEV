CREATE TABLE [dbo].[PA_ACCT_DEPOSIT_DEL_LOG] (
    [MOID]         NVARCHAR (100) NOT NULL,
    [VEN_CODE]     NVARCHAR (7)   NOT NULL,
    [DEPOSIT_GB]   NVARCHAR (2)   NOT NULL,
    [DEPOSIT_NO]   NVARCHAR (11)  NOT NULL,
    [DEPOSIT_AMT]  BIGINT         NOT NULL,
    [DEPOSIT_DT]   NVARCHAR (8)   NOT NULL,
    [DEPOSIT_FISH] NVARCHAR (1)   NOT NULL,
    [ISSUER_CODE]  NVARCHAR (5)   NULL,
    [CARD_NO]      NVARCHAR (16)  NULL,
    [APP_NO]       NVARCHAR (18)  NULL,
    [MODE]         NCHAR (1)      NULL,
    [IDATE]        DATETIME       NOT NULL,
    [IEMP_ID]      NVARCHAR (20)  NOT NULL,
    [NIDATE]       DATETIME       NOT NULL
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입금날짜', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_DEL_LOG', @level2type = N'COLUMN', @level2name = N'DEPOSIT_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입금금', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_DEL_LOG', @level2type = N'COLUMN', @level2name = N'DEPOSIT_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'카드 발급사 코드(TOSS_CARD_XPAY)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_DEL_LOG', @level2type = N'COLUMN', @level2name = N'ISSUER_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입금완료여부(Y/N)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_DEL_LOG', @level2type = N'COLUMN', @level2name = N'DEPOSIT_FISH';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_DEL_LOG', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'승인번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_DEL_LOG', @level2type = N'COLUMN', @level2name = N'APP_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입금구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_DEL_LOG', @level2type = N'COLUMN', @level2name = N'DEPOSIT_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'카드번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_DEL_LOG', @level2type = N'COLUMN', @level2name = N'CARD_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입금번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_DEL_LOG', @level2type = N'COLUMN', @level2name = N'DEPOSIT_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_DEL_LOG', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PG 주문아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_DEL_LOG', @level2type = N'COLUMN', @level2name = N'MOID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생성 모드 : I,U,D', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_DEL_LOG', @level2type = N'COLUMN', @level2name = N'MODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생성날짜', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_DEL_LOG', @level2type = N'COLUMN', @level2name = N'NIDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'가상계좌 입금내역 삭제 데이터 로그', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_DEL_LOG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_DEPOSIT_DEL_LOG', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

