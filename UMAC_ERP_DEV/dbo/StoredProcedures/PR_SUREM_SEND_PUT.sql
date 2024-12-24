/*
-- 생성자 :	강세미
-- 등록일 :	2024.06.18
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 
-- 실행문 : EXEC PR_SUREM_LOG_PUT '','ORD_1','82-1033329335', '027865064', '내용', '', 'Y', '', '',   'result','','','',''
*/
CREATE PROCEDURE [dbo].[PR_SUREM_SEND_PUT]
	@P_message_id			INT,				-- 메시지키값
	@P_template_code		NVARCHAR(30),		-- 템플릿코드
	@P_to					NVARCHAR(20),		-- 전화번호(국가번호포함)
	@P_reqphone				NVARCHAR(20),		-- 문자 재전송시 발신번호
	@P_text					NVARCHAR(1000),		-- 템플릿내용
	@P_reserved_time		NVARCHAR(12),		-- 예약발송시 예약시간
	@P_re_send				NVARCHAR(1),		-- 알림톡 전송 실패시 문자 재전송 여부
	@P_subject				NVARCHAR(100),		-- 알림톡 실패 재전송 시 LMS규격 일 경우 세팅 될 메시지 제목
	@P_re_text				NVARCHAR(1000),		-- 알림톡 전송 실패시 재전송될 사용자 정의

	--- Webhook 결과 컬럼
	@P_result				NVARCHAR(1),		-- 이통사결과(전송결과)
	@P_errorcode			NVARCHAR(10),		-- 에러코드
	@P_mediatype			NVARCHAR(1),		-- 통신사정보
	@P_sentmedia			NVARCHAR(1),		-- 과금서비스
	@P_recvtime				NVARCHAR(14)		-- 단말기수신시간

AS 
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	BEGIN TRAN
	BEGIN TRY 
		DECLARE @RETURN_CODE	INT = 0										-- 리턴코드(저장완료)
		DECLARE @RETURN_MESSAGE NVARCHAR(MAX) = DBO.GET_ERR_MSG('0')		-- 리턴메시지
		DECLARE @message_id		INT	= 0										-- 메시지키값
		
		IF @P_message_id = 0
			BEGIN				
				SELECT @message_id = (ISNULL(MAX(message_id),0) + 1) FROM TBL_SUREM_SEND

				INSERT INTO TBL_SUREM_SEND(
					message_id,
					template_code,
					[to],
					reqphone,
					[text],
					reserved_time,
					re_send,
					[subject],
					re_text,
					SEND_YN,
					IDATE
					) VALUES (
					@message_id,	
					@P_template_code,
					@P_to,			
					@P_reqphone,
					@P_text,			
					@P_reserved_time,
					@P_re_send,		
					@P_subject,		
					@P_re_text,
					'N',
					GETDATE()
					)
			END
		ELSE
			BEGIN
				UPDATE TBL_SUREM_SEND
				   SET SEND_YN = (CASE WHEN @P_result = '2' THEN 'Y' ELSE 'N' END),
					   errorcode = @P_errorcode,
					   mediatype = @P_mediatype,
					   sentmedia = @P_sentmedia,
					   recvtime = @P_recvtime,
					   UDATE = GETDATE()
				 WHERE message_id = @P_message_id
			END

		SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE, @message_id AS message_id
		
	COMMIT;
	END TRY
	
	BEGIN CATCH		
		IF @@TRANCOUNT > 0
		BEGIN 
			ROLLBACK TRAN
			SET @RETURN_CODE = -1
			SET @RETURN_MESSAGE = ERROR_MESSAGE()

			--에러 로그 테이블 저장
			INSERT INTO TBL_ERROR_LOG 
			SELECT ERROR_PROCEDURE()		-- 프로시저명
				, ERROR_MESSAGE()			-- 에러메시지
				, ERROR_LINE()				-- 에러라인
				, GETDATE()	
		END 
		
		SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE 
	END CATCH
	
END

GO

