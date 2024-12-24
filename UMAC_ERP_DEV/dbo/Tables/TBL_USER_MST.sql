CREATE TABLE [dbo].[TBL_USER_MST] (
    [USER_ID]   NVARCHAR (20)   NOT NULL,
    [PASSWD_NO] BINARY (20)     NOT NULL,
    [USER_NM]   NVARCHAR (20)   NOT NULL,
    [ROLE_ID]   NVARCHAR (6)    NOT NULL,
    [DEPT_CODE] NVARCHAR (25)   NOT NULL,
    [POSITION]  NVARCHAR (3)    NOT NULL,
    [PWD_COUNT] INT             CONSTRAINT [DF_PWD_COUNT] DEFAULT ((0)) NULL,
    [JOB_FLAG]  NVARCHAR (2)    NOT NULL,
    [MOBIL_NO]  VARBINARY (256) NULL,
    [IDATE]     DATE            NULL,
    [IEMP_ID]   NVARCHAR (20)   NULL,
    [UDATE]     DATE            NULL,
    [UEMP_ID]   NVARCHAR (20)   NULL,
    CONSTRAINT [PK_TBL_USER_MST] PRIMARY KEY CLUSTERED ([USER_ID] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_MST', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'직급', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_MST', @level2type = N'COLUMN', @level2name = N'POSITION';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'재직구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_MST', @level2type = N'COLUMN', @level2name = N'JOB_FLAG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'패스워드_번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_MST', @level2type = N'COLUMN', @level2name = N'PASSWD_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'권한그룹', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_MST', @level2type = N'COLUMN', @level2name = N'ROLE_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_MST', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'사용자마스터', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_MST';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'휴대폰번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_MST', @level2type = N'COLUMN', @level2name = N'MOBIL_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록사원번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_MST', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'조직코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_MST', @level2type = N'COLUMN', @level2name = N'DEPT_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'오류횟수', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_MST', @level2type = N'COLUMN', @level2name = N'PWD_COUNT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'담당자이름', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_MST', @level2type = N'COLUMN', @level2name = N'USER_NM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정사원번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_MST', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'사용자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_USER_MST', @level2type = N'COLUMN', @level2name = N'USER_ID';


GO

