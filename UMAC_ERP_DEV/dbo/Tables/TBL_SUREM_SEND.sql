CREATE TABLE [dbo].[TBL_SUREM_SEND] (
    [message_id]    INT             NOT NULL,
    [template_code] NVARCHAR (30)   NULL,
    [to]            NVARCHAR (20)   NULL,
    [reqphone]      NVARCHAR (20)   NULL,
    [text]          NVARCHAR (1000) NULL,
    [reserved_time] NVARCHAR (12)   NULL,
    [re_send]       NVARCHAR (1)    NULL,
    [subject]       NVARCHAR (100)  NULL,
    [re_text]       NVARCHAR (1000) NULL,
    [SEND_YN]       NVARCHAR (1)    NULL,
    [errorcode]     NVARCHAR (10)   NULL,
    [mediatype]     NVARCHAR (1)    NULL,
    [sentmedia]     NVARCHAR (1)    NULL,
    [recvtime]      NVARCHAR (14)   NULL,
    [IDATE]         DATETIME        NULL,
    [UDATE]         DATETIME        NULL,
    CONSTRAINT [PK_TBL_SUREM_LOG] PRIMARY KEY CLUSTERED ([message_id] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_SEND', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'템플릿코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_SEND', @level2type = N'COLUMN', @level2name = N'template_code';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'통신사정보', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_SEND', @level2type = N'COLUMN', @level2name = N'mediatype';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'알림톡 전송 실패시 재전송될 사용자 정의 메시지', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_SEND', @level2type = N'COLUMN', @level2name = N're_text';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'예약 발송시 예약시간', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_SEND', @level2type = N'COLUMN', @level2name = N'reserved_time';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'메시지키값', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_SEND', @level2type = N'COLUMN', @level2name = N'message_id';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'이통사 에러코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_SEND', @level2type = N'COLUMN', @level2name = N'errorcode';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'알림톡 실패 재전송 시 LMS규격 일 경우 세팅 될 메시지 제목', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_SEND', @level2type = N'COLUMN', @level2name = N'subject';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'템플릿내용', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_SEND', @level2type = N'COLUMN', @level2name = N'text';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'알림톡 전송 실패시 문자 재전송 여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_SEND', @level2type = N'COLUMN', @level2name = N're_send';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'슈어엠 알림톡 전송로그', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_SEND';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'문자 재전송시 발신번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_SEND', @level2type = N'COLUMN', @level2name = N'reqphone';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'단말기수신시간', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_SEND', @level2type = N'COLUMN', @level2name = N'recvtime';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_SEND', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'전화번호', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_SEND', @level2type = N'COLUMN', @level2name = N'to';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'과금서비스', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_SEND', @level2type = N'COLUMN', @level2name = N'sentmedia';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'전송여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_SUREM_SEND', @level2type = N'COLUMN', @level2name = N'SEND_YN';


GO

