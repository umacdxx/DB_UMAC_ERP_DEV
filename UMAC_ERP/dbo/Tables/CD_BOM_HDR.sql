CREATE TABLE [dbo].[CD_BOM_HDR] (
    [BOM_CD]      NVARCHAR (3)   NOT NULL,
    [BOM_NAME]    NVARCHAR (100) NOT NULL,
    [BOM_PROD_CD] NVARCHAR (14)  NOT NULL,
    [BOM_PROD_NM] NVARCHAR (100) NULL,
    [USE_YN]      NVARCHAR (1)   NOT NULL,
    [IDATE]       DATETIME       NULL,
    [IEMP_ID]     NVARCHAR (20)  NULL,
    [UDATE]       DATETIME       NULL,
    [UEMP_ID]     NVARCHAR (20)  NULL,
    CONSTRAINT [PK_CD_BOM_HDR] PRIMARY KEY CLUSTERED ([BOM_CD] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'BOM 생산품 코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOM_HDR', @level2type = N'COLUMN', @level2name = N'BOM_PROD_CD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOM_HDR', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOM_HDR', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOM_HDR', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'BOM 생산품 상품명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOM_HDR', @level2type = N'COLUMN', @level2name = N'BOM_PROD_NM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'BOM 마스터 HDR', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOM_HDR';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'BOM 코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOM_HDR', @level2type = N'COLUMN', @level2name = N'BOM_CD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'BOM 이름', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOM_HDR', @level2type = N'COLUMN', @level2name = N'BOM_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOM_HDR', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'사용여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOM_HDR', @level2type = N'COLUMN', @level2name = N'USE_YN';


GO

