CREATE TABLE [dbo].[TBL_ACCESS_MST] (
    [ACCESS_GB]       NVARCHAR (1)    NOT NULL,
    [ACCESS_ID]       NVARCHAR (20)   NOT NULL,
    [LAST_IP_ADDRESS] INT             NULL,
    [REMARKS]         NVARCHAR (2000) NULL,
    [USE_YN]          NVARCHAR (1)    NULL,
    [IDATE]           DATETIME        NULL,
    [IEMP_ID]         NVARCHAR (20)   NULL,
    [UDATE]           DATETIME        NULL,
    [UEMP_ID]         NVARCHAR (20)   NULL,
    CONSTRAINT [PK_TBL_ACCESS_MST] PRIMARY KEY CLUSTERED ([ACCESS_GB] ASC, [ACCESS_ID] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '접근 아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ACCESS_MST', @level2type = N'COLUMN', @level2name = N'ACCESS_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ACCESS_MST', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ACCESS_MST', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '0:IP, 2:IP 대역, 3:ID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ACCESS_MST', @level2type = N'COLUMN', @level2name = N'ACCESS_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'IP 대역망 마지막 주소', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ACCESS_MST', @level2type = N'COLUMN', @level2name = N'LAST_IP_ADDRESS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '사용여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ACCESS_MST', @level2type = N'COLUMN', @level2name = N'USE_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ACCESS_MST', @level2type = N'COLUMN', @level2name = N'REMARKS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ACCESS_MST', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'IP 접근 마스터', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ACCESS_MST';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_ACCESS_MST', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

