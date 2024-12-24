/*
-- 생성자 :	임현태	
-- 등록일 :	2024.11.08
-- 수정자 : 임현태
-- 수정일 : 2024.11.12
			- 공지 구분 이름값 반환
			2024.11.13
			- 공지 리스트 요청 분기처리 공지등록페이지 & 공지 조회 버튼
-- 설 명  : 공지사항 리스트 RETURN
*/
CREATE PROCEDURE [dbo].[PR_NOTI_LIST]
(
	@P_RETURN_TYPE	NVARCHAR(1),	-- 리턴 구분 (1: getNotiList, 2: getActiveNoti, 3: getNewNotiNo)
	@P_NOTI_GB		NVARCHAR(2),	-- 공지 구분
	@P_NOTI_TITLE	NVARCHAR(100),	-- 공지 제목
	@P_DEL_YN		NVARCHAR(1),	-- 삭제 여부
	@P_START_DT		NVARCHAR(10),	-- 조회 시작 날짜
	@P_END_DT		NVARCHAR(10)	-- 조회 종료 날짜
)
AS
BEGIN
   SET NOCOUNT ON;
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	BEGIN TRY 

	IF(@P_RETURN_TYPE = '1')
		BEGIN

			SELECT A.NOTI_NO,									-- 공지 코드
				   B.CD_NM AS NOTI_GB_NM,						-- 공지 구분명
				   A.NOTI_GB,									-- 공지 구분
				   A.NOTI_TITLE,								-- 공지 제목
				   A.CONTENTS,									-- 내용	
				   A.DEL_YN,									-- 삭제여부
				   CONVERT(NVARCHAR(10), A.IDATE, 23) AS IDATE	--등록날짜			
			FROM TBL_NOTI AS A 
			INNER JOIN TBL_COMM_CD_MST AS B 
				ON B.CD_CL = 'NOTI_GB' AND A.NOTI_GB = B.CD_ID 
			WHERE A.NOTI_TITLE LIKE (CASE WHEN @P_NOTI_TITLE <> '' THEN '%'+ @P_NOTI_TITLE +'%' ELSE A.NOTI_TITLE END)
				AND A.NOTI_GB = (CASE WHEN @P_NOTI_GB <> '' THEN @P_NOTI_GB ELSE A.NOTI_GB END)
				AND A.DEL_YN = (CASE WHEN @P_DEL_YN <> '' THEN @P_DEL_YN ELSE A.DEL_YN END)
				AND 1 = (CASE WHEN CONVERT(NVARCHAR(10), A.IDATE, 23) BETWEEN @P_START_DT AND @P_END_DT THEN 1 ELSE 0 END)
			
			ORDER BY A.NOTI_NO DESC

		END
	ELSE IF(@P_RETURN_TYPE = '2')
		BEGIN

			SELECT NOTI_NO,				-- 공지 코드
				   '' AS NOTI_GB_NM,	-- 공지 구분명
				   '' AS NOTI_GB,		-- 공지 구분
				   NOTI_TITLE,			-- 공지 제목
				   CONTENTS,			-- 내용	
				   DEL_YN,				-- 삭제여부
				   '' AS IDATE			-- 등록날짜
			FROM TBL_NOTI 			
			WHERE NOTI_NO = (SELECT TOP 1 NOTI_NO 
							 FROM TBL_NOTI 
							 WHERE DEL_YN = (CASE WHEN @P_DEL_YN <> '' THEN @P_DEL_YN ELSE DEL_YN END) 
							 ORDER BY NOTI_NO DESC)

		END
	ELSE IF(@P_RETURN_TYPE = '3')
		BEGIN 

			SELECT NOTI_NO,				-- 공지 코드
				   '' AS NOTI_GB_NM,	-- 공지 구분명
				   '' AS NOTI_GB,		-- 공지 구분
				   '' AS NOTI_TITLE,	-- 공지 제목
				   '' AS CONTENTS,		-- 내용	
				   '' AS DEL_YN,		-- 삭제여부
				   '' AS IDATE			-- 등록날짜 
			FROM TBL_NOTI

		END
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

