CREATE TABLE [dbo].[PUR_INFO] (
    [PUR_DT]        NVARCHAR (8)    NOT NULL,
    [ORD_NO]        NVARCHAR (11)   NOT NULL,
    [SCAN_CODE]     NVARCHAR (14)   NOT NULL,
    [VEN_CODE]      NVARCHAR (7)    NOT NULL,
    [ITM_CODE]      NVARCHAR (6)    NOT NULL,
    [TAX_GB]        NVARCHAR (1)    NOT NULL,
    [PUR_EA]        INT             NULL,
    [PUR_KG]        NUMERIC (15, 2) NULL,
    [PUR_TOTAL_AMT] NUMERIC (15, 2) NULL,
    [PUR_CFM_DT]    NVARCHAR (8)    NULL,
    [IDATE]         DATETIME        CONSTRAINT [DF_PUR_INFO_IDATE] DEFAULT (getdate()) NOT NULL,
    [IEMP_ID]       NVARCHAR (20)   NULL,
    [UDATE]         DATETIME        NULL,
    [UEMP_ID]       NVARCHAR (20)   NULL,
    CONSTRAINT [PK_PUR_INFO] PRIMARY KEY CLUSTERED ([PUR_DT] ASC, [ORD_NO] ASC, [SCAN_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품 관리코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_INFO', @level2type = N'COLUMN', @level2name = N'ITM_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_INFO', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_INFO', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_INFO', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_INFO', @level2type = N'COLUMN', @level2name = N'ORD_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_INFO', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입합계금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_INFO', @level2type = N'COLUMN', @level2name = N'PUR_TOTAL_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입 관리', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_INFO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입 수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_INFO', @level2type = N'COLUMN', @level2name = N'PUR_EA';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'과면세구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_INFO', @level2type = N'COLUMN', @level2name = N'TAX_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_INFO', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_INFO', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_INFO', @level2type = N'COLUMN', @level2name = N'PUR_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입확정일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_INFO', @level2type = N'COLUMN', @level2name = N'PUR_CFM_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입 중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_INFO', @level2type = N'COLUMN', @level2name = N'PUR_KG';


GO

