/*
-- 생성자 :	강세미
-- 등록일 :	2024.01.31
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : SET 마스터 DTL 저장
-- 실행문 : EXEC PR_SET_MST_DTL_PUT '','SET_NAME','210005','Y','admin', 'I'
-- 실행문 : EXEC PR_SET_MST_DTL_PUT '001','수정수정','8801052951720','N','admin', 'U'
-- SELECT * FROM TBL_COMM_CD_MST
*/
CREATE PROCEDURE [dbo].[PR_SET_MST_DTL_PUT]
	@P_SET_CD NVARCHAR(3),					-- SET코드
	@P_SET_COMP_CD NVARCHAR(14), 			-- SET구성품 코드
	@P_SET_COMP_CD_BEFORE NVARCHAR(14),		-- SET구성품 코드 기존	
	@P_COMP_QTY INT,						-- 구성품수량
	@P_EMP_ID NVARCHAR(20), 				-- 아이디
	@P_MODE NVARCHAR(1) 						-- I: 등록 U: 수정 D: 삭제
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @SET_COMP_CD_YN VARCHAR(1) = 'N'				-- 코드유무여부
	DECLARE @RETURN_CODE INT = 0						-- 리턴코드(저장완료)
	DECLARE @RETURN_MESSAGE NVARCHAR(10) = DBO.GET_ERR_MSG('0')		-- 리턴메시지

	BEGIN TRY 
		IF @P_MODE = 'I'
			BEGIN
				IF EXISTS (
					SELECT 1 
						FROM CD_SET_DTL
						WHERE SET_CD = @P_SET_CD 
						  AND SET_COMP_CD = @P_SET_COMP_CD
				)
				BEGIN
					SET @SET_COMP_CD_YN = 'Y'
				END

				IF @SET_COMP_CD_YN = 'Y' 
					BEGIN
						SET @RETURN_CODE = 9
						SET @RETURN_MESSAGE = 'DTL상품 중복'
					END
				ELSE
					BEGIN
						
						INSERT INTO CD_SET_DTL(
										SET_CD,
										SET_COMP_CD,										
										COMP_QTY,
										IDATE,
										IEMP_ID
										) VALUES (
										@P_SET_CD,
										@P_SET_COMP_CD,										
										@P_COMP_QTY,
										GETDATE(), 
										@P_EMP_ID
										)
					END
				END
		ELSE IF @P_MODE = 'U'
			BEGIN
				UPDATE CD_SET_DTL
					SET SET_COMP_CD = @P_SET_COMP_CD,						 
						 COMP_QTY = @P_COMP_QTY,
						 UDATE = GETDATE(),
						 UEMP_ID = @P_EMP_ID
				 WHERE SET_CD = @P_SET_CD
					AND SET_COMP_CD = @P_SET_COMP_CD_BEFORE
			END
		ELSE
			BEGIN
				DELETE CD_SET_DTL
					WHERE SET_CD = @P_SET_CD
					  AND SET_COMP_CD = @P_SET_COMP_CD
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

