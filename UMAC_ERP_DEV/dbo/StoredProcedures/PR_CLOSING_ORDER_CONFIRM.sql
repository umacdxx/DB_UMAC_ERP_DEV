
/*

-- 생성자 :	강세미
-- 등록일 :	2024.09.24
-- 수정일 : 2024.10.29 강세미 - 로직 변경
-- 설 명  : 월 매출마감 확정/확정취소
-- 실행문 : 

EXEC PR_CLOSING_ORDER_CONFIRM '[{"ORD_NO":"2241010007", "CLOSE_DT": "20241011", "ISSUE_GB": "1", "CONFIRM_TYPE": "CONFIRM"},
{"ORD_NO":"2241010007", "CLOSE_DT": "20241011", "CONFIRM_TYPE": "CONFIRM"}]','admin'
EXEC PR_CLOSING_ORDER_CONFIRM '[{"ORD_NO":"2241010007", "CLOSE_DT": "20241011", "ISSUE_GB": "1", "CONFIRM_TYPE": "CANCEL"}]','admin'

*/
CREATE PROCEDURE [dbo].[PR_CLOSING_ORDER_CONFIRM]
( 
	@P_JSONDT			VARCHAR(MAX) = '',
	@P_EMP_ID			NVARCHAR(20)	-- 아이디
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @RETURN_CODE	INT = 0										-- 리턴코드(저장완료)
	DECLARE @RETURN_MESSAGE NVARCHAR(MAX) = DBO.GET_ERR_MSG('0')		-- 리턴메시지
	DECLARE @CLOSE_NO		NVARCHAR(11)								-- 마감번호
	DECLARE @NEW_CLOSE_DT	NVARCHAR(8)									-- 마감일자

	BEGIN TRAN
	BEGIN TRY 
		DECLARE @TMP_ITEM TABLE (
				ORD_NO NVARCHAR(11),
				CONFIRM_TYPE NVARCHAR(10),
				CLOSE_DT NVARCHAR(8),
				ISSUE_GB NVARCHAR(1)
		)
		
		INSERT INTO @TMP_ITEM
		SELECT ORD_NO, CONFIRM_TYPE, CLOSE_DT, ISSUE_GB
			FROM 
				OPENJSON ( @P_JSONDT )   
					WITH (    
						ORD_NO NVARCHAR(11) '$.ORD_NO',
						CONFIRM_TYPE NVARCHAR(10) '$.CONFIRM_TYPE',
						CLOSE_DT NVARCHAR(8) '$.CLOSE_DT',
						ISSUE_GB NVARCHAR(1) '$.ISSUE_GB'
					)
				
		DECLARE CURSOR_REMARKS CURSOR FOR

			SELECT A.ORD_NO, A.CONFIRM_TYPE, A.CLOSE_DT, A.ISSUE_GB
				FROM @TMP_ITEM A
			
		OPEN CURSOR_REMARKS

		DECLARE @P_ORD_NO NVARCHAR(11),
				@P_CONFIRM_TYPE NVARCHAR(10),
				@P_CLOSE_DT NVARCHAR(8),
				@P_ISSUE_GB NVARCHAR(1)

		FETCH NEXT FROM CURSOR_REMARKS INTO @P_ORD_NO, @P_CONFIRM_TYPE, @P_CLOSE_DT, @P_ISSUE_GB
			-- ************************************************************
			-- 마감번호 생성
			-- ************************************************************
			IF @P_CONFIRM_TYPE = 'CONFIRM' --확정
			BEGIN
				SELECT @CLOSE_NO = ISNULL(
						MAX(CLOSE_NO) + 1,                -- CLOSE_NO가 존재할 경우 최대값에 +1
						LEFT(@P_CLOSE_DT, 6) + '01'       -- CLOSE_NO가 없을 경우 기본 값 설정 (예: YYYYMM01)
				)
				FROM PO_ORDER_HDR
				WHERE CLOSE_DT LIKE LEFT(@P_CLOSE_DT, 6) + '%';
			END

			WHILE(@@FETCH_STATUS=0)
			BEGIN
				-- ************************************************************
				-- 마감번호, 확정여부 업데이트
				-- ************************************************************

				IF @P_CONFIRM_TYPE = 'CONFIRM' --확정
				BEGIN

					SET @NEW_CLOSE_DT = @P_CLOSE_DT

					-- 발행예정인 건은 해당 월의 말일로 마감일자 변경
					IF @P_ISSUE_GB = '2'
					BEGIN
						SET @NEW_CLOSE_DT = CONVERT(VARCHAR(8),EOMONTH(CONVERT(DATE, @P_CLOSE_DT)), 112)
					END

					UPDATE PO_ORDER_HDR 
					   SET CLOSE_NO = @CLOSE_NO,
						   CLOSE_DT = @NEW_CLOSE_DT,
					       CLOSE_STAT = 'Y',
						   CLOSE_EMP_ID = @P_EMP_ID,
						   UDATE = GETDATE(),
						   UEMP_ID = @P_EMP_ID
					 WHERE ORD_NO = @P_ORD_NO

				END
				ELSE IF @P_CONFIRM_TYPE = 'CANCEL' --확정취소
				BEGIN
					SELECT @CLOSE_NO = CLOSE_NO FROM PO_ORDER_HDR WHERE ORD_NO = @P_ORD_NO
					
					-- 동일한 마감번호 NULL처리
					UPDATE PO_ORDER_HDR 
					   SET CLOSE_NO = NULL,
					       CLOSE_STAT = 'N',
						   CLOSE_EMP_ID = NULL,
						   UDATE = GETDATE(),
						   UEMP_ID = @P_EMP_ID
					 WHERE CLOSE_NO = @CLOSE_NO

				END

				FETCH NEXT FROM CURSOR_REMARKS INTO @P_ORD_NO, @P_CONFIRM_TYPE, @P_CLOSE_DT, @P_ISSUE_GB

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

	END CATCH
	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE 
END

GO

