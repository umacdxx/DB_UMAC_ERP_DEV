CREATE TABLE [dbo].[PO_SCALE] (
    [ORD_NO]                NVARCHAR (11)   NOT NULL,
    [ORD_DT]                NVARCHAR (8)    NULL,
    [DELIVERY_DT]           NVARCHAR (8)    NULL,
    [ORD_AMT]               NUMERIC (17, 4) NULL,
    [VEN_CODE]              NVARCHAR (7)    NULL,
    [GROUP_NO]              INT             NULL,
    [ITM_PUR_GB]            NVARCHAR (1)    NULL,
    [SCALE_DT]              NVARCHAR (8)    NULL,
    [CAR_GB]                NVARCHAR (1)    NULL,
    [TRANS_COST]            INT             NULL,
    [RENT_COST]             INT             NULL,
    [CAR_NO]                NVARCHAR (8)    NULL,
    [MOBIL_NO]              VARBINARY (256) NULL,
    [CENTER_GB]             NVARCHAR (1)    NULL,
    [PLT_QTY11]             INT             NULL,
    [PLT_QTY12]             INT             NULL,
    [GROSS_WGHT]            INT             NULL,
    [UNLOAD_WGHT]           INT             NULL,
    [NET_WGHT]              INT             NULL,
    [OFFICIAL_WGHT]         INT             NULL,
    [GAP_WGHT]              INT             NULL,
    [CLOSE_WGHT]            INT             NULL,
    [BAG_GB]                NVARCHAR (1)    NULL,
    [BAG_QTY]               INT             NULL,
    [BAG_WGHT]              NUMERIC (15, 2) NULL,
    [ENTRANCE_YN]           NVARCHAR (1)    NULL,
    [ENTRANCE_TIME]         NVARCHAR (5)    NULL,
    [GROSS_WGHT_DT]         DATETIME        NULL,
    [UNLOAD_WGHT_DT]        DATETIME        NULL,
    [OFFICIAL_WGHT_DT]      DATETIME        NULL,
    [OFFICIAL_WGHT_UEMP_ID] NVARCHAR (20)   NULL,
    [IN_IDATE]              DATETIME        NULL,
    [REMARKS]               NVARCHAR (2000) NULL,
    [IDATE]                 DATETIME        NULL,
    [IEMP_ID]               NVARCHAR (20)   NULL,
    [UDATE]                 DATETIME        NULL,
    [UEMP_ID]               NVARCHAR (20)   NULL,
    CONSTRAINT [PK_PO_SCALE] PRIMARY KEY CLUSTERED ([ORD_NO] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'파렛트11형수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'PLT_QTY11';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문/발주일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'ORD_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입차여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'ENTRANCE_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'용차비', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'RENT_COST';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'자차중량(순중량)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'NET_WGHT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품매출입구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'ITM_PUR_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'REMARKS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피중량 구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'BAG_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피중량 무게(KG)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'BAG_WGHT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'창고구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'CENTER_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'운송비', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'TRANS_COST';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'공차중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'UNLOAD_WGHT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'계근대 최초 진입 날짜', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'IN_IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문/발주/수입번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'ORD_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'마감중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'CLOSE_WGHT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'그룹번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'GROUP_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'공차중량 등록일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'UNLOAD_WGHT_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'피중량 수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'BAG_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주문/발주 합계금액', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'ORD_AMT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'타차중량 최신 수정자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'OFFICIAL_WGHT_UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'총중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'GROSS_WGHT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'휴대폰번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'MOBIL_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'차량구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'CAR_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'총중량 등록일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'GROSS_WGHT_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'차이중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'GAP_WGHT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'계근대 정보', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'타차중량 등록일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'OFFICIAL_WGHT_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입고일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'DELIVERY_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'파렛트12형수량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'PLT_QTY12';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'차량번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'CAR_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입차시간', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'ENTRANCE_TIME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'타차중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'OFFICIAL_WGHT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'계근일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_SCALE', @level2type = N'COLUMN', @level2name = N'SCALE_DT';


GO

