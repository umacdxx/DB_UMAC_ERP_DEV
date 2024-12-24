/*
-- 생성자 :	윤현빈
-- 등록일 :	2024.06.10
-- 수정자 : -
-- 수정일 : - 
-- 설 명 : 배치성, 일 수불 테이블 실행 (해당 월의 지난 일 수 만큼)
--			START_DATE 받는데 없으면 월 수불처럼 동작, 있으면 그 때부터 현재기준 어제 까지 돌림
-- 실행문 : EXEC PR_BATCH_DAILY_IV_ITEM_COLL_LOOP
*/
CREATE PROCEDURE [dbo].[PR_BATCH_DAILY_IV_ITEM_COLL_LOOP]
	@P_START_DATE	NVARCHAR(8),	-- YYYYMMDD 형태, 파라미터 있을 때 해당 파라미터부터 수불 처리
	@P_IEMP_ID		NVARCHAR(20)		-- 화면에서 수불 처리 시 등록자
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	DECLARE @RETURN_CODE INT = 0				-- 리턴코드
	DECLARE @RETURN_MESSAGE NVARCHAR(100) = ''	-- 리턴메시지

	BEGIN TRAN
	BEGIN TRY 
		DECLARE @V_MAX_SEQ INT;
		DECLARE @V_START_TIME DATETIME;

-- ************************************************************
-- 배치 로그 테이블 삽입
-- ************************************************************
		SET @RETURN_CODE = 1;
		DECLARE @InsertedSEQ TABLE (SEQ INT);
		
		INSERT INTO TBL_BATCH_LOG
		OUTPUT INSERTED.SEQ INTO @InsertedSEQ
		SELECT CONVERT(VARCHAR(8), GETDATE(), 112)
			    , 'PR_BATCH_DAILY_IV_ITEM_COLL_LOOP'
				, 'R'
				, GETDATE()
				, NULL
				, NULL
				, 'N'
				;
		
		SELECT @V_MAX_SEQ = SEQ FROM @InsertedSEQ;

-- ************************************************************
-- 배치 실행 (해당 월의 지난 일 수 만큼)
-- #매 월 초일 때 전 달 전체 집계
-- #20241104 10일 이전일 때 전달 까지 돌리도록 변경
-- ************************************************************

		DECLARE @V_START_DATE DATE = DATEADD(DAY, 1 - DAY(GETDATE()), CAST(GETDATE() AS DATE));
		DECLARE @V_END_DATE DATE = DATEADD(DAY, -1, GETDATE());
		DECLARE @V_CUR_DATE DATE = @V_START_DATE;
		DECLARE @V_FORMAT_DATE VARCHAR(8);

		-- 매월 초일 때
		-- #20241104 10일 이전일 때 전달 까지 돌리도록 변경
		IF DAY(GETDATE()) <= 10
		BEGIN
			SET @V_CUR_DATE = DATEADD(M, -1, @V_CUR_DATE);
		END

		-- 파라미터 있을 때 해당일부터 현재 기준 어제 까지 수불 처리
		IF @P_START_DATE != ''
		BEGIN
			SET @V_CUR_DATE = CAST(@P_START_DATE AS DATE);
		END
		
		WHILE @V_CUR_DATE <= @V_END_DATE
		BEGIN
			SET @RETURN_CODE = @RETURN_CODE + 1;
			SET @V_FORMAT_DATE = CONVERT(VARCHAR(8), @V_CUR_DATE, 112);
			
			EXEC PR_BATCH_DAILY_IV_ITEM_COLL @V_FORMAT_DATE, '', 'N';

			SET @V_CUR_DATE = DATEADD(DAY, 1, @V_CUR_DATE);
		END;

		SET @RETURN_CODE = 99;
		SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('99');

		UPDATE TBL_BATCH_LOG
			SET BATCH_STATUS = 'S'
				, END_TIME = GETDATE()
				, MSG = CONCAT('SUCCESS', ' / ', @P_IEMP_ID)
			WHERE SEQ = @V_MAX_SEQ
			;

		COMMIT;

	END TRY
	BEGIN CATCH		

	    IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN;

			INSERT INTO TBL_BATCH_LOG
			SELECT CONVERT(VARCHAR(8), GETDATE(), 112)
				, 'PR_BATCH_DAILY_IV_ITEM_COLL_LOOP'
				, 'F'
				, @V_START_TIME
				, GETDATE()
				, CONCAT(ERROR_MESSAGE(), ' / ', @RETURN_CODE)
				, 'N'
			;

			SET @RETURN_CODE = -99;
			SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('-99');
			SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE
		END;
		
	END CATCH
	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE
END

GO

