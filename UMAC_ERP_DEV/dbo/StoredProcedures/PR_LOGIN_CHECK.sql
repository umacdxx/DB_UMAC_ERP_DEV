/*
-- 생성자 :	강세미
-- 등록일 :	2023.12.11
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 로그인 체크
-- 실행문 : EXEC PR_LOGIN_CHECK 'admin', '1234'
*/
CREATE PROCEDURE [dbo].[PR_LOGIN_CHECK]
	@P_USER_ID NVARCHAR(20),			-- 아이디
	@P_PASSWD_NO NVARCHAR(256) 	   -- 패스워드
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @USER_ID NVARCHAR(20) = ''			-- 조회한 아이디
	DECLARE @PASSWD_NO BINARY(20)				-- 조회한 패스워드
	DECLARE @PWD_COUNT INT = 0					-- 로그인 실패 횟수
	DECLARE @PASSWD_NO_B BINARY(20)				-- 암호화 패스워드
	DECLARE @USER_ID_B BINARY(20)				-- 암호화 아이디(2024.02.06 추가)
	DECLARE @JOB_FLAG NVARCHAR(2)				-- 재직구분

	--RETURN_CODE -9: 로그인 횟수 초과
	--				  -2: 비밀번호 불일치
	--				  -3: 최초로그인
	--				  -4: 퇴직자
	--				   0: 성공
	--				  -1: 계정정보없음(USER_ID 없음)

	BEGIN TRY 
	EXEC UMAC_CERT_OPEN_KEY; -- OPEN
	-- 받아온 패스워드 암호화
	SET @PASSWD_NO_B = CONVERT(BINARY(20), HASHBYTES('SHA1',@P_PASSWD_NO))
	SET @USER_ID_B = CONVERT(BINARY(20), HASHBYTES('SHA1',@P_USER_ID))
	--
	-- 계정 조회
	SELECT @USER_ID = USER_ID, @PASSWD_NO = PASSWD_NO, @PWD_COUNT = PWD_COUNT, @JOB_FLAG = JOB_FLAG FROM TBL_USER_MST WHERE USER_ID = @P_USER_ID
	
	IF @PWD_COUNT > 5
		BEGIN
			SELECT -9 AS RETURN_CODE,  
						 '로그인 횟수 초과로 로그인이 불가합니다. 관리자에게 문의해주세요.' AS RETURN_MESSAGE,  
						 '' AS USER_ID,
						 '' AS USER_NM,
						 '' AS ROLE_ID,
						 '' AS DEPT_CODE,
						 '' AS DEPT_NAME,
						 '' AS POSITION,
						 0 AS PWD_COUNT,
						 '' AS JOB_FLAG,
						 '' AS MOBIL_NO	
		END
	ELSE
		BEGIN
			IF @USER_ID != '' 
				BEGIN 
				-- 패스워드 틀렸을 경우
				IF @PASSWD_NO != @PASSWD_NO_B 
					BEGIN 			
						--로그인 실패 COUNT UPDATE
						UPDATE TBL_USER_MST SET PWD_COUNT = (@PWD_COUNT + 1)  WHERE USER_ID = @P_USER_ID
			
						SELECT -2 AS RETURN_CODE,  
								 '비밀번호가 일치하지 않습니다.' AS RETURN_MESSAGE,  
								 '' AS USER_ID,
								 '' AS USER_NM,
								 '' AS ROLE_ID,
								 '' AS DEPT_CODE,
								 '' AS DEPT_NAME,
								 '' AS POSITION,
								 @PWD_COUNT + 1 AS PWD_COUNT,
								 '' AS JOB_FLAG,
								 '' AS MOBIL_NO	
				END 
			ELSE
				BEGIN
					
					-- 퇴직자
					IF @JOB_FLAG = '02'
						BEGIN
							SELECT -4 AS RETURN_CODE,  
							 '사용불가한 계정입니다.' AS RETURN_MESSAGE,  
							 '' AS USER_ID,
							 '' AS USER_NM,
							 '' AS ROLE_ID,
							 '' AS DEPT_CODE,
							 '' AS DEPT_NAME,
							 '' AS POSITION,
							 0 AS PWD_COUNT,
							 '' AS JOB_FLAG,
							 '' AS MOBIL_NO	
						END

					-- 최초 로그인
					IF @PASSWD_NO_B = @USER_ID_B
						BEGIN
							SELECT -3 AS RETURN_CODE,  
							 '최초 로그인 시 비밀번호 변경 후 로그인이 가능합니다.' AS RETURN_MESSAGE,  
							 '' AS USER_ID,
							 '' AS USER_NM,
							 '' AS ROLE_ID,
							 '' AS DEPT_CODE,
							 '' AS DEPT_NAME,
							 '' AS POSITION,
							 0 AS PWD_COUNT,
							 '' AS JOB_FLAG,
							 '' AS MOBIL_NO	
						END
					ELSE
						BEGIN
							--로그인 실패 COUNT 초기화
							UPDATE TBL_USER_MST SET PWD_COUNT = 0  WHERE USER_ID = @P_USER_ID

							SELECT 0 AS RETURN_CODE,  
									 '로그인 성공' AS RETURN_MESSAGE,
									 USER_ID,
									 USER_NM,
									 ROLE_ID,
									 A.DEPT_CODE,
									 B.DEPT_NAME,
									 POSITION,
									 PWD_COUNT,
									 JOB_FLAG,
									 --MOBIL_NO
									 DBO.GET_DECRYPT(MOBIL_NO) AS MOBIL_NO
							  FROM TBL_USER_MST AS A
									INNER JOIN TBL_DEPT_MST AS B
									ON A.DEPT_CODE = B.DEPT_CODE
							 WHERE USER_ID = @P_USER_ID	
						END
			
				END 
			END
		ELSE
			BEGIN
					SELECT -1 AS RETURN_CODE,  
							 '계정 정보가 없습니다.' AS RETURN_MESSAGE,
							 '' AS USER_ID,
							 '' AS USER_NM,
							 '' AS ROLE_ID,
							 '' AS DEPT_CODE,
							 '' AS DEPT_NAME,
							 '' AS POSITION,
							 0 AS PWD_COUNT,
							 '' AS JOB_FLAG,
							 '' AS MOBIL_NO			
			END
		END
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

