
/*
-- 생성자 :	윤현빈
-- 등록일 :	2024.02.21
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 메뉴 경로 위한 테스트 프로시저2 (*나중에 삭제 예정*)
-- 실행문 : 
EXEC PR_USER_ROLE_MENU_LNB_TEST 'admin'
*/
CREATE PROCEDURE [dbo].[PR_LNB_MENU_LIST_TEST]
	@P_MENU_CODE	NVARCHAR(100) = '',			-- 메뉴코드
	@P_DEL_YN			NVARCHAR(1) = '',				-- N : 미삭제, Y : 삭제	
	@P_LIST_TYPE		NVARCHAR(25) = 'JSON'		-- JSON, LIST

AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	BEGIN TRY 
		
		IF @P_MENU_CODE != ''		 
		BEGIN
		
			DECLARE @LOW_MENU_CODE NVARCHAR(25)
			DECLARE @LOW_SORT_ORDER INT = 0
			
			-- 하위메뉴 생성 코드 및 정렬순서 셋팅
			SELECT @LOW_MENU_CODE = (IIF(_MENU_CODE IS NULL, @P_MENU_CODE + '01', _MENU_CODE)), 
				@LOW_SORT_ORDER = (IIF(_SORT_ORDER IS NULL, 1, _SORT_ORDER))
			FROM (				
						SELECT 
							(	CASE LEN(_MENU_CODE)  
									WHEN 3 THEN '0' + _MENU_CODE 
									WHEN 5 THEN '0' + _MENU_CODE
								ELSE _MENU_CODE
								END 
							) AS _MENU_CODE,
							_SORT_ORDER 
						FROM (
							SELECT 
							CAST(_MENU_CODE AS VARCHAR) AS _MENU_CODE, 
							_SORT_ORDER 
							FROM (
								SELECT MAX(MENU_CODE) + 1 AS _MENU_CODE, 
								MAX(SORT_ORDER) + 1 AS _SORT_ORDER
							FROM TBL_MENU_INFO WHERE UP_MENU_CODE = @P_MENU_CODE
							) S1
						) S2												
			) S3
								
			SELECT 
				A.SEQ,
				A.MENU_CODE,
				A.MENU_NM,			
				A.MENU_GB,
				A.MENU_ICON,
				A.MENU_LINK,
				A.UP_MENU_CODE,
				IIF(A.SORT_ORDER IS NULL, 0, A.SORT_ORDER) AS SORT_ORDER,
				A.HELP,
				A.DEL_YN,
				@LOW_MENU_CODE AS LOW_MENU_CODE, 
				@LOW_SORT_ORDER AS LOW_SORT_ORDER,
				IIF(B.MENU_NM IS NULL, '', B.MENU_NM) AS UPPER_MENU_NM,
				'' AS MENU_NM_PATH
			FROM TBL_MENU_INFO AS A
				LEFT OUTER JOIN TBL_MENU_INFO AS B 
							ON A.UP_MENU_CODE = B.MENU_CODE				
			WHERE A.MENU_CODE = @P_MENU_CODE

		END 
		ELSE
		BEGIN
			IF @P_LIST_TYPE = 'JSON'
			BEGIN
			-- 메뉴 TREE 구조 JSON 형식으로 출력

				SELECT dbo.FN_MENU_INFO_TREE_JSON('', NULL, 0) AS RETURN_JSON;
			END
			ELSE
			BEGIN
			-- 메뉴 TREE LIST

					WITH TEMP_TBL
					AS (
						SELECT 							
							SEQ,
							MENU_CODE,
							MENU_NM,			
							MENU_GB,
							MENU_ICON,
							MENU_LINK,
							UP_MENU_CODE,
							SORT_ORDER,
							HELP,
							DEL_YN,
							CONVERT(VARCHAR(50), MENU_CODE) AS SORT
						FROM TBL_MENU_INFO
						WHERE  UP_MENU_CODE = ''
						UNION ALL
						SELECT 
							DM.SEQ,
							DM.MENU_CODE,
							DM.MENU_NM,			
							DM.MENU_GB,
							DM.MENU_ICON,
							DM.MENU_LINK,
							DM.UP_MENU_CODE,
							DM.SORT_ORDER,
							DM.HELP,
							DM.DEL_YN,		
							CONVERT(VARCHAR(50), CONVERT(NVARCHAR, TT.SORT) + N' > ' + CONVERT(VARCHAR(255), dbo.FN_DEPT_CODE_SORT_CH(DM.MENU_CODE,DM.SORT_ORDER))) SORT
						FROM TBL_MENU_INFO AS DM,
							TEMP_TBL AS TT
						WHERE  DM.UP_MENU_CODE = TT.MENU_CODE							
					)
					SELECT 
							SEQ,
							MENU_CODE,
							MENU_NM,			
							MENU_GB,
							MENU_ICON,
							MENU_LINK,
							UP_MENU_CODE,
							SORT_ORDER,
							HELP,
							DEL_YN,
							'' AS LOW_MENU_CODE, 
							0 AS LOW_SORT_ORDER,
							'' AS UPPER_MENU_NM,
							'' AS MENU_NM_PATH
					FROM TEMP_TBL WHERE (@P_DEL_YN = '' OR (@P_DEL_YN <> '' AND @P_DEL_YN = DEL_YN))			
					ORDER  BY SORT


			END

					
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

