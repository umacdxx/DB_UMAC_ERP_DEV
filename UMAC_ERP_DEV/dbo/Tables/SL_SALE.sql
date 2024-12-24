CREATE TABLE [dbo].[SL_SALE] (
    [SALE_DT]        NVARCHAR (8)    NOT NULL,
    [ORD_NO]         NVARCHAR (11)   NOT NULL,
    [SCAN_CODE]      NVARCHAR (14)   NOT NULL,
    [GUBUN]          NVARCHAR (1)    NOT NULL,
    [VEN_CODE]       NVARCHAR (7)    NOT NULL,
    [ITM_CODE]       NVARCHAR (6)    NOT NULL,
    [TAX_GB]         NVARCHAR (1)    NOT NULL,
    [SALE_EA]        INT             NOT NULL,
    [SALE_KG]        NUMERIC (15, 2) NOT NULL,
    [SALE_TOTAL_AMT] NUMERIC (17, 4) NULL,
    [SALE_CFM_DT]    NVARCHAR (8)    NULL,
    [BEFO_QTY]       NUMERIC (15, 2) CONSTRAINT [DF_SL_SALE_BEFO_QTY] DEFAULT ((0)) NOT NULL,
    [BEFO_AMT]       NUMERIC (17, 4) CONSTRAINT [DF_SL_SALE_BEFO_AMT] DEFAULT ((0)) NULL,
    [IDATE]          DATETIME        CONSTRAINT [DF_SL_SALE_IDATE] DEFAULT (getdate()) NOT NULL,
    [IEMP_ID]        NVARCHAR (20)   NULL,
    [UDATE]          DATETIME        NULL,
    [UEMP_ID]        NVARCHAR (20)   NULL,
    CONSTRAINT [PK_SL_SALE] PRIMARY KEY CLUSTERED ([SALE_DT] ASC, [ORD_NO] ASC, [SCAN_CODE] ASC, [GUBUN] ASC)
);


GO

CREATE NONCLUSTERED INDEX [INDEX_VEN_CODE]
    ON [dbo].[SL_SALE]([VEN_CODE] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'변경전 수/중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE', @level2type = N'COLUMN', @level2name = N'BEFO_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출 수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE', @level2type = N'COLUMN', @level2name = N'SALE_EA';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'판매일자(출고일자)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE', @level2type = N'COLUMN', @level2name = N'SALE_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출 중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE', @level2type = N'COLUMN', @level2name = N'SALE_KG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE', @level2type = N'COLUMN', @level2name = N'ORD_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출합계금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE', @level2type = N'COLUMN', @level2name = N'SALE_TOTAL_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품 관리코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE', @level2type = N'COLUMN', @level2name = N'ITM_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'변경 전 금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE', @level2type = N'COLUMN', @level2name = N'BEFO_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'본품:D 샘플:S', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE', @level2type = N'COLUMN', @level2name = N'GUBUN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출확정일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE', @level2type = N'COLUMN', @level2name = N'SALE_CFM_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'과면세코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE', @level2type = N'COLUMN', @level2name = N'TAX_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출 관리', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE';


GO

