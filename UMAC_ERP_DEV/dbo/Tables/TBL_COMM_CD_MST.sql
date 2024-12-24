CREATE TABLE [dbo].[TBL_COMM_CD_MST] (
    [CD_CL]                    NVARCHAR (30)   NOT NULL,
    [CD_ID]                    NVARCHAR (30)   NOT NULL,
    [CD_NM]                    NVARCHAR (100)  NULL,
    [CD_SHORT_NM]              NVARCHAR (20)   NULL,
    [CD_DESCRIPTION]           NVARCHAR (2000) NULL,
    [SORT_ORDER]               INT             NOT NULL,
    [MGMT_ENTRY_1]             NVARCHAR (50)   NULL,
    [MGMT_ENTRY_DESCRIPTION_1] NVARCHAR (2000) NULL,
    [MGMT_ENTRY_2]             NVARCHAR (50)   NULL,
    [MGMT_ENTRY_DESCRIPTION_2] NVARCHAR (2000) NULL,
    [MGMT_ENTRY_3]             NVARCHAR (50)   NULL,
    [MGMT_ENTRY_DESCRIPTION_3] NVARCHAR (2000) NULL,
    [DEL_YN]                   CHAR (1)        NULL,
    [IDATE]                    DATETIME        NULL,
    [IEMP_IP]                  NVARCHAR (50)   NULL,
    [IEMP_ID]                  NVARCHAR (20)   NULL,
    [UDATE]                    DATETIME        NULL,
    [UEMP_IP]                  NVARCHAR (50)   NULL,
    [UEMP_ID]                  NVARCHAR (20)   NULL,
    CONSTRAINT [PK_TBL_COMM_CD_MST] PRIMARY KEY CLUSTERED ([CD_CL] ASC, [CD_ID] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'관리_항목_설명_2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'MGMT_ENTRY_DESCRIPTION_2';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'관리_항목_2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'MGMT_ENTRY_2';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'관리_항목_설명_1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'MGMT_ENTRY_DESCRIPTION_1';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'코드_분류', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'CD_CL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록_IP', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'IEMP_IP';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'공통코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록_일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'관리_항목_설명_3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'MGMT_ENTRY_DESCRIPTION_3';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'삭제_여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'DEL_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'관리_항목_3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'MGMT_ENTRY_3';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정_ID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'코드_명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'CD_NM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'코드_ID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'CD_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정_IP', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'UEMP_IP';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록_ID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정_일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'관리_항목_1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'MGMT_ENTRY_1';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'정렬_순서', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'SORT_ORDER';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'코드_설명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'CD_DESCRIPTION';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'코드_단축_명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_COMM_CD_MST', @level2type = N'COLUMN', @level2name = N'CD_SHORT_NM';


GO

