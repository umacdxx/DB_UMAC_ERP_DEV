CREATE TABLE [dbo].[PO_SCALE_GROUP] (
    [GROUP_NO] INT           NOT NULL,
    [ORD_NO]   NVARCHAR (11) NOT NULL,
    [LAND_GB]  INT           NOT NULL,
    [IDATE]    DATETIME      NULL,
    [IEMP_ID]  NVARCHAR (20) NULL,
    [UDATE]    DATETIME      NULL,
    [UEMP_ID]  NVARCHAR (20) NULL,
    CONSTRAINT [PK_PO_SCALE_GROUP] PRIMARY KEY CLUSTERED ([GROUP_NO] ASC, [ORD_NO] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문/발주/수입번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE_GROUP', @level2type = N'COLUMN', @level2name = N'ORD_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE_GROUP', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'그룹번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE_GROUP', @level2type = N'COLUMN', @level2name = N'GROUP_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE_GROUP', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE_GROUP', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배차그룹', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE_GROUP';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE_GROUP', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'착지구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE_GROUP', @level2type = N'COLUMN', @level2name = N'LAND_GB';


GO

