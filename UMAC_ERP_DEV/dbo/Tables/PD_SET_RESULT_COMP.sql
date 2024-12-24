CREATE TABLE [dbo].[PD_SET_RESULT_COMP] (
    [SET_PLAN_ID]   NVARCHAR (11) NOT NULL,
    [SEQ]           INT           NOT NULL,
    [PROD_DT]       NVARCHAR (8)  NOT NULL,
    [SCAN_CODE]     NVARCHAR (14) NULL,
    [SET_COMP_CD]   NVARCHAR (14) NULL,
    [LOT_NO]        NVARCHAR (30) NULL,
    [RESTORE_YN]    NVARCHAR (2)  NOT NULL,
    [COMP_QTY]      INT           NOT NULL,
    [COMP_CFM_FLAG] NVARCHAR (2)  CONSTRAINT [DF_PD_SET_RESULT_COMP_COMP_CFM_FLAG] DEFAULT (N'N') NULL,
    [IDATE]         DATETIME      NOT NULL,
    [IEMP_ID]       NVARCHAR (20) NOT NULL,
    [UDATE]         DATETIME      NULL,
    [UEMP_ID]       NVARCHAR (20) NULL,
    CONSTRAINT [PK__PD_SET_R__AA716A2469AA2198] PRIMARY KEY CLUSTERED ([SET_PLAN_ID] ASC, [SEQ] ASC),
    CONSTRAINT [CK__PD_SET_RE__RESTO__0307610B] CHECK ([RESTORE_YN]='N' OR [RESTORE_YN]='Y')
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'작업 번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_COMP', @level2type = N'COLUMN', @level2name = N'SET_PLAN_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'제품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_COMP', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_COMP', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '순번', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_COMP', @level2type = N'COLUMN', @level2name = N'SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SET 구성품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_COMP', @level2type = N'COLUMN', @level2name = N'SET_COMP_CD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_COMP', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'구성품 수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_COMP', @level2type = N'COLUMN', @level2name = N'COMP_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_COMP', @level2type = N'COLUMN', @level2name = N'PROD_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_COMP', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'LOT 번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_COMP', @level2type = N'COLUMN', @level2name = N'LOT_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '자재 생산 확정 구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_COMP', @level2type = N'COLUMN', @level2name = N'COMP_CFM_FLAG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_COMP', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'환원 여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_COMP', @level2type = N'COLUMN', @level2name = N'RESTORE_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산 SET 결과 디테일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_COMP';


GO

