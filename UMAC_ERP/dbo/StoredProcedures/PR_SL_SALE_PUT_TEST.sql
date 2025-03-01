
/*

-- 생성자 :	이동호
-- 등록일 :	2024.05.23
-- 수정자 : 강세미- 2024.06.14 판매일자: 현재일자 -> 출고일자
			강세미- 2024.06.26 매입 프로세스 추가 
-- 설 명  : 입출고현황관리 > 매출(입)확정
-- 실행문 : 

EXEC PR_SL_SALE_PUT '[{"ORD_NO":"2240617001"}]'

*/
CREATE PROCEDURE [dbo].[PR_SL_SALE_PUT_TEST]
( 
	@P_JSONDT		VARCHAR(8000) = '',
	@P_EMP_ID		VARCHAR(20)				-- 아이디
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @RETURN_CODE	INT = 0										-- 리턴코드(저장완료)
	DECLARE @RETURN_MESSAGE NVARCHAR(MAX) = DBO.GET_ERR_MSG('0')		-- 리턴메시지
	DECLARE @SALE_CFM_DT	NVARCHAR(8) = FORMAT(GETDATE(), 'yyyyMMdd')	-- 매출확정일
	DECLARE @PUR_CFM_DT		NVARCHAR(8) = FORMAT(GETDATE(), 'yyyyMMdd')		-- 매입확정일
	DECLARE @VEN_CODE		NVARCHAR(7) = ''
	DECLARE @JSONDT			NVARCHAR(MAX) = ''

	BEGIN TRAN
	BEGIN TRY 				
			
		--########매출#######
		DECLARE @ORDER_TBL TABLE (
			ORD_NO NVARCHAR(11)
		)

		INSERT INTO @ORDER_TBL
			SELECT ORD_NO FROM 
				OPENJSON ( @P_JSONDT )   
					WITH (    
						ORD_NO NVARCHAR(11) '$.ORD_NO'									
					)
			WHERE LEFT(ORD_NO,1) = '2'
		
	
		IF EXISTS (SELECT 1 FROM @ORDER_TBL)
		BEGIN
			--#주문(출고) 매출 확정 처리
			MERGE SL_SALE AS A
			USING (			
				SELECT 
					OHDR.DELIVERY_DEC_DT AS SALE_DT,						--판매일자(출고일자)
					OT.ORD_NO, 												--주문번호			
					OHDR.VEN_CODE,											--거래처코드
					CMN.ITM_CODE,											--상품관리코드
					PRD_DATA.SCAN_CODE,											--상품코드
					CMN.TAX_GB,
					(CASE WHEN CMN.WEIGHT_GB = 'QTY' THEN PRD_DATA.PICKING_QTY ELSE 0 END) AS SALE_EA,
					(CASE WHEN CMN.WEIGHT_GB = 'WT' THEN PRD_DATA.PICKING_QTY ELSE 0 END) AS SALE_KG,
					ISNULL(PRD_DATA.PICKING_SAMT, 0) AS SALE_TOTAL_AMT,						--피킹금액
					@SALE_CFM_DT AS SALE_CFM_DT,
					PRD_DATA.GUBUN
				FROM @ORDER_TBL AS OT 
					INNER JOIN PO_ORDER_HDR AS OHDR ON OT.ORD_NO = OHDR.ORD_NO
					INNER JOIN ( SELECT DTL_SAM.ORD_NO, DTL_SAM.GUBUN, DTL_SAM.SCAN_CODE, DTL_SAM.PICKING_QTY, DTL_SAM.PICKING_SAMT
									FROM (
									SELECT DTL.ORD_NO, 'D' AS GUBUN, DTL.SCAN_CODE, DTL.PICKING_QTY, DTL.PICKING_SAMT FROM PO_ORDER_DTL AS DTL 
									UNION ALL
									SELECT SAM.ORD_NO, 'S' AS GUBUN, SAM.SCAN_CODE, SAM.PICKING_QTY, 0 AS PICKING_SAMT FROM PO_ORDER_SAMPLE AS SAM
								) AS DTL_SAM
					) AS PRD_DATA ON PRD_DATA.ORD_NO = OHDR.ORD_NO
					INNER JOIN CD_PRODUCT_CMN AS CMN ON CMN.SCAN_CODE = PRD_DATA.SCAN_CODE		
			) AS B
			ON (
				A.ORD_NO  = B.ORD_NO AND A.SCAN_CODE = B.SCAN_CODE
			)		
			WHEN NOT MATCHED THEN
				INSERT (SALE_DT, ORD_NO, VEN_CODE, SCAN_CODE, ITM_CODE, GUBUN, TAX_GB, SALE_EA, SALE_KG, SALE_TOTAL_AMT, SALE_CFM_DT, IDATE, IEMP_ID)
					VALUES (B.SALE_DT, B.ORD_NO, B.VEN_CODE, B.SCAN_CODE, B.ITM_CODE, B.GUBUN, B.TAX_GB, ISNULL(B.SALE_EA,0), ISNULL(B.SALE_KG,0), ISNULL(B.SALE_TOTAL_AMT,0), @SALE_CFM_DT, GETDATE(), @P_EMP_ID)
			WHEN MATCHED THEN
				UPDATE SET SALE_EA = B.SALE_EA,
						   SALE_KG = B.SALE_KG,
						   SALE_TOTAL_AMT = B.SALE_TOTAL_AMT,
						   SALE_CFM_DT = B.SALE_CFM_DT,
						   UDATE = GETDATE(),
						   UEMP_ID = @P_EMP_ID
			;		
		
			--################################################
			--# 주문별 입금처리내역 등록(PA_ACCT_DEPOSIT_ORD)
			--################################################			
			MERGE PA_ACCT_DEPOSIT_ORD AS A
			USING (			
				SELECT 
					SL.SALE_DT, 
					SL.ORD_NO, 
					SL.VEN_CODE,
					ISNULL(SUM(SL.SALE_TOTAL_AMT),0) AS DEPOSIT_AMT_SUM
				FROM SL_SALE AS SL 
					INNER JOIN @ORDER_TBL AS OT 
						ON SL.ORD_NO = OT.ORD_NO
					GROUP BY SL.SALE_DT, SL.ORD_NO, SL.VEN_CODE
			) AS B
			ON (
				A.ORD_NO  = B.ORD_NO
			)		
			WHEN NOT MATCHED THEN		
				INSERT (SALE_DT, ORD_NO, VEN_CODE, SALE_TOTAL_AMT, DEPOSIT_GB, DEPOSIT_NO, MOID, DEPOSIT_AMT, DEPOSIT_DT, DEPOSIT_FISH, DEL_YN, IDATE)
					VALUES (B.SALE_DT, B.ORD_NO, B.VEN_CODE, B.DEPOSIT_AMT_SUM, '', '', '', '', '', CASE WHEN B.DEPOSIT_AMT_SUM = 0 THEN 'Y' ELSE 'N' END, 'N', GETDATE())
			WHEN MATCHED THEN
				UPDATE SET SALE_TOTAL_AMT = B.DEPOSIT_AMT_SUM
			;
										
			--################################################################
			--# 거래처에 초과된 입금액이 있으면 주문확정시 해당 금액 차감 처리	
			--################################################################
			DECLARE @SALE_TOTAL_AMT		NUMERIC(17,4),
					@DEPOSIT_ORD_AMT	NUMERIC(15,2),
					@DEPOSIT_AMT		NUMERIC(15,2)

			DECLARE CURSOR_VEN_CODE	CURSOR FOR
				SELECT SL.VEN_CODE FROM SL_SALE AS SL 
					INNER JOIN @ORDER_TBL AS OT ON SL.ORD_NO = OT.ORD_NO 
						GROUP BY SL.VEN_CODE
			OPEN CURSOR_VEN_CODE

			FETCH NEXT FROM CURSOR_VEN_CODE INTO @VEN_CODE
			WHILE(@@FETCH_STATUS=0)
			BEGIN		
				
				--해당거래처의 매출총합, 입금총합
				SELECT @SALE_TOTAL_AMT = SUM(SALE_TOTAL_AMT), @DEPOSIT_ORD_AMT = SUM(DEPOSIT_AMT) FROM PA_ACCT_DEPOSIT_ORD WHERE VEN_CODE = @VEN_CODE
				--해당거래처의 입금한 금액의 총합
				SELECT @DEPOSIT_AMT = SUM(DEPOSIT_AMT) FROM PA_ACCT_DEPOSIT WHERE VEN_CODE = @VEN_CODE

				--해당 거래처에 초과 입금된 금액이 있거나, 선입금이 있는 거래처가 일경우 
				IF((SELECT COUNT(1) AS CNT FROM PA_ACCT_DEPOSIT_ORD WHERE VEN_CODE = @VEN_CODE AND DEPOSIT_AMT < 0) > 0) OR (@DEPOSIT_ORD_AMT = 0 AND @DEPOSIT_AMT > 0)
				BEGIN	
						SET @JSONDT = (				
							SELECT 
								'' AS MOID, 
								'' AS DEPOSIT_DT, 
								'' AS DEPOSIT_GB_NAME, 
								'' AS DEPOSIT_NO, 
								'' AS DEPOSIT_AMT, 
								'' AS ISSUER_CODE, 
								'' AS APP_NO, 
								@VEN_CODE AS VEN_CODE, 
								'' AS IEMP_ID											
							FOR JSON PATH
						)										
						EXEC PR_ACCT_DEPOSIT_MANUAL_PUT @JSONDT, @P_EMP_ID, @RETURN_CODE OUT, @RETURN_MESSAGE OUT;
				END 
													
			FETCH NEXT FROM CURSOR_VEN_CODE INTO @VEN_CODE

			END

			CLOSE CURSOR_VEN_CODE
			DEALLOCATE CURSOR_VEN_CODE
			--//
						
			--# 주문상태 매출확정으로 업데이트
			UPDATE PO_ORDER_HDR SET ORD_STAT = '40' 
				FROM @ORDER_TBL AS ORD 
							WHERE ORD.ORD_NO = PO_ORDER_HDR.ORD_NO

			--# 판매일자 별 데이터 쌓기위한 테이블변수 생성
			DECLARE @SALE_DT_TBL TABLE (
				ID INT IDENTITY(1,1),
				SALE_DT NVARCHAR(8)
			)

			INSERT INTO @SALE_DT_TBL(SALE_DT)
				SELECT SALE_DT 
				FROM SL_SALE
				WHERE SALE_CFM_DT = @SALE_CFM_DT
				GROUP BY SALE_DT

			DECLARE @MAX_ID INT = ISNULL((SELECT MAX(ID) FROM @SALE_DT_TBL),0)
			DECLARE @CUR_ID INT = 1
			DECLARE @SALE_DT NVARCHAR(8) --판매일자(출고일자)

			WHILE @CUR_ID <= @MAX_ID
			BEGIN

				SELECT @SALE_DT = SALE_DT
				  FROM @SALE_DT_TBL 
				 WHERE ID = @CUR_ID

				--# 일자별 거래처 매출 생성 및 업데이트
				EXEC PR_SL_SALE_VEN_PUT @SALE_DT, @RETURN_CODE OUT, @RETURN_MESSAGE OUT


				--# 일자별 상품 매출 생성 및 업데이트
				EXEC PR_SL_SALE_ITEM_PUT @SALE_DT, @RETURN_CODE OUT, @RETURN_MESSAGE OUT

				SET @CUR_ID = @CUR_ID + 1
			END
		END
		--########매출 끝#######

		--########매입#######
		DECLARE @PUR_ORDER_TBL TABLE (
			ORD_NO NVARCHAR(11)
		)

		INSERT INTO @PUR_ORDER_TBL
			SELECT ORD_NO FROM 
				OPENJSON ( @P_JSONDT )   
					WITH (    
						ORD_NO NVARCHAR(11) '$.ORD_NO'									
					)
			WHERE LEFT(ORD_NO,1) = '1'


			
		IF EXISTS (SELECT 1 FROM @PUR_ORDER_TBL)
		BEGIN
			--#발주(입고) 매입 확정 처리
			MERGE PUR_INFO AS A
			USING (			
				SELECT 
					PHDR.DELIVERY_IN_DT AS PUR_DT,							--매입일자(입고일자)
					OT.ORD_NO, 												--주문번호			
					PHDR.VEN_CODE,											--거래처코드
					CMN.ITM_CODE,											--상품관리코드
					PDTL.SCAN_CODE,											--상품코드
					CMN.TAX_GB,
					(CASE WHEN CMN.WEIGHT_GB = 'QTY' THEN PDTL.PUR_QTY ELSE 0 END) AS PUR_EA,
					(CASE WHEN CMN.WEIGHT_GB = 'WT' THEN PDTL.PUR_QTY ELSE 0 END) AS PUR_KG,
					PDTL.PUR_WAMT AS PUR_TOTAL_AMT,							--입고금액
					@PUR_CFM_DT AS PUR_CFM_DT
				FROM @PUR_ORDER_TBL AS OT 
					INNER JOIN PO_PURCHASE_HDR AS PHDR ON OT.ORD_NO = PHDR.ORD_NO
					INNER JOIN PO_PURCHASE_DTL AS PDTL ON PHDR.ORD_NO = PDTL.ORD_NO
					INNER JOIN CD_PRODUCT_CMN AS CMN ON CMN.SCAN_CODE = PDTL.SCAN_CODE			
			
			) AS B
			ON (
				A.ORD_NO  = B.ORD_NO AND A.SCAN_CODE = B.SCAN_CODE
			)		
			WHEN NOT MATCHED THEN
				INSERT (PUR_DT, ORD_NO, VEN_CODE, SCAN_CODE, ITM_CODE, TAX_GB, PUR_EA, PUR_KG, PUR_TOTAL_AMT, PUR_CFM_DT, IDATE, IEMP_ID)
					VALUES (B.PUR_DT, B.ORD_NO, B.VEN_CODE, B.SCAN_CODE, B.ITM_CODE, B.TAX_GB, ISNULL(B.PUR_EA,0), ISNULL(B.PUR_KG,0), ISNULL(B.PUR_TOTAL_AMT,0), @PUR_CFM_DT, GETDATE(), @P_EMP_ID)
			WHEN MATCHED THEN
				UPDATE SET PUR_EA = B.PUR_EA,
						   PUR_KG = B.PUR_KG,
						   PUR_TOTAL_AMT = B.PUR_TOTAL_AMT,
						   PUR_CFM_DT = B.PUR_CFM_DT,
						   UDATE = GETDATE(),
						   UEMP_ID = @P_EMP_ID
			;		
		 
			--# 발주상태 매입확정으로 업데이트
			UPDATE PO_PURCHASE_HDR SET PUR_STAT = '40' 
				FROM @PUR_ORDER_TBL AS PUR 
							WHERE PUR.ORD_NO = PO_PURCHASE_HDR.ORD_NO

			--# 매입일자 별 데이터 쌓기위한 테이블변수 생성
			DECLARE @PUR_DT_TBL TABLE (
				ID INT IDENTITY(1,1),
				PUR_DT NVARCHAR(8)
			)

			INSERT INTO @PUR_DT_TBL(PUR_DT)
				SELECT PUR_DT 
				FROM PUR_INFO
				WHERE PUR_CFM_DT = @PUR_CFM_DT
				GROUP BY PUR_DT

			DECLARE @PUR_MAX_ID INT = ISNULL((SELECT MAX(ID) FROM @PUR_DT_TBL),0)
			DECLARE @PUR_CUR_ID INT = 1
			DECLARE @PUR_DT NVARCHAR(8) --매입일자(입고일자)

			WHILE @PUR_CUR_ID <= @PUR_MAX_ID
			BEGIN

				SELECT @PUR_DT = PUR_DT
				  FROM @PUR_DT_TBL 
				 WHERE ID = @PUR_CUR_ID

				--# 일자별 거래처 매입 생성 및 업데이트
				EXEC PR_PUR_VEN_PUT @PUR_DT, @RETURN_CODE OUT, @RETURN_MESSAGE OUT


				--# 일자별 상품 매입 생성 및 업데이트
				EXEC PR_PUR_ITEM_PUT @PUR_DT, @RETURN_CODE OUT, @RETURN_MESSAGE OUT

				SET @PUR_CUR_ID = @PUR_CUR_ID + 1
			END
		END
		--########매입 끝#######

		SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE

	COMMIT;
	END TRY
	
	BEGIN CATCH	
		
		IF @@TRANCOUNT > 0
		BEGIN 

			IF CURSOR_STATUS('global', 'CURSOR_VEN_CODE') >= 0
			BEGIN
				CLOSE CURSOR_VEN_CODE;
				DEALLOCATE CURSOR_VEN_CODE;
			END

			ROLLBACK TRAN

			SET @RETURN_CODE = -1
			SET @RETURN_MESSAGE = ERROR_MESSAGE()


			--에러 로그 테이블 저장
			INSERT INTO TBL_ERROR_LOG 
			SELECT ERROR_PROCEDURE()		-- 프로시저명
				, ERROR_MESSAGE()			-- 에러메시지
				, ERROR_LINE()				-- 에러라인
				, GETDATE()	
		END 
		
		SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE 

	END CATCH
END

GO

