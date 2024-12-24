CREATE TABLE [dbo].[PUR_CLOSING] (
    [PUR_MM]     NVARCHAR (6)    NOT NULL,
    [VEN_CODE]   NVARCHAR (7)    NOT NULL,
    [OVER_WPRC]  NUMERIC (15, 2) NULL,
    [CFM_FLAG]   NVARCHAR (2)    NULL,
    [CFM_EMP_ID] NVARCHAR (20)   NULL,
    [IDATE]      DATETIME        NULL,
    [IEMP_ID]    NVARCHAR (20)   NULL,
    [UDATE]      DATETIME        NULL,
    [UEMP_ID]    NVARCHAR (20)   NULL,
    CONSTRAINT [PK_PUR_CLOSING] PRIMARY KEY CLUSTERED ([PUR_MM] ASC, [VEN_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'확정구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING', @level2type = N'COLUMN', @level2name = N'CFM_FLAG';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입년월', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING', @level2type = N'COLUMN', @level2name = N'PUR_MM';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'월매입마감', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'당기이월금액(공급가)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING', @level2type = N'COLUMN', @level2name = N'OVER_WPRC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'확정자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING', @level2type = N'COLUMN', @level2name = N'CFM_EMP_ID';


GO

