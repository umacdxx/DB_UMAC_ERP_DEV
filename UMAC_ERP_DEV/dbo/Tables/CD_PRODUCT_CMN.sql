CREATE TABLE [dbo].[CD_PRODUCT_CMN] (
    [SCAN_CODE]       NVARCHAR (14)   NOT NULL,
    [ITM_CODE]        NVARCHAR (6)    NOT NULL,
    [ITM_NAME]        NVARCHAR (50)   NOT NULL,
    [ITM_NAME_DETAIL] NVARCHAR (100)  NULL,
    [VEN_CODE]        NVARCHAR (7)    NULL,
    [VEN_CODE_2]      NVARCHAR (7)    NULL,
    [VEN_CODE_3]      NVARCHAR (7)    NULL,
    [VEN_CODE_4]      NVARCHAR (7)    NULL,
    [VEN_CODE_5]      NVARCHAR (7)    NULL,
    [GRE_GB]          NVARCHAR (1)    NULL,
    [ITM_GB]          NVARCHAR (1)    NULL,
    [END_IND]         NVARCHAR (1)    NULL,
    [MID_CODE]        NVARCHAR (4)    NOT NULL,
    [ITM_FORM]        NVARCHAR (2)    NULL,
    [TAX_GB]          NVARCHAR (1)    NULL,
    [WEIGHT_GB]       NVARCHAR (3)    NULL,
    [UNIT]            NVARCHAR (2)    NULL,
    [IPSU_QTY]        INT             NULL,
    [PLT_BOX_QTY]     INT             NULL,
    [FILE_NAME]       NVARCHAR (100)  NULL,
    [UNIT_CAPACITY]   INT             NULL,
    [UNIT_WEIGHT]     INT             NULL,
    [NET_WEIGHT]      INT             NULL,
    [CURRENCY_TYPE]   NVARCHAR (3)    NULL,
    [BASE_WPRC]       NUMERIC (15, 2) NULL,
    [BASE_WVAT]       NUMERIC (15, 2) NULL,
    [BASE_SPRC]       NUMERIC (17, 4) NULL,
    [BASE_SVAT]       NUMERIC (17, 4) NULL,
    [WIDTH]           NUMERIC (3, 1)  NULL,
    [LENGTH]          NUMERIC (3, 1)  NULL,
    [DEPTH]           NUMERIC (3, 1)  NULL,
    [LOT_OIL_GB]      NVARCHAR (6)    NULL,
    [LOT_PARTNER_GB]  NVARCHAR (6)    NULL,
    [BOM_GB]          NVARCHAR (1)    NULL,
    [SET_GB]          NVARCHAR (1)    NULL,
    [EXPIRY_CNT]      INT             NULL,
    [IDATE]           DATETIME        NULL,
    [IEMP_IP]         NVARCHAR (50)   NULL,
    [IEMP_ID]         NVARCHAR (20)   NULL,
    [UDATE]           DATETIME        NULL,
    [UEMP_IP]         NVARCHAR (50)   NULL,
    [UEMP_ID]         NVARCHAR (20)   NULL,
    CONSTRAINT [PK_CD_PRODUCT_CMN_1] PRIMARY KEY CLUSTERED ([SCAN_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'GRE_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'BOM 구분 공통코드 : BOM_GB', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'BOM_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'표시용량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'UNIT_CAPACITY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품마스터', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'원가공급', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'BASE_WPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록사원번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'단위', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'UNIT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품 세로', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'LENGTH';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'VEN_CODE_3';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품형태', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'ITM_FORM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'파일명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'FILE_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록_IP', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'IEMP_IP';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'LOT 거래처 구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'LOT_PARTNER_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매가부가세', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'BASE_SVAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수중량관리(QTY,WT)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'WEIGHT_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'환종(KRW,USD) 공통코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'CURRENCY_TYPE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드5', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'VEN_CODE_5';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'중분류코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'MID_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'단축상품명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'ITM_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품 가로', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'WIDTH';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'VEN_CODE_2';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'순중량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'NET_WEIGHT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정사원번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매가공급가', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'BASE_SPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PLT 박스 환산량', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'PLT_BOX_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'LOT 유종구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'LOT_OIL_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'취급여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'END_IND';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'관리코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'ITM_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품무게', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'UNIT_WEIGHT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SET구분 공통코드 : SET_GB', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'SET_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입수', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'IPSU_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'제품명(상세)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'ITM_NAME_DETAIL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'원가부가세', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'BASE_WVAT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'과/면세 구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'TAX_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'VEN_CODE_4';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'소비기한 계산일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'EXPIRY_CNT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'ITM_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상품 높이', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'DEPTH';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정_IP', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PRODUCT_CMN', @level2type = N'COLUMN', @level2name = N'UEMP_IP';


GO

