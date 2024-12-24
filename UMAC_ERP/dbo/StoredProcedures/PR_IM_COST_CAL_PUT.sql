/*
-- 생성자 :	강세미
-- 등록일 :	2024.05.23
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 제비용 원가계산
-- 실행문 : EXEC PR_IM_COST_CAL_PUT 'PO240502'
*/
CREATE PROCEDURE [dbo].[PR_IM_COST_CAL_PUT] 
	@P_PO_NO	NVARCHAR(15)				-- PO번호
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	DECLARE @COST_CFM			NVARCHAR(1)							-- 제비용확정여부

	DECLARE @RETURN_CODE		INT = 0								-- 리턴코드(저장완료)
	DECLARE @RETURN_MESSAGE		NVARCHAR(10) = DBO.GET_ERR_MSG('0')	-- 리턴메시지
	
	BEGIN TRY 
		SELECT @COST_CFM = COST_CFM FROM IM_COST_HDR WHERE PO_NO = @P_PO_NO;
	 
		IF @COST_CFM = 'Y'
			BEGIN
				UPDATE IM_ORDER_DTL SET TAX_GB = TMP.TAX_GB, 
					PUR_WPRC = TMP.PUR_WPRC, 
					PUR_WAMT = TMP.PUR_WAMT   
				FROM (   
					SELECT
						PO_NO,
						SEQ,
						ORD_QTY,
						PUR_WAMT,
						(PUR_WAMT / ORD_QTY) AS PUR_WPRC, -- 매입원가합계 / 발주수량
						B.SCAN_CODE,
						C.TAX_GB
						FROM (
							SELECT 
								PO_NO,
								SEQ,
								ORD_QTY,
								((WPRC_AMT + (SUM_COST_WRPC * COST_PERCENT))/ORD_QTY) * ORD_QTY AS PUR_WAMT,  -- 매입원가합계 : (원화금액 + (부대비용SUM * COST_PERCENT)/발주수량) * 발주수량
								SCAN_CODE
							FROM (
								SELECT A.PO_NO,
										A.SEQ,
										A.ORD_QTY,
										A.WPRC_AMT,
										(A.WPRC_AMT / (SELECT SUM(WPRC_AMT) FROM IM_ORDER_DTL WHERE PO_NO = @P_PO_NO)) AS COST_PERCENT, --상품 별 제비용 계산 비율
										(SELECT SUM(COST_WPRC) FROM IM_COST_DTL WHERE PO_NO = @P_PO_NO AND COST_ITM_CODE != 'W02') AS SUM_COST_WRPC , -- 제비용합계(수입부가세 항목 제외 공급가만)
										B.SCAN_CODE				
								FROM IM_ORDER_DTL A
									INNER JOIN CD_PRODUCT_CMN B ON A.ITM_CODE = B.ITM_CODE
								WHERE A.PO_NO = @P_PO_NO
							) AS A
						) AS B INNER JOIN CD_PRODUCT_CMN AS C ON B.SCAN_CODE = C.SCAN_CODE
				) TMP WHERE IM_ORDER_DTL.SEQ = TMP.SEQ AND TMP.PO_NO = IM_ORDER_DTL.PO_NO
				
			END
		ELSE  
			BEGIN 
				SET @RETURN_CODE = -1 -- 저장실패
				SET @RETURN_MESSAGE = '제비용확정 후 원가 계산이 가능합니다.'
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

