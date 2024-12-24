/*
-- 생성자 :	강세미
-- 등록일 :	2024.05.22
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 제비용등록 DTL 저장
-- 실행문 : EXEC PR_IM_COST_DTL_PUT
*/
CREATE PROCEDURE [dbo].[PR_IM_COST_DTL_PUT]
	@P_PO_NO			NVARCHAR(15),				-- PO번호
	@P_SEQ				INT, 						-- 순번
	@P_COST_DT			NVARCHAR(8), 				-- 제비용발생일자
	@P_COST_VEN_CODE	NVARCHAR(20),				-- 제비용거래처코드
	@P_COST_ITM_CODE	NVARCHAR(3),				-- 제비용항목코드
	@P_COST_NAME		NVARCHAR(100),				-- 제비용항목명
	@P_COST_WPRC		NUMERIC(13,0),				-- 공급가
	@P_COST_WVAT		NUMERIC(13,0),				-- 부가세
	@P_COST_AMOUNT		NUMERIC(13,0),				-- 합계금액
	@P_NOTE				NVARCHAR(100),				-- 적요
	@P_BL_NO			NVARCHAR(20),				-- BL번호
	@P_MODE				NVARCHAR(1)					-- I: 등록 U: 수정 D: 삭제
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	 
	DECLARE @RETURN_CODE INT = 0						-- 리턴코드(저장완료)
	DECLARE @RETURN_MESSAGE NVARCHAR(10) = DBO.GET_ERR_MSG('0')		-- 리턴메시지

	BEGIN TRY 
	 
		IF @P_MODE = 'I'
			BEGIN
				-- 신규 SEQ SET
				SELECT @P_SEQ = ISNULL(MAX(SEQ),0) + 1 FROM IM_COST_DTL WHERE PO_NO = @P_PO_NO

				INSERT INTO IM_COST_DTL(
								PO_NO,
								SEQ,
								COST_DT,
								COST_VEN_CODE,
								COST_ITM_CODE,
								COST_NAME,
								COST_WPRC,
								COST_WVAT,
								COST_AMOUNT,
								COST_SLIP,
								NOTE,
								BL_NO
								) VALUES (
								@P_PO_NO,
								@P_SEQ,
								@P_COST_DT,
								@P_COST_VEN_CODE,
								@P_COST_ITM_CODE,
								@P_COST_NAME,
								@P_COST_WPRC,
								@P_COST_WVAT,
								@P_COST_AMOUNT,
								'N',
								@P_NOTE,
								@P_BL_NO
							) 
				END
		ELSE IF @P_MODE = 'U'
			BEGIN
				UPDATE IM_COST_DTL
					SET COST_DT = @P_COST_DT,
						COST_VEN_CODE = @P_COST_VEN_CODE,
						COST_ITM_CODE = @P_COST_ITM_CODE,
						COST_NAME = @P_COST_NAME,
						COST_WPRC = @P_COST_WPRC,
						COST_WVAT = @P_COST_WVAT,
						COST_AMOUNT = @P_COST_AMOUNT,
						NOTE = @P_NOTE,
						BL_NO = @P_BL_NO 
				  WHERE PO_NO = @P_PO_NO
				    AND SEQ = @P_SEQ
			END
		ELSE
			BEGIN
				DELETE IM_COST_DTL
					WHERE PO_NO = @P_PO_NO
				     AND SEQ = @P_SEQ
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

