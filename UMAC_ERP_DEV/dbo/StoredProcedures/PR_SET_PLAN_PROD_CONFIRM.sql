/*
-- 생성자 :	윤현빈
-- 등록일 :	2024.08.16
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : SET 생산 확정
-- 실행문 : EXEC PR_SET_PLAN_PROD_CONFIRM '','','','',''
*/
CREATE PROCEDURE [dbo].[PR_SET_PLAN_PROD_CONFIRM]
( 
	@P_SET_PLAN_ID		NVARCHAR(11) = '',
	@P_EMP_ID			NVARCHAR(20)				-- 아이디
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	DECLARE @RETURN_CODE 	INT 			= 0		-- 리턴코드
	DECLARE @RETURN_MESSAGE NVARCHAR(10) 	= '' 	-- 리턴메시지
	
	BEGIN TRAN
	BEGIN TRY 	
	
		------------------------------------------------------------
		-- SET 마스터 확정처리
		------------------------------------------------------------
		UPDATE PD_SET_PLAN_MST
			SET SET_STATUS = '3'
		      , UDATE = GETDATE()
			  , UEMP_ID = @P_EMP_ID
		   WHERE SET_PLAN_ID = @P_SET_PLAN_ID
		     AND SET_STATUS != '3'
		;

		------------------------------------------------------------
		-- TEMP 테이블 생성 및 인서트
		-- 조건: 투입, 환원 미확정 제품
		------------------------------------------------------------
		CREATE TABLE #TEMP_SET_RESTORE (
			SEQ INT
		);

		INSERT INTO #TEMP_SET_RESTORE (SEQ)
		SELECT A.SEQ
			FROM IV_STOCK_ADJUST AS A
			INNER JOIN (
				SELECT B.PROD_DT
					 , B.SET_COMP_CD AS SCAN_CODE
					 , B.LOT_NO
					 , B.COMP_QTY
					FROM PD_SET_PLAN_MST AS A
					INNER JOIN PD_SET_RESULT_COMP AS B ON A.SET_PLAN_ID = B.SET_PLAN_ID
				   WHERE A.SET_PLAN_ID = @P_SET_PLAN_ID
					 AND A.SET_STATUS = '3'
					 AND B.LOT_NO IS NOT NULL	-- LOT 있는 제품들이 투입, 환원제품
					 AND B.COMP_CFM_FLAG = 'N'
			) AS B ON A.INV_DT = B.PROD_DT AND A.SCAN_CODE = B.SCAN_CODE AND A.LOT_NO = B.LOT_NO AND A.CFM_FLAG = 'N' AND A.INV_GB IN ('11','12')

		;
		
		------------------------------------------------------------
		-- *투입 또는 환원 제품이 미확정상태로 있으면 확정 처리*
		------------------------------------------------------------
		DECLARE CUR CURSOR FOR
		SELECT SEQ
			FROM #TEMP_SET_RESTORE
		;
		
		DECLARE @C_SEQ INT;

		OPEN CUR;

		FETCH NEXT FROM CUR INTO @C_SEQ;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- 재고조정 확정 처리
			EXEC PR_SINGLE_STOCK_AD_CONFIRM @C_SEQ, @P_EMP_ID, 'Y';

			FETCH NEXT FROM CUR INTO @C_SEQ;
		END;
		
		CLOSE CUR;
		DEALLOCATE CUR;
		
		DROP TABLE #TEMP_SET_RESTORE;

		SET @RETURN_CODE = 91; -- 확정완료
		SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('91');
		
		COMMIT;
	END TRY
	
	BEGIN CATCH		
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN;
			
			DROP TABLE IF EXISTS #TEMP_SET_RESTORE;

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

