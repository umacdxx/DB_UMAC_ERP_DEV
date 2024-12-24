CREATE TABLE [dbo].[PUR_CLOSING_ORD] (
    [PUR_DT]    NVARCHAR (8)    NOT NULL,
    [VEN_CODE]  NVARCHAR (7)    NOT NULL,
    [ORD_NO]    NVARCHAR (11)   NOT NULL,
    [SCAN_CODE] NVARCHAR (14)   NOT NULL,
    [OVER_WPRC] NUMERIC (15, 2) NULL,
    [REMARKS]   NVARCHAR (2000) NULL,
    [IDATE]     DATETIME        NULL,
    [IEMP_ID]   NVARCHAR (20)   NULL,
    [UDATE]     DATETIME        NULL,
    [UEMP_ID]   NVARCHAR (20)   NULL,
    CONSTRAINT [PK_PUR_CLOSING_ORD] PRIMARY KEY CLUSTERED ([PUR_DT] ASC, [VEN_CODE] ASC, [ORD_NO] ASC, [SCAN_CODE] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'제품코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING_ORD', @level2type = N'COLUMN', @level2name = N'SCAN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING_ORD', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'매입일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING_ORD', @level2type = N'COLUMN', @level2name = N'PUR_DT';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING_ORD', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'비고', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING_ORD', @level2type = N'COLUMN', @level2name = N'REMARKS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'발주번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING_ORD', @level2type = N'COLUMN', @level2name = N'ORD_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'건별매입마감', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING_ORD';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING_ORD', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'거래처코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING_ORD', @level2type = N'COLUMN', @level2name = N'VEN_CODE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING_ORD', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'당기이월금액(공급가)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PUR_CLOSING_ORD', @level2type = N'COLUMN', @level2name = N'OVER_WPRC';


GO

