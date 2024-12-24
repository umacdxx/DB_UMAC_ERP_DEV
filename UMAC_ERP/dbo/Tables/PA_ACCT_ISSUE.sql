CREATE TABLE [dbo].[PA_ACCT_ISSUE] (
    [ISSUE_DT]    NVARCHAR (8)    NOT NULL,
    [VEN_CODE]    NVARCHAR (7)    NOT NULL,
    [TID]         NVARCHAR (100)  NOT NULL,
    [MOID]        NVARCHAR (100)  NOT NULL,
    [BANK_CODE]   NVARCHAR (2)    NOT NULL,
    [VACT_NO]     VARBINARY (256) NOT NULL,
    [REQ_AMT]     INT             NOT NULL,
    [DEPOSIT_AMT] INT             NOT NULL,
    [VACT_STAT]   NVARCHAR (30)   NOT NULL,
    [VACT_DATE]   NVARCHAR (8)    NOT NULL,
    [VACT_TIME]   NVARCHAR (5)    NOT NULL,
    [RECEIVE_YN]  NVARCHAR (1)    CONSTRAINT [DF_PA_ACCT_ISSUE_RECEIVE_YN] DEFAULT (N'N') NOT NULL,
    [IDATE]       DATETIME        NOT NULL,
    [IEMP_ID]     NVARCHAR (20)   NOT NULL,
    CONSTRAINT [PK_PA_ACCT_ISSUE] PRIMARY KEY CLUSTERED ([MOID] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입금금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_ISSUE', @level2type = N'COLUMN', @level2name = N'DEPOSIT_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입금요청금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_ISSUE', @level2type = N'COLUMN', @level2name = N'REQ_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'가상계좌번호(고정식)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_ISSUE', @level2type = N'COLUMN', @level2name = N'VACT_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'가상계좌만료일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_ISSUE', @level2type = N'COLUMN', @level2name = N'VACT_DATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'가상계좌 결제 처리상태', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_ISSUE', @level2type = N'COLUMN', @level2name = N'VACT_STAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PG 거래 아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_ISSUE', @level2type = N'COLUMN', @level2name = N'TID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'가상계좌입금여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_ISSUE', @level2type = N'COLUMN', @level2name = N'RECEIVE_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_ISSUE', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'가상계좌발행일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_ISSUE', @level2type = N'COLUMN', @level2name = N'ISSUE_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'가상계좌 만료시간', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_ISSUE', @level2type = N'COLUMN', @level2name = N'VACT_TIME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'가상계좌 발급내역', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_ISSUE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_ISSUE', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'은행코드(토스)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_ISSUE', @level2type = N'COLUMN', @level2name = N'BANK_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PG 주문 아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_ISSUE', @level2type = N'COLUMN', @level2name = N'MOID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_ISSUE', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

