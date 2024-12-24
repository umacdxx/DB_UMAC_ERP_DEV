CREATE TABLE [dbo].[TBL_DOUZONE_MGMT_ITEM] (
    [SCAN_CODE]    NVARCHAR (14) NOT NULL,
    [MGMT_ENTRY_1] NVARCHAR (50) NULL,
    [MGMT_ENTRY_2] NVARCHAR (50) NULL,
    [MGMT_ENTRY_3] NVARCHAR (50) NULL,
    CONSTRAINT [PK_TBL_DOUZONE_MGMT_ITEM] PRIMARY KEY CLUSTERED ([SCAN_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '더존 저장품 구분(DOUZONE_D93)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_DOUZONE_MGMT_ITEM', @level2type = N'COLUMN', @level2name = N'MGMT_ENTRY_2';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '더존 제품매출 구분(DOUZONE_D96)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_DOUZONE_MGMT_ITEM', @level2type = N'COLUMN', @level2name = N'MGMT_ENTRY_3';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '더존 원재료 구분(DOUZONE_D95)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_DOUZONE_MGMT_ITEM', @level2type = N'COLUMN', @level2name = N'MGMT_ENTRY_1';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '더존 관리항목 관리', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_DOUZONE_MGMT_ITEM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '스캔코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_DOUZONE_MGMT_ITEM', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

