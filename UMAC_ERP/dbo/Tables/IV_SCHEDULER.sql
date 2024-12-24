CREATE TABLE [dbo].[IV_SCHEDULER] (
    [INV_DT]     NVARCHAR (8)  NOT NULL,
    [SURVEY_ID]  NVARCHAR (8)  NOT NULL,
    [SURVEY_GB]  NVARCHAR (1)  NOT NULL,
    [CFM_FLAG]   NVARCHAR (2)  NULL,
    [CFM_DT]     NVARCHAR (8)  NULL,
    [CFM_EMP_ID] NVARCHAR (20) NULL,
    [IDATE]      DATETIME      NOT NULL,
    [IEMP_ID]    NVARCHAR (20) NOT NULL,
    [UDATE]      DATETIME      NULL,
    [UEMP_ID]    NVARCHAR (20) NULL,
    CONSTRAINT [PK_IV_SCHEDULER] PRIMARY KEY CLUSTERED ([SURVEY_ID] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_SCHEDULER', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'조사방법구분  1:전수, 2:수기', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_SCHEDULER', @level2type = N'COLUMN', @level2name = N'SURVEY_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'재고조사 ID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_SCHEDULER', @level2type = N'COLUMN', @level2name = N'SURVEY_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_SCHEDULER', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'확정자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_SCHEDULER', @level2type = N'COLUMN', @level2name = N'CFM_EMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_SCHEDULER', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'재고일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_SCHEDULER', @level2type = N'COLUMN', @level2name = N'INV_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'확정일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_SCHEDULER', @level2type = N'COLUMN', @level2name = N'CFM_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'재고조사일정관리', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_SCHEDULER';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_SCHEDULER', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'확정구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_SCHEDULER', @level2type = N'COLUMN', @level2name = N'CFM_FLAG';


GO

