CREATE TABLE [dbo].[PD_SET_PLAN_MST] (
    [SET_PLAN_ID]    NVARCHAR (11)  NOT NULL,
    [SET_PLAN_NM]    NVARCHAR (100) NOT NULL,
    [SET_PLAN_SDATE] NVARCHAR (8)   NOT NULL,
    [SET_PLAN_EDATE] NVARCHAR (8)   NOT NULL,
    [SET_STATUS]     NVARCHAR (2)   NOT NULL,
    [IDATE]          DATETIME       NOT NULL,
    [IEMP_ID]        NVARCHAR (20)  NOT NULL,
    [UDATE]          DATETIME       NULL,
    [UEMP_ID]        NVARCHAR (20)  NULL,
    CONSTRAINT [PK__PD_SET_P__6FDD1DB0E6D0CE0B] PRIMARY KEY CLUSTERED ([SET_PLAN_ID] ASC),
    CONSTRAINT [CK__PD_SET_PL__SET_S__08F5448B] CHECK ([SET_STATUS]='3' OR [SET_STATUS]='2' OR [SET_STATUS]='1' OR [SET_STATUS]='0')
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'작업 번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_MST', @level2type = N'COLUMN', @level2name = N'SET_PLAN_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'작업 명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_MST', @level2type = N'COLUMN', @level2name = N'SET_PLAN_NM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_MST', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'작업 상태', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_MST', @level2type = N'COLUMN', @level2name = N'SET_STATUS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산 SET 계획 마스터', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_MST';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_MST', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'작업 예정 시작일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_MST', @level2type = N'COLUMN', @level2name = N'SET_PLAN_SDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_MST', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_MST', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'작업 예정 종료일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_MST', @level2type = N'COLUMN', @level2name = N'SET_PLAN_EDATE';


GO

