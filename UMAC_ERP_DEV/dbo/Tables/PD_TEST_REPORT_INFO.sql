CREATE TABLE [dbo].[PD_TEST_REPORT_INFO] (
    [SCAN_CODE]     NVARCHAR (14)  NOT NULL,
    [ITM_PROD_NO]   NVARCHAR (20)  NULL,
    [RAW_MATERIALS] NVARCHAR (100) NULL,
    [CHAR]          NVARCHAR (50)  NULL,
    [ACID]          NVARCHAR (30)  NULL,
    [PEROXIDE]      NVARCHAR (30)  NULL,
    [LODINE]        NVARCHAR (30)  NULL,
    [COLOR]         NVARCHAR (50)  NULL,
    [BENXO]         NVARCHAR (30)  NULL,
    [R_NO]          NVARCHAR (20)  NULL,
    [COLOR_TYPE]    NVARCHAR (200) NULL,
    [IDATE]         DATETIME       NULL,
    [IEMP_ID]       NVARCHAR (20)  NULL,
    [UDATE]         DATETIME       NULL,
    [UEMP_ID]       NVARCHAR (20)  NULL,
    CONSTRAINT [PK__TEST_REP__E698084D5B8999F2] PRIMARY KEY CLUSTERED ([SCAN_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '색상', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT_INFO', @level2type = N'COLUMN', @level2name = N'COLOR';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'R번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT_INFO', @level2type = N'COLUMN', @level2name = N'R_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT_INFO', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT_INFO', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT_INFO', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT_INFO', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '육안 및 관능', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT_INFO', @level2type = N'COLUMN', @level2name = N'CHAR';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '과산화', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT_INFO', @level2type = N'COLUMN', @level2name = N'PEROXIDE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '벤조', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT_INFO', @level2type = N'COLUMN', @level2name = N'BENXO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '시험성적서 기초정', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT_INFO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'COLOR 분석방법', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT_INFO', @level2type = N'COLUMN', @level2name = N'COLOR_TYPE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '품목제조보고번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT_INFO', @level2type = N'COLUMN', @level2name = N'ITM_PROD_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT_INFO', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '원재료 및 함량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT_INFO', @level2type = N'COLUMN', @level2name = N'RAW_MATERIALS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '산성', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT_INFO', @level2type = N'COLUMN', @level2name = N'ACID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '요오드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT_INFO', @level2type = N'COLUMN', @level2name = N'LODINE';


GO

