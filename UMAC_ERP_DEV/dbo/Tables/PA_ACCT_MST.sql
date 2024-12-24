CREATE TABLE [dbo].[PA_ACCT_MST] (
    [VEN_CODE]    NVARCHAR (7)    NOT NULL,
    [BANK_CODE]   NVARCHAR (2)    NOT NULL,
    [VACT_NO]     VARBINARY (256) NOT NULL,
    [VACT_NO_KEY] NVARCHAR (10)   NOT NULL,
    [IEMP_ID]     NVARCHAR (20)   NOT NULL,
    [IDATE]       DATETIME        NOT NULL,
    CONSTRAINT [PK_PA_ACCT_MST] PRIMARY KEY CLUSTERED ([VEN_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'가상계좌번호(고정식)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_MST', @level2type = N'COLUMN', @level2name = N'VACT_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_MST', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'은행코드(토스)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_MST', @level2type = N'COLUMN', @level2name = N'BANK_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'회원별 가상계좌 내역', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_MST';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_MST', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_MST', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'고정식 가상계좌 KEY', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_ACCT_MST', @level2type = N'COLUMN', @level2name = N'VACT_NO_KEY';


GO

