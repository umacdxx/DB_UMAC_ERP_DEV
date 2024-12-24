
/*
-- 생성자 :	이동호
-- 등록일 :	2024.05.17
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 가상계좌 주문번호 생성
-- 실행문 : 
PR_ACCT_ORDER_ID 'UM20127'
*/
CREATE PROCEDURE [dbo].[PR_ACCT_ORDER_ID]
	@P_VEN_CODE		NVARCHAR(7) =''				--거래처코드	
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	BEGIN TRY 
				
		DECLARE @MOID VARCHAR(100) = FORMAT(GETDATE(), 'yyyyMMddHHmmssffff')
		

		--# 중복된 주문번호가 있는지 체크
		IF EXISTS(SELECT MOID FROM PA_ACCT_ISSUE WHERE MOID = @MOID)
		BEGIN
			--# 만약 매칭된 주문번호가 있다면 +1 해준다.
			SET @MOID = CAST((CAST(@MOID AS BIGINT) + 1) AS VARCHAR)
		END

		SELECT 
			@MOID AS MOID,					--토스 : orderId
			@P_VEN_CODE AS VACT_NO_KEY		--토스 고정식 가상계좌 key : accountKey

		/*
		--# 해당 거래처가 이미 발급된 가상계좌가 있는지 체크
		IF EXISTS(SELECT VEN_CODE FROM PA_ACCT_MST WHERE VEN_CODE = @P_VEN_CODE)
		BEGIN
			SELECT 
				'-1' AS MOID,					--토스 : -1 : 실패
				'' AS VACT_NO_KEY				--토스 고정식 가상계좌 key : accountKey
		END
		ELSE
		BEGIN
			--# 중복된 주문번호가 있는지 체크
			IF EXISTS(SELECT MOID FROM PA_ACCT_ISSUE WHERE MOID = @MOID)
			BEGIN
				--# 만약 매칭된 주문번호가 있다면 +1 해준다.
				SET @MOID = CAST((CAST(@MOID AS BIGINT) + 1) AS VARCHAR)
			END

			SELECT 
				@MOID AS MOID,					--토스 : orderId
				@P_VEN_CODE AS VACT_NO_KEY		--토스 고정식 가상계좌 key : accountKey
		END
		*/

		
	END TRY
	BEGIN CATCH		
		--에러 로그 테이블 저장
		INSERT INTO TBL_ERROR_LOG 
		SELECT ERROR_PROCEDURE()	-- 프로시저명
		, ERROR_MESSAGE()			-- 에러메시지
		, ERROR_LINE()				-- 에러라인
		, GETDATE()	
	END CATCH
END

GO

