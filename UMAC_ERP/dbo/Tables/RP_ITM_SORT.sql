CREATE TABLE [dbo].[RP_ITM_SORT] (
    [PARTNER_GB]   NVARCHAR (2)  NOT NULL,
    [ITM_CATEGORY] NVARCHAR (2)  NOT NULL,
    [SCAN_CODE]    NVARCHAR (14) NOT NULL,
    [START_DATE]   NVARCHAR (8)  NOT NULL,
    [END_DATE]     NVARCHAR (8)  NULL,
    [SORT_ORDER]   INT           NULL,
    [IDATE]        DATETIME      DEFAULT (getdate()) NOT NULL,
    [IEMP_ID]      NVARCHAR (20) NOT NULL,
    [UDATE]        DATETIME      NULL,
    [UEMP_ID]      NVARCHAR (20) NULL,
    CONSTRAINT [PK_RP_ITM_SORT] PRIMARY KEY CLUSTERED ([PARTNER_GB] ASC, [ITM_CATEGORY] ASC, [SCAN_CODE] ASC, [START_DATE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'제품 카테고리', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ITM_SORT', @level2type = N'COLUMN', @level2name = N'ITM_CATEGORY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ITM_SORT', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'종료일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ITM_SORT', @level2type = N'COLUMN', @level2name = N'END_DATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'정렬_순서', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ITM_SORT', @level2type = N'COLUMN', @level2name = N'SORT_ORDER';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ITM_SORT', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'일보 소팅', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ITM_SORT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ITM_SORT', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ITM_SORT', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ITM_SORT', @level2type = N'COLUMN', @level2name = N'PARTNER_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ITM_SORT', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'시작일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RP_ITM_SORT', @level2type = N'COLUMN', @level2name = N'START_DATE';


GO

