CREATE TABLE [dbo].[IV_STOCK_SURVEY] (
    [INV_DT]       NVARCHAR (8)  NOT NULL,
    [ITM_CODE]     NVARCHAR (6)  NOT NULL,
    [SCAN_CODE]    NVARCHAR (14) NOT NULL,
    [SURVEY_ID]    NVARCHAR (8)  NOT NULL,
    [LOT_NO]       NVARCHAR (30) NOT NULL,
    [SURVEY_QTY_1] INT           NULL,
    [SURVEY_QTY_2] INT           NULL,
    [CFM_QTY]      INT           NULL,
    [SURVEY_GB]    NVARCHAR (1)  NOT NULL,
    [INV_FLAG]     NVARCHAR (1)  NOT NULL,
    [IDATE]        DATETIME      CONSTRAINT [DF__IV_STOCK___IDATE__11BF94B6] DEFAULT (getdate()) NOT NULL,
    [IEMP_ID]      NVARCHAR (20) NOT NULL,
    [UDATE]        DATETIME      NULL,
    [UEMP_ID]      NVARCHAR (20) NULL,
    CONSTRAINT [PK_IV_STOCK_SURVEY] PRIMARY KEY CLUSTERED ([INV_DT] ASC, [ITM_CODE] ASC, [SCAN_CODE] ASC, [SURVEY_ID] ASC, [LOT_NO] ASC, [INV_FLAG] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'재고조사 ID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_SURVEY', @level2type = N'COLUMN', @level2name = N'SURVEY_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_SURVEY', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'LOT번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_SURVEY', @level2type = N'COLUMN', @level2name = N'LOT_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_SURVEY', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_SURVEY', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록 구분 1.수기 2. EXCEL 3.PDA', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_SURVEY', @level2type = N'COLUMN', @level2name = N'INV_FLAG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'재고일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_SURVEY', @level2type = N'COLUMN', @level2name = N'INV_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'확정 수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_SURVEY', @level2type = N'COLUMN', @level2name = N'CFM_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'조사방법구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_SURVEY', @level2type = N'COLUMN', @level2name = N'SURVEY_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'관리코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_SURVEY', @level2type = N'COLUMN', @level2name = N'ITM_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'실사 수량 1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_SURVEY', @level2type = N'COLUMN', @level2name = N'SURVEY_QTY_1';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_SURVEY', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'실사재고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_SURVEY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_SURVEY', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'실사 수량 2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IV_STOCK_SURVEY', @level2type = N'COLUMN', @level2name = N'SURVEY_QTY_2';


GO

