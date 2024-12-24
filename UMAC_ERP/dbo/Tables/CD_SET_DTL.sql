CREATE TABLE [dbo].[CD_SET_DTL] (
    [SET_CD]      NVARCHAR (3)    NOT NULL,
    [SET_COMP_CD] NVARCHAR (14)   NOT NULL,
    [SET_COMP_NM] NVARCHAR (100)  NULL,
    [COMP_QTY]    NUMERIC (15, 2) NULL,
    [IDATE]       DATETIME        NULL,
    [IEMP_ID]     NVARCHAR (20)   NULL,
    [UDATE]       DATETIME        NULL,
    [UEMP_ID]     NVARCHAR (20)   NULL,
    CONSTRAINT [PK_CD_SET_DTL] PRIMARY KEY CLUSTERED ([SET_CD] ASC, [SET_COMP_CD] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SET 구성품 상품명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_SET_DTL', @level2type = N'COLUMN', @level2name = N'SET_COMP_NM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'구성품 수/중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_SET_DTL', @level2type = N'COLUMN', @level2name = N'COMP_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SET 코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_SET_DTL', @level2type = N'COLUMN', @level2name = N'SET_CD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SET 마스터 DTL', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_SET_DTL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SET 구성품 코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_SET_DTL', @level2type = N'COLUMN', @level2name = N'SET_COMP_CD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_SET_DTL', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_SET_DTL', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_SET_DTL', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_SET_DTL', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

