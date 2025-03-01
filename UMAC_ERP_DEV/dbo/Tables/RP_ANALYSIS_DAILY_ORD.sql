CREATE TABLE [dbo].[RP_ANALYSIS_DAILY_ORD] (
    [REPORT_DATE]   NVARCHAR (8)    NOT NULL,
    [VEN_CODE]      NVARCHAR (7)    NOT NULL,
    [DELIVERY_CODE] NVARCHAR (7)    NOT NULL,
    [SCAN_CODE]     NVARCHAR (14)   NOT NULL,
    [ORD_QTY]       NUMERIC (15, 2) NOT NULL,
    [IDATE]         DATETIME        DEFAULT (getdate()) NOT NULL,
    [IEMP_ID]       NVARCHAR (20)   NOT NULL,
    [UDATE]         DATETIME        NULL,
    [UEMP_ID]       NVARCHAR (20)   NULL,
    PRIMARY KEY CLUSTERED ([REPORT_DATE] ASC, [VEN_CODE] ASC, [DELIVERY_CODE] ASC, [SCAN_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_ORD', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_ORD', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문/발주수중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_ORD', @level2type = N'COLUMN', @level2name = N'ORD_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배송지코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_ORD', @level2type = N'COLUMN', @level2name = N'DELIVERY_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'리포트 일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_ORD', @level2type = N'COLUMN', @level2name = N'REPORT_DATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_ORD', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_ORD', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_ORD', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_ORD', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'원재료 부자재 일보', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_ORD';


GO

