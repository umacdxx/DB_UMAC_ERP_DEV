/*
-- 생성자 :	강세미
-- 등록일 :	2024.05.16
-- 수정자 : 2024.12.04 강세미 - B/L 관련 신규컬럼 추가
-- 설 명  : 수입발주등록 HDR 저장  
-- 실행문 : exec PR_IM_ORDER_HDR_PUT '','20240516','','','','','','','','','','','','','','','',0,'',0,0,0,0,'admin'
*/
CREATE PROCEDURE [dbo].[PR_IM_ORDER_HDR_PUT]
	@P_PO_NO				NVARCHAR(15),			-- PO번호
	@P_PO_ORD_DT			NVARCHAR(8), 			-- 발주일
	@P_PO_NAME				NVARCHAR(100),			-- PO명
	@P_VEN_CODE				NVARCHAR(7),			-- 수입업체코드
	@P_INCOTERMS			NVARCHAR(3),			-- 인도조건
	@P_CUSTOMS_CL_DT		NVARCHAR(8),			-- 통관일
	@P_LC_NO				NVARCHAR(20),			-- LC번호
	@P_LC_GB				NVARCHAR(2),			-- 거래구분
	@P_LC_OPEN_DT			NVARCHAR(8),			-- 개설일
	@P_LC_CLOSE_DT			NVARCHAR(8),			-- 만료일
	@P_OPEN_BANK			NVARCHAR(2),			-- 개설은행
	@P_DEPARTURE_COUNTRY	NVARCHAR(50),			-- 출발지국가
	@P_DEPARTURE_PORT		NVARCHAR(50),			-- 출발지항구
	@P_ARRIVAL_COUNTRY		NVARCHAR(50),			-- 도착지국가
	@P_ARRIVAL_PORT			NVARCHAR(50),			-- 도착지항구
	@P_BL_NO				NVARCHAR(20),			-- BL번호
	@P_BL_NO_2				NVARCHAR(20),			-- BL번호2
	@P_BL_NO_3				NVARCHAR(20),			-- BL번호3
	@P_BL_DT				NVARCHAR(8),			-- 선적일
	@P_BL_DT_2				NVARCHAR(8),			-- 선적일2
	@P_BL_DT_3				NVARCHAR(8),			-- 선적일3
	@P_INVOICE_AMT			NUMERIC(13,2),			-- 송장금액
	@P_INVOICE_AMT_2		NUMERIC(13,2),			-- 송장금액2
	@P_INVOICE_AMT_3		NUMERIC(13,2),			-- 송장금액3
	@P_CURRENCY_TYPE		NVARCHAR(3),			-- 환종
	@P_LC_EXCHANGE_RATE		NUMERIC(6,2),			-- LC환율
	@P_TT_EXCHANGE_RATE		NUMERIC(6,2),			-- TT환율
	@P_LC_AMT				NUMERIC(13,2),			-- LC결제금액
	@P_TT_AMT				NUMERIC(13,2),			-- TT결제금액
	@P_EMP_ID				NVARCHAR(20) 			-- 아이디
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	DECLARE @PO_NO				NVARCHAR(15)						-- 신규PO번호
	DECLARE @RETURN_CODE		INT = 0								-- 리턴코드(저장완료)
	DECLARE @RETURN_MESSAGE		NVARCHAR(10) = DBO.GET_ERR_MSG('0')	-- 리턴메시지

	BEGIN TRY 
		IF @P_PO_NO = ''
			BEGIN
				--SEQ 생성
				SET @P_PO_ORD_DT = CONVERT(NVARCHAR(8), GETDATE(), 112)
				SET @PO_NO = dbo.GET_PO_NO(@P_PO_ORD_DT)
				
				INSERT INTO IM_ORDER_HDR(
								PO_NO,
								PO_NAME,
								PO_ORD_DT,
								VEN_CODE,
								INCOTERMS,
								LC_NO,
								LC_GB,
								LC_OPEN_DT,
								LC_CLOSE_DT,
								OPEN_BANK,
								DEPARTURE_COUNTRY,
								DEPARTURE_PORT,
								ARRIVAL_COUNTRY,
								ARRIVAL_PORT,
								BL_NO,
								BL_NO_2,
								BL_NO_3,
								BL_DT,
								BL_DT_2,
								BL_DT_3,
								INVOICE_AMT,
								INVOICE_AMT_2,
								INVOICE_AMT_3,
								CURRENCY_TYPE,
								LC_EXCHANGE_RATE,
								TT_EXCHANGE_RATE,
								LC_AMT,
								TT_AMT,
								CUSTOMS_CL_DT,
								NOT_DELIVERED_SLIP,
								PUR_SLIP,
								IDATE,
								IEMP_ID
								) VALUES (
								@PO_NO,
								@P_PO_NAME,
								@P_PO_ORD_DT,
								@P_VEN_CODE,
								@P_INCOTERMS,
								@P_LC_NO,
								@P_LC_GB,
								@P_LC_OPEN_DT,
								@P_LC_CLOSE_DT,
								@P_OPEN_BANK,
								@P_DEPARTURE_COUNTRY,
								@P_DEPARTURE_PORT,
								@P_ARRIVAL_COUNTRY,
								@P_ARRIVAL_PORT,
								@P_BL_NO,
								@P_BL_NO_2,
								@P_BL_NO_3,
								@P_BL_DT,
								@P_BL_DT_2,
								@P_BL_DT_3,
								@P_INVOICE_AMT,
								@P_INVOICE_AMT_2,
								@P_INVOICE_AMT_3,
								@P_CURRENCY_TYPE,
								@P_LC_EXCHANGE_RATE,
								@P_TT_EXCHANGE_RATE,
								@P_LC_AMT,
								@P_TT_AMT,
								@P_CUSTOMS_CL_DT,
								'N',
								'N',
								GETDATE(), 
								@P_EMP_ID
								)

				-- 제비용 헤더 생성
				INSERT INTO IM_COST_HDR(
								PO_NO,
							    VEN_CODE,
							    PO_ORD_DT,
							    COST_CFM,
							    ALTRN_SLIP,
							    IDATE,
							    IEMP_ID
								) VALUES (
								@PO_NO,
							    @P_VEN_CODE,
							    @P_PO_ORD_DT,
							    'N',
							    'N',
							    GETDATE(),
							    @P_EMP_ID
								)
							


			END
		ELSE 
			BEGIN
				SET @PO_NO = @P_PO_NO

				UPDATE IM_ORDER_HDR
				   SET PO_NAME = @P_PO_NAME,
					   VEN_CODE = @P_VEN_CODE,
					   INCOTERMS = @P_INCOTERMS,
					   LC_NO = @P_LC_NO,
					   LC_GB = @P_LC_GB,
					   LC_OPEN_DT = @P_LC_OPEN_DT,
					   LC_CLOSE_DT = @P_LC_CLOSE_DT,
					   OPEN_BANK = @P_OPEN_BANK,
					   DEPARTURE_COUNTRY = @P_DEPARTURE_COUNTRY,
					   DEPARTURE_PORT = @P_DEPARTURE_PORT,
					   ARRIVAL_COUNTRY = @P_ARRIVAL_COUNTRY,
					   ARRIVAL_PORT = @P_ARRIVAL_PORT,
					   BL_NO = @P_BL_NO,
					   BL_NO_2 = @P_BL_NO_2,
					   BL_NO_3 = @P_BL_NO_3,
					   BL_DT = @P_BL_DT,
					   BL_DT_2 = @P_BL_DT_2,
					   BL_DT_3 = @P_BL_DT_3,
					   INVOICE_AMT = @P_INVOICE_AMT,
					   INVOICE_AMT_2 = @P_INVOICE_AMT_2,
					   INVOICE_AMT_3 = @P_INVOICE_AMT_3,
					   CURRENCY_TYPE = @P_CURRENCY_TYPE,
					   LC_EXCHANGE_RATE = @P_LC_EXCHANGE_RATE,
					   TT_EXCHANGE_RATE = @P_TT_EXCHANGE_RATE,
					   LC_AMT = @P_LC_AMT,
					   TT_AMT = @P_TT_AMT,
					   CUSTOMS_CL_DT = @P_CUSTOMS_CL_DT,
					   UDATE = GETDATE(), 
					   UEMP_ID = @P_EMP_ID
				WHERE PO_NO = @PO_NO

				--제비용 헤더
                UPDATE IM_COST_HDR
				   SET VEN_CODE = @P_VEN_CODE,
					   UDATE = GETDATE(),
					   UEMP_ID = @P_EMP_ID
                 WHERE PO_NO  = @PO_NO
                ;
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
		SET @RETURN_MESSAGE = ERROR_MESSAGE()
	END CATCH
	
	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE, @PO_NO AS PO_NO
END

GO

