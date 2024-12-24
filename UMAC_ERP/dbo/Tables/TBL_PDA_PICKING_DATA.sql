CREATE TABLE [dbo].[TBL_PDA_PICKING_DATA] (
    [SEQ]     INT             NOT NULL,
    [DATA]    NVARCHAR (4000) NOT NULL,
    [IEMP_ID] NVARCHAR (20)   NOT NULL,
    [IDATE]   DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([SEQ] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'순번', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_PDA_PICKING_DATA', @level2type = N'COLUMN', @level2name = N'SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PDA 피킹 로그 데이터', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_PDA_PICKING_DATA';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_PDA_PICKING_DATA', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_PDA_PICKING_DATA', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'데이터', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_PDA_PICKING_DATA', @level2type = N'COLUMN', @level2name = N'DATA';


GO

