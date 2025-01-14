/*
-- 생성자 :	윤현빈
-- 등록일 :	2024.07.04
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 재고조사 일정 등록
-- 실행문 : EXEC PR_STOCK_SCHD_PUT '20240701','1','testy'
*/
CREATE PROCEDURE [dbo].[PR_STOCK_SCHD_PUT]
( 
	@P_INV_DT		NVARCHAR(8) = '',		-- 조정일자
	@P_INV_GB		NVARCHAR(2) = '',		-- 재고조정 구분
	@P_EMP_ID	 	NVARCHAR(20) = ''		-- 세션 아이디
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	DECLARE @TEMP_SEQ		NVARCHAR(3);
	DECLARE @TEMP_SURVEY_ID	NVARCHAR(8);

	DECLARE @RETURN_CODE 	INT 			= 0		-- 리턴코드
	DECLARE @RETURN_MESSAGE NVARCHAR(10) 	= '' 	-- 리턴메시지

	BEGIN TRAN
	BEGIN TRY

		-- SURVEY_ID 채번
		--SELECT @TEMP_SEQ = RIGHT('0' + CAST(COUNT(*) + 1 AS VARCHAR(2)), 2)
		SELECT @TEMP_SEQ = (CASE WHEN MAX(SURVEY_ID) IS NOT NULL THEN  RIGHT('0' + MAX(SURVEY_ID)+1, 2) ELSE '01' END )
			FROM IV_SCHEDULER
		   WHERE INV_DT LIKE CONCAT(LEFT(@P_INV_DT, 6), '%')
		;
		
		--SET @TEMP_SURVEY_ID = CONCAT(FORMAT(GETDATE(), 'yyyyMM'), @TEMP_SEQ);
		SET @TEMP_SURVEY_ID = CONCAT(SUBSTRING(@P_INV_DT, 1, 6), @TEMP_SEQ)

		INSERT INTO IV_SCHEDULER 
		(
		     INV_DT
	  	   , SURVEY_ID
	  	   , SURVEY_GB
		   , CFM_FLAG
	  	   , IDATE
	  	   , IEMP_ID
		)
		VALUES
		(
			@P_INV_DT
		  , @TEMP_SURVEY_ID
		  , @P_INV_GB
		  , 'N'
		  , GETDATE()
		  , @P_EMP_ID
		)

		SET @RETURN_CODE = 0; -- 저장완료
		SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('0');
		COMMIT;
	
	END TRY
	
	BEGIN CATCH		
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN

			--에러 로그 테이블 저장
			INSERT INTO TBL_ERROR_LOG 
			SELECT ERROR_PROCEDURE()	-- 프로시저명
			, ERROR_MESSAGE()			-- 에러메시지
			, ERROR_LINE()				-- 에러라인
			, GETDATE();
		
			SET @RETURN_CODE = -1; -- 저장 실패
			SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('-1');
			
			SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE
		END
			
	END CATCH

	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE

END

GO

