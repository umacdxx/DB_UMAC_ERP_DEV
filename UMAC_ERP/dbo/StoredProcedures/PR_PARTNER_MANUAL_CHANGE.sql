/*
-- 생성자 :	윤현빈
-- 등록일 :	2024.12.03
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 매출 거래처 수동 변경 프로시저
-- 실행문 : EXEC PR_PARTNER_MANUAL_CHANGE @P_ORD_NO, @P_VEN_CODE, @P_DELIVERY_CODE, @P_EMP_ID
*/
CREATE PROCEDURE [dbo].[PR_PARTNER_MANUAL_CHANGE]
( 
	@P_ORD_NO		    NVARCHAR(11) = '',	-- 주문번호
	@P_VEN_CODE		    NVARCHAR(7) = '',	-- 거래처코드
	@P_DELIVERY_CODE	NVARCHAR(7) = '',	-- 배송지코드
	@P_EMP_ID		    NVARCHAR(20) = ''	-- 아이디
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	DECLARE @RETURN_CODE 	INT 			= 0		-- 리턴코드
	DECLARE @RETURN_MESSAGE NVARCHAR(10) 	= '' 	-- 리턴메시지

	BEGIN TRAN
	BEGIN TRY
		DECLARE @V_GRE_GB	            NVARCHAR(1)	    -- 매입, 매출 구분
		DECLARE @V_ORD_DATE             NVARCHAR(8)	    -- 주문서 일자

        DECLARE @V_DELIVERY_PRICE_SEQ   INT             -- 배송지가격정보SEQ
        DECLARE @V_POST_NO              NVARCHAR(5)     -- 우편번호
        DECLARE @V_ADDR                 NVARCHAR(100)   -- 주소
        DECLARE @V_ADDR_DTL             NVARCHAR(50)    -- 상세주소

		SET @V_GRE_GB = LEFT(@P_ORD_NO, 1);

        -- 배송지 처리 위함
        SELECT @V_DELIVERY_PRICE_SEQ = DELIVERY_PRICE_SEQ
             , @V_POST_NO = POST_NO
             , @V_ADDR = ADDR
             , @V_ADDR_DTL = ADDR_DTL
            FROM CD_PARTNER_DELIVERY AS A
           WHERE VEN_CODE = @P_VEN_CODE
             AND DELIVERY_CODE = @P_DELIVERY_CODE
        ;
		
		-- 계근 테이블 업데이트
		UPDATE PO_SCALE
			SET VEN_CODE = @P_VEN_CODE
			  , UDATE = GETDATE()
			  , UEMP_ID = @P_EMP_ID
		   WHERE ORD_NO = @P_ORD_NO
		;


		-- 매입일 때
		IF @V_GRE_GB = '1'
		BEGIN
			-- 주문서 헤더 업데이트
			UPDATE PO_PURCHASE_HDR 
				SET VEN_CODE = @P_VEN_CODE
                  , DELIVERY_CODE = @P_DELIVERY_CODE
                  , DELIVERY_PRICE_SEQ = ISNULL(@V_DELIVERY_PRICE_SEQ, '')
                  , R_POST_NO = ISNULL(@V_POST_NO, '')
                  , R_ADDR = ISNULL(@V_ADDR, '')
                  , R_ADDR_DTL = ISNULL(@V_ADDR_DTL, '')
				  , UDATE = GETDATE()
				  , UEMP_ID = @P_EMP_ID
			   WHERE ORD_NO = @P_ORD_NO
			;

			-- 매입 집계 처리
			DELETE PUR_INFO WHERE PUR_DT = @V_ORD_DATE
			DELETE PUR_VEN WHERE PUR_DT = @V_ORD_DATE
			DELETE PUR_ITEM WHERE PUR_DT = @V_ORD_DATE

			DECLARE @JSON NVARCHAR(MAX)
			SELECT @JSON =
			(SELECT ORD_NO
				FROM PO_PURCHASE_HDR
				WHERE PUR_STAT IN ('35', '40') AND DELIVERY_IN_DT = @V_ORD_DATE
				FOR JSON PATH)
 
			EXEC PR_SL_SALE_PUT @JSON, @P_EMP_ID
		END

		-- 매출
		ELSE IF @V_GRE_GB = '2'
		BEGIN
		
			-- 주문별 입금 테이블 업데이트
			UPDATE PA_ACCT_DEPOSIT_ORD
				SET VEN_CODE = @P_VEN_CODE
			   WHERE ORD_NO = @P_ORD_NO
			;

			-- 주문서 헤더 업데이트
			UPDATE PO_ORDER_HDR 
				SET VEN_CODE = @P_VEN_CODE
                  , DELIVERY_CODE = @P_DELIVERY_CODE
                  , DELIVERY_PRICE_SEQ = ISNULL(@V_DELIVERY_PRICE_SEQ, '')
                  , R_POST_NO = ISNULL(@V_POST_NO, '')
                  , R_ADDR = ISNULL(@V_ADDR, '')
                  , R_ADDR_DTL = ISNULL(@V_ADDR_DTL, '')
				  , UDATE = GETDATE()
				  , UEMP_ID = @P_EMP_ID
			   WHERE ORD_NO = @P_ORD_NO
			;

			SELECT @V_ORD_DATE = DELIVERY_DEC_DT FROM PO_ORDER_HDR WHERE ORD_NO = @P_ORD_NO;

			-- 대시보드 처리
			EXEC PR_AGGR_OIL_ITM_SALE_DEDUCT @P_ORD_NO, @RETURN_CODE, @RETURN_MESSAGE;
			EXEC PR_AGGR_OIL_ITM_SALE_PUT @P_ORD_NO, @RETURN_CODE, @RETURN_MESSAGE;

			-- 매출 집계 처리
			DELETE SL_SALE WHERE SALE_DT = @V_ORD_DATE;
			DELETE SL_SALE_VEN WHERE SALE_DT = @V_ORD_DATE;
			DELETE SL_SALE_ITEM WHERE SALE_DT = @V_ORD_DATE;

			DECLARE @JSON2 NVARCHAR(MAX)

			SELECT @JSON2 =
			(SELECT ORD_NO
			 FROM PO_ORDER_HDR
			 WHERE ORD_STAT IN ('35', '40')
			   AND DELIVERY_DEC_DT = @V_ORD_DATE
			 FOR JSON PATH)
 
			EXEC PR_SL_SALE_PUT @JSON2, @P_EMP_ID

		END
		COMMIT;
	
	END TRY
	
	BEGIN CATCH		
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN

				--에러 로그 테이블 저장
				INSERT INTO TBL_ERROR_LOG 
				SELECT ERROR_PROCEDURE()	-- 프로시저명
				, ERROR_MESSAGE()			-- 에러메시지
				, ERROR_LINE()				-- 에러라인
				, GETDATE();
		
				SET @RETURN_CODE = -1; -- 저장 실패
				SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('-1');
			
		END
			
	END CATCH

	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE

END

GO

