CREATE TABLE [dbo].[CD_BOX_MST] (
    [BOX_CODE] NVARCHAR (6)   NOT NULL,
    [BOX_NAME] NVARCHAR (50)  NULL,
    [ITM_CODE] NVARCHAR (6)   NULL,
    [ITM_NAME] NVARCHAR (100) NULL,
    [IPSU_QTY] INT            NULL,
    [IDATE]    DATETIME       NULL,
    [IEMP_ID]  NVARCHAR (20)  NULL,
    [UDATE]    DATETIME       NULL,
    [UEMP_ID]  NVARCHAR (20)  NULL,
    CONSTRAINT [PK_CD_BOX_MST] PRIMARY KEY CLUSTERED ([BOX_CODE] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IDX_ITM_CODE]
    ON [dbo].[CD_BOX_MST]([ITM_CODE] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOX_MST', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'박스상품명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOX_MST', @level2type = N'COLUMN', @level2name = N'BOX_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입수', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOX_MST', @level2type = N'COLUMN', @level2name = N'IPSU_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'관리코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOX_MST', @level2type = N'COLUMN', @level2name = N'ITM_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'박스마스터', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOX_MST';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOX_MST', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'박스관리코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOX_MST', @level2type = N'COLUMN', @level2name = N'BOX_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정사원번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOX_MST', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOX_MST', @level2type = N'COLUMN', @level2name = N'ITM_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록사원번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_BOX_MST', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

