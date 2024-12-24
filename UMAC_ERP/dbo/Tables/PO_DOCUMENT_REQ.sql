CREATE TABLE [dbo].[PO_DOCUMENT_REQ] (
    [SEQ]           INT             IDENTITY (1, 1) NOT NULL,
    [ORD_NO]        NVARCHAR (11)   NULL,
    [DOC_NAME]      NVARCHAR (100)  NULL,
    [REAL_DOC_NAME] NVARCHAR (100)  NULL,
    [REMARKS]       NVARCHAR (2000) NULL,
    [IDATE]         DATETIME        NULL,
    [IEMP_ID]       NVARCHAR (20)   NULL,
    [UDATE]         DATETIME        NULL,
    [UEMP_ID]       NVARCHAR (20)   NULL,
    CONSTRAINT [PK_PO_DOCUMENT_REQ] PRIMARY KEY CLUSTERED ([SEQ] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_DOCUMENT_REQ', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'순번', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_DOCUMENT_REQ', @level2type = N'COLUMN', @level2name = N'SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_DOCUMENT_REQ', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_DOCUMENT_REQ', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'첨부서류명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_DOCUMENT_REQ', @level2type = N'COLUMN', @level2name = N'DOC_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'첨부서류관리', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_DOCUMENT_REQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_DOCUMENT_REQ', @level2type = N'COLUMN', @level2name = N'REMARKS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'경로', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_DOCUMENT_REQ', @level2type = N'COLUMN', @level2name = N'REAL_DOC_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_DOCUMENT_REQ', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_DOCUMENT_REQ', @level2type = N'COLUMN', @level2name = N'ORD_NO';


GO

