CREATE TABLE [dbo].[HCMS_ACCT_TRSC_PTCL] (
    [CMS_SEQ]               INT             NOT NULL,
    [INST_DV_NO]            VARCHAR (8)     NOT NULL,
    [CMSV_CUR_CD]           VARCHAR (3)     NOT NULL,
    [CRYP_CMSV_ACCT_NO]     VARCHAR (20)    NOT NULL,
    [TRSC_DT]               VARCHAR (8)     NOT NULL,
    [CMSV_ACCT_TRSC_SEQ_NO] DECIMAL (10)    NOT NULL,
    [TRSC_DRTM]             VARCHAR (6)     NULL,
    [RCV_WDRW_DV_CD]        CHAR (1)        NOT NULL,
    [TX_AMT]                DECIMAL (18, 3) NULL,
    [TRSC_AF_ACCT_BAL]      DECIMAL (18, 3) NULL,
    [RCRD_MTTR_CTT]         VARCHAR (300)   NULL,
    [CMSV_ACCT_TRSC_DV_CTT] VARCHAR (100)   NULL,
    [CMSV_TRSC_BR_NM]       VARCHAR (300)   NULL,
    [INDATE]                VARCHAR (8)     NULL,
    [INTIME]                VARCHAR (6)     NULL,
    [ERP_LNK_CTT]           VARCHAR (500)   NULL,
    [ERP_LNK_DV_CD]         CHAR (1)        NULL,
    [MOID]                  NVARCHAR (100)  NULL,
    [CFM_DT]                NVARCHAR (8)    NULL,
    [CFM_EMP_ID]            NVARCHAR (20)   NULL,
    CONSTRAINT [PK_HCMS_ACCT_TRSC_PTCL] PRIMARY KEY CLUSTERED ([INST_DV_NO] ASC, [CMSV_CUR_CD] ASC, [CRYP_CMSV_ACCT_NO] ASC, [TRSC_DT] ASC, [CMSV_ACCT_TRSC_SEQ_NO] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래일', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'TRSC_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'확정일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'CFM_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'확정자 아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'CFM_EMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PG 주문아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'MOID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'일련번호 : 계좌,거래일자별 순번', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'CMSV_ACCT_TRSC_SEQ_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'데이터이관시간', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'INTIME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'통화코드 : KRW', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'CMSV_CUR_CD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'은행코드 : 8자리로 들어가지만 3자리로 끊어 넣어드릴 수 있습니다. EX:100000004 -> 004', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'INST_DV_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'데이터이관일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'INDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ERP연계구분코드(CMS관리용)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'ERP_LNK_DV_CD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'계좌번', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'CRYP_CMSV_ACCT_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ERP연계내용(CMS관리용)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'ERP_LNK_CTT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'적', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'RCRD_MTTR_CTT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CMS 입출금거래내역(보통예금기준)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래지점', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'CMSV_TRSC_BR_NM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래구분 > 타행이체, 당행송금 등등..', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'CMSV_ACCT_TRSC_DV_CTT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'고유 자동 증가 값', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'CMS_SEQ';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'입출금구분 > 1 : 입금, 2 : 출금', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'RCV_WDRW_DV_CD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래시간', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'TRSC_DRTM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'잔', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'TRSC_AF_ACCT_BAL';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래금', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'HCMS_ACCT_TRSC_PTCL', @level2type = N'COLUMN', @level2name = N'TX_AMT';


GO

