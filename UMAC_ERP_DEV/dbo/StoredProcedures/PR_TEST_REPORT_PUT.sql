/*
-- 생성자 :	윤현빈
-- 등록일 :	2024.05.10
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 시험성적서 기초정보 저장
-- 실행문 : EXEC PR_TEST_REPORT_PUT 
*/
CREATE PROCEDURE [dbo].[PR_TEST_REPORT_PUT]

	@P_MODE				NVARCHAR(1),
	@P_SCAN_CODE		NVARCHAR(14),
	@P_RAW_MATERIALS	NVARCHAR(100),
	@P_ITM_PROD_NO		NVARCHAR(20),
	@P_CHAR				NVARCHAR(50),
	@P_ACID				NVARCHAR(30),
	@P_PEROXIDE			NVARCHAR(30),
	@P_LODINE			NVARCHAR(30),
	@P_COLOR			NVARCHAR(50),
	@P_BENXO			NVARCHAR(30),
	@P_R_NO				NVARCHAR(20),
	@P_COLOR_TYPE		NVARCHAR(200),
	@P_EMP_ID			NVARCHAR(20)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	DECLARE @RETURN_CODE INT = 0			-- 리턴코드
	DECLARE @RETURN_MESSAGE NVARCHAR(10) = ''		-- 리턴메시지

	BEGIN TRY 
		
		IF @P_MODE = 'D'
		BEGIN
			DELETE PD_TEST_REPORT_INFO WHERE SCAN_CODE = @P_SCAN_CODE;
		END
		
		ELSE  
		BEGIN
			MERGE INTO PD_TEST_REPORT_INFO AS A
			USING (SELECT 1 DUAL) AS B
				ON (A.SCAN_CODE = @P_SCAN_CODE)
			WHEN MATCHED THEN 
				UPDATE SET
  				    A.ITM_PROD_NO = @P_ITM_PROD_NO
  				  , A.RAW_MATERIALS = @P_RAW_MATERIALS
  				  , A.CHAR = @P_CHAR
  				  , A.ACID = @P_ACID
  				  , A.PEROXIDE = @P_PEROXIDE
  				  , A.LODINE = @P_LODINE
  				  , A.COLOR = @P_COLOR
  				  , A.BENXO = @P_BENXO
  				  , A.R_NO = @P_R_NO
				  , A.COLOR_TYPE = @P_COLOR_TYPE
				  , A.UDATE = GETDATE()
				  , A.UEMP_ID = @P_EMP_ID
  			WHEN NOT MATCHED THEN 
  				INSERT 
  				(
  					SCAN_CODE
				  , ITM_PROD_NO
				  , RAW_MATERIALS
				  , CHAR
				  , ACID
				  , PEROXIDE
				  , LODINE
				  , COLOR
				  , BENXO
				  , R_NO
				  , COLOR_TYPE
				  , IDATE
				  , IEMP_ID
				  , UDATE
				  , UEMP_ID
  				)
  				VALUES 
  				(
				    @P_SCAN_CODE
				  , @P_ITM_PROD_NO
				  , @P_RAW_MATERIALS
				  , @P_CHAR
				  , @P_ACID
				  , @P_PEROXIDE
				  , @P_LODINE
				  , @P_COLOR
				  , @P_BENXO
				  , @P_R_NO
				  , @P_COLOR_TYPE
				  , GETDATE()
				  , @P_EMP_ID
				  , GETDATE()
				  , @P_EMP_ID
  				)
  				;
		END
		
		SET @RETURN_CODE = 0 -- 저장되었습니다.
		SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('0')

	END TRY
	BEGIN CATCH		
		--에러 로그 테이블 저장
		INSERT INTO TBL_ERROR_LOG 
		SELECT ERROR_PROCEDURE()	-- 프로시저명
		, ERROR_MESSAGE()			-- 에러메시지
		, ERROR_LINE()				-- 에러라인
		, GETDATE()	

		SET @RETURN_CODE = -1 -- 저장실패
		SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('-1')
	END CATCH
	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE
END

GO

