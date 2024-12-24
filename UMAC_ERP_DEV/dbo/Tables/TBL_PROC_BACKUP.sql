CREATE TABLE [dbo].[TBL_PROC_BACKUP] (
    [PROC_NM]   NVARCHAR (150) NOT NULL,
    [PROC_TEXT] NVARCHAR (MAX) NOT NULL,
    [IEMP_NM]   NVARCHAR (25)  NOT NULL,
    [IDATE]     DATETIME       CONSTRAINT [DF_TBL_PROC_BACKUP_IDATE] DEFAULT (getdate()) NOT NULL
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_PROC_BACKUP', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록자 이름', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_PROC_BACKUP', @level2type = N'COLUMN', @level2name = N'IEMP_NM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'프로시저 이름', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_PROC_BACKUP', @level2type = N'COLUMN', @level2name = N'PROC_NM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'프로시저 내용', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_PROC_BACKUP', @level2type = N'COLUMN', @level2name = N'PROC_TEXT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'DX 프로시저 백업관리', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_PROC_BACKUP';


GO

