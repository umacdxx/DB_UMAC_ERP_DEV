CREATE TABLE [dbo].[IM_COST_HDR] (
    [PO_NO]       NVARCHAR (15) NOT NULL,
    [VEN_CODE]    NVARCHAR (7)  NULL,
    [PO_ORD_DT]   NVARCHAR (8)  NULL,
    [COST_CFM]    NVARCHAR (1)  NULL,
    [ALTRN_SLIP]  NVARCHAR (1)  NULL,
    [COST_CFM_DT] NVARCHAR (8)  NULL,
    [IDATE]       DATETIME      NULL,
    [IEMP_ID]     NVARCHAR (20) NULL,
    [UDATE]       DATETIME      NULL,
    [UEMP_ID]     NVARCHAR (20) NULL,
    CONSTRAINT [PK_IM_COST_HDR] PRIMARY KEY CLUSTERED ([PO_NO] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_HDR', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_HDR', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_HDR', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_HDR', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'제비용확정여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_HDR', @level2type = N'COLUMN', @level2name = N'COST_CFM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'발주일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_HDR', @level2type = N'COLUMN', @level2name = N'PO_ORD_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_HDR', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'제비용확정일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_HDR', @level2type = N'COLUMN', @level2name = N'COST_CFM_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'대체전표상태', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_HDR', @level2type = N'COLUMN', @level2name = N'ALTRN_SLIP';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수입제비용 HDR', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_HDR';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PO번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_HDR', @level2type = N'COLUMN', @level2name = N'PO_NO';


GO

