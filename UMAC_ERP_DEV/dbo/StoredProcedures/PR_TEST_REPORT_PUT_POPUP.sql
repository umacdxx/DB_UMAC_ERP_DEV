/*
-- 생성자 :	윤현빈
-- 등록일 :	2024.04.25
-- 수정자 : 2024.10.03 강세미 - R_NO 기초정보 업데이트
-- 수정일 : - 
-- 설 명  : 시험성적서 저장
-- 실행문 : EXEC PR_TEST_REPORT_PUT_POPUP
*/
CREATE PROCEDURE [dbo].[PR_TEST_REPORT_PUT_POPUP]	
	@P_SCAN_CODE		VARCHAR(14),
	@P_PROD_DT			VARCHAR(10),
	@P_LOT_NO			VARCHAR(30),
	@P_CHAR_RESULT		VARCHAR(30),
	@P_ACID_RESULT		DECIMAL(15,3),
	@P_PEROXIDE_RESULT	DECIMAL(15,2),
	@P_LODINE_RESULT	DECIMAL(15,2),
	@P_COLOR_RESULT		VARCHAR(30),
	@P_BENXO_RESULT		VARCHAR(30),
	@P_R_NO				NVARCHAR(20),
	@P_EMP_ID			VARCHAR(20)
	
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	DECLARE @RETURN_CODE 	INT 			= 0		-- 리턴코드
	DECLARE @RETURN_MESSAGE NVARCHAR(10) 	= '' 	-- 리턴메시지
	
	BEGIN TRY
	
	-- 에러발생 테스트
		--select 1/0
		--DECLARE @V_R_NO NVARCHAR(20);
		--SELECT @V_R_NO = R_NO FROM PD_TEST_REPORT_INFO WHERE SCAN_CODE = @P_SCAN_CODE;

		DECLARE @LATEST_SCAN_CODE NVARCHAR(14);
		DECLARE @LATEST_PROD_DT NVARCHAR(8);
		DECLARE @LATEST_LOT_NO NVARCHAR(30);

		MERGE INTO PD_TEST_REPORT 		AS A
			USING (SELECT 1 AS DUAL) 	AS B
			ON (A.SCAN_CODE = @P_SCAN_CODE AND A.PROD_DT = @P_PROD_DT AND A.LOT_NO = @P_LOT_NO)
			WHEN MATCHED THEN
				UPDATE SET
					CHAR_RESULT 	= @P_CHAR_RESULT
				  , ACID_RESULT 	= @P_ACID_RESULT
				  , PEROXIDE_RESULT = @P_PEROXIDE_RESULT
				  , LODINE_RESULT 	= @P_LODINE_RESULT
				  , COLOR_RESULT 	= @P_COLOR_RESULT
				  , BENXO_RESULT 	= @P_BENXO_RESULT
				  , R_NO			= @P_R_NO
				  , UDATE			= GETDATE()
				  , UEMP_ID			= @P_EMP_ID
			WHEN NOT MATCHED THEN
				INSERT(
					SCAN_CODE
				  , PROD_DT
				  , LOT_NO
				  , CHAR_RESULT
				  , ACID_RESULT
				  , PEROXIDE_RESULT
				  , LODINE_RESULT
				  , COLOR_RESULT
				  , BENXO_RESULT
				  , R_NO
				  , IDATE
				  , IEMP_ID
				  , UDATE
				  , UEMP_ID
				)
				VALUES(
					@P_SCAN_CODE
				  , @P_PROD_DT
				  , @P_LOT_NO
				  , @P_CHAR_RESULT
				  , @P_ACID_RESULT
				  , @P_PEROXIDE_RESULT
				  , @P_LODINE_RESULT
				  , @P_COLOR_RESULT
				  , @P_BENXO_RESULT
				  , @P_R_NO
				  , GETDATE()
				  , @P_EMP_ID
				  , GETDATE()
				  , @P_EMP_ID
				)
			;
	
		SELECT TOP 1 @LATEST_SCAN_CODE = SCAN_CODE, @LATEST_PROD_DT = PROD_DT, @LATEST_LOT_NO = LOT_NO FROM PD_TEST_REPORT
		WHERE SCAN_CODE = @P_SCAN_CODE
		ORDER BY PROD_DT DESC

		-- 제일 신규 생성된 시험성적서일 경우 R_NO 기초정보 업데이트
		IF @LATEST_SCAN_CODE = @P_SCAN_CODE AND @LATEST_PROD_DT = @P_PROD_DT AND @LATEST_LOT_NO = @P_LOT_NO
		BEGIN
			UPDATE PD_TEST_REPORT_INFO SET R_NO = @P_R_NO WHERE SCAN_CODE = @P_SCAN_CODE;
		END
	

		SET @RETURN_CODE = 0
		SET @RETURN_MESSAGE = '저장되었습니다.'
	END TRY
	BEGIN CATCH		
		--에러 로그 테이블 저장
		INSERT INTO TBL_ERROR_LOG 
		SELECT ERROR_PROCEDURE()	-- 프로시저명
		, ERROR_MESSAGE()			-- 에러메시지
		, ERROR_LINE()				-- 에러라인
		, GETDATE();
		
		SET @RETURN_CODE = 9;
		SET @RETURN_MESSAGE = '저장 실패하였습니다.';
	END CATCH
	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE
END

GO
