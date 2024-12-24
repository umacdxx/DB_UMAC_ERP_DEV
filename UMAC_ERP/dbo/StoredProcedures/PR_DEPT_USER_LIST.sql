
/*
-- 생성자		: 이동호
-- 등록일		: 2024.01.02
-- 수정자		: 
-- 수정일		:  
-- 설 명		: 조직별 구성원(직원) 목록
-- 실행문		: 
EXEC PR_DEPT_USER_LIST '01020201'
*/
CREATE PROCEDURE [dbo].[PR_DEPT_USER_LIST]
(
	@P_DEPT_CODE	NVARCHAR(25) = ''		-- 조직코드		
)
AS
BEGIN
EXEC UMAC_CERT_OPEN_KEY; -- OPEN
	
	BEGIN TRY 				
	OPEN SYMMETRIC KEY UMAC_CERT_KEY DECRYPTION BY CERTIFICATE UMAC_CERT;
			SELECT 
				T1.[USER_ID],							--아이디
				T1.USER_NM,							--담당자 이름
				T1.ROLE_ID,							--권한그룹				
				T1.DEPT_CODE,						--조직코드
				T2.DEPT_NAME,						--조직명
				T1.POSITION,							--직급
				T1.PWD_COUNT,						--오류횟수
				T1.JOB_FLAG,							--제직구분			
				DBO.GET_DECRYPT(T1.MOBIL_NO) as MOBIL_NO,	--휴대폰번호
				T4.CD_NM AS POSITION_NM,		-- 직급명
				T3.ROLE_NM,							--권한그룹이름
				'' AS JOB_FLAG_NM,
				CAST(0 AS BIGINT) AS ROW_NUM
			FROM TBL_USER_MST AS T1
				LEFT OUTER JOIN TBL_DEPT_MST AS T2 
					ON T1.DEPT_CODE = T2.DEPT_CODE	
				LEFT OUTER JOIN TBL_ROLE_MST AS T3
					ON T1.ROLE_ID = T3.ROLE_ID	
				LEFT OUTER JOIN TBL_COMM_CD_MST AS T4
					ON T1.POSITION = T4.CD_ID AND T4.CD_CL='POSITION'	
					
			WHERE (@P_DEPT_CODE = '' OR (@P_DEPT_CODE <> '' AND @P_DEPT_CODE = T1.DEPT_CODE))			
	EXEC UMAC_CERT_CLOSE_KEY -- CLOSE
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

