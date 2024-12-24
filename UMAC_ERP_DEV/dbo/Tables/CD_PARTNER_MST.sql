CREATE TABLE [dbo].[CD_PARTNER_MST] (
    [VEN_CODE]         NVARCHAR (7)    NOT NULL,
    [VEN_NAME]         NVARCHAR (50)   NULL,
    [VEN_GB]           NVARCHAR (10)   NULL,
    [REP_NAME]         NVARCHAR (50)   NULL,
    [POST_NO]          NVARCHAR (5)    NULL,
    [ADDR]             NVARCHAR (100)  NULL,
    [ADDR_DTL]         NVARCHAR (50)   NULL,
    [UPJONG]           NVARCHAR (50)   NULL,
    [UPTAE]            NVARCHAR (50)   NULL,
    [BUSI_NO]          NVARCHAR (13)   NULL,
    [TEL_NO]           NVARCHAR (14)   NULL,
    [FAX_NO]           NVARCHAR (14)   NULL,
    [REP_MAIL_ID]      NVARCHAR (120)  NULL,
    [PARTNER_CD]       NVARCHAR (15)   NULL,
    [BANK_CODE]        NVARCHAR (7)    NULL,
    [BANK_ACC_NO]      VARBINARY (256) NULL,
    [BANK_ACC_OWN]     NVARCHAR (20)   NULL,
    [BANK_PAY_CON]     NVARCHAR (2)    NULL,
    [CREDIT_LIMIT_YN]  NVARCHAR (1)    NULL,
    [CREDIT_LIMIT]     NUMERIC (13)    NULL,
    [MGNT_DEPT]        NVARCHAR (25)   NULL,
    [MGNT_USER_ID]     NVARCHAR (20)   NULL,
    [DIRECT_EXPORT_YN] NVARCHAR (1)    CONSTRAINT [DF_CD_PARTNER_MST_DIRECT_EXPORT_YN] DEFAULT (N'N') NULL,
    [USE_YN]           NVARCHAR (1)    NULL,
    [IDATE]            DATETIME        NULL,
    [IEMP_ID]          NVARCHAR (20)   NULL,
    [UDATE]            DATETIME        NULL,
    [UEMP_ID]          NVARCHAR (20)   NULL,
    CONSTRAINT [PK_CD_PARTNER_MST] PRIMARY KEY CLUSTERED ([VEN_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'협력업체명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'VEN_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록사원번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'팩스번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'FAX_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'직수출여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'DIRECT_EXPORT_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'상세주소', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'ADDR_DTL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'사업자번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'BUSI_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'우편번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'POST_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'지불주기', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'BANK_PAY_CON';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'은행코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'BANK_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처마스터', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'대표자명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'REP_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'업태', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'UPTAE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'더존 거래처코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'PARTNER_CD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'여신한도', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'CREDIT_LIMIT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'예금주 명칭', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'BANK_ACC_OWN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'여신한도 사용여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'CREDIT_LIMIT_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'계좌번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'BANK_ACC_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정사원번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'주소', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'ADDR';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'전화번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'TEL_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출관리 직원', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'MGNT_USER_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'사용여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'USE_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매출관리부서 코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'MGNT_DEPT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'업종', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'UPJONG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'대표이메일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'REP_MAIL_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처구분 1 : 매입처, 2 : 매출처, 3 : 수입처, 4 : 기타', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_MST', @level2type = N'COLUMN', @level2name = N'VEN_GB';


GO

