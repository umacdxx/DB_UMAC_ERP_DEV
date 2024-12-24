CREATE TABLE [dbo].[PD_TEST_REPORT] (
    [SCAN_CODE]       NVARCHAR (14)   NOT NULL,
    [PROD_DT]         NVARCHAR (8)    NOT NULL,
    [LOT_NO]          NVARCHAR (30)   NOT NULL,
    [CHAR_RESULT]     NVARCHAR (30)   NULL,
    [ACID_RESULT]     NUMERIC (15, 3) NULL,
    [PEROXIDE_RESULT] NUMERIC (15, 2) NULL,
    [LODINE_RESULT]   NUMERIC (15, 2) NULL,
    [COLOR_RESULT]    NVARCHAR (30)   NULL,
    [BENXO_RESULT]    NVARCHAR (30)   NULL,
    [R_NO]            NVARCHAR (20)   NULL,
    [IDATE]           DATETIME        NULL,
    [IEMP_ID]         NVARCHAR (20)   NULL,
    [UDATE]           DATETIME        NULL,
    [UEMP_ID]         NVARCHAR (20)   NULL,
    CONSTRAINT [PK_PD_TEST_REPORT] PRIMARY KEY CLUSTERED ([SCAN_CODE] ASC, [PROD_DT] ASC, [LOT_NO] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '색상', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT', @level2type = N'COLUMN', @level2name = N'COLOR_RESULT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'LOT 번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT', @level2type = N'COLUMN', @level2name = N'LOT_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '과산화', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT', @level2type = N'COLUMN', @level2name = N'PEROXIDE_RESULT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '요오드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT', @level2type = N'COLUMN', @level2name = N'LODINE_RESULT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '육안 및 관능', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT', @level2type = N'COLUMN', @level2name = N'CHAR_RESULT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '벤조', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT', @level2type = N'COLUMN', @level2name = N'BENXO_RESULT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '시험성적서 상세내역', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '산성', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT', @level2type = N'COLUMN', @level2name = N'ACID_RESULT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '생산일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_TEST_REPORT', @level2type = N'COLUMN', @level2name = N'PROD_DT';


GO

