CREATE TABLE [dbo].[CD_PARTNER_EMP] (
    [VEN_CODE]    NVARCHAR (7)    NOT NULL,
    [SORT_ORDER]  INT             NULL,
    [USER_NM]     NVARCHAR (20)   NULL,
    [POSITION]    NVARCHAR (3)    NULL,
    [MAIL_ID]     NVARCHAR (120)  NULL,
    [ALIMTALK_YN] NVARCHAR (1)    NULL,
    [IDATE]       DATETIME        NULL,
    [IEMP_ID]     NVARCHAR (20)   NULL,
    [UDATE]       DATETIME        NULL,
    [UEMP_ID]     NVARCHAR (20)   NULL,
    [MOBIL_NO]    VARBINARY (256) NULL,
    [ASGNR]       NVARCHAR (1)    NULL
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'직급', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_EMP', @level2type = N'COLUMN', @level2name = N'POSITION';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'정렬순서', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_EMP', @level2type = N'COLUMN', @level2name = N'SORT_ORDER';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_EMP', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_EMP', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처 코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_EMP', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'알림톡여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_EMP', @level2type = N'COLUMN', @level2name = N'ALIMTALK_YN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'세금계산서 담당 여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_EMP', @level2type = N'COLUMN', @level2name = N'ASGNR';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_EMP', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'휴대폰번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_EMP', @level2type = N'COLUMN', @level2name = N'MOBIL_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_EMP', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'사용자이름', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_EMP', @level2type = N'COLUMN', @level2name = N'USER_NM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처 직원 정보', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_EMP';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'메일ID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CD_PARTNER_EMP', @level2type = N'COLUMN', @level2name = N'MAIL_ID';


GO

