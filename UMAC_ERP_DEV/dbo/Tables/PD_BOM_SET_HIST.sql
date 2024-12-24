CREATE TABLE [dbo].[PD_BOM_SET_HIST] (
    [PROD_DT]         NVARCHAR (8)    NOT NULL,
    [PROD_GB]         NVARCHAR (1)    NOT NULL,
    [BOM_SET_CD]      NVARCHAR (3)    NOT NULL,
    [LOT_NO]          NVARCHAR (30)   NOT NULL,
    [BOM_SET_COMP_CD] NVARCHAR (14)   NOT NULL,
    [COMP_QTY]        NUMERIC (15, 2) NOT NULL,
    [COMP_APP_QTY]    NUMERIC (15, 2) CONSTRAINT [DF_PD_BOM_SET_HIST_COMP_APP_QTY] DEFAULT ((0)) NULL,
    [CFM_FLAG]        NVARCHAR (2)    CONSTRAINT [DF_PD_BOM_SET_HIST_CFM_FLAG] DEFAULT ('N') NULL,
    [IDATE]           DATETIME        NULL,
    [IEMP_ID]         NVARCHAR (20)   NULL,
    [UDATE]           DATETIME        NULL,
    [UEMP_ID]         NVARCHAR (20)   NULL,
    CONSTRAINT [PK__PD_BOM_S__977C56CCE43D68EB] PRIMARY KEY CLUSTERED ([PROD_DT] ASC, [PROD_GB] ASC, [BOM_SET_CD] ASC, [LOT_NO] ASC, [BOM_SET_COMP_CD] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'BOM/SET 코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_BOM_SET_HIST', @level2type = N'COLUMN', @level2name = N'BOM_SET_CD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_BOM_SET_HIST', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산구분(B:BOM, S:SET)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_BOM_SET_HIST', @level2type = N'COLUMN', @level2name = N'PROD_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_BOM_SET_HIST', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'BOM/SET 구성품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_BOM_SET_HIST', @level2type = N'COLUMN', @level2name = N'BOM_SET_COMP_CD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'LOT 번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_BOM_SET_HIST', @level2type = N'COLUMN', @level2name = N'LOT_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_BOM_SET_HIST', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'BOM 확정 수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_BOM_SET_HIST', @level2type = N'COLUMN', @level2name = N'COMP_APP_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'구성품 수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_BOM_SET_HIST', @level2type = N'COLUMN', @level2name = N'COMP_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_BOM_SET_HIST', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'생산일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_BOM_SET_HIST', @level2type = N'COLUMN', @level2name = N'PROD_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'BOM/SET 사용내역', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_BOM_SET_HIST';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'확정구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PD_BOM_SET_HIST', @level2type = N'COLUMN', @level2name = N'CFM_FLAG';


GO

