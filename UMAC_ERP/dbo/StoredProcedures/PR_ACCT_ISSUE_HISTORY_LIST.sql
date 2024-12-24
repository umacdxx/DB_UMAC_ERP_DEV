
/*
-- 생성자 :	이동호
-- 등록일 :	2024.06.07
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 거래처 가상계좌 발급 전체 내역 
-- 실행문 : 
	
EXEC PR_ACCT_ISSUE_HISTORY_LIST 'UM20127'

*/
 CREATE PROCEDURE [dbo].[PR_ACCT_ISSUE_HISTORY_LIST]
( 
	@P_VEN_CODE	NVARCHAR(7) = ''		-- 거래처코드
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	 
	BEGIN TRY 
		
		DECLARE @ISSUE_DT_DAY VARCHAR(8) = FORMAT(GETDATE(), 'yyyyMMdd')
		DECLARE @ISSUE_DT_TIME VARCHAR(8) = FORMAT(GETDATE(), 'HHmm')

		EXEC UMAC_CERT_OPEN_KEY; -- OPEN

		SELECT 
				ISSUE_DT,												--가상계좌 발행일
				VEN_CODE,												--거래처 코드
				TID,													--PG 거래아이디
				MOID,													--주문번호
				REQ_AMT,												--입금발행금액
				DEPOSIT_AMT,											--입금금액
				VACT_STAT,												--가상계좌 결제 처리상태 코드						
				(CASE WHEN VACT_STAT = 'WAITING_FOR_DEPOSIT' AND DUEDATE_STAT = '만료' THEN '만료' 
					ELSE VACT_STAT_NM END) AS VACT_STAT_NM,				--가상계좌 결제 처리상태 이름
				VACT_DATE,												--가상계좌 만료일자
				VACT_TIME,												--가상계좌 만료시간
				RECEIVE_YN,												--가상계좌 입금여부
				FORMAT(DEP_IDATE, 'yyyy.MM.dd HH:mm') AS DEP_IDATE,		--입금일자
				VACT_NO,												--가상계좌번호
				BANK_NM													--은행이름
		FROM (

			SELECT 
				AIS.ISSUE_DT,
				AIS.VEN_CODE,
				AIS.TID,
				AIS.MOID,
				AIS.REQ_AMT,
				AIS.DEPOSIT_AMT,
				AIS.VACT_STAT,
				dbo.GET_TOSS_STAT(AIS.VACT_STAT) AS VACT_STAT_NM,
				AIS.VACT_DATE,
				AIS.VACT_TIME,				
				AIS.RECEIVE_YN,
				ADE.IDATE AS DEP_IDATE,
				(CASE WHEN (@ISSUE_DT_DAY + @ISSUE_DT_TIME) > (AIS.VACT_DATE + AIS.VACT_TIME) THEN '만료' ELSE '' END) AS DUEDATE_STAT,
				AIS.IDATE,
				ISNULL(DBO.GET_DECRYPT(AIS.VACT_NO), '') AS VACT_NO,								
				ISNULL(COM.CD_NM, '') AS BANK_NM													
			FROM PA_ACCT_ISSUE AS AIS				
				LEFT OUTER JOIN PA_ACCT_DEPOSIT AS ADE ON AIS.MOID = ADE.MOID				
				LEFT OUTER JOIN TBL_COMM_CD_MST AS COM ON COM.CD_CL='TOSS_BANK' AND COM.CD_ID = AIS.BANK_CODE
				WHERE AIS.VEN_CODE = @P_VEN_CODE
					AND AIS.REQ_AMT > 1
		) AS T ORDER BY IDATE DESC
			
		EXEC UMAC_CERT_CLOSE_KEY; -- CLOSE

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

