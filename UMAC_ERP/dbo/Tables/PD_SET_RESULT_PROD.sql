CREATE TABLE [dbo].[PD_SET_RESULT_PROD] (
    [SET_PLAN_ID]   NVARCHAR (11) NOT NULL,
    [PROD_DT]       NVARCHAR (8)  NOT NULL,
    [SCAN_CODE]     NVARCHAR (14) NOT NULL,
    [PROD_QTY]      INT           NOT NULL,
    [PROD_CFM_FLAG] NVARCHAR (2)  CONSTRAINT [DF_PD_SET_RESULT_PROD_PROD_CFM_FLAG] DEFAULT (N'N') NOT NULL,
    [IDATE]         DATETIME      NOT NULL,
    [IEMP_ID]       NVARCHAR (20) NOT NULL,
    [UDATE]         DATETIME      NULL,
    [UEMP_ID]       NVARCHAR (20) NULL,
    CONSTRAINT [PK__PD_SET_R__4809F8CA4CFDB044] PRIMARY KEY CLUSTERED ([SET_PLAN_ID] ASC, [PROD_DT] ASC, [SCAN_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_PROD', @level2type = N'COLUMN', @level2name = N'PROD_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_PROD', @level2type = N'COLUMN', @level2name = N'PROD_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산 SET 결과 헤더', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_PROD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_PROD', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_PROD', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_PROD', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SET생산 확정구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_PROD', @level2type = N'COLUMN', @level2name = N'PROD_CFM_FLAG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_PROD', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_PROD', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'작업 번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_RESULT_PROD', @level2type = N'COLUMN', @level2name = N'SET_PLAN_ID';


GO

