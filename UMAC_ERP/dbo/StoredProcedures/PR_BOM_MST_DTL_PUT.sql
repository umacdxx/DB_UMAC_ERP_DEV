/*
-- 생성자 :	강세미
-- 등록일 :	2024.01.30
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : BOM 마스터 DTL 저장
-- 실행문 : EXEC PR_BOM_MST_DTL_PUT '','BOM_NAME','210005','BOX)포도씨유(대상,청정원포도씨유,PET,500ML)','Y','admin', 'I'
-- 실행문 : EXEC PR_BOM_MST_DTL_PUT '001','수정수정','8801052951720','카놀라유(대상,청정원카놀라유,PET,500ML)','N','admin', 'U'
-- SELECT * FROM TBL_COMM_CD_MST
*/
CREATE PROCEDURE [dbo].[PR_BOM_MST_DTL_PUT]
	@P_BOM_CD NVARCHAR(3),					-- BOM코드
	@P_BOM_COMP_CD NVARCHAR(14), 			-- BOM구성품 코드
	@P_BOM_COMP_CD_BEFORE NVARCHAR(14),		-- BOM구성품 코드 기존	
	@P_COMP_QTY NUMERIC(15,2),				-- 구성품수량
	@P_EMP_ID NVARCHAR(20), 				-- 아이디
	@P_MODE NVARCHAR(1) 					-- I: 등록 U: 수정 D: 삭제
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @RETURN_CODE INT = 0						-- 리턴코드
	DECLARE @RETURN_MESSAGE NVARCHAR(20) = '저장되었습니다.'		-- 리턴메시지

	BEGIN TRY 
		IF @P_MODE = 'I'
			BEGIN
				IF EXISTS (
					SELECT 1 
						FROM CD_BOM_DTL
						WHERE BOM_CD = @P_BOM_CD 
						  AND BOM_COMP_CD = @P_BOM_COMP_CD
				)
				BEGIN
					SET @RETURN_CODE = 9
					SET @RETURN_MESSAGE = '중복된 상품이 있습니다.'
				END
				ELSE
				BEGIN
					INSERT INTO CD_BOM_DTL(
										BOM_CD,
										BOM_COMP_CD,									
										COMP_QTY,
										IDATE,
										IEMP_ID
										) VALUES (
										@P_BOM_CD,
										@P_BOM_COMP_CD,										
										@P_COMP_QTY,
										GETDATE(), 
										@P_EMP_ID
										)
				END
			END
		ELSE IF @P_MODE = 'U'
			BEGIN
				UPDATE CD_BOM_DTL
					SET BOM_COMP_CD = @P_BOM_COMP_CD,						 
						 COMP_QTY = @P_COMP_QTY,
						 UDATE = GETDATE(),
						 UEMP_ID = @P_EMP_ID
				 WHERE BOM_CD = @P_BOM_CD
					AND BOM_COMP_CD = @P_BOM_COMP_CD_BEFORE
			END
		ELSE
			BEGIN
				DELETE CD_BOM_DTL
					WHERE BOM_CD = @P_BOM_CD
					  AND BOM_COMP_CD = @P_BOM_COMP_CD
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

