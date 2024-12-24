/*
-- 생성자 :	임현태
-- 등록일 :	2024.11.07
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 공지사항 등록
*/
CREATE PROCEDURE [dbo].[PR_NOTI_PUT]
(
	@P_NOTI_NO     NVARCHAR(10),	-- 공지사항 코드
	@P_NOTI_GB	   NVARCHAR(2),		-- 공지사항 구분
	@P_NOTI_TITLE  NVARCHAR(100),	-- 공지사항 제목
	@P_CONTENTS    NVARCHAR(2000),	-- 내용
	@P_DEL_YN	   NVARCHAR(1),		-- 삭제여부
	@P_IEMP_ID     NVARCHAR(20)		-- 등록아이디
)
AS
BEGIN
   SET NOCOUNT ON;
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
   DECLARE @RETURN_CODE	INT = 0					    -- 결과코드 정상 : '0', 실패 : -1
   DECLARE @RETURN_MESSAGE VARCHAR(50) = 'OK'		-- 결과메시지
   DECLARE @ORIGINAL_CONTENTS NVARCHAR(2000)		-- 기존 내용

	BEGIN TRAN
	BEGIN TRY 
		IF EXISTS (SELECT NOTI_NO FROM TBL_NOTI WHERE NOTI_NO = @P_NOTI_NO)
			BEGIN
				SET @ORIGINAL_CONTENTS = (SELECT CONTENTS FROM TBL_NOTI WHERE NOTI_NO = @P_NOTI_NO)

				UPDATE TBL_NOTI 
				SET NOTI_GB = @P_NOTI_GB,			-- 공지 구분
					DEL_YN = @P_DEL_YN,				-- 삭제 여부
					NOTI_TITLE = @P_NOTI_TITLE,		-- 공지 제목
					CONTENTS = @P_CONTENTS,			-- 내용	
					UEMP_ID = @P_IEMP_ID,			-- 수정아이디
					UDATE = GETDATE()				-- 수정 날짜
				WHERE NOTI_NO = @P_NOTI_NO

			END
		ELSE
			BEGIN
				INSERT INTO TBL_NOTI (NOTI_NO, NOTI_GB, DEL_YN, NOTI_TITLE, CONTENTS, IEMP_ID, IDATE, UEMP_ID) 
				VALUES (@P_NOTI_NO, @P_NOTI_GB, @P_DEL_YN, @P_NOTI_TITLE, @P_CONTENTS, @P_IEMP_ID, GETDATE(), '')
			END
	SET @RETURN_CODE = 0 -- 저장완료
	SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('0')

	COMMIT;	
	END TRY

	BEGIN CATCH		
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK;
			SET @RETURN_CODE  = -1
			SET @RETURN_MESSAGE  = ERROR_MESSAGE()			
			--에러 로그 테이블 저장
			INSERT INTO TBL_ERROR_LOG 
			SELECT ERROR_PROCEDURE()	-- 프로시저명
			, ERROR_MESSAGE()			-- 에러메시지
			, ERROR_LINE()				-- 에러라인
			, GETDATE()
		END
	END CATCH
	--결과 출력
	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE
END

GO
