
/*
-- 생성자 : 이동호
-- 등록일 : 2023.01.18
-- 수정자 : -
-- 수정일 : - 
-- 설 명	: 거래처 마스터 신규 거래처코드 출력
-- 실행문 : 
EXEC PR_PARTNER_MST_NEW_VEN_CODE '1'
*/
CREATE PROCEDURE [dbo].[PR_PARTNER_MST_NEW_VEN_CODE]
( 
	@P_VEN_GB		NVARCHAR(1) = ''	-- 거래처구분	
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @RETURN_CODE INT = 0							-- 리턴코드
	DECLARE @RETURN_MESSAGE NVARCHAR(10) = ''		-- 리턴메시지

	DECLARE @UM NVARCHAR(2) = 'UM'			

	BEGIN TRY 
	
		SELECT @RETURN_MESSAGE = (@UM + @P_VEN_GB + VEN_CODE) FROM (
			SELECT 
				CASE LEN(CODE) 
					WHEN 1 THEN '000' + CODE
					WHEN 2 THEN '00' + CODE
					WHEN 3 THEN '0' + CODE
					ELSE CODE
				END AS VEN_CODE
			FROM (
				SELECT 
						IIF(VEN_CODE IS NULL, '0001', VEN_CODE) AS CODE
					FROM (
						SELECT CAST(MAX(SUBSTRING(VEN_CODE, 4, 7)) + 1 AS VARCHAR) AS VEN_CODE 
								FROM CD_PARTNER_MST 
									WHERE SUBSTRING(VEN_CODE, 1, 3) = @UM + @P_VEN_GB
									--------------------------------------------------------------------------------------------------------------------
									-- 20240920 윤현빈, 테스트 거래처코드 때문에 새로운 거래처가 따이지 않아서 아래 코드 추가
									-- 테스트 위해 추가한 부분, 삭제해도 무방
									  and VEN_CODE not in ('UM29997','UM29998','UM29999','UM19994','UM19995','UM19996','UM19997','UM19998','UM19999')
									--------------------------------------------------------------------------------------------------------------------
				) AS T1 
			) AS T2
		) AS T3

	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE

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

