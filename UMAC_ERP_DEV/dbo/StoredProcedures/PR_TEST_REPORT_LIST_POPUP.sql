/*
-- 생성자 :	윤현빈
-- 등록일 :	2024.04.24
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 시험성적서 내용 조회
-- 실행문 : EXEC PR_TEST_REPORT_LIST_POPUP 
*/
CREATE PROCEDURE [dbo].[PR_TEST_REPORT_LIST_POPUP]
	@P_SCAN_CODE	NVARCHAR(14),
	@P_LOT_NO		NVARCHAR(30),	-- LOT
	@P_STR_LOT_LIST	NVARCHAR(500),	-- P_LOT_NO_LIST
	@P_VEN_NAME		NVARCHAR(50),		-- 거래처 이름
	@P_EMP_ID		NVARCHAR(20)		
AS 
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	BEGIN TRY 
	
	-- 에러발생
--	select 1/0;
	
		DECLARE @TMP_LOT TABLE(T_LOT_NO VARCHAR(30));
		
		IF @P_STR_LOT_LIST != '' 
		BEGIN
			INSERT INTO @TMP_LOT (T_LOT_NO)
		    SELECT CAST(value AS VARCHAR) AS T_LOT_NO
			FROM STRING_SPLIT(@P_STR_LOT_LIST, ',')
			;	
		END;
		

		WITH W_TEST_REPORT_DATA AS (
			SELECT A.LOT_NO
			     , A.PROD_DT
			     , A.SCAN_CODE
				 , A.EXPIRATION_DT
			     , B.CHAR_RESULT
			     , B.ACID_RESULT
			     , B.PEROXIDE_RESULT
			     , B.LODINE_RESULT
			     , B.COLOR_RESULT
			     , B.BENXO_RESULT
				 , B.R_NO
				 , ISNULL(B.UEMP_ID, B.IEMP_ID) AS IEMP_ID
				 , C.USER_NM
				FROM CD_LOT_MST AS A
				-- 2024.07.24 PDA에서 LOT 부여 안하고 시험성적서 출력할 수 있도록
				--INNER JOIN CD_PRODUCT_CMN AS MST_PRD ON A.SCAN_CODE = MST_PRD.SCAN_CODE
				LEFT OUTER JOIN PD_TEST_REPORT AS B ON A.PROD_DT = B.PROD_DT AND A.SCAN_CODE = B.SCAN_CODE AND A.LOT_NO = B.LOT_NO
				LEFT OUTER JOIN TBL_USER_MST AS C ON ISNULL(B.UEMP_ID, B.IEMP_ID) = C.USER_ID
			   WHERE 1=(CASE WHEN @P_LOT_NO != '' AND A.LOT_NO = @P_LOT_NO THEN 1 
			                 WHEN @P_LOT_NO =  '' AND A.LOT_NO IN (SELECT T_LOT_NO FROM @TMP_LOT) THEN 1
					--		 WHEN MST_PRD.ITM_FORM = '3' AND A.SCAN_CODE = @P_SCAN_CODE THEN 1
			                 ELSE 2 END)
		)
		SELECT A.LOT_NO
		     , A.PROD_DT
		     , A.EXPIRATION_DT AS EXPIRY_DATE
		     , A.CHAR_RESULT
		     , A.ACID_RESULT
		     , A.PEROXIDE_RESULT
		     , A.LODINE_RESULT
		     , A.COLOR_RESULT
		     , A.BENXO_RESULT
		     , B.RAW_MATERIALS 
		     , B.ITM_PROD_NO 
		     , B.CHAR
		     , B.ACID
		     , B.PEROXIDE
		     , B.LODINE
		     , B.COLOR
		     , B.BENXO
		     , COALESCE(A.R_NO, B.R_NO, '') AS R_NO
			 , ISNULL(B.COLOR_TYPE, '') AS COLOR_TYPE
		     , CASE WHEN PARSENAME(REPLACE(A.LOT_NO, '-', '.'), 2) = F.MGMT_ENTRY_1 THEN F.MGMT_ENTRY_DESCRIPTION_1 ELSE COALESCE(F.CD_NM, F.CD_NM, C.ITM_NAME) END AS ITM_NAME
		     , CASE WHEN C.ITM_FORM = '3' THEN 'Tank Lorry' ELSE CONCAT(ISNULL(C.UNIT_CAPACITY, 0), D.CD_NM) END AS UNIT_CAPACITY
		     , @P_VEN_NAME AS VEN_NAME
		     , CASE WHEN C.LOT_PARTNER_GB = 'UM' OR C.LOT_PARTNER_GB = 'OEM' THEN '㈜유맥' ELSE CONCAT('㈜유맥/', E.CD_NM) END AS SALES_PERSON
			 , A.IEMP_ID
			 , A.USER_NM
			FROM W_TEST_REPORT_DATA 		AS A 
			INNER JOIN PD_TEST_REPORT_INFO 	AS B ON A.SCAN_CODE = B.SCAN_CODE
			INNER JOIN CD_PRODUCT_CMN 		AS C ON A.SCAN_CODE = C.SCAN_CODE
			INNER JOIN TBL_COMM_CD_MST 		AS D ON D.CD_CL = 'UNIT' AND C.UNIT = D.CD_ID  AND D.DEL_YN = 'N'
			LEFT OUTER JOIN TBL_COMM_CD_MST AS E ON E.CD_CL = 'LOT_PARTNER_GB' AND C.LOT_PARTNER_GB = E.CD_ID  AND E.DEL_YN = 'N'
			LEFT OUTER JOIN TBL_COMM_CD_MST AS F ON F.CD_CL = 'ITM_TEST_REPORT_NM' AND C.SCAN_CODE = F.CD_ID  AND F.DEL_YN = 'N'
			
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
