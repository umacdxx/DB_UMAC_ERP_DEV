CREATE TABLE [dbo].[RP_ANALYSIS_DAILY_PROD] (
    [REPORT_MON]   NVARCHAR (6)    NOT NULL,
    [PARTNER_GB]   NVARCHAR (2)    NOT NULL,
    [ITM_CATEGORY] NVARCHAR (2)    NOT NULL,
    [SCAN_CODE]    NVARCHAR (14)   NOT NULL,
    [R_YN]         NVARCHAR (1)    NOT NULL,
    [REMARKS]      NVARCHAR (2000) NULL,
    [IDATE]        DATETIME        CONSTRAINT [DF__RP_ANALYS__IDATE__64A2D57C] DEFAULT (getdate()) NULL,
    [IEMP_ID]      NVARCHAR (20)   NULL,
    [UDATE]        DATETIME        NULL,
    [UEMP_ID]      NVARCHAR (20)   NULL,
    CONSTRAINT [PK_RP_ANALYSIS_DAILY_PROD] PRIMARY KEY CLUSTERED ([REPORT_MON] ASC, [PARTNER_GB] ASC, [ITM_CATEGORY] ASC, [SCAN_CODE] ASC, [R_YN] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_PROD', @level2type = N'COLUMN', @level2name = N'PARTNER_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_PROD', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산 일보', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_PROD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_PROD', @level2type = N'COLUMN', @level2name = N'REMARKS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_PROD', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_PROD', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'제품 카테고리', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_PROD', @level2type = N'COLUMN', @level2name = N'ITM_CATEGORY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'리포트 월', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_PROD', @level2type = N'COLUMN', @level2name = N'REPORT_MON';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_PROD', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'R병여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_PROD', @level2type = N'COLUMN', @level2name = N'R_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_DAILY_PROD', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

