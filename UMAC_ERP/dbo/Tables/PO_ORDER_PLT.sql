CREATE TABLE [dbo].[PO_ORDER_PLT] (
    [ORD_NO]        NVARCHAR (11) NOT NULL,
    [PLT_KPP_QTY11] INT           NULL,
    [PLT_KPP_QTY12] INT           NULL,
    [PLT_AJ_QTY11]  INT           NULL,
    [PLT_AJ_QTY12]  INT           NULL,
    CONSTRAINT [PK_PO_ORDER_PLT] PRIMARY KEY CLUSTERED ([ORD_NO] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'AJ 12형 수', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_PLT', @level2type = N'COLUMN', @level2name = N'PLT_AJ_QTY12';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문등록 PLT 수량 정보', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_PLT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_PLT', @level2type = N'COLUMN', @level2name = N'ORD_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'KPP 11형 수', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_PLT', @level2type = N'COLUMN', @level2name = N'PLT_KPP_QTY11';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'KPP 12형 수', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_PLT', @level2type = N'COLUMN', @level2name = N'PLT_KPP_QTY12';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'AJ 11형 수', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_PLT', @level2type = N'COLUMN', @level2name = N'PLT_AJ_QTY11';


GO

