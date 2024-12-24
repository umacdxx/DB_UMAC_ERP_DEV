/*
-- 생성자 :	강세미
-- 등록일 :	2023.12.18
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 공통코드 리스트/상세 출력
-- 실행문 : 
EXEC PR_COMM_CODE_LIST  '', '', 'N'
EXEC PR_COMM_CODE_LIST  '', 'POSITION', 'N'
EXEC PR_COMM_CODE_LIST  '0000', '은행', null
EXEC PR_COMM_CODE_LIST  null, 'IM_OPEN_BANK', null
*/
CREATE PROCEDURE [dbo].[PR_COMM_CODE_LIST]
( 
	@P_CD_CL		   NVARCHAR(100) = '',	-- 공통코드('0000' : 리스트 조회 '' : 상세조회)
	@P_CD_NM		   NVARCHAR(100) = '',	-- 코드명
	@P_USE_YN		   NVARCHAR(1) = '',		-- Y: 사용, N: 미사용
	@P_SORT			   NVARCHAR(100) = ''		-- 정렬할 컬럼
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	BEGIN TRY 
	
	SET @P_CD_CL = IIF(@P_CD_CL IS NULL, '', @P_CD_CL)
	SET @P_CD_NM = IIF(@P_CD_NM IS NULL, '', @P_CD_NM)
	SET @P_USE_YN = IIF(@P_USE_YN IS NULL, '', @P_USE_YN)
	
	SELECT * FROM (
		 SELECT ROW_NUMBER() OVER(ORDER BY SORT_ORDER, CD_NM) AS ROW_NUM
				, CD_CL
				, CD_ID
				, CD_NM
				, CD_SHORT_NM
				, CD_DESCRIPTION
				, SORT_ORDER
				, MGMT_ENTRY_1
				, MGMT_ENTRY_DESCRIPTION_1
				, MGMT_ENTRY_2
				, MGMT_ENTRY_DESCRIPTION_2
				, MGMT_ENTRY_3
				, MGMT_ENTRY_DESCRIPTION_3
            , DEL_YN
         FROM TBL_COMM_CD_MST
        WHERE ((@P_CD_CL <> '0000' AND CD_CL <> '0000') OR (@P_CD_CL = '0000' AND CD_CL = '0000' AND CD_ID <> '0000'))
			  AND ((@P_CD_CL <> '0000' AND (CD_CL = ISNULL(@P_CD_NM, CD_CL))) 
				  OR (@P_CD_CL = '0000' AND CD_ID <> '0000' AND (CD_ID LIKE '%' + ISNULL(@P_CD_NM, CD_ID) + '%' OR CD_NM LIKE '%' + ISNULL(@P_CD_NM, CD_NM) + '%'))) 
			  AND DEL_YN = (CASE WHEN @P_USE_YN = '' THEN DEL_YN ELSE @P_USE_YN END)			
	  ) AS TBL ORDER BY SORT_ORDER ASC, CD_CL
	 
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

