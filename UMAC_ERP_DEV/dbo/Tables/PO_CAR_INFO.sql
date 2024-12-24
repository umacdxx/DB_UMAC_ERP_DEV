CREATE TABLE [dbo].[PO_CAR_INFO] (
    [CAR_NO]          NVARCHAR (8)    NOT NULL,
    [CAR_GB]          NVARCHAR (1)    NULL,
    [MOBIL_NO]        VARBINARY (256) NULL,
    [DRIVER_NAME]     NVARCHAR (20)   NULL,
    [DRIVER_VEN_NAME] NVARCHAR (50)   NULL,
    [IDATE]           DATETIME        NOT NULL,
    [IEMP_ID]         NVARCHAR (20)   NOT NULL,
    [UDATE]           DATETIME        NULL,
    [UEMP_ID]         NVARCHAR (20)   NULL,
    CONSTRAINT [PK_PO_CAR_INFO] PRIMARY KEY CLUSTERED ([CAR_NO] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'차량번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_CAR_INFO', @level2type = N'COLUMN', @level2name = N'CAR_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_CAR_INFO', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_CAR_INFO', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'기사번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_CAR_INFO', @level2type = N'COLUMN', @level2name = N'MOBIL_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'회사명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_CAR_INFO', @level2type = N'COLUMN', @level2name = N'DRIVER_VEN_NAME';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_CAR_INFO', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'차량구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_CAR_INFO', @level2type = N'COLUMN', @level2name = N'CAR_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'차량정보', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_CAR_INFO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일자', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_CAR_INFO', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'기사명', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PO_CAR_INFO', @level2type = N'COLUMN', @level2name = N'DRIVER_NAME';


GO

