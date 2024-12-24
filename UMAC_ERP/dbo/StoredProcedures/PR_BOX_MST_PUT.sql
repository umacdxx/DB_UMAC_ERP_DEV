/*
-- 생성자 :	강세미
-- 등록일 :	2024.01.25
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 박스마스터 저장
-- 실행문 : EXEC PR_BOX_MST_PUT '210005','BOX)포도씨유(대상,청정원포도씨유,PET,500ML)','210001','포도씨유(대상,청정원포도씨유,PET,500ML)',15,'admin', 'I'
-- SELECT * FROM TBL_COMM_CD_MST
*/
CREATE PROCEDURE [dbo].[PR_BOX_MST_PUT]
	@P_BOX_CODE NVARCHAR(6),	-- 박스상품코드	
	@P_ITM_CODE NVARCHAR(6), 	-- 단품상품코드	
	@P_IPSU_QTY INT, 			-- 입수량
	@P_EMP_ID NVARCHAR(20), 	-- 아이디
	@P_MODE NVARCHAR(1) 		
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @RETURN_CODE INT = 0			-- 리턴코드
	DECLARE @RETURN_MESSAGE NVARCHAR(30) = '저장되었습니다.'		-- 리턴메시지

	BEGIN TRY 
		IF @P_MODE = 'I'
			BEGIN
				IF EXISTS (
					SELECT 1 
						FROM CD_BOX_MST
						WHERE BOX_CODE = @P_BOX_CODE
				)
				BEGIN
					SET @RETURN_CODE = 9
					SET @RETURN_MESSAGE = '중복된 박스상품이 있습니다.'
				END
				ELSE
				BEGIN
					INSERT INTO CD_BOX_MST(
										BOX_CODE,										
										ITM_CODE,										
										IPSU_QTY,
										IDATE,
										IEMP_ID
										) VALUES (
										@P_BOX_CODE,										
										@P_ITM_CODE,										
										@P_IPSU_QTY,
										GETDATE(), 
										@P_EMP_ID
										)
				END
			END
		ELSE IF @P_MODE = 'U'
			BEGIN
				UPDATE CD_BOX_MST 
					SET ITM_CODE = @P_ITM_CODE,							
							IPSU_QTY = @P_IPSU_QTY,
							UDATE = GETDATE(),
							UEMP_ID = @P_EMP_ID
					WHERE BOX_CODE = @P_BOX_CODE
			END
		ELSE
			BEGIN
				DELETE CD_BOX_MST
					WHERE BOX_CODE = @P_BOX_CODE
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

