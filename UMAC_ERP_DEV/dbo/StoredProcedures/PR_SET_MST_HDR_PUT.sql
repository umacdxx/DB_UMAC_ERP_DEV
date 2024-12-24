/*
-- 생성자 :	강세미
-- 등록일 :	2024.01.31
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : SET 마스터 HDR 저장
-- 실행문 : EXEC PR_SET_MST_HDR_PUT '','SET_NAME','210005','Y','admin', 'I'
-- 실행문 : EXEC PR_SET_MST_HDR_PUT '001','수정수정','8801052951720','N','admin', 'U'
-- SELECT * FROM TBL_COMM_CD_MST
*/
CREATE PROCEDURE [dbo].[PR_SET_MST_HDR_PUT]
	@P_SET_CD NVARCHAR(3),			-- SET코드
	@P_SET_NAME NVARCHAR(100), 		-- SET이름
	@P_SET_PROD_CD NVARCHAR(14), 	-- SET생산품 코드	
	@P_USE_YN NVARCHAR(1),			-- 사용여부
	@P_EMP_ID NVARCHAR(20), 		-- 아이디
	@P_MODE NVARCHAR(1) 		
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @SET_PROD_CD_YN VARCHAR(1) = 'N'				-- 코드유무여부
	DECLARE @NEW_SET_CD NVARCHAR(3) = ''			-- SET코드
	DECLARE @RETURN_CODE INT = 0						-- 리턴코드(저장완료)
	DECLARE @RETURN_MESSAGE NVARCHAR(10) = DBO.GET_ERR_MSG('0')		-- 리턴메시지

	BEGIN TRY 
		IF @P_MODE = 'I'
			BEGIN
				SELECT @NEW_SET_CD = ISNULL(MAX(SET_CD) + 1,'001') FROM CD_SET_HDR
				IF LEN(@NEW_SET_CD) = 1
					BEGIN
						SET @NEW_SET_CD = CONCAT('00',@NEW_SET_CD)
					END
				ELSE IF LEN(@NEW_SET_CD) = 2
					BEGIN
						SET @NEW_SET_CD = CONCAT('0',@NEW_SET_CD)
					END

				INSERT INTO CD_SET_HDR(
								SET_CD,
								SET_NAME,
								SET_PROD_CD,								
								USE_YN,
								IDATE,
								IEMP_ID
								) VALUES (
								@NEW_SET_CD,
								@P_SET_NAME,
								@P_SET_PROD_CD,								
								@P_USE_YN,
								GETDATE(), 
								@P_EMP_ID
								)
				END
		ELSE IF @P_MODE = 'U'
			BEGIN
				UPDATE CD_SET_HDR
					SET SET_NAME = @P_SET_NAME,
						 SET_PROD_CD = @P_SET_PROD_CD,						
						 USE_YN = @P_USE_YN,
						 UDATE = GETDATE(),
						 UEMP_ID = @P_EMP_ID
				 WHERE SET_CD = @P_SET_CD
			END
		ELSE
			BEGIN
				DELETE CD_SET_HDR
					WHERE SET_CD = @P_SET_CD

				DELETE CD_SET_DTL
					WHERE SET_CD = @P_SET_CD
			END


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

