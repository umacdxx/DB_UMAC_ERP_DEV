CREATE TABLE [dbo].[PO_PURCHASE_HDR] (
    [ORD_NO]             NVARCHAR (11)   NOT NULL,
    [ORD_DT]             NVARCHAR (8)    NOT NULL,
    [DELIVERY_EXP_DT]    NVARCHAR (8)    NULL,
    [DELIVERY_IN_DT]     NVARCHAR (8)    NULL,
    [ORD_AMT]            NUMERIC (15, 2) NULL,
    [PUR_TOTAL_WPRC]     NUMERIC (15, 2) NULL,
    [PUR_TOTAL_AMT]      NUMERIC (15, 2) NULL,
    [VEN_CODE]           NVARCHAR (7)    NULL,
    [DELIVERY_CODE]      NVARCHAR (7)    NULL,
    [DELIVERY_PRICE_SEQ] INT             NULL,
    [R_POST_NO]          NVARCHAR (5)    NULL,
    [R_ADDR]             NVARCHAR (100)  NULL,
    [R_ADDR_DTL]         NVARCHAR (50)   NULL,
    [PUR_STAT]           NVARCHAR (2)    NULL,
    [PUR_CFM]            NVARCHAR (1)    NULL,
    [PUR_CFM_DT]         NVARCHAR (8)    NULL,
    [TRANS_YN]           NVARCHAR (1)    NULL,
    [REMARKS]            NVARCHAR (2000) NULL,
    [CLOSE_DT]           NVARCHAR (8)    NULL,
    [CLOSE_DT_CHG_YN]    NVARCHAR (1)    CONSTRAINT [DF_PO_PURCHASE_HDR_CLOSE_DT_CHG_YN] DEFAULT (N'N') NULL,
    [CLOSE_REMARKS]      NVARCHAR (2000) NULL,
    [CLOSE_STAT]         NCHAR (1)       CONSTRAINT [DF_PO_PURCHASE_HDR_CLOSE_STAT] DEFAULT (N'N') NULL,
    [CLOSE_EMP_ID]       NVARCHAR (20)   NULL,
    [DOUZONE_FLAG]       NVARCHAR (1)    CONSTRAINT [Def_PO_PURCHASE_HDR_DOUZONE_FLAG] DEFAULT ('N') NULL,
    [IDATE]              DATETIME        NULL,
    [IEMP_ID]            NVARCHAR (20)   NULL,
    [UDATE]              DATETIME        NULL,
    [UEMP_ID]            NVARCHAR (20)   NULL,
    CONSTRAINT [PK_PO_PURCHASE_HDR] PRIMARY KEY CLUSTERED ([ORD_NO] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IDX_WHERE]
    ON [dbo].[PO_PURCHASE_HDR]([ORD_DT] ASC, [VEN_CODE] ASC, [PUR_STAT] ASC);


GO

CREATE NONCLUSTERED INDEX [IDX_VEN_CODE]
    ON [dbo].[PO_PURCHASE_HDR]([VEN_CODE] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '입고일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'DELIVERY_IN_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '주문/발주 합계금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'ORD_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'마감일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'CLOSE_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입단가합계금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'PUR_TOTAL_WPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'마감일변경여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'CLOSE_DT_CHG_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '입고/매입 합계 금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'PUR_TOTAL_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '거래처코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '발주확정일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'PUR_CFM_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '발주등록_HDR', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배차사용여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'TRANS_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '주문/발주/수입번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'ORD_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '주문/발주일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'ORD_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'REMARKS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입고요청일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'DELIVERY_EXP_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배송지주소', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'R_ADDR';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'마감확정자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'CLOSE_EMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배송지상세주소', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'R_ADDR_DTL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'더존연동구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'DOUZONE_FLAG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '발주상태', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'PUR_STAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '발주확정여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'PUR_CFM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'마감비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'CLOSE_REMARKS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배송지코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'DELIVERY_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'운송비마스터SEQ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'DELIVERY_PRICE_SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입/출고 마감확정여부 (Y/N)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'CLOSE_STAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배송지우편번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_PURCHASE_HDR', @level2type = N'COLUMN', @level2name = N'R_POST_NO';


GO

