CREATE TABLE [dbo].[PD_SET_PLAN_COMP] (
    [SET_PLAN_ID] NVARCHAR (11) NOT NULL,
    [SCAN_CODE]   NVARCHAR (14) NOT NULL,
    [SET_CD]      NVARCHAR (3)  NOT NULL,
    [SET_COMP_CD] NVARCHAR (14) NOT NULL,
    [PLAN_QTY]    INT           NOT NULL,
    [IDATE]       DATETIME      NOT NULL,
    [IEMP_ID]     NVARCHAR (20) NOT NULL,
    [UDATE]       DATETIME      NULL,
    [UEMP_ID]     NVARCHAR (20) NULL,
    CONSTRAINT [PK__PD_SET_P__B8200764105CD24E] PRIMARY KEY CLUSTERED ([SET_PLAN_ID] ASC, [SCAN_CODE] ASC, [SET_CD] ASC, [SET_COMP_CD] ASC),
    CONSTRAINT [CK__PD_SET_PL__SET_C__0DB9F9A8] CHECK ([SET_CD]>='001' AND [SET_CD]<='999')
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'계획 수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_COMP', @level2type = N'COLUMN', @level2name = N'PLAN_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_COMP', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'작업 번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_COMP', @level2type = N'COLUMN', @level2name = N'SET_PLAN_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_COMP', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_COMP', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SET 코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_COMP', @level2type = N'COLUMN', @level2name = N'SET_CD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_COMP', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SET 구성품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_COMP', @level2type = N'COLUMN', @level2name = N'SET_COMP_CD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_COMP', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산 SET 계획 디테일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_SET_PLAN_COMP';


GO

