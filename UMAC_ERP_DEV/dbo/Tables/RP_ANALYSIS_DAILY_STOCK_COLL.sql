CREATE TABLE [dbo].[RP_ANALYSIS_DAILY_STOCK_COLL] (
    [REPORT_DATE] NVARCHAR (8)    NOT NULL,
    [SCAN_CODE]   NVARCHAR (14)   NOT NULL,
    [REMARKS]     NVARCHAR (2000) NULL,
    [IDATE]       DATETIME        NOT NULL,
    [IEMP_ID]     NVARCHAR (20)   NOT NULL,
    [UDATE]       DATETIME        NULL,
    [UEMP_ID]     NVARCHAR (20)   NULL,
    CONSTRAINT [PK_RP_ANALYSIS_DAILY_STOCK_COLL] PRIMARY KEY CLUSTERED ([REPORT_DATE] ASC, [SCAN_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_STOCK_COLL', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_STOCK_COLL', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_STOCK_COLL', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'일 수불 현황(비고)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_STOCK_COLL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_STOCK_COLL', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_STOCK_COLL', @level2type = N'COLUMN', @level2name = N'REMARKS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_STOCK_COLL', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'리포트 일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_STOCK_COLL', @level2type = N'COLUMN', @level2name = N'REPORT_DATE';


GO

