CREATE TABLE [dbo].[TBL_NOTI] (
    [NOTI_NO]    NVARCHAR (10)   NOT NULL,
    [NOTI_GB]    NVARCHAR (2)    NOT NULL,
    [NOTI_TITLE] NVARCHAR (100)  NOT NULL,
    [CONTENTS]   NVARCHAR (2000) NOT NULL,
    [DEL_YN]     NVARCHAR (1)    NULL,
    [IDATE]      DATETIME        NULL,
    [IEMP_ID]    NVARCHAR (20)   NULL,
    [UDATE]      DATETIME        NULL,
    [UEMP_ID]    NVARCHAR (20)   NULL,
    CONSTRAINT [PK_TBL_NOTI] PRIMARY KEY CLUSTERED ([NOTI_NO] ASC)
);


GO

-- =============================================
-- 생성자 :	이동호
-- 등록일 :	2024.11.19
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : INSERT, UPDATE, DELETE TBL_NOTI 트리거
-- =============================================
CREATE TRIGGER [dbo].[TRG_TBL_NOTI_UPDATED]
   ON [dbo].[TBL_NOTI]
   AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
	
	SET NOCOUNT ON;

	BEGIN TRY

		DECLARE @MESSAGEBODY NVARCHAR(MAX);
		SET @MESSAGEBODY = (SELECT TOP 1 NOTI_NO, NOTI_TITLE, CONTENTS, DEL_YN FROM TBL_NOTI WITH(NOLOCK) WHERE DEL_YN = 'N' ORDER BY NOTI_NO DESC FOR JSON AUTO);
		IF @MESSAGEBODY IS NULL 
			SET @MESSAGEBODY = '[]'

		INSERT INTO TBL_SIGNALR_SEND (JSONDATA, GUBUN) VALUES(@MESSAGEBODY, 0);


		--DECLARE @DIALOGHANDLE UNIQUEIDENTIFIER;  
		--BEGIN DIALOG CONVERSATION @DIALOGHANDLE
		--	FROM SERVICE [NotiService]
		--	TO SERVICE 'NotiService'
		--	ON CONTRACT [NotiContract]
		--	WITH ENCRYPTION = OFF;

		--SEND ON CONVERSATION @DIALOGHANDLE
		--	MESSAGE TYPE [NotiSendMsg] (@MESSAGEBODY);
				
	END TRY        
    BEGIN CATCH
        
    END CATCH  

END

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '수정아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_NOTI', @level2type = N'COLUMN', @level2name = N'UEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '공지제목', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_NOTI', @level2type = N'COLUMN', @level2name = N'NOTI_TITLE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '등록아이디', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_NOTI', @level2type = N'COLUMN', @level2name = N'IEMP_ID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '공지코드', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_NOTI', @level2type = N'COLUMN', @level2name = N'NOTI_NO';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '수정일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_NOTI', @level2type = N'COLUMN', @level2name = N'UDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '공지구분', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_NOTI', @level2type = N'COLUMN', @level2name = N'NOTI_GB';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '등록일시', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_NOTI', @level2type = N'COLUMN', @level2name = N'IDATE';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '공지사항', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_NOTI';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '내용', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_NOTI', @level2type = N'COLUMN', @level2name = N'CONTENTS';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '삭제여부', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TBL_NOTI', @level2type = N'COLUMN', @level2name = N'DEL_YN';


GO

