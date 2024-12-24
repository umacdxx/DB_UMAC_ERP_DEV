CREATE TABLE [dbo].[PUR_VEN] (
    [PUR_DT]        NVARCHAR (8)    NOT NULL,
    [VEN_CODE]      NVARCHAR (7)    NOT NULL,
    [ORD_CNT]       INT             NULL,
    [PUR_TOTAL_AMT] NUMERIC (15, 2) NULL,
    CONSTRAINT [PK_PUR_VEN] PRIMARY KEY CLUSTERED ([PUR_DT] ASC, [VEN_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입 일자별 거래처 매출', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_VEN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_VEN', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문건수', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_VEN', @level2type = N'COLUMN', @level2name = N'ORD_CNT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_VEN', @level2type = N'COLUMN', @level2name = N'PUR_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입합계금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_VEN', @level2type = N'COLUMN', @level2name = N'PUR_TOTAL_AMT';


GO

