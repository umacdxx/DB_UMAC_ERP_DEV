/*
-- 생성자 :	윤현빈
-- 등록일 :	2024.07.17
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 실사재고결과 조회
-- 실행문 : EXEC PR_STOCK_AUDIT_RESULT_LIST '','','','',''
*/
CREATE PROCEDURE [dbo].[PR_STOCK_AUDIT_RESULT_LIST]
( 
	@P_SURVEY_ID	NVARCHAR(8) = '',
	@P_INV_DT		NVARCHAR(8) = '',
	@P_SCAN_CODE	NVARCHAR(14) = '',
	@P_LRG_CODE		NVARCHAR(2) = '',
	@P_MID_CODE		NVARCHAR(4) = ''
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	BEGIN TRY 	
		
		WITH W_DATA AS (       
			SELECT A.INV_DT
				 , A.SCAN_CODE    
				 , A.ITM_CODE    
				 , A.SURVEY_QTY_1 AS BEFORE_AD_QTY   
				FROM IV_STOCK_SURVEY_ADD AS A   
				INNER JOIN (
					SELECT MIN(SURVEY_ID) AS SURVEY_ID, ITM_CODE
						FROM IV_STOCK_SURVEY_ADD 
					   WHERE INV_DT LIKE SUBSTRING(@P_SURVEY_ID, 1, 6) + '%'
					   GROUP BY ITM_CODE
				) AS B ON A.SURVEY_ID = B.SURVEY_ID AND A.ITM_CODE = B.ITM_CODE   
		), W_BEFORE_AD AS (   
			SELECT @P_SURVEY_ID AS SURVEY_ID        
				 , A.ITM_CODE     
				 , ISNULL(B.BEFORE_AD_QTY, A.INV_END_QTY) AS BEFORE_AD_QTY    
				 --, A.INV_END_QTY AS ACC_BOOK_QTY
				FROM IV_DT_ITEM_COLL AS A       
				INNER JOIN W_DATA AS B ON A.INV_DT = B.INV_DT AND A.ITM_CODE = B.ITM_CODE    
		), W_ACC_BOOK AS (
			SELECT @P_SURVEY_ID AS SURVEY_ID
			     , A.ITM_CODE
				 , A.INV_END_QTY AS ACC_BOOK_QTY
				FROM IV_DT_ITEM_COLL AS A
				LEFT OUTER JOIN IV_STOCK_SURVEY_ADD AS B ON A.INV_DT = B.INV_DT AND A.ITM_CODE = B.ITM_CODE AND B.SURVEY_ID = @P_SURVEY_ID
			   WHERE A.INV_DT = @P_INV_DT
			   --WHERE A.INV_DT = CONVERT(VARCHAR(8), DATEADD(DAY, -1, CONVERT(DATE, @P_INV_DT, 112)), 112)
			   
		), W_BOX_MST AS (
			SELECT A.BOX_CODE
				 , A.ITM_CODE
				 , B.SCAN_CODE
				 , B.ITM_NAME
				 , A.IPSU_QTY
				FROM CD_BOX_MST AS A
				INNER JOIN CD_PRODUCT_CMN AS B ON A.ITM_CODE = B.ITM_CODE
		)
		SELECT ROW_NUMBER() OVER(ORDER BY A.SCAN_CODE) AS ROW_NUM
			 , CASE WHEN MST_PRD.ITM_FORM = '2' THEN ISNULL(BOX_MST.SCAN_CODE, A.SCAN_CODE) ELSE A.SCAN_CODE END AS SCAN_CODE
			 , CASE WHEN MST_PRD.ITM_FORM = '2' THEN ISNULL(BOX_MST.ITM_CODE, A.ITM_CODE) ELSE A.ITM_CODE END AS ITM_CODE
			 , CASE WHEN MST_PRD.ITM_FORM = '2' THEN ISNULL(BOX_MST.ITM_NAME, '(NO BOX MASTER)') ELSE MST_PRD.ITM_NAME END AS ITM_NAME
			 --, ISNULL(BOX_MST.SCAN_CODE, A.SCAN_CODE) AS SCAN_CODE
			 --, ISNULL(BOX_MST.ITM_CODE, A.ITM_CODE) AS ITM_CODE
			 --, ISNULL(BOX_MST.ITM_NAME, MST_PRD.ITM_NAME) AS ITM_NAME 
			 , ISNULL(C.BEFORE_AD_QTY, ISNULL(D.ACC_BOOK_QTY, 0)) AS BEFORE_AD_QTY    
			 --, ISNULL(C.BEFORE_AD_QTY, 0) AS BEFORE_AD_QTY    
			 , CAST(ISNULL(D.ACC_BOOK_QTY, 0) AS INT) AS ACC_BOOK_QTY    
			 , CASE WHEN MST_PRD.ITM_FORM = '2' THEN A.SURVEY_QTY_2 * ISNULL(BOX_MST.IPSU_QTY, 0)
												ELSE A.SURVEY_QTY_2 END AS SURVEY_QTY
			 , CASE WHEN MST_PRD.ITM_FORM = '2' THEN CAST(ISNULL(D.ACC_BOOK_QTY, 0) AS INT) - (A.SURVEY_QTY_2 * ISNULL(BOX_MST.IPSU_QTY, 0))
												ELSE CAST(ISNULL(D.ACC_BOOK_QTY, 0) AS INT) - A.SURVEY_QTY_2 END AS DIFF_QTY


			 --, CAST(ISNULL(D.ACC_BOOK_QTY, 0) AS INT) - A.SURVEY_QTY_2 AS DIFF_QTY   
			FROM (
				SELECT INV_DT 
					 , ITM_CODE
					 , SCAN_CODE
					 , SURVEY_ID
					 , LOT_NO
					 , SUM(SURVEY_QTY_1) AS SURVEY_QTY_1
					 , SUM(SURVEY_QTY_2) AS SURVEY_QTY_2
					 , SUM(CFM_QTY) AS CFM_QTY
					FROM IV_STOCK_SURVEY
				   WHERE SURVEY_ID = @P_SURVEY_ID
				   GROUP BY INV_DT , ITM_CODE, SCAN_CODE, SURVEY_ID, LOT_NO
			) AS A   
			INNER JOIN IV_SCHEDULER AS B ON A.SURVEY_ID = B.SURVEY_ID   
			INNER JOIN CD_PRODUCT_CMN AS MST_PRD ON A.SCAN_CODE = MST_PRD.SCAN_CODE
			INNER JOIN CD_MID_MST AS MST_MID ON MST_PRD.MID_CODE = MST_MID.MID_CODE
			INNER JOIN CD_LRG_MST AS MST_LRG ON MST_MID.LRG_CODE = MST_LRG.LRG_CODE
			LEFT OUTER JOIN W_BOX_MST AS BOX_MST ON A.ITM_CODE = BOX_MST.BOX_CODE
			LEFT OUTER JOIN W_BEFORE_AD AS C ON A.SURVEY_ID = C.SURVEY_ID AND ISNULL(BOX_MST.ITM_CODE, A.ITM_CODE) = C.ITM_CODE 
			LEFT OUTER JOIN W_ACC_BOOK AS D ON A.SURVEY_ID = D.SURVEY_ID AND ISNULL(BOX_MST.ITM_CODE, A.ITM_CODE) = D.ITM_CODE
		   WHERE 1=(CASE WHEN @P_SCAN_CODE = '' THEN 1 WHEN @P_SCAN_CODE != '' AND MST_PRD.SCAN_CODE = @P_SCAN_CODE THEN 1 ELSE 2 END)
			 AND 1=(CASE WHEN @P_MID_CODE = '' THEN 1 WHEN @P_MID_CODE != '' AND MST_MID.MID_CODE = @P_MID_CODE THEN 1 ELSE 2 END)
			 AND 1=(CASE WHEN @P_LRG_CODE = '' THEN 1 WHEN @P_LRG_CODE != '' AND MST_LRG.LRG_CODE = @P_LRG_CODE THEN 1 ELSE 2 END)
			 AND MST_PRD.ITM_FORM != '3'

		--WITH W_DATA AS (   
		--	--SELECT CONVERT(VARCHAR(8), DATEADD(DAY, -1, CONVERT(DATE, A.INV_DT)), 112) AS INV_DT       
		--	SELECT A.INV_DT
		--		 , A.SCAN_CODE    
		--		 , A.ITM_CODE    
		--		 , A.SURVEY_QTY_1 AS BEFORE_AD_QTY   
		--		FROM IV_STOCK_SURVEY_ADD AS A   
		--		INNER JOIN (
		--			SELECT MIN(SURVEY_ID) AS SURVEY_ID, ITM_CODE
		--				FROM IV_STOCK_SURVEY_ADD 
		--			   WHERE INV_DT LIKE SUBSTRING(@P_SURVEY_ID, 1, 6) + '%'
		--			   GROUP BY ITM_CODE
		--		) AS B ON A.SURVEY_ID = B.SURVEY_ID AND A.ITM_CODE = B.ITM_CODE   
		--		--CROSS APPLY (    
		--		--	SELECT TOP 1 B.SURVEY_ID     
		--		--		FROM IV_STOCK_SURVEY_ADD AS B       
		--		--	   WHERE B.INV_DT LIKE SUBSTRING(@P_SURVEY_ID, 1, 6) + '%'       
		--		--	  ORDER BY B.SURVEY_ID ASC   
		--		--) AS T   
		--	 --  WHERE A.SURVEY_ID = T.SURVEY_ID        
		--), W_BEFORE_AD AS (   
		--	SELECT @P_SURVEY_ID AS SURVEY_ID        
		--		 , A.ITM_CODE     
		--		 , ISNULL(B.BEFORE_AD_QTY, A.INV_END_QTY) AS BEFORE_AD_QTY    
		--		 , A.INV_END_QTY AS ACC_BOOK_QTY
		--		FROM IV_DT_ITEM_COLL AS A       
		--		INNER JOIN W_DATA AS B ON A.INV_DT = B.INV_DT AND A.ITM_CODE = B.ITM_CODE    
		--		--LEFT OUTER JOIN W_DATA AS B ON A.INV_DT = B.INV_DT AND A.ITM_CODE = B.ITM_CODE      
		--	 --  --WHERE A.INV_DT = CONVERT(VARCHAR(8), DATEADD(DAY, -1, CONVERT(DATE, @P_INV_DT)), 112)  
		--	 --  WHERE A.INV_DT = @P_INV_DT
		--)  
		--SELECT ROW_NUMBER() OVER(ORDER BY A.SCAN_CODE) AS ROW_NUM
		--	 , A.SCAN_CODE       
		--	 , A.ITM_CODE    
		--	 , MST_PRD.ITM_NAME
		--	 , ISNULL(C.BEFORE_AD_QTY, 0) AS BEFORE_AD_QTY    
		--	 --, A.SURVEY_QTY_1 AS ACC_BOOK_QTY    
		--	 , CAST(ISNULL(C.ACC_BOOK_QTY, 0) AS INT) AS ACC_BOOK_QTY    
		--	 , A.SURVEY_QTY_2 AS SURVEY_QTY    
		--	 , CAST(ISNULL(C.ACC_BOOK_QTY, 0) AS INT) - A.SURVEY_QTY_2 AS DIFF_QTY   
		--	FROM IV_STOCK_SURVEY_ADD AS A   
		--	INNER JOIN IV_SCHEDULER AS B ON A.SURVEY_ID = B.SURVEY_ID   
		--	INNER JOIN CD_PRODUCT_CMN AS MST_PRD ON A.SCAN_CODE = MST_PRD.SCAN_CODE
		--	INNER JOIN CD_MID_MST AS MST_MID ON MST_PRD.MID_CODE = MST_MID.MID_CODE
		--	INNER JOIN CD_LRG_MST AS MST_LRG ON MST_MID.LRG_CODE = MST_LRG.LRG_CODE
		--	LEFT OUTER JOIN W_BEFORE_AD AS C ON A.SURVEY_ID = C.SURVEY_ID AND A.ITM_CODE = C.ITM_CODE     
		--   WHERE B.CFM_FLAG = 'Y'   
		--     --AND A.INV_DT = @P_INV_DT   
		--	 AND A.SURVEY_ID = @P_SURVEY_ID
		--	 AND 1=(CASE WHEN @P_SCAN_CODE = '' THEN 1 WHEN @P_SCAN_CODE != '' AND MST_PRD.SCAN_CODE = @P_SCAN_CODE THEN 1 ELSE 2 END)
		--	 AND 1=(CASE WHEN @P_MID_CODE = '' THEN 1 WHEN @P_MID_CODE != '' AND MST_MID.MID_CODE = @P_MID_CODE THEN 1 ELSE 2 END)
		--	 AND 1=(CASE WHEN @P_LRG_CODE = '' THEN 1 WHEN @P_LRG_CODE != '' AND MST_LRG.LRG_CODE = @P_LRG_CODE THEN 1 ELSE 2 END)
		   ;
	END TRY
	
	BEGIN CATCH		
		--에러 로그 테이블 저장
		INSERT INTO TBL_ERROR_LOG 
		SELECT ERROR_PROCEDURE()	-- 프로시저명
		, ERROR_MESSAGE()			-- 에러메시지
		, ERROR_LINE()				-- 에러라인
		, GETDATE()	
	END CATCH
	
END

GO
