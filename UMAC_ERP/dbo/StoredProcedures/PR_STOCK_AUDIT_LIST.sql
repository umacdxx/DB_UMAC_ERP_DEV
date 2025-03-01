/*
-- 생성자 :	윤현빈
-- 등록일 :	2024.07.09
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 실사재고 조회
-- 실행문 : EXEC PR_STOCK_AUDIT_LIST '','','','',''
*/
CREATE PROCEDURE [dbo].[PR_STOCK_AUDIT_LIST]
( 
	@P_SURVEY_ID		NVARCHAR(8) = ''	-- 재고조사ID
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	BEGIN TRY 	
		
		SELECT ROW_NUMBER() OVER(ORDER BY A.SCAN_CODE) AS ROW_NUM
		     , A.SCAN_CODE
			 , MST_PRD.ITM_NAME
			 , A.LOT_NO
			 , ISNULL(A.SURVEY_QTY_2, A.SURVEY_QTY_1) AS SURVEY_QTY
			 , MST_LRG.LRG_NAME AS LRG_NM
			 , MST_MID.MID_NAME AS MID_NM
			 , COM_UNIT.CD_NM AS UNIT_NM
			 , A.INV_FLAG
			 , MST_IUSR.USER_NM AS IEMP_NM
			 , MST_CUSR.USER_NM AS CFM_EMP_NM
			 , B.CFM_EMP_ID
			 , B.CFM_FLAG
			 , MST_PRD.WEIGHT_GB
			 , COM_WEI_GB.CD_NM AS WEIGHT_GB_NM
			 , CASE WHEN LOT.SCAN_CODE IS NULL THEN 'N' ELSE 'Y' END AS LOT_YN
			FROM IV_STOCK_SURVEY AS A
			INNER JOIN IV_SCHEDULER AS B ON A.SURVEY_ID = B.SURVEY_ID
			INNER JOIN CD_PRODUCT_CMN AS MST_PRD ON A.SCAN_CODE = MST_PRD.SCAN_CODE
			INNER JOIN CD_MID_MST AS MST_MID ON MST_PRD.MID_CODE = MST_MID.MID_CODE
			INNER JOIN CD_LRG_MST AS MST_LRG ON MST_MID.LRG_CODE = MST_LRG.LRG_CODE
			INNER JOIN TBL_COMM_CD_MST AS COM_WEI_GB ON COM_WEI_GB.CD_CL = 'WEIGHT_GB' AND MST_PRD.WEIGHT_GB = COM_WEI_GB.CD_ID
			INNER JOIN TBL_COMM_CD_MST AS COM_UNIT ON COM_UNIT.CD_CL = 'UNIT' AND MST_PRD.UNIT = COM_UNIT.CD_ID
			INNER JOIN TBL_USER_MST AS MST_IUSR ON A.IEMP_ID = MST_IUSR.USER_ID
			LEFT OUTER JOIN TBL_USER_MST AS MST_CUSR ON B.CFM_EMP_ID = MST_CUSR.USER_ID
			LEFT OUTER JOIN IV_LOT_STAT AS LOT ON A.SCAN_CODE = LOT.SCAN_CODE AND A.LOT_NO = LOT.LOT_NO
		   WHERE A.SURVEY_ID = @P_SURVEY_ID
		     AND MST_PRD.ITM_FORM != '3'

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

