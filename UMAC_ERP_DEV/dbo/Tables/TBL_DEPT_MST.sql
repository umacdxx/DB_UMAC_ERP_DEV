CREATE TABLE [dbo].[TBL_DEPT_MST] (
    [DEPT_CODE]       NVARCHAR (25) NOT NULL,
    [DEPT_NAME]       NVARCHAR (20) NOT NULL,
    [UPPER_DEPT]      NVARCHAR (25) NULL,
    [GRADE]           NVARCHAR (1)  NOT NULL,
    [SORT_ORDER]      INT           NOT NULL,
    [DOUZONE_DEPT_CD] NVARCHAR (10) NULL,
    [USE_YN]          NVARCHAR (1)  NOT NULL,
    [IDATE]           DATETIME      NULL,
    [IEMP_ID]         NVARCHAR (20) NULL,
    [UDATE]           DATETIME      NULL,
    [UEMP_ID]         NVARCHAR (20) NULL,
    CONSTRAINT [PK_TBL_DEPT_MST] PRIMARY KEY CLUSTERED ([DEPT_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'조직명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_DEPT_MST', @level2type = N'COLUMN', @level2name = N'DEPT_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'조직코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_DEPT_MST', @level2type = N'COLUMN', @level2name = N'DEPT_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'레벨', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_DEPT_MST', @level2type = N'COLUMN', @level2name = N'GRADE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상위코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_DEPT_MST', @level2type = N'COLUMN', @level2name = N'UPPER_DEPT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'조직마스터', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_DEPT_MST';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정사원번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_DEPT_MST', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'더존부서코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_DEPT_MST', @level2type = N'COLUMN', @level2name = N'DOUZONE_DEPT_CD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'정렬순서', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_DEPT_MST', @level2type = N'COLUMN', @level2name = N'SORT_ORDER';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_DEPT_MST', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'사용여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_DEPT_MST', @level2type = N'COLUMN', @level2name = N'USE_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_DEPT_MST', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록사원번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_DEPT_MST', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

