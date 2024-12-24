CREATE TABLE [dbo].[IM_ORDER_DTL] (
    [PO_NO]         NVARCHAR (15)   NOT NULL,
    [SEQ]           INT             NOT NULL,
    [ITM_CODE]      NVARCHAR (6)    NULL,
    [ORD_QTY]       NUMERIC (7, 2)  NULL,
    [FRGN_WPRC]     NUMERIC (13, 2) NULL,
    [FRGN_WPRC_AMT] NUMERIC (13, 2) NULL,
    [WPRC]          NUMERIC (13)    NULL,
    [WPRC_AMT]      NUMERIC (13)    NULL,
    [TAX_GB]        NVARCHAR (1)    NULL,
    [ORG_CODE]      NVARCHAR (3)    NULL,
    [PUR_WPRC]      NUMERIC (15, 2) NULL,
    [PUR_WAMT]      NUMERIC (15, 2) NULL,
    [IDATE]         DATETIME        NULL,
    [IEMP_ID]       NVARCHAR (20)   NULL,
    [UDATE]         DATETIME        NULL,
    [UEMP_ID]       NVARCHAR (20)   NULL,
    CONSTRAINT [PK_IM_ORDER_DTL] PRIMARY KEY CLUSTERED ([PO_NO] ASC, [SEQ] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PO번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'PO_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입합계금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'PUR_WAMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'원화단가', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'WPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'외화금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'FRGN_WPRC_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입단가(공급가)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'PUR_WPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'원화금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'WPRC_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'순번', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'발주 수/중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'ORD_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'과/면세 구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'TAX_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수입상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'ITM_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수입발주 DTL', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_DTL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'외화단가', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'FRGN_WPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'원산지코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_DTL', @level2type = N'COLUMN', @level2name = N'ORG_CODE';


GO

