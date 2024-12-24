CREATE TABLE [dbo].[RP_ANALYSIS_ITM_PARTNER] (
    [REPORT_DATE] NVARCHAR (8)    NOT NULL,
    [SCAN_CODE]   NVARCHAR (14)   NOT NULL,
    [VEN_CODE]    NVARCHAR (7)    NOT NULL,
    [CAR_NO]      NVARCHAR (8)    NULL,
    [REMARKS]     NVARCHAR (2000) NULL,
    [IDATE]       DATETIME        NOT NULL,
    [IEMP_ID]     NVARCHAR (20)   NOT NULL,
    [UDATE]       DATETIME        NULL,
    [UEMP_ID]     NVARCHAR (20)   NULL
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_ITM_PARTNER', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'리포트 일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_ITM_PARTNER', @level2type = N'COLUMN', @level2name = N'REPORT_DATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_ITM_PARTNER', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드 (영업관리 스캔코드(88))', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_ITM_PARTNER', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_ITM_PARTNER', @level2type = N'COLUMN', @level2name = N'REMARKS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드 (채번 규칙: UM+거래구분 1자리 +0001~9999)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_ITM_PARTNER', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_ITM_PARTNER', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'차량번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_ITM_PARTNER', @level2type = N'COLUMN', @level2name = N'CAR_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_ITM_PARTNER', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'품목/거래처 일보', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ANALYSIS_ITM_PARTNER';


GO

