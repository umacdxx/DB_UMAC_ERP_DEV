CREATE TABLE [dbo].[TBL_TOSSPAY_XPAY] (
    [MID]         NVARCHAR (15) NOT NULL,
    [PAYTYPE]     CHAR (6)      NOT NULL,
    [TRANSACTION] NVARCHAR (24) NOT NULL,
    [OID]         NVARCHAR (64) NOT NULL,
    [FINANCECODE] NVARCHAR (10) NOT NULL,
    [FINANCENAME] NVARCHAR (10) NOT NULL,
    [BUYERID]     NVARCHAR (15) NULL,
    [AMOUNT]      INT           NOT NULL,
    [USEESCROW]   CHAR (1)      NOT NULL,
    [PAYDATE]     NVARCHAR (8)  NOT NULL,
    [AUTHNMUNBER] NVARCHAR (8)  NOT NULL,
    [STATUS]      CHAR (2)      NOT NULL,
    [USE_YN]      NVARCHAR (1)  CONSTRAINT [DF_TBL_TOSSPAY_XPAY_USE_YN] DEFAULT (N'N') NOT NULL,
    CONSTRAINT [PK_TBL_TOSSPAY_XPAY] PRIMARY KEY CLUSTERED ([OID] ASC, [STATUS] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_XPAY', @level2type = N'COLUMN', @level2name = N'AMOUNT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_XPAY', @level2type = N'COLUMN', @level2name = N'OID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'결제기관코드명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_XPAY', @level2type = N'COLUMN', @level2name = N'FINANCENAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'10: 거래 성공, 11: 거래 실패, 20: 취소/환불성공, 21: 취소/환불실패', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_XPAY', @level2type = N'COLUMN', @level2name = N'STATUS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'토스 안심키 결제 데이터 기록', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_XPAY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'결제수단코드 : SC0010 :카드, SC0030:계좌이체, SC0040:무통장입금', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_XPAY', @level2type = N'COLUMN', @level2name = N'PAYTYPE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'결제일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_XPAY', @level2type = N'COLUMN', @level2name = N'PAYDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'구매자 아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_XPAY', @level2type = N'COLUMN', @level2name = N'BUYERID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'최종 에스크로 적용 여부 : Y/N', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_XPAY', @level2type = N'COLUMN', @level2name = N'USEESCROW';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_XPAY', @level2type = N'COLUMN', @level2name = N'TRANSACTION';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'결제기관코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_XPAY', @level2type = N'COLUMN', @level2name = N'FINANCECODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상점아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_XPAY', @level2type = N'COLUMN', @level2name = N'MID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'승인번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_XPAY', @level2type = N'COLUMN', @level2name = N'AUTHNMUNBER';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입금처리 사용여부 Y,N', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_TOSSPAY_XPAY', @level2type = N'COLUMN', @level2name = N'USE_YN';


GO

