CREATE TABLE [dbo].[CD_DELIVERY_PRICE] (
    [SEQ]           INT           NOT NULL,
    [TRANS_SECTION] NVARCHAR (6)  NOT NULL,
    [TRANS_GB]      NVARCHAR (1)  NOT NULL,
    [TRANS_COST_1]  INT           NULL,
    [RENT_COST_1]   INT           NULL,
    [TRANS_COST_2]  INT           NULL,
    [RENT_COST_2]   INT           NULL,
    [TRANS_COST_3]  INT           NULL,
    [RENT_COST_3]   INT           NULL,
    [TRANS_COST_4]  INT           NULL,
    [RENT_COST_4]   INT           NULL,
    [TRANS_COST_5]  INT           NULL,
    [RENT_COST_5]   INT           NULL,
    [IDATE]         DATETIME      NULL,
    [IEMP_ID]       NVARCHAR (20) NULL,
    [UDATE]         DATETIME      NULL,
    [UEMP_ID]       NVARCHAR (20) NULL,
    CONSTRAINT [PK_CD_DELIVERY_PRICE] PRIMARY KEY CLUSTERED ([SEQ] ASC)
);


GO

CREATE NONCLUSTERED INDEX [Non_TRANS_GB_INDEX]
    ON [dbo].[CD_DELIVERY_PRICE]([TRANS_GB] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_DELIVERY_PRICE', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'14톤운송비', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_DELIVERY_PRICE', @level2type = N'COLUMN', @level2name = N'TRANS_COST_2';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'운송구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_DELIVERY_PRICE', @level2type = N'COLUMN', @level2name = N'TRANS_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'탱크용차비', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_DELIVERY_PRICE', @level2type = N'COLUMN', @level2name = N'RENT_COST_4';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'5톤운송비', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_DELIVERY_PRICE', @level2type = N'COLUMN', @level2name = N'TRANS_COST_1';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'순번', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_DELIVERY_PRICE', @level2type = N'COLUMN', @level2name = N'SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'18톤용차비', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_DELIVERY_PRICE', @level2type = N'COLUMN', @level2name = N'RENT_COST_3';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_DELIVERY_PRICE', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'운송구간', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_DELIVERY_PRICE', @level2type = N'COLUMN', @level2name = N'TRANS_SECTION';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_DELIVERY_PRICE', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'탱크운송비', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_DELIVERY_PRICE', @level2type = N'COLUMN', @level2name = N'TRANS_COST_4';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'벌크운송비', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_DELIVERY_PRICE', @level2type = N'COLUMN', @level2name = N'TRANS_COST_5';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'14톤용차비', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_DELIVERY_PRICE', @level2type = N'COLUMN', @level2name = N'RENT_COST_2';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_DELIVERY_PRICE', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'18톤운송비', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_DELIVERY_PRICE', @level2type = N'COLUMN', @level2name = N'TRANS_COST_3';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'벌크용차비', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_DELIVERY_PRICE', @level2type = N'COLUMN', @level2name = N'RENT_COST_5';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배송지 가격 정보', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_DELIVERY_PRICE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'5톤용차비', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_DELIVERY_PRICE', @level2type = N'COLUMN', @level2name = N'RENT_COST_1';


GO

