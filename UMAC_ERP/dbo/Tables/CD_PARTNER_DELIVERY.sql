CREATE TABLE [dbo].[CD_PARTNER_DELIVERY] (
    [VEN_CODE]           NVARCHAR (7)    NOT NULL,
    [DELIVERY_CODE]      NVARCHAR (7)    NOT NULL,
    [DELIVERY_NAME]      NVARCHAR (20)   NOT NULL,
    [DELIVERY_GB]        NVARCHAR (1)    NOT NULL,
    [SORT_ORDER]         INT             NOT NULL,
    [POST_NO]            NVARCHAR (5)    NULL,
    [ADDR]               NVARCHAR (100)  NULL,
    [ADDR_DTL]           NVARCHAR (50)   NULL,
    [CHRG_NAME]          NVARCHAR (20)   NULL,
    [TEL_NO]             NVARCHAR (14)   NULL,
    [MOBIL_NO_TEST]      NVARCHAR (11)   NULL,
    [EMAIL]              NVARCHAR (50)   NULL,
    [FAX_NO]             NVARCHAR (14)   NULL,
    [DELIVERY_PRICE_SEQ] INT             NULL,
    [USE_YN]             NVARCHAR (1)    NULL,
    [IDATE]              DATETIME        NULL,
    [IEMP_ID]            NVARCHAR (20)   NULL,
    [UDATE]              DATETIME        NULL,
    [UEMP_ID]            NVARCHAR (20)   NULL,
    [MOBIL_NO]           VARBINARY (256) NULL,
    CONSTRAINT [PK_CD_PARTNER_DELIVERY] PRIMARY KEY CLUSTERED ([VEN_CODE] ASC, [DELIVERY_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'사용여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'USE_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상세주소', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'ADDR_DTL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'휴대폰번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'MOBIL_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배송지그룹', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'DELIVERY_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'우편번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'POST_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'팩스번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'FAX_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록사원번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배송지이름', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'DELIVERY_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'이메일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'EMAIL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'전화번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'TEL_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주소', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'ADDR';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배송지가격정보SEQ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'DELIVERY_PRICE_SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정사원번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'정렬순서', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'SORT_ORDER';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'휴대폰번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'MOBIL_NO_TEST';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'배송지코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'DELIVERY_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'담당자명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'CHRG_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처배송지', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_DELIVERY', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

