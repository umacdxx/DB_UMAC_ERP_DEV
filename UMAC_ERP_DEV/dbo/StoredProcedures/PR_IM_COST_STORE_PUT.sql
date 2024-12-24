/*
-- 생성자 :	강세미
-- 등록일 :	2024.05.23
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 제비용거래처 저장
-- 실행문 : EXEC PR_IM_COST_STORE_PUT
*/
CREATE PROCEDURE [dbo].[PR_IM_COST_STORE_PUT] 
	@P_COST_VEN_CODE	NVARCHAR(20),				-- 제비용거래처코드
	@P_COST_VEN_NAME	NVARCHAR(50),				-- 제비용항목코드
	@P_BUSI_NO			NVARCHAR(13),				-- 제비용항목명
	@P_NOTE				NVARCHAR(100),				-- 적요
	@P_MODE				NVARCHAR(1)					-- I: 등록 U: 수정 D: 삭제
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	 
	DECLARE @RETURN_CODE INT = 0						-- 리턴코드(저장완료)
	DECLARE @RETURN_MESSAGE NVARCHAR(10) = DBO.GET_ERR_MSG('0')		-- 리턴메시지

	BEGIN TRY 
	 
		IF @P_MODE = 'I'
			BEGIN
				IF EXISTS (SELECT COST_VEN_CODE FROM IM_COST_STORE WHERE COST_VEN_CODE = @P_COST_VEN_CODE)
					BEGIN
						SET @RETURN_CODE = -1 -- 저장실패
						SET @RETURN_MESSAGE = '중복되는 거래처코드가 있습니다.'
					END
				ELSE
					BEGIN
						INSERT INTO IM_COST_STORE(
									COST_VEN_CODE,
									COST_VEN_NAME,
									BUSI_NO,
									NOTE,
									REG_DTTM) 
									VALUES (
									@P_COST_VEN_CODE,
									@P_COST_VEN_NAME,
									@P_BUSI_NO,
									@P_NOTE,
									GETDATE()
									)

					END
			END
		ELSE IF @P_MODE = 'U'
			BEGIN
				UPDATE IM_COST_STORE
					SET COST_VEN_NAME = @P_COST_VEN_NAME,
						BUSI_NO = @P_BUSI_NO,
						NOTE = @P_NOTE
				  WHERE COST_VEN_CODE = @P_COST_VEN_CODE
			END
		ELSE
			BEGIN
				DELETE IM_COST_STORE
					WHERE COST_VEN_CODE = @P_COST_VEN_CODE
			END 
			 
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

