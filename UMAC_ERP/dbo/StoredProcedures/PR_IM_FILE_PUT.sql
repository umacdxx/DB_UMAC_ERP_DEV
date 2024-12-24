/*
-- 생성자 :	강세미
-- 등록일 :	2024.05.17
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 수입발주파일저장
-- 실행문 : EXEC PR_IM_FILE_PUT 0,'2240416010','라라.png', '2240416010_1.png','D:\\DEV\\Upload\\Order\\2240416010_1.png',null,'','I'
*/
CREATE PROCEDURE [dbo].[PR_IM_FILE_PUT]
	@P_SEQ				INT,				-- SEQ
	@P_PO_NO			NVARCHAR(15),		-- PO번호
	@P_DOC_DIV			NVARCHAR(2), 		-- 파일구분
	@P_DOC_NAME			NVARCHAR(100), 		-- 파일명
	@P_REAL_DOC_NAME	NVARCHAR(100), 		-- 실제파일명
	@P_REMARKS			NVARCHAR(2000),		-- 비고
	@P_EMP_ID			NVARCHAR(20), 		-- 아이디
	@P_MODE				NVARCHAR(1)			-- I: 등록 U: 수정 D: 삭제
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @RETURN_CODE	INT = 0 						-- 리턴코드(저장완료)
	DECLARE @RETURN_MESSAGE NVARCHAR(10) = DBO.GET_ERR_MSG('0')		-- 리턴메시지

	BEGIN TRY
		
		--IF EXISTS (SELECT SEQ FROM IM_ORDER_UPLOAD WHERE SEQ = @P_SEQ AND PO_NO = @P_PO_NO)
		
		IF @P_MODE = 'I'
			BEGIN 
				INSERT INTO IM_ORDER_UPLOAD(
								PO_NO,
								DOC_DIV,
								DOC_NAME,
								REAL_DOC_NAME,
								REMARKS,
								IDATE,
								IEMP_ID
								) VALUES (
								@P_PO_NO,
								@P_DOC_DIV,
								@P_DOC_NAME,
								@P_REAL_DOC_NAME,
								@P_REMARKS,
								GETDATE(), 
								@P_EMP_ID
							) 
							
				END
		ELSE IF @P_MODE = 'U'
			BEGIN
				UPDATE IM_ORDER_UPLOAD
					SET DOC_DIV = @P_DOC_DIV,
						DOC_NAME = @P_DOC_NAME,
						REAL_DOC_NAME = @P_REAL_DOC_NAME,
						REMARKS = @P_REMARKS,
						UDATE = GETDATE(), 
						UEMP_ID = @P_EMP_ID
				  WHERE SEQ = @P_SEQ
				    AND PO_NO = @P_PO_NO
			END
		ELSE
			BEGIN
				DELETE IM_ORDER_UPLOAD
				 WHERE SEQ = @P_SEQ
				   AND PO_NO = @P_PO_NO
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

