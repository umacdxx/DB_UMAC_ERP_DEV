CREATE TABLE [dbo].[IM_COST_DTL] (
    [PO_NO]         NVARCHAR (15)  NOT NULL,
    [SEQ]           INT            NOT NULL,
    [COST_DT]       NVARCHAR (8)   NULL,
    [COST_VEN_CODE] NVARCHAR (20)  NULL,
    [COST_ITM_CODE] NVARCHAR (3)   NULL,
    [COST_NAME]     NVARCHAR (100) NULL,
    [COST_WPRC]     NUMERIC (13)   NULL,
    [COST_WVAT]     NUMERIC (13)   NULL,
    [COST_AMOUNT]   NUMERIC (13)   NULL,
    [COST_SLIP]     NVARCHAR (1)   NULL,
    [COST_SLIP_DT]  NVARCHAR (8)   NULL,
    [NOTE]          NVARCHAR (100) NULL,
    [BL_NO]         NVARCHAR (20)  NULL,
    CONSTRAINT [PK_IM_COST_DTL] PRIMARY KEY CLUSTERED ([PO_NO] ASC, [SEQ] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'제비용거래처', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_DTL', @level2type = N'COLUMN', @level2name = N'COST_VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'제비용이름', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_DTL', @level2type = N'COLUMN', @level2name = N'COST_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'제비용항목코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_DTL', @level2type = N'COLUMN', @level2name = N'COST_ITM_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PO번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_DTL', @level2type = N'COLUMN', @level2name = N'PO_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수입제비용 DTL', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_DTL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'제비용발생일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_DTL', @level2type = N'COLUMN', @level2name = N'COST_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'순번', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_DTL', @level2type = N'COLUMN', @level2name = N'SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'제비용합계금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_DTL', @level2type = N'COLUMN', @level2name = N'COST_AMOUNT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'전표생성', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_DTL', @level2type = N'COLUMN', @level2name = N'COST_SLIP';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'비용 공급가', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_DTL', @level2type = N'COLUMN', @level2name = N'COST_WPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'부가세', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_DTL', @level2type = N'COLUMN', @level2name = N'COST_WVAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'BL번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_DTL', @level2type = N'COLUMN', @level2name = N'BL_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'전표생성일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_DTL', @level2type = N'COLUMN', @level2name = N'COST_SLIP_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'적요', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_COST_DTL', @level2type = N'COLUMN', @level2name = N'NOTE';


GO

