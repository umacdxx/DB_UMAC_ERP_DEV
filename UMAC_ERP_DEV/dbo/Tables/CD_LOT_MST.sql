CREATE TABLE [dbo].[CD_LOT_MST] (
    [PROD_DT]       NVARCHAR (8)    NOT NULL,
    [SCAN_CODE]     NVARCHAR (14)   NOT NULL,
    [LOT_NO]        NVARCHAR (30)   NOT NULL,
    [EXPIRATION_DT] NVARCHAR (8)    NULL,
    [PROD_GB]       NVARCHAR (1)    NULL,
    [LOT_NO_TEMP]   NVARCHAR (30)   NULL,
    [PROD_GB_CD]    NVARCHAR (3)    NULL,
    [PROD_QTY]      NUMERIC (15, 2) NULL,
    [PROD_APP_QTY]  NUMERIC (15, 2) CONSTRAINT [DF_CD_LOT_MST_PROD_APP_QTY] DEFAULT ((0)) NULL,
    [CFM_FLAG]      NVARCHAR (2)    CONSTRAINT [DF_CD_LOT_MST_CFM_FLAG] DEFAULT ('N') NULL,
    [CFM_EMP_ID]    NVARCHAR (20)   NULL,
    [CFM_DT]        NVARCHAR (8)    NULL,
    [IDATE]         DATETIME        NULL,
    [IEMP_ID]       NVARCHAR (20)   NULL,
    [UDATE]         DATETIME        NULL,
    [UEMP_ID]       NVARCHAR (20)   NULL,
    CONSTRAINT [PK_CD_LOT_MST] PRIMARY KEY CLUSTERED ([PROD_DT] ASC, [SCAN_CODE] ASC, [LOT_NO] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IDX_CD_LOT_MST_SCAN_CODE]
    ON [dbo].[CD_LOT_MST]([SCAN_CODE] ASC, [LOT_NO] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'확정 여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_LOT_MST', @level2type = N'COLUMN', @level2name = N'CFM_FLAG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_LOT_MST', @level2type = N'COLUMN', @level2name = N'PROD_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산구분코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_LOT_MST', @level2type = N'COLUMN', @level2name = N'PROD_GB_CD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_LOT_MST', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산 수/중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_LOT_MST', @level2type = N'COLUMN', @level2name = N'PROD_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'소비기한', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_LOT_MST', @level2type = N'COLUMN', @level2name = N'EXPIRATION_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_LOT_MST', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산구분(B:BOM, S:SET, K:벌크)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_LOT_MST', @level2type = N'COLUMN', @level2name = N'PROD_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_LOT_MST', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_LOT_MST', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_LOT_MST', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'확정자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_LOT_MST', @level2type = N'COLUMN', @level2name = N'CFM_EMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'확정일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_LOT_MST', @level2type = N'COLUMN', @level2name = N'CFM_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'LOT 번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_LOT_MST', @level2type = N'COLUMN', @level2name = N'LOT_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'LOT마스터', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_LOT_MST';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'확정 수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_LOT_MST', @level2type = N'COLUMN', @level2name = N'PROD_APP_QTY';


GO

