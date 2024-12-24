CREATE TABLE [dbo].[IM_ORDER_HDR] (
    [PO_NO]              NVARCHAR (15)   NOT NULL,
    [PO_NAME]            NVARCHAR (100)  NULL,
    [PO_ORD_DT]          NVARCHAR (8)    NULL,
    [VEN_CODE]           NVARCHAR (7)    NULL,
    [INCOTERMS]          NVARCHAR (3)    NULL,
    [LC_NO]              NVARCHAR (20)   NULL,
    [LC_GB]              NVARCHAR (2)    NULL,
    [LC_OPEN_DT]         NVARCHAR (8)    NULL,
    [LC_CLOSE_DT]        NVARCHAR (8)    NULL,
    [OPEN_BANK]          NVARCHAR (2)    NULL,
    [DEPARTURE_COUNTRY]  NVARCHAR (50)   NULL,
    [DEPARTURE_PORT]     NVARCHAR (50)   NULL,
    [ARRIVAL_COUNTRY]    NVARCHAR (50)   NULL,
    [ARRIVAL_PORT]       NVARCHAR (50)   NULL,
    [BL_NO]              NVARCHAR (20)   NULL,
    [BL_NO_2]            NVARCHAR (20)   NULL,
    [BL_NO_3]            NVARCHAR (20)   NULL,
    [BL_DT]              NVARCHAR (8)    NULL,
    [BL_DT_2]            NVARCHAR (8)    NULL,
    [BL_DT_3]            NVARCHAR (8)    NULL,
    [INVOICE_AMT]        NUMERIC (13, 2) NULL,
    [INVOICE_AMT_2]      NUMERIC (13, 2) NULL,
    [INVOICE_AMT_3]      NUMERIC (13, 2) NULL,
    [CURRENCY_TYPE]      NVARCHAR (3)    NULL,
    [LC_EXCHANGE_RATE]   NUMERIC (6, 2)  NULL,
    [TT_EXCHANGE_RATE]   NUMERIC (6, 2)  NULL,
    [LC_AMT]             NUMERIC (13, 2) NULL,
    [TT_AMT]             NUMERIC (13, 2) NULL,
    [CUSTOMS_CL_DT]      NVARCHAR (8)    NULL,
    [NOT_DELIVERED_SLIP] NVARCHAR (1)    NULL,
    [PUR_SLIP]           NVARCHAR (1)    NULL,
    [PUR_SLIP_NO]        NVARCHAR (15)   NULL,
    [PUR_SLIP_DT]        NVARCHAR (8)    NULL,
    [IDATE]              DATETIME        NULL,
    [IEMP_ID]            NVARCHAR (20)   NULL,
    [UDATE]              DATETIME        NULL,
    [UEMP_ID]            NVARCHAR (20)   NULL,
    CONSTRAINT [PK_IM_ORDER_HDR] PRIMARY KEY CLUSTERED ([PO_NO] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'인도조건', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'INCOTERMS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'BL번호2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'BL_NO_2';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'출발지국가', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'DEPARTURE_COUNTRY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'개설은행', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'OPEN_BANK';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'BL번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'BL_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'환종', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'CURRENCY_TYPE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'TT 결제금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'TT_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'선적일3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'BL_DT_3';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입전표번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'PUR_SLIP_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PO번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'PO_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'BL번호3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'BL_NO_3';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'출발지항구', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'DEPARTURE_PORT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'LC 환율', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'LC_EXCHANGE_RATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'통관일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'CUSTOMS_CL_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수입발주 HDR', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'송장금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'INVOICE_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입전표생성일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'PUR_SLIP_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'LC번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'LC_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'개설일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'LC_OPEN_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'선적일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'BL_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PO명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'PO_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'도착지국가', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'ARRIVAL_COUNTRY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'송장금액2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'INVOICE_AMT_2';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'TT 환율', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'TT_EXCHANGE_RATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'LC_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'미착품전표생성여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'NOT_DELIVERED_SLIP';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'선적일2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'BL_DT_2';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'송장금액3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'INVOICE_AMT_3';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'LC 결제금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'LC_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'만료일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'LC_CLOSE_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입전표생성여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'PUR_SLIP';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'도착지항구', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'ARRIVAL_PORT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'발주일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'IM_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'PO_ORD_DT';


GO

