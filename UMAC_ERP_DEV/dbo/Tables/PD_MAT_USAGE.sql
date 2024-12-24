CREATE TABLE [dbo].[PD_MAT_USAGE] (
    [PROD_DT]   NVARCHAR (8)  NOT NULL,
    [SCAN_CODE] NVARCHAR (14) NOT NULL,
    [COMP_CODE] NVARCHAR (14) NOT NULL,
    [MAT_GB]    NVARCHAR (1)  NULL,
    [YYYYMM]    NVARCHAR (6)  NOT NULL,
    [INPUT_QTY] INT           NOT NULL,
    [IDATE]     DATETIME      NOT NULL,
    [IEMP_ID]   NVARCHAR (20) NOT NULL,
    [UDATE]     DATETIME      NULL,
    [UEMP_ID]   NVARCHAR (20) NULL,
    CONSTRAINT [PK__PD_MAT_U__374DC9692B801A1D] PRIMARY KEY CLUSTERED ([PROD_DT] ASC, [SCAN_CODE] ASC, [COMP_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_MAT_USAGE', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'부자재코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_MAT_USAGE', @level2type = N'COLUMN', @level2name = N'COMP_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'YYYYMM 정보', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_MAT_USAGE', @level2type = N'COLUMN', @level2name = N'YYYYMM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_MAT_USAGE', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'부자재구분[1:CAP,2:루뎅,3:띠라벨]', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_MAT_USAGE', @level2type = N'COLUMN', @level2name = N'MAT_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_MAT_USAGE', @level2type = N'COLUMN', @level2name = N'PROD_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'투입량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_MAT_USAGE', @level2type = N'COLUMN', @level2name = N'INPUT_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산 부자재 사용내역', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_MAT_USAGE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_MAT_USAGE', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_MAT_USAGE', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_MAT_USAGE', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

