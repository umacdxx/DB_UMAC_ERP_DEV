CREATE TABLE [dbo].[PA_TOSS_DEPOSIT] (
    [SOLDATE]      NVARCHAR (8)    NOT NULL,
    [PAIDOUTDATE]  NVARCHAR (8)    NOT NULL,
    [PAYMENTKEY]   NVARCHAR (200)  NOT NULL,
    [ORDERID]      NVARCHAR (64)   NOT NULL,
    [METHOD]       NVARCHAR (25)   NOT NULL,
    [ACQUIRERCODE] NVARCHAR (5)    NOT NULL,
    [AMOUNT]       NUMERIC (13, 2) NOT NULL,
    [FEE]          NUMERIC (13, 2) NOT NULL,
    [SUPPLYAMOUNT] NUMERIC (13, 2) NOT NULL,
    [VAT]          NUMERIC (13, 2) NOT NULL,
    [PAYOUTAMOUNT] NUMERIC (13, 2) NOT NULL,
    [IDATE]        DATETIME        NOT NULL
);


GO

CREATE NONCLUSTERED INDEX [INDEX_PAIDOUTDATE]
    ON [dbo].[PA_TOSS_DEPOSIT]([PAIDOUTDATE] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수수료 금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_TOSS_DEPOSIT', @level2type = N'COLUMN', @level2name = N'FEE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입금 금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_TOSS_DEPOSIT', @level2type = N'COLUMN', @level2name = N'AMOUNT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입사 코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_TOSS_DEPOSIT', @level2type = N'COLUMN', @level2name = N'ACQUIRERCODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'결제 수수료 부가세', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_TOSS_DEPOSIT', @level2type = N'COLUMN', @level2name = N'VAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'결제수수료의 공급가액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_TOSS_DEPOSIT', @level2type = N'COLUMN', @level2name = N'SUPPLYAMOUNT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'결제 KEY', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_TOSS_DEPOSIT', @level2type = N'COLUMN', @level2name = N'PAYMENTKEY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_TOSS_DEPOSIT', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'지급 금액을 상점에 지급할 정산 지급일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_TOSS_DEPOSIT', @level2type = N'COLUMN', @level2name = N'PAIDOUTDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'정산 매출일(입금날짜)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_TOSS_DEPOSIT', @level2type = N'COLUMN', @level2name = N'SOLDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'지급 금액 (결제 금액(AMOUNT) 에서 수수료(FEE)를 제외한 금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_TOSS_DEPOSIT', @level2type = N'COLUMN', @level2name = N'PAYOUTAMOUNT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'토스 입금정산 관리', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_TOSS_DEPOSIT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'결제수단', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_TOSS_DEPOSIT', @level2type = N'COLUMN', @level2name = N'METHOD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PA_TOSS_DEPOSIT', @level2type = N'COLUMN', @level2name = N'ORDERID';


GO

