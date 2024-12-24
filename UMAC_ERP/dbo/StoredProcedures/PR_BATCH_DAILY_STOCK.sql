/*
-- 생성자 :	윤현빈
-- 등록일 :	2024.07.11
-- 수정자 : -
-- 수정일 : - 
-- 설 명 : 배치성, 일 수불 배치 실행, 실사 재고 확정 시 파라미터 추가
-- 실행문 : EXEC PR_BATCH_DAILY_STOCK
*/
CREATE PROCEDURE [dbo].[PR_BATCH_DAILY_STOCK]
AS
BEGIN


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	DECLARE @RETURN_CODE INT = 0				-- 리턴코드
	DECLARE @RETURN_MESSAGE NVARCHAR(10) = ''	-- 리턴메시지
	
	DECLARE @P_SURVEY_DATE VARCHAR(8) = '';
	DECLARE @P_SURVEY_GB VARCHAR(1) = '';
	DECLARE @P_SURVEY_ID VARCHAR(8) = '';
	DECLARE @V_START_TIME DATETIME = GETDATE();

	BEGIN TRAN
	BEGIN TRY 
		-- 재고실사 확정된것 있으면 셋팅
		SELECT @P_SURVEY_DATE = INV_DT
		     , @P_SURVEY_GB = SURVEY_GB
			 , @P_SURVEY_ID = SURVEY_ID
			FROM IV_SCHEDULER
		   WHERE CFM_FLAG = 'Y' 
		     AND CFM_DT = CONVERT(VARCHAR(8), GETDATE()-1, 112)
			 AND SURVEY_ID = (
								SELECT MAX(SURVEY_ID) 
								    FROM IV_SCHEDULER 
								   WHERE CFM_FLAG = 'Y' 
		                             AND CFM_DT = CONVERT(VARCHAR(8), GETDATE()-1, 112)
							)
		;

------------------------------------------------------------------------
-- 실사재고 적용 로직
-- 1. 적용 일자에 실사재고를 기말재고에 적용
-- 2. 적용 일자에 재고조정수량 인서트 (재고조정 수량 = 기말재고 - 매출 - 주문 - 등)
-- 3. ([적용 일자 + 1] ~ [현재기준 어제]) 까지 수불 돌리기
-- 4. [현재기준 어제] 일자의 기말재고를 현재고에 반영
------------------------------------------------------------------------
-- 1. 적용 일자에 실사재고를 기말재고에 적용
		IF @P_SURVEY_DATE != '' 
		BEGIN
			-- #0_1. 실사재고 처리 전 현재고에 없는 제품들 재고 0으로 인서트 처리
			INSERT INTO IV_PRODUCT_STAT
			SELECT A.SCAN_CODE, A.ITM_CODE, null, null,0,GETDATE()
				FROM CD_PRODUCT_CMN AS A
				LEFT OUTER JOIN IV_PRODUCT_STAT AS B ON A.SCAN_CODE = B.SCAN_CODE
			   WHERE B.SCAN_CODE IS NULL
				 AND A.ITM_FORM != '2'
			;

			-- #0_2. 실사재고 처리 일자가 전일자라면 수불이 없기 때문에 한번 돌리고 진행
			IF @P_SURVEY_DATE = CONVERT(VARCHAR(8), DATEADD(DAY, -1, GETDATE()), 112)
			BEGIN
				EXEC PR_BATCH_DAILY_IV_ITEM_COLL '', '', 'N';
			END

			-- #1. 전수 (실사재고 적용)
			IF @P_SURVEY_GB = '1'
			BEGIN
				MERGE INTO IV_DT_ITEM_LOT_COLL AS A
					USING (
						SELECT @P_SURVEY_DATE AS INV_DT
								, A.ITM_CODE
								, ISNULL(B.LOT_NO, '') AS LOT_NO
								--, (-1) * (ISNULL(B.INV_END_QTY, 0) - ISNULL(B.INV_ADJ_QTY, 0)) AS INV_ADJ_QTY
								, ISNULL(B.INV_ADJ_QTY, 0) AS INV_ADJ_QTY
								, ISNULL(B.INV_END_QTY, 0) AS INV_END_QTY
							FROM (
								SELECT A.SCAN_CODE
										, A.ITM_CODE
									FROM IV_PRODUCT_STAT AS A
									LEFT OUTER JOIN IV_LOT_STAT AS B ON A.SCAN_CODE = B.SCAN_CODE
									GROUP BY A.SCAN_CODE, A.ITM_CODE
							) AS A
							LEFT OUTER JOIN (
								SELECT CASE WHEN MST_PRD.ITM_FORM = '2' THEN BOX_MST.ITM_CODE ELSE A.ITM_CODE END AS ITM_CODE
									 , A.LOT_NO
									 , CASE WHEN MST_PRD.ITM_FORM = '2' THEN A.CFM_QTY * ISNULL(BOX_MST.IPSU_QTY, 1) - ISNULL((B.BASE_INV_QTY + B.PUR_QTY + B.PROD_QTY + B.SALE_QTY + B.RTN_QTY), 0) 
																		ELSE A.CFM_QTY - ISNULL((B.BASE_INV_QTY + B.PUR_QTY + B.PROD_QTY + B.SALE_QTY + B.RTN_QTY), 0)  END AS INV_ADJ_QTY
									 , CASE WHEN MST_PRD.ITM_FORM = '2' THEN A.CFM_QTY * ISNULL(BOX_MST.IPSU_QTY, 1) ELSE A.CFM_QTY END AS INV_END_QTY

									 --, A.CFM_QTY * ISNULL(BOX_MST.IPSU_QTY, 1) - ISNULL((B.BASE_INV_QTY + B.PUR_QTY + B.PROD_QTY + B.SALE_QTY + B.RTN_QTY), 0) AS INV_ADJ_QTY
									 --, A.CFM_QTY * ISNULL(BOX_MST.IPSU_QTY, 1) AS INV_END_QTY
									FROM IV_STOCK_SURVEY AS A
									INNER JOIN CD_PRODUCT_CMN AS MST_PRD ON A.ITM_CODE = MST_PRD.ITM_CODE
									LEFT OUTER JOIN (
										SELECT A.BOX_CODE
											 , A.ITM_CODE
											 , B.SCAN_CODE
											 , A.IPSU_QTY
											FROM CD_BOX_MST AS A
											INNER JOIN CD_PRODUCT_CMN AS B ON A.ITM_CODE = B.ITM_CODE
									) AS BOX_MST ON A.ITM_CODE = BOX_MST.BOX_CODE
									LEFT OUTER JOIN IV_DT_ITEM_LOT_COLL AS B ON A.INV_DT = B.INV_DT AND ISNULL(BOX_MST.ITM_CODE, A.ITM_CODE) = B.ITM_CODE AND A.LOT_NO = B.LOT_NO
								   WHERE A.INV_DT = @P_SURVEY_DATE
								     AND A.SURVEY_ID = @P_SURVEY_ID
								UNION ALL
								SELECT A.ITM_CODE
									 , A.LOT_NO
									 , A.INV_END_QTY * -1 AS INV_ADJ_QTY
									 , 0 AS INV_END_QTY
									FROM IV_DT_ITEM_LOT_COLL AS A
									--LEFT OUTER JOIN IV_STOCK_SURVEY AS B ON A.INV_DT = B.INV_DT AND A.ITM_CODE = B.ITM_CODE AND A.LOT_NO = B.LOT_NO AND B.SURVEY_ID = @P_SURVEY_ID
									LEFT OUTER JOIN (
										SELECT A.INV_DT
										     , ISNULL(B.ITM_CODE, A.ITM_CODE) AS ITM_CODE
											 , A.LOT_NO
											 , A.SURVEY_ID
											FROM IV_STOCK_SURVEY AS A
											LEFT OUTER JOIN (
												SELECT A.BOX_CODE
													 , A.ITM_CODE
													 , B.SCAN_CODE
													 , A.IPSU_QTY
													FROM CD_BOX_MST AS A
													INNER JOIN CD_PRODUCT_CMN AS B ON A.ITM_CODE = B.ITM_CODE
											) AS B ON A.ITM_CODE = B.BOX_CODE

									) AS B ON A.INV_DT = B.INV_DT AND A.ITM_CODE = B.ITM_CODE AND A.LOT_NO = B.LOT_NO AND B.SURVEY_ID = @P_SURVEY_ID
								   WHERE A.INV_DT = @P_SURVEY_DATE
									 AND B.LOT_NO IS NULL
							) AS B ON A.ITM_CODE = B.ITM_CODE
							---------------------------------------------------------------------
						--SELECT @P_SURVEY_DATE AS INV_DT
						--		, A.ITM_CODE
						--		, ISNULL(C.LOT_NO, '') AS LOT_NO
						--		, ISNULL(COALESCE(C.SURVEY_QTY_2, C.SURVEY_QTY_1, 0) - ISNULL((B.BASE_INV_QTY + B.PUR_QTY + B.PROD_QTY + B.SALE_QTY + B.RTN_QTY), 0), 0) AS INV_ADJ_QTY
						--		, COALESCE(C.SURVEY_QTY_2, C.SURVEY_QTY_1, 0) AS INV_END_QTY
						--	FROM (
						--		SELECT A.SCAN_CODE
						--			 , A.ITM_CODE
						--			FROM IV_PRODUCT_STAT AS A
						--			LEFT OUTER JOIN IV_LOT_STAT AS B ON A.SCAN_CODE = B.SCAN_CODE
						--			GROUP BY A.SCAN_CODE, A.ITM_CODE
						--	) AS A
						--	LEFT OUTER JOIN IV_DT_ITEM_LOT_COLL AS B ON A.ITM_CODE = B.ITM_CODE AND B.INV_DT = @P_SURVEY_DATE
						--	LEFT OUTER JOIN IV_STOCK_SURVEY AS C ON  A.ITM_CODE = C.ITM_CODE AND B.LOT_NO = C.LOT_NO AND C.INV_DT = @P_SURVEY_DATE
							---------------------------------------------------------------------
						--SELECT A.INV_DT
						--	 , A.ITM_CODE
						--	 , A.LOT_NO
						--	 , COALESCE(B.SURVEY_QTY_2, B.SURVEY_QTY_1, 0) - (A.BASE_INV_QTY + A.PUR_QTY + A.PROD_QTY + A.SALE_QTY + A.RTN_QTY) AS INV_ADJ_QTY
						--	 , COALESCE(B.SURVEY_QTY_2, B.SURVEY_QTY_1, 0) AS INV_END_QTY
						--	FROM IV_DT_ITEM_LOT_COLL AS A
						--	LEFT OUTER JOIN IV_STOCK_SURVEY AS B ON A.INV_DT = B.INV_DT AND A.ITM_CODE = B.ITM_CODE AND A.LOT_NO = B.LOT_NO
						--   WHERE A.INV_DT = @P_SURVEY_DATE
					 ) AS B
					 ON (A.INV_DT = B.INV_DT AND A.ITM_CODE = B.ITM_CODE AND A.LOT_NO = B.LOT_NO)
				WHEN MATCHED THEN
					UPDATE
						SET INV_END_QTY = B.INV_END_QTY
						  , INV_ADJ_QTY = B.INV_ADJ_QTY
						  , UDATE = GETDATE()
				WHEN NOT MATCHED THEN
					INSERT 
					(
						INV_DT
					  , ITM_CODE
					  , LOT_NO
					  , BASE_INV_QTY
					  , PUR_QTY
					  , PROD_QTY
					  , SALE_QTY
					  , RTN_QTY
					  , INV_ADJ_QTY
					  , INV_END_QTY
					  , IDATE
					  , UDATE
					)
					VALUES
					(
						B.INV_DT
					  , B.ITM_CODE
					  , B.LOT_NO
					  , 0
					  , 0
					  , 0
					  , 0
					  , 0
					  , B.INV_ADJ_QTY
					  , B.INV_END_QTY
					  , GETDATE()
					  , NULL
					)
					;
			END
			
			-- #2. 일부 (실사재고 적용)
			ELSE
			BEGIN
				MERGE INTO IV_DT_ITEM_LOT_COLL AS MAIN_A
					USING (
						SELECT A.INV_DT
						     , CASE WHEN MST_PRD.ITM_FORM = '2' THEN ISNULL(B.ITM_CODE, A.ITM_CODE) ELSE A.ITM_CODE END AS ITM_CODE
							 , A.LOT_NO
							 , CASE WHEN MST_PRD.ITM_FORM = '2' THEN SUM(A.SURVEY_QTY_1 * ISNULL(B.IPSU_QTY, 1)) ELSE SUM(A.SURVEY_QTY_1) END AS SURVEY_QTY_1
							 , CASE WHEN MST_PRD.ITM_FORM = '2' THEN SUM(A.SURVEY_QTY_2 * ISNULL(B.IPSU_QTY, 1)) ELSE SUM(A.SURVEY_QTY_2) END AS SURVEY_QTY_2
							FROM IV_STOCK_SURVEY AS A
							INNER JOIN CD_PRODUCT_CMN AS MST_PRD ON A.ITM_CODE = MST_PRD.ITM_CODE
							LEFT OUTER JOIN (
								SELECT SUB_A.BOX_CODE
									 , SUB_A.ITM_CODE
									 , SUB_B.SCAN_CODE
									 , SUB_A.IPSU_QTY
									FROM CD_BOX_MST AS SUB_A
									INNER JOIN CD_PRODUCT_CMN AS SUB_B ON SUB_A.ITM_CODE = SUB_B.ITM_CODE
							) AS B ON A.ITM_CODE = B.BOX_CODE
						   WHERE A.SURVEY_ID = @P_SURVEY_ID
						   GROUP BY A.INV_DT, CASE WHEN MST_PRD.ITM_FORM = '2' THEN ISNULL(B.ITM_CODE, A.ITM_CODE) ELSE A.ITM_CODE END, A.LOT_NO, MST_PRD.ITM_FORM
					) AS MAIN_B
					ON (MAIN_A.INV_DT = MAIN_B.INV_DT AND MAIN_A.ITM_CODE = MAIN_B.ITM_CODE AND MAIN_A.LOT_NO = MAIN_B.LOT_NO)
				WHEN MATCHED THEN
					UPDATE
						SET INV_END_QTY = ISNULL(MAIN_B.SURVEY_QTY_2, MAIN_B.SURVEY_QTY_1)
						  , INV_ADJ_QTY = ISNULL(MAIN_B.SURVEY_QTY_2, MAIN_B.SURVEY_QTY_1) - (MAIN_A.BASE_INV_QTY + MAIN_A.PUR_QTY + MAIN_A.PROD_QTY + MAIN_A.SALE_QTY + MAIN_A.RTN_QTY)
						  , UDATE = GETDATE()
				WHEN NOT MATCHED THEN
					INSERT 
					(
						INV_DT
					  , ITM_CODE
					  , LOT_NO
					  , BASE_INV_QTY
					  , PUR_QTY
					  , PROD_QTY
					  , SALE_QTY
					  , RTN_QTY
					  , INV_ADJ_QTY
					  , INV_END_QTY
					  , IDATE
					  , UDATE
					)
					VALUES
					(
						MAIN_B.INV_DT
					  , MAIN_B.ITM_CODE
					  , MAIN_B.LOT_NO
					  , 0
					  , 0
					  , 0
					  , 0
					  , 0
					  , ISNULL(MAIN_B.SURVEY_QTY_2, MAIN_B.SURVEY_QTY_1)
					  , ISNULL(MAIN_B.SURVEY_QTY_2, MAIN_B.SURVEY_QTY_1)
					  , GETDATE()
					  , NULL
					)
					;
			END

-- 2. 적용 일자에 재고조정수량 인서트 (재고조정 수량 = 기말재고 - 매출 - 주문 - 등)
			INSERT INTO IV_STOCK_ADJUST
			(
				ITM_CODE
			  , SCAN_CODE
			  , INV_DT
			  , INV_GB
			  , LOT_NO
			  , REQ_QTY
			  , CFM_FLAG
			  , CFM_DT
			  , APP_QTY
			  , REMARKS
			  , IDATE
			  , IEMP_ID
			  , UDATE
			  , UEMP_ID
			)
			SELECT A.ITM_CODE
				 , B.SCAN_CODE
				 , A.INV_DT
				 , '99'
				 , A.LOT_NO
				 , A.INV_ADJ_QTY
				 , 'Y'
				 , CONVERT(VARCHAR(8), DATEADD(DAY, -1, GETDATE()), 112)
				 , A.INV_ADJ_QTY
				 , '재고실사 일배치'
				 , GETDATE()
				 , 'BATCH'
				 , NULL
				 , NULL
				FROM IV_DT_ITEM_LOT_COLL AS A
				INNER JOIN CD_PRODUCT_CMN AS B ON A.ITM_CODE = B.ITM_CODE
			   WHERE A.INV_DT = @P_SURVEY_DATE
				 --AND A.INV_ADJ_QTY != 0 -- 주석 이유: 전수조사 시 0개로 처리해야 하는 상품이 있는데 IV_DT_ITEM_LOT_COLL 테이블에 없는 데이터를 삽입하기 위해
				 ;

-- 3. ([적용 일자 + 1] ~ [현재기준 어제]) 까지 수불 돌리기
-- ㄴ 20240712 수정, 적용일자 ~ [현재기준 어제]
--
			DECLARE @V_START_DATE NVARCHAR(8);
			SET @V_START_DATE = CONVERT(NVARCHAR, DATEADD(DAY, 1 - DAY(GETDATE()), CAST(GETDATE() AS DATE)), 112);

			IF @V_START_DATE > @P_SURVEY_DATE
			BEGIN
				SET @V_START_DATE = @P_SURVEY_DATE;
			END

			EXEC PR_BATCH_DAILY_IV_ITEM_COLL_LOOP @V_START_DATE, 'BATCH';

-- 20240911 현재고 반영 로직 수정
-- 수정전: 실사 시 현재고 반영 o, 수불만 돌 때 현재고 반영 x
-- 수정후: 실사 시 현재고 반영 o, 수불만 돌 때 현재고 반영 o
---- 4. [현재기준 어제] 일자의 기말재고를 현재고에 반영
--			DECLARE @YESTERDAY VARCHAR(8) = CONVERT(VARCHAR(8), DATEADD(DAY, -1, GETDATE()), 112);

--			MERGE INTO IV_PRODUCT_STAT AS A
--				USING (	
--					SELECT B.SCAN_CODE
--				         , A.ITM_CODE
--					     , A.INV_END_QTY
--						FROM IV_DT_ITEM_COLL AS A
--						INNER JOIN CD_PRODUCT_CMN AS B ON A.ITM_CODE = B.ITM_CODE
--					   WHERE INV_DT = @YESTERDAY
--				) AS B
--				ON (A.ITM_CODE = B.ITM_CODE)
--			WHEN MATCHED THEN
--				UPDATE 
--					SET CUR_INV_QTY = B.INV_END_QTY 
--					  , UDATE = GETDATE()
--			WHEN NOT MATCHED THEN
--				INSERT 
--				(
--					SCAN_CODE
--				  , ITM_CODE
--				  , LAST_PUR_DT
--				  , LAST_SALE_DT
--				  , CUR_INV_QTY
--				  , UDATE
--				)
--				VALUES 
--				(
--					B.SCAN_CODE
--				  , B.ITM_CODE
--				  , ''
--				  , ''
--				  , B.INV_END_QTY
--				  , NULL
--				)
--			;

--			MERGE INTO IV_LOT_STAT AS A
--				USING (	SELECT B.SCAN_CODE
--				             , A.ITM_CODE
--							 , A.LOT_NO
--							 , A.INV_END_QTY
--							FROM IV_DT_ITEM_LOT_COLL AS A
--							INNER JOIN CD_PRODUCT_CMN AS B ON A.ITM_CODE = B.ITM_CODE
--						   WHERE INV_DT = @YESTERDAY
--						     AND A.LOT_NO != ''
--				) AS B
--				ON (A.ITM_CODE = B.ITM_CODE AND A.LOT_NO = B.LOT_NO)
--			WHEN MATCHED THEN
--				UPDATE 
--					SET CUR_INV_QTY = B.INV_END_QTY 
--					  , UDATE = GETDATE()
--			WHEN NOT MATCHED THEN
--				INSERT 
--				(
--					SCAN_CODE
--				  , LOT_NO
--				  , ITM_CODE
--				  , CUR_INV_QTY
--				  , LAST_SALE_DT
--				  , UDATE
--				)
--				VALUES 
--				(
--					B.SCAN_CODE
--				  , B.LOT_NO
--				  , B.ITM_CODE
--				  , B.INV_END_QTY
--				  , ''
--				  , NULL
--				)
--			;

		END

		-- 실사재고 미 적용
		ELSE
		BEGIN
			EXEC PR_BATCH_DAILY_IV_ITEM_COLL_LOOP '', 'BATCH';
		END

-- 20240911 현재고 반영 로직 수정
-- 수정전: 실사 시 현재고 반영 o, 수불만 돌 때 현재고 반영 x
-- 수정후: 실사 시 현재고 반영 o, 수불만 돌 때 현재고 반영 o
-- 4. [현재기준 어제] 일자의 기말재고를 현재고에 반영
			DECLARE @YESTERDAY VARCHAR(8) = CONVERT(VARCHAR(8), DATEADD(DAY, -1, GETDATE()), 112);

			MERGE INTO IV_PRODUCT_STAT AS A
				USING (	
					SELECT B.SCAN_CODE
				         , A.ITM_CODE
					     , A.INV_END_QTY
						FROM IV_DT_ITEM_COLL AS A
						INNER JOIN CD_PRODUCT_CMN AS B ON A.ITM_CODE = B.ITM_CODE
					   WHERE INV_DT = @YESTERDAY
				) AS B
				ON (A.ITM_CODE = B.ITM_CODE)
			WHEN MATCHED THEN
				UPDATE 
					SET CUR_INV_QTY = B.INV_END_QTY 
					  , UDATE = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT 
				(
					SCAN_CODE
				  , ITM_CODE
				  , LAST_PUR_DT
				  , LAST_SALE_DT
				  , CUR_INV_QTY
				  , UDATE
				)
				VALUES 
				(
					B.SCAN_CODE
				  , B.ITM_CODE
				  , ''
				  , ''
				  , B.INV_END_QTY
				  , NULL
				)
			;

			MERGE INTO IV_LOT_STAT AS A
				USING (	SELECT B.SCAN_CODE
				             , A.ITM_CODE
							 , A.LOT_NO
							 , A.INV_END_QTY
							FROM IV_DT_ITEM_LOT_COLL AS A
							INNER JOIN CD_PRODUCT_CMN AS B ON A.ITM_CODE = B.ITM_CODE
						   WHERE INV_DT = @YESTERDAY
						     AND A.LOT_NO != ''
				) AS B
				ON (A.ITM_CODE = B.ITM_CODE AND A.LOT_NO = B.LOT_NO)
			WHEN MATCHED THEN
				UPDATE 
					SET CUR_INV_QTY = B.INV_END_QTY 
					  , UDATE = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT 
				(
					SCAN_CODE
				  , LOT_NO
				  , ITM_CODE
				  , CUR_INV_QTY
				  , LAST_SALE_DT
				  , UDATE
				)
				VALUES 
				(
					B.SCAN_CODE
				  , B.LOT_NO
				  , B.ITM_CODE
				  , B.INV_END_QTY
				  , ''
				  , NULL
				)
			;

		COMMIT;
	END TRY
	BEGIN CATCH		

	    IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN;

			INSERT INTO TBL_BATCH_LOG
			SELECT CONVERT(VARCHAR(8), GETDATE(), 112)
				, 'PR_BATCH_DAILY_STOCK'
				, 'F'
				, @V_START_TIME
				, GETDATE()
				, CONCAT(ERROR_MESSAGE(), ' / ', @RETURN_CODE)
				, 'N'
			;
		END;
		
	END CATCH
	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE
END

GO

