CREATE TABLE [dbo].[SL_SALE_VEN] (
    [SALE_DT]        NVARCHAR (8)    NOT NULL,
    [VEN_CODE]       NVARCHAR (7)    NOT NULL,
    [ORD_CNT]        INT             NOT NULL,
    [SALE_TOTAL_AMT] NUMERIC (17, 4) NULL,
    CONSTRAINT [PK_SL_SALE_VEN] PRIMARY KEY CLUSTERED ([SALE_DT] ASC, [VEN_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'판매일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_VEN', @level2type = N'COLUMN', @level2name = N'SALE_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출 일자별 거래처 매출', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_VEN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_VEN', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문건수', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_VEN', @level2type = N'COLUMN', @level2name = N'ORD_CNT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'판매금액(PICKING_AMT 합)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SL_SALE_VEN', @level2type = N'COLUMN', @level2name = N'SALE_TOTAL_AMT';


GO

