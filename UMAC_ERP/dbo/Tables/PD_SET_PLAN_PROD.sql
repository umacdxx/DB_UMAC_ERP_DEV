CREATE TABLE [dbo].[PD_SET_PLAN_PROD] (
    [SET_PLAN_ID]     NVARCHAR (11) NOT NULL,
    [SCAN_CODE]       NVARCHAR (14) NOT NULL,
    [PLAN_QTY]        INT           NOT NULL,
    [SET_EXPIRY_DATE] NVARCHAR (8)  NOT NULL,
    [IDATE]           DATETIME      NOT NULL,
    [IEMP_ID]         NVARCHAR (20) NOT NULL,
    [UDATE]           DATETIME      NULL,
    [UEMP_ID]         NVARCHAR (20) NULL,
    CONSTRAINT [PK__PD_SET_P__A1B49D348D83C461] PRIMARY KEY CLUSTERED ([SET_PLAN_ID] ASC, [SCAN_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_PROD', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'계획 수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_PROD', @level2type = N'COLUMN', @level2name = N'PLAN_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산 SET 계획 헤더', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_PROD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_PROD', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'소비기한', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_PROD', @level2type = N'COLUMN', @level2name = N'SET_EXPIRY_DATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'작업 번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_PROD', @level2type = N'COLUMN', @level2name = N'SET_PLAN_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_PROD', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_PROD', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_PROD', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

