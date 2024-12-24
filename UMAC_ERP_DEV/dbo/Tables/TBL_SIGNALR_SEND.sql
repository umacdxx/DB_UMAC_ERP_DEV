CREATE TABLE [dbo].[TBL_SIGNALR_SEND] (
    [JSONDATA] NVARCHAR (MAX) NOT NULL,
    [GUBUN]    INT            NOT NULL
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 : 배고공지', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SIGNALR_SEND', @level2type = N'COLUMN', @level2name = N'GUBUN';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'전송 받은 데이터 JSON 형식으로 담기', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SIGNALR_SEND', @level2type = N'COLUMN', @level2name = N'JSONDATA';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'실시간 시그널통신 연동 데이터 테스트중', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SIGNALR_SEND';


GO

