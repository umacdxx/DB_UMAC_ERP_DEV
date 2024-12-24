/*
-- 생성자 :	강세미
-- 등록일 :	2024.01.09
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 권한그룹 마스터 저장
-- 실행문 : EXEC PR_ROLE_MST_PUT 'ROLE01','시스템관리자','시스템관리자','Y','admin'
*/
CREATE PROCEDURE [dbo].[PR_ROLE_MST_PUT]
	@P_ROLE_ID NVARCHAR(6),					-- 권한그룹코드
	@P_ROLE_NM NVARCHAR(100), 				-- 권한그룹명
	@P_ROLE_DC NVARCHAR(100), 				-- 설명
	@P_USE_YN NVARCHAR(1), 					-- 사용여부
	@P_EMP_ID NVARCHAR(20) 					-- 아이디
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @ROLE_YN VARCHAR(1) = 'N'	-- 권한그룹코드 유무
	DECLARE @NEW_ROLE_ID NVARCHAR(6)		-- 신규권한그룹코드
	DECLARE @RETURN_CODE INT = 0			-- 리턴코드
	DECLARE @RETURN_MESSAGE NVARCHAR(10) = ''		-- 리턴메시지

	BEGIN TRY 
		 -- 해당 코드 있는지 확인
		IF EXISTS (
			SELECT 1 
			  FROM TBL_ROLE_MST
			 WHERE ROLE_ID = @P_ROLE_ID
		)
		BEGIN
			SET @ROLE_YN = 'Y'
		END

		IF @ROLE_YN = 'Y' 
			BEGIN
				UPDATE TBL_ROLE_MST
					SET ROLE_NM = @P_ROLE_NM
					  , ROLE_DC = @P_ROLE_DC
					  , USE_YN = @P_USE_YN
					  , UDATE = GETDATE()
					  , UEMP_ID = @P_EMP_ID
				 WHERE ROLE_ID = @P_ROLE_ID
				 
				DELETE TBL_ROLE_MENU
				 WHERE ROLE_ID = @P_ROLE_ID

			END
		ELSE
			--권한그룹코드 생성
			BEGIN
				SELECT @NEW_ROLE_ID = ISNULL(MAX(SUBSTRING(ROLE_ID,5,6)),0) + 1
				  FROM TBL_ROLE_MST

				IF LEN(@NEW_ROLE_ID) = 1
					BEGIN
						SET @NEW_ROLE_ID = 'ROLE0' + @NEW_ROLE_ID
					END
				ELSE 
					BEGIN
						SET @NEW_ROLE_ID = 'ROLE' + @NEW_ROLE_ID
				   END
			
			INSERT INTO TBL_ROLE_MST(
							ROLE_ID,
							ROLE_NM,
							ROLE_DC,
							USE_YN,
							IDATE,
							IEMP_ID
							) VALUES (
							@NEW_ROLE_ID,
							@P_ROLE_NM,
							@P_ROLE_DC,
							@P_USE_YN,
							GETDATE(),
							@P_EMP_ID
							)

			END

		SET @RETURN_CODE = 0 -- 저장완료
		SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('0')

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

