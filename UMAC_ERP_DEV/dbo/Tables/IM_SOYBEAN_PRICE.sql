CREATE TABLE [dbo].[IM_SOYBEAN_PRICE] (
    [PRICE_DATE]        NVARCHAR (8)    NOT NULL,
    [PRICE_MONTH_1]     NVARCHAR (3)    NULL,
    [PRICE_MONTH_2]     NVARCHAR (3)    NULL,
    [PRICE_MONTH_3]     NVARCHAR (3)    NULL,
    [PRICE_1]           NUMERIC (15, 2) NULL,
    [PRICE_2]           NUMERIC (15, 2) NULL,
    [PRICE_3]           NUMERIC (15, 2) NULL,
    [NEAR_MTH_NORTH]    INT             NULL,
    [NEAR_MTH_SOUTH]    INT             NULL,
    [CURRENT_MTH_NORTH] INT             NULL,
    [CURRENT_MTH_SOUTH] INT             NULL,
    [NEAR_MTH_BASIS]    NUMERIC (15, 1) NULL,
    [CURRENT_MTH_BASIS] NUMERIC (15, 1) NULL,
    [NEAR_SELECT]       INT             NULL,
    [CURRENT_SELECT]    INT             NULL,
    [REMARKS]           NVARCHAR (2000) NULL,
    [IDATE]             DATETIME        NULL,
    [IEMP_ID]           NVARCHAR (20)   NULL,
    [UDATE]             DATETIME        NULL,
    [UEMP_ID]           NVARCHAR (20)   NULL
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '원월물 선택', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'CURRENT_SELECT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '근월물 basis', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'NEAR_MTH_BASIS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '대두유 국제시세', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '근원물_남미', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'NEAR_MTH_SOUTH';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '원월물 basis', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'CURRENT_MTH_BASIS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '원월물_북미', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'CURRENT_MTH_NORTH';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '선적월_3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'PRICE_MONTH_3';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '가격일자(시세일자)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'PRICE_DATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '가격_3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'PRICE_3';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '가격_1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'PRICE_1';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '선적월_1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'PRICE_MONTH_1';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '근원물_북미', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'NEAR_MTH_NORTH';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'REMARKS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '선적월_2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'PRICE_MONTH_2';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '가격_2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'PRICE_2';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '근월물 선택', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'NEAR_SELECT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '원월물_남미', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_SOYBEAN_PRICE', @level2type = N'COLUMN', @level2name = N'CURRENT_MTH_SOUTH';


GO

