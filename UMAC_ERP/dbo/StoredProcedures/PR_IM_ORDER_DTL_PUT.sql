/*
-- 생성자 :	강세미
-- 등록일 :	2024.05.16
-- 수정자 : 2024.12.03 강세미 - ORD_QTY 데이터타입 변경 INT -> NUMERIC(7,2)
-- 수정일 : - 
-- 설 명  : 수입발주등록 DTL 저장
-- 실행문 : EXEC PR_IM_ORDER_DTL_PUT 'PO240506',0,'','','',0,0,0,0,0,0,0,'','I'
*/
CREATE PROCEDURE [dbo].[PR_IM_ORDER_DTL_PUT]
	@P_PO_NO			NVARCHAR(15),			-- PO번호
	@P_SEQ				INT, 					-- 순번
	@P_ITM_CODE			NVARCHAR(6), 			-- 상품코드
	@P_TAX_GB			NVARCHAR(1),			-- 면과세구분
	@P_ORG_CODE			NVARCHAR(3),			-- 원산지
	@P_ORD_QTY			NUMERIC(7,2),			-- 발주수량
	@P_FRGN_WPRC		NUMERIC(13,2),			-- 외화단가
	@P_FRGN_WPRC_AMT	NUMERIC(13,2),			-- 외화금액
	@P_WPRC				NUMERIC(13,0),			-- 원화단가
	@P_WPRC_AMT			NUMERIC(13,0),			-- 원화금액
	@P_PUR_WPRC			NUMERIC(15,2),			-- 매입단가(공급가)
	@P_PUR_WAMT			NUMERIC(15,2),			-- 매입합계금액
	@P_EMP_ID			NVARCHAR(20), 			-- 아이디
	@P_MODE				NVARCHAR(1)				-- I: 등록 U: 수정 D: 삭제
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	DECLARE @RETURN_CODE		INT = 0									-- 리턴코드(저장완료)
	DECLARE @RETURN_MESSAGE		NVARCHAR(10) = DBO.GET_ERR_MSG('0')		-- 리턴메시지
	
	BEGIN TRY 
		IF @P_MODE = 'I'
			BEGIN
				-- 신규 SEQ SET
				SELECT @P_SEQ = ISNULL(MAX(SEQ),0) + 1 FROM IM_ORDER_DTL WHERE PO_NO = @P_PO_NO

				INSERT INTO IM_ORDER_DTL(
								PO_NO,
								SEQ,
								ITM_CODE,
								ORD_QTY,
								FRGN_WPRC,
								FRGN_WPRC_AMT,
								WPRC,
								WPRC_AMT,
								TAX_GB,
								ORG_CODE,
								PUR_WPRC,
								PUR_WAMT,
								IDATE,
								IEMP_ID
								) VALUES (
								@P_PO_NO,
								@P_SEQ,
								@P_ITM_CODE,
								@P_ORD_QTY,
								@P_FRGN_WPRC,
								@P_FRGN_WPRC_AMT,
								@P_WPRC,
								@P_WPRC_AMT,
								@P_TAX_GB,
								@P_ORG_CODE,
								@P_PUR_WPRC,
								@P_PUR_WAMT,
								GETDATE(), 
								@P_EMP_ID
							) 
				END
		ELSE IF @P_MODE = 'U'
			BEGIN
				UPDATE IM_ORDER_DTL
					SET ITM_CODE = @P_ITM_CODE,
						ORD_QTY = @P_ORD_QTY,
						FRGN_WPRC = @P_FRGN_WPRC,
						FRGN_WPRC_AMT = @P_FRGN_WPRC_AMT,
						WPRC = @P_WPRC,
						WPRC_AMT = @P_WPRC_AMT,
						TAX_GB = @P_TAX_GB,
						ORG_CODE = @P_ORG_CODE,
						PUR_WPRC = @P_PUR_WPRC,
						PUR_WAMT = @P_PUR_WAMT,
						UDATE = GETDATE(), 
						UEMP_ID = @P_EMP_ID
				 WHERE PO_NO = @P_PO_NO
				   AND SEQ = @P_SEQ
			END
		ELSE
			BEGIN
				DELETE IM_ORDER_DTL
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

		DELETE IM_ORDER_HDR 
			WHERE PO_NO = @P_PO_NO

		SET @RETURN_CODE = -1 -- 저장실패
		SET @RETURN_MESSAGE = ERROR_MESSAGE()
		
	END CATCH
	
	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE, @P_PO_NO AS PO_NO 
END

GO

