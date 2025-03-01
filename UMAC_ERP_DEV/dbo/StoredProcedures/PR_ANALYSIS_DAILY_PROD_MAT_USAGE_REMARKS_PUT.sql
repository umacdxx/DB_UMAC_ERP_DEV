
/*

-- 생성자 :	윤현빈
-- 등록일 :	2024.09.02
-- 설 명  : 생산/부자재사용량 비고 저장
-- 실행문 : 

EXEC PR_ANALYSIS_DAILY_PROD_MAT_USAGE_REMARKS_PUT '','','','',''

*/
CREATE PROCEDURE [dbo].[PR_ANALYSIS_DAILY_PROD_MAT_USAGE_REMARKS_PUT]
( 
	@P_JSONDT			VARCHAR(8000) = '',
	@P_EMP_ID			NVARCHAR(20)				-- 아이디
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @RETURN_CODE	INT = 0										-- 리턴코드(저장완료)
	DECLARE @RETURN_MESSAGE NVARCHAR(MAX) = DBO.GET_ERR_MSG('0')		-- 리턴메시지
	
	BEGIN TRAN
	BEGIN TRY 

		DECLARE @TMP_ITEM TABLE (
			REPORT_DATE NVARCHAR(8),
			SCAN_CODE NVARCHAR(14),
			REMARKS NVARCHAR(2000),
			MODE NVARCHAR(1)
		)
		
		INSERT INTO @TMP_ITEM
		SELECT REPORT_DATE, SCAN_CODE, REMARKS, MODE
			FROM 
				OPENJSON ( @P_JSONDT )   
					WITH (    
						REPORT_DATE NVARCHAR(8) '$.REPORT_DATE',
						SCAN_CODE NVARCHAR(14) '$.SCAN_CODE',
						REMARKS NVARCHAR(2000) '$.REMARKS',
						MODE NVARCHAR(1) '$.MODE'
					)
				
		DECLARE CURSOR_REMARKS CURSOR FOR

			SELECT A.REPORT_DATE, A.SCAN_CODE, A.REMARKS, MODE 
				FROM @TMP_ITEM A
			
		OPEN CURSOR_REMARKS

		DECLARE @P_REPORT_DATE NVARCHAR(8),
				@P_SCAN_CODE NVARCHAR(14),
				@P_REMARKS NVARCHAR(2000),
				@P_MODE NVARCHAR(1)

		FETCH NEXT FROM CURSOR_REMARKS INTO @P_REPORT_DATE, @P_SCAN_CODE, @P_REMARKS, @P_MODE

			WHILE(@@FETCH_STATUS=0)
			BEGIN

				MERGE INTO RP_ANALYSIS_DAILY_PROD_MAT_USAGE AS A
					USING (select 1 as daul) AS B
					ON (A.REPORT_DATE = @P_REPORT_DATE AND SCAN_CODE = @P_SCAN_CODE)
				WHEN MATCHED THEN
					UPDATE
						SET REMARKS = @P_REMARKS
						  , UDATE = GETDATE()
						  , UEMP_ID = @P_EMP_ID
				WHEN NOT MATCHED THEN
					INSERT
					(
						REPORT_DATE
					  , SCAN_CODE
					  , REMARKS
					  , IDATE
					  , IEMP_ID
					  , UDATE
					  , UEMP_ID
					)
					VALUES
					(
						@P_REPORT_DATE
					  , @P_SCAN_CODE
					  , @P_REMARKS
					  , GETDATE()
					  , @P_EMP_ID
					  , NULL
					  , NULL
					)
				;

				FETCH NEXT FROM CURSOR_REMARKS INTO @P_REPORT_DATE, @P_SCAN_CODE, @P_REMARKS, @P_MODE

			END

		CLOSE CURSOR_REMARKS
		DEALLOCATE CURSOR_REMARKS

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
	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE 
END

GO

