/*
-- 생성자 :	윤현빈
-- 등록일 :	2024.06.17
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 입금내역 조회(미완)
-- 실행문 : EXEC PR_PARTNER_DEPOSIT_DTL_LIST 'UM20129','20240601','20240728'
*/
CREATE PROCEDURE [dbo].[PR_PARTNER_DEPOSIT_DTL_LIST]
( 
	@P_VEN_CODE		NVARCHAR(7) = '',	-- 거래처코드
	@P_FROM_DT		NVARCHAR(8) = '',	-- FROM 일자
	@P_TO_DT		NVARCHAR(8) = ''	-- TO 일자
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	BEGIN TRY 			
		SELECT 
			ROW_NUMBER() OVER(ORDER BY A.DEPOSIT_DT, A.DEPOSIT_NO) AS ROW_NUM,
			A.MOID,
			CONCAT(SUBSTRING(A.DEPOSIT_DT, 1,4), '-',SUBSTRING(A.DEPOSIT_DT, 5,2), '-', SUBSTRING(A.DEPOSIT_DT, 7,2)) AS DEPOSIT_DT,
			A.DEPOSIT_GB,
			B.CD_NM AS DEPOSIT_GB_NAME,
			A.DEPOSIT_NO,								--입금번호
			A.DEPOSIT_AMT,								--입금금액
			ISNULL(A.ISSUER_CODE, '') AS ISSUER_CODE,	--카드발급사코드
			ISNULL(TCD.CD_NM, '') AS ISSUER_CODE_NM,	--카드발급사명
			ISNULL(A.APP_NO, '') AS APP_NO,				--승인번호
			A.IDATE
		FROM PA_ACCT_DEPOSIT AS A
			INNER JOIN TBL_COMM_CD_MST AS B ON A.DEPOSIT_GB = B.CD_ID AND B.CD_CL = 'DEPOSIT_GB'			
			LEFT OUTER JOIN TBL_COMM_CD_MST AS TCD ON TCD.CD_CL = 'TOSS_CARD_XPAY' AND TCD.CD_ID = A.ISSUER_CODE
		WHERE A.DEPOSIT_DT BETWEEN @P_FROM_DT AND @P_TO_DT
			AND 1 = (CASE WHEN @P_VEN_CODE = '' THEN 1 WHEN @P_VEN_CODE != '' AND A.VEN_CODE = @P_VEN_CODE THEN 1 ELSE 2 END)
		ORDER BY A.DEPOSIT_DT ASC, A.IDATE ASC
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
