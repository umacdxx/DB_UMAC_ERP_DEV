CREATE TABLE [dbo].[TBL_TOSSPAY_VIRTUAL] (
    [PAYMENTKEY]    VARCHAR (200) NOT NULL,
    [ORDERID]       VARCHAR (64)  NOT NULL,
    [STATUS]        VARCHAR (15)  NOT NULL,
    [APPROVEDAT]    VARCHAR (35)  NOT NULL,
    [METHOD]        NVARCHAR (25) NOT NULL,
    [TOTALAMOUNT]   INT           NOT NULL,
    [ACCOUNTNUMBER] VARCHAR (20)  NOT NULL,
    [ACCOUNTTYPE]   NVARCHAR (25) NOT NULL,
    [BANKCODE]      VARCHAR (3)   NOT NULL,
    [REFUNDSTATUS]  NVARCHAR (15) NOT NULL
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'결제 승인 날짜', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_VIRTUAL', @level2type = N'COLUMN', @level2name = N'APPROVEDAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'가상계좌 은행 숫자 코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_VIRTUAL', @level2type = N'COLUMN', @level2name = N'BANKCODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_VIRTUAL', @level2type = N'COLUMN', @level2name = N'ORDERID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'가상계좌번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_VIRTUAL', @level2type = N'COLUMN', @level2name = N'ACCOUNTNUMBER';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'결제의 키', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_VIRTUAL', @level2type = N'COLUMN', @level2name = N'PAYMENTKEY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'총 결제 금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_VIRTUAL', @level2type = N'COLUMN', @level2name = N'TOTALAMOUNT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'환불 처리 상태', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_VIRTUAL', @level2type = N'COLUMN', @level2name = N'REFUNDSTATUS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'가상계좌 타입(일반, 고정)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_VIRTUAL', @level2type = N'COLUMN', @level2name = N'ACCOUNTTYPE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'결제 처리 상태', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_VIRTUAL', @level2type = N'COLUMN', @level2name = N'STATUS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'결제수단 (카드, 가상계좌)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_VIRTUAL', @level2type = N'COLUMN', @level2name = N'METHOD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'토스 가상계좌 입금 로그', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_VIRTUAL';


GO

