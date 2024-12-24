/*
-- 생성자 :	강세미
-- 등록일 :	2024.01.30
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : BOM 마스터 HDR 저장
-- 실행문 : EXEC PR_BOM_MST_HDR_PUT '','BOM_NAME','Y','admin', 'I'
-- 실행문 : EXEC PR_BOM_MST_HDR_PUT '001','수정수정','8801052951720','N','admin', 'U'
-- SELECT * FROM TBL_COMM_CD_MST
*/
CREATE PROCEDURE [dbo].[PR_BOM_MST_HDR_PUT]
	@P_BOM_CD NVARCHAR(3),			-- BOM코드
	@P_BOM_NAME NVARCHAR(100), 		-- BOM이름
	@P_BOM_PROD_CD NVARCHAR(14), 	-- BOM생산품 코드	
	@P_USE_YN NVARCHAR(1),			-- 사용여부
	@P_EMP_ID NVARCHAR(20), 		-- 아이디
	@P_MODE NVARCHAR(1) 		
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @NEW_BOM_CD NVARCHAR(3) = ''			-- BOM코드
	DECLARE @RETURN_CODE INT = 0						-- 리턴코드
	DECLARE @RETURN_MESSAGE NVARCHAR(10) = '저장되었습니다.'		-- 리턴메시지

	BEGIN TRY 
		IF @P_MODE = 'I'
			BEGIN
				SELECT @NEW_BOM_CD = ISNULL(MAX(BOM_CD) + 1,'001') FROM CD_BOM_HDR
				IF LEN(@NEW_BOM_CD) = 1
					BEGIN
						SET @NEW_BOM_CD = CONCAT('00',@NEW_BOM_CD)
					END
				ELSE IF LEN(@NEW_BOM_CD) = 2
					BEGIN
						SET @NEW_BOM_CD = CONCAT('0',@NEW_BOM_CD)
					END

				INSERT INTO CD_BOM_HDR(
								BOM_CD,
								BOM_NAME,
								BOM_PROD_CD,								
								USE_YN,
								IDATE,
								IEMP_ID
								) VALUES (
								@NEW_BOM_CD,
								@P_BOM_NAME,
								@P_BOM_PROD_CD,								
								@P_USE_YN,
								GETDATE(), 
								@P_EMP_ID
								)
				END
		ELSE IF @P_MODE = 'U'
			BEGIN
				UPDATE CD_BOM_HDR
					SET BOM_NAME = @P_BOM_NAME,
						 BOM_PROD_CD = @P_BOM_PROD_CD,						
						 USE_YN = @P_USE_YN,
						 UDATE = GETDATE(),
						 UEMP_ID = @P_EMP_ID
				 WHERE BOM_CD = @P_BOM_CD
			END
		ELSE
			BEGIN
				DELETE CD_BOM_HDR
					WHERE BOM_CD = @P_BOM_CD

				DELETE CD_BOM_DTL
					WHERE BOM_CD = @P_BOM_CD
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

