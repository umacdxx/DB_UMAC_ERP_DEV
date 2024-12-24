CREATE TABLE [dbo].[PO_ORDER_HDR] (
    [ORD_NO]             NVARCHAR (11)   NOT NULL,
    [ORD_NO_PARENT]      NVARCHAR (11)   NOT NULL,
    [ORD_DT]             NVARCHAR (8)    NOT NULL,
    [ORD_GB]             INT             CONSTRAINT [DF_PO_ORDER_HDR_ORD_GB] DEFAULT ((1)) NULL,
    [ORD_AMT]            NUMERIC (17, 4) NULL,
    [PICKING_TOTAL_SPRC] NUMERIC (17, 4) NULL,
    [PICKING_TOTAL_AMT]  NUMERIC (17, 4) NULL,
    [VEN_CODE]           NVARCHAR (7)    NOT NULL,
    [DELIVERY_REQ_DT]    NVARCHAR (8)    NULL,
    [DELIVERY_DEC_DT]    NVARCHAR (8)    NULL,
    [ARRIVAL_REQ_DT]     NVARCHAR (8)    NULL,
    [ARRIVAL_DEC_DT]     NVARCHAR (8)    NULL,
    [DELIVERY_CODE]      NVARCHAR (7)    NULL,
    [DELIVERY_PRICE_SEQ] INT             NULL,
    [R_POST_NO]          NVARCHAR (5)    NULL,
    [R_ADDR]             NVARCHAR (100)  NULL,
    [R_ADDR_DTL]         NVARCHAR (50)   NULL,
    [DOCUMENT_REQ_1]     NVARCHAR (2)    NULL,
    [DOCUMENT_REQ_2]     NVARCHAR (2)    NULL,
    [DOCUMENT_REQ_3]     NVARCHAR (2)    NULL,
    [DOCUMENT_REQ_4]     NVARCHAR (2)    NULL,
    [DOCUMENT_REMARKS]   NVARCHAR (100)  NULL,
    [ORD_STAT]           NVARCHAR (2)    NULL,
    [ORD_CFM]            NVARCHAR (1)    NULL,
    [ORD_CFM_DT]         NVARCHAR (8)    NULL,
    [TRANS_YN]           NVARCHAR (1)    NULL,
    [REMARKS]            NVARCHAR (2000) NULL,
    [CLOSE_NO]           NVARCHAR (11)   NULL,
    [CLOSE_DT]           NVARCHAR (8)    NULL,
    [ISSUE_GB]           NVARCHAR (1)    NULL,
    [CLOSE_REMARKS]      NVARCHAR (2000) NULL,
    [CLOSE_STAT]         NCHAR (1)       CONSTRAINT [DF_PO_ORDER_HDR_CLOSE_STAT] DEFAULT (N'N') NULL,
    [CLOSE_EMP_ID]       NVARCHAR (20)   NULL,
    [DOUZONE_FLAG]       NVARCHAR (1)    CONSTRAINT [Def_PO_ORDER_HDR_DOUZONE_FLAG] DEFAULT ('N') NULL,
    [IDATE]              DATETIME        NULL,
    [IEMP_ID]            NVARCHAR (20)   NULL,
    [UDATE]              DATETIME        NULL,
    [UEMP_ID]            NVARCHAR (20)   NULL,
    CONSTRAINT [PK_PO_ORDER_HDR_1] PRIMARY KEY CLUSTERED ([ORD_NO] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IDX_WHERE]
    ON [dbo].[PO_ORDER_HDR]([ORD_DT] ASC, [VEN_CODE] ASC, [DELIVERY_REQ_DT] ASC, [ORD_STAT] ASC);


GO

CREATE NONCLUSTERED INDEX [IDX_ORD_NO_PARENT]
    ON [dbo].[PO_ORDER_HDR]([ORD_NO_PARENT] ASC);


GO

CREATE NONCLUSTERED INDEX [IDX_DELIVERY_DEC_DT_IDX]
    ON [dbo].[PO_ORDER_HDR]([DELIVERY_DEC_DT] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'ORD_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'발행구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'ISSUE_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'도착요청일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'ARRIVAL_REQ_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문상태', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'ORD_STAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'공급가합계금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'PICKING_TOTAL_SPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배송지 상세주소', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'R_ADDR_DTL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'마감비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'CLOSE_REMARKS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문확정여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'ORD_CFM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1착지 주문번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'ORD_NO_PARENT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'마감번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'CLOSE_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'첨부서류4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'DOCUMENT_REQ_4';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문등록HDR', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배송지 우편번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'R_POST_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'출고일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'DELIVERY_DEC_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문 합계금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'ORD_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'마감일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'CLOSE_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'첨부서류비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'DOCUMENT_REMARKS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배송지 주소', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'R_ADDR';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배차사용여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'TRANS_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'운송비마스터SEQ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'DELIVERY_PRICE_SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'첨부서류3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'DOCUMENT_REQ_3';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'REMARKS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문구분 1 : 정상, 2 : 반품', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'ORD_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'출고요청일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'DELIVERY_REQ_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'도착일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'ARRIVAL_DEC_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입/출고 마감확정여부 (Y/N)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'CLOSE_STAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피킹합계금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'PICKING_TOTAL_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'첨부서류1(공통코드 DOCUMENT_REQ)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'DOCUMENT_REQ_1';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문확정일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'ORD_CFM_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'마감확정자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'CLOSE_EMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배송지코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'DELIVERY_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'ORD_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'첨부서류2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'DOCUMENT_REQ_2';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'더존연동구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_ORDER_HDR', @level2type = N'COLUMN', @level2name = N'DOUZONE_FLAG';


GO

