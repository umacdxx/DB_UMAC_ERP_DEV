CREATE TABLE [dbo].[IM_ORDER_UPLOAD] (
    [SEQ]           INT             IDENTITY (1, 1) NOT NULL,
    [PO_NO]         NVARCHAR (15)   NOT NULL,
    [DOC_DIV]       NVARCHAR (2)    NULL,
    [DOC_NAME]      NVARCHAR (100)  NULL,
    [REAL_DOC_NAME] NVARCHAR (100)  NULL,
    [REMARKS]       NVARCHAR (2000) NULL,
    [IDATE]         DATETIME        NULL,
    [IEMP_ID]       NVARCHAR (20)   NULL,
    [UDATE]         DATETIME        NULL,
    [UEMP_ID]       NVARCHAR (20)   NULL,
    CONSTRAINT [PK_IM_ORDER_UPLOAD_1] PRIMARY KEY CLUSTERED ([SEQ] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PO번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_UPLOAD', @level2type = N'COLUMN', @level2name = N'PO_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'실제파일명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_UPLOAD', @level2type = N'COLUMN', @level2name = N'REAL_DOC_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_UPLOAD', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_UPLOAD', @level2type = N'COLUMN', @level2name = N'REMARKS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_UPLOAD', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_UPLOAD', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수입발주 파일업로드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_UPLOAD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_UPLOAD', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'파일구분 1: LC 2: BL 3:기타', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_UPLOAD', @level2type = N'COLUMN', @level2name = N'DOC_DIV';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'순번', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_UPLOAD', @level2type = N'COLUMN', @level2name = N'SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'파일명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_UPLOAD', @level2type = N'COLUMN', @level2name = N'DOC_NAME';


GO

