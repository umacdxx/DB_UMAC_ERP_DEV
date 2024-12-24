/*
-- 생성자 :	윤현빈
-- 등록일 :	2024.08.13
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : SET 생산 등록
-- 실행문 : EXEC PR_SET_PROD_PUT '', ''
*/
CREATE PROCEDURE [dbo].[PR_SET_PROD_PUT_BAK]
( 
	@P_JSONDT			VARCHAR(8000) = '',
	@P_EMP_ID			NVARCHAR(20)				-- 아이디
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @PRE_QTY		INT				= 0
	DECLARE @RETURN_CODE 	INT 			= 0		-- 리턴코드
	DECLARE @RETURN_MESSAGE NVARCHAR(10) 	= '' 	-- 리턴메시지
	
	

	BEGIN TRAN
	BEGIN TRY
			
		DECLARE @TMP_ITEM TABLE (
			PROD_DT NVARCHAR(8),
			SCAN_CODE NVARCHAR(14),
			PROD_QTY INT,
			SET_PLAN_ID NVARCHAR(11),
			MODE NVARCHAR(1)
		)
		
		INSERT INTO @TMP_ITEM
		SELECT PROD_DT, SCAN_CODE, PROD_QTY, SET_PLAN_ID, MODE
			FROM 
				OPENJSON ( @P_JSONDT )   
					WITH (    
						PROD_DT NVARCHAR(8) '$.PROD_DT',
						SCAN_CODE NVARCHAR(14) '$.SCAN_CODE',
						PROD_QTY INT '$.PROD_QTY',
						SET_PLAN_ID NVARCHAR(11) '$.SET_PLAN_ID',
						MODE NVARCHAR(1) '$.MODE'
					)
				
		DECLARE CURSOR_SET_PLAN CURSOR FOR

			SELECT A.PROD_DT, A.SCAN_CODE, A.PROD_QTY, A.SET_PLAN_ID, A.MODE 
				FROM @TMP_ITEM A
				INNER JOIN CD_PRODUCT_CMN AS B ON A.SCAN_CODE = B.SCAN_CODE
			
		OPEN CURSOR_SET_PLAN

		DECLARE @P_PROD_DT NVARCHAR(8),
		        @P_SCAN_CODE NVARCHAR(14),
				@P_PROD_QTY INT,
				@P_SET_PLAN_ID NVARCHAR(11),
				@P_MODE NVARCHAR(1)

		FETCH NEXT FROM CURSOR_SET_PLAN INTO @P_PROD_DT, @P_SCAN_CODE, @P_PROD_QTY, @P_SET_PLAN_ID, @P_MODE
		
			WHILE(@@FETCH_STATUS=0)
			BEGIN
				IF @P_MODE != 'D'
				BEGIN
					DECLARE @V_PRE_QTY INT;

					SELECT @V_PRE_QTY = ISNULL(MAX(PROD_QTY), 0) FROM PD_SET_RESULT_PROD WHERE SET_PLAN_ID = @P_SET_PLAN_ID AND PROD_DT = @P_PROD_DT AND SCAN_CODE = @P_SCAN_CODE;

------------------------------------------------------------
-- 1. SET 제품 생산 결과 저장
------------------------------------------------------------
					MERGE INTO PD_SET_RESULT_PROD AS A
						USING (select 1 as dual) AS B
						ON A.SET_PLAN_ID = @P_SET_PLAN_ID AND A.PROD_DT = @P_PROD_DT AND A.SCAN_CODE = @P_SCAN_CODE
					WHEN MATCHED THEN
						UPDATE 
							SET PROD_QTY = @P_PROD_QTY
								, UDATE = GETDATE()
								, UEMP_ID = @P_EMP_ID
					WHEN NOT MATCHED THEN 
						INSERT
						(
							SET_PLAN_ID
							, PROD_DT
							, SCAN_CODE
							, PROD_QTY
							, IDATE
							, IEMP_ID
							, UDATE
							, UEMP_ID
						)
						VALUES
						(
							@P_SET_PLAN_ID
							, @P_PROD_DT
							, @P_SCAN_CODE
							, @P_PROD_QTY
							, GETDATE()
							, @P_EMP_ID
							, NULL
							, NULL
						)
						;

------------------------------------------------------------
-- 2. SET 제품 생산 결과 재고처리
------------------------------------------------------------
					EXEC PR_IV_PRODUCT_STAT_HDR_PUT @P_SCAN_CODE, @P_PROD_QTY, 'PR_SET_PROD_PUT', @V_PRE_QTY, '', '', '', @RETURN_CODE, @RETURN_MESSAGE;

------------------------------------------------------------
--3. SET 제품 하위 생산 결과 저장
--  LOT없는 부자재류 만 처리, LOT 있는 제품들은 PDA에서 처리
------------------------------------------------------------
					-- 임시 테이블 생성
					CREATE TABLE #Temp_W_SEQ (
						SET_PLAN_ID VARCHAR(11),
						PROD_DT VARCHAR(8),
						SET_COMP_CD VARCHAR(13),
						PRE_COMP_QTY INT,
						COMP_QTY INT,
						New_SEQ INT
					);

					-- 임시 테이블에 데이터 삽입
					INSERT INTO #Temp_W_SEQ (SET_PLAN_ID, PROD_DT, SET_COMP_CD, PRE_COMP_QTY, COMP_QTY, New_SEQ)
					SELECT 
						B.SET_PLAN_ID,
						B.PROD_DT,
						B.SET_COMP_CD,
						B.PRE_COMP_QTY,
						B.COMP_QTY,
						ROW_NUMBER() OVER (PARTITION BY B.SET_PLAN_ID ORDER BY B.SET_COMP_CD) 
						+ ISNULL((SELECT MAX(SEQ) FROM PD_SET_RESULT_COMP WHERE SET_PLAN_ID = B.SET_PLAN_ID), 0) AS New_SEQ
					FROM (
						SELECT 
							A.SET_PLAN_ID,
							@P_PROD_DT AS PROD_DT,
							DTL.SET_COMP_CD,
							ISNULL(B.COMP_QTY, 0) AS PRE_COMP_QTY,
							DTL.COMP_QTY * @P_PROD_QTY AS COMP_QTY
						FROM CD_SET_HDR AS HDR
						INNER JOIN CD_SET_DTL AS DTL ON HDR.SET_CD = DTL.SET_CD
						INNER JOIN PD_SET_PLAN_COMP AS A ON DTL.SET_COMP_CD = A.SET_COMP_CD AND A.SET_PLAN_ID = @P_SET_PLAN_ID
						LEFT OUTER JOIN PD_SET_RESULT_COMP AS B ON A.SET_PLAN_ID = B.SET_PLAN_ID AND B.PROD_DT = @P_PROD_DT AND A.SET_COMP_CD = B.SET_COMP_CD AND B.RESTORE_YN = 'N'
						LEFT OUTER JOIN (
							SELECT MAX(LOT_NO) AS LOT_NO, SCAN_CODE
							FROM CD_LOT_MST AS MST_LOT
							GROUP BY SCAN_CODE
						) AS LOT ON DTL.SET_COMP_CD = LOT.SCAN_CODE
						WHERE HDR.SET_PROD_CD = @P_SCAN_CODE
						  AND LOT.LOT_NO IS NULL
					) B;

					-- MERGE 문 실행
					MERGE INTO PD_SET_RESULT_COMP AS A
					USING #Temp_W_SEQ AS B
					ON (A.SET_PLAN_ID = B.SET_PLAN_ID AND A.PROD_DT = B.PROD_DT AND A.SET_COMP_CD = B.SET_COMP_CD AND A.LOT_NO IS NULL AND A.RESTORE_YN = 'N')
					WHEN MATCHED THEN
						UPDATE 
							SET A.COMP_QTY = B.COMP_QTY,
								A.UDATE = GETDATE(),
								A.UEMP_ID = @P_EMP_ID
					WHEN NOT MATCHED BY TARGET THEN
						INSERT 
						(
							SET_PLAN_ID,
							SEQ,
							PROD_DT,
							SET_COMP_CD,
							LOT_NO,
							RESTORE_YN,
							COMP_QTY,
							IDATE,
							IEMP_ID,
							UDATE,
							UEMP_ID
						)
						VALUES 
						(
							B.SET_PLAN_ID,
							B.New_SEQ,
							B.PROD_DT,
							B.SET_COMP_CD,
							NULL,
							'N',
							B.COMP_QTY,
							GETDATE(),
							@P_EMP_ID,
							NULL,
							NULL
						);

------------------------------------------------------------
--4. SET 제품 하위 생산 결과 재고처리
------------------------------------------------------------
					DECLARE CURSOR_TEMP_W_SEQ CURSOR FOR
					SELECT SET_PLAN_ID, PROD_DT, SET_COMP_CD, PRE_COMP_QTY, COMP_QTY
					FROM #Temp_W_SEQ;

					OPEN CURSOR_TEMP_W_SEQ;

					DECLARE @T_SET_PLAN_ID VARCHAR(11),
							@T_PROD_DT VARCHAR(8),
							@T_SET_COMP_CD VARCHAR(13),
							@T_PRE_COMP_QTY INT,
							@T_COMP_QTY INT;

					FETCH NEXT FROM CURSOR_TEMP_W_SEQ INTO @T_SET_PLAN_ID, @T_PROD_DT, @T_SET_COMP_CD, @T_PRE_COMP_QTY, @T_COMP_QTY;

					WHILE @@FETCH_STATUS = 0
					BEGIN
	        
						EXEC PR_IV_PRODUCT_STAT_HDR_PUT @T_SET_COMP_CD, @T_COMP_QTY, 'PR_SET_PROD_PUT', @T_PRE_COMP_QTY, '', '', '', @RETURN_CODE, @RETURN_MESSAGE;

						FETCH NEXT FROM CURSOR_TEMP_W_SEQ INTO @T_SET_PLAN_ID, @T_PROD_DT, @T_SET_COMP_CD, @T_PRE_COMP_QTY, @T_COMP_QTY;
					END;

					CLOSE CURSOR_TEMP_W_SEQ;
					DEALLOCATE CURSOR_TEMP_W_SEQ;

					-- 임시 테이블 삭제
					DROP TABLE #Temp_W_SEQ;



				END

				FETCH NEXT FROM CURSOR_SET_PLAN INTO @P_PROD_DT, @P_SCAN_CODE, @P_PROD_QTY, @P_SET_PLAN_ID, @P_MODE

			END

		CLOSE CURSOR_SET_PLAN
		DEALLOCATE CURSOR_SET_PLAN
		
		SET @RETURN_CODE = 0; -- 저장완료
		SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('0');
		COMMIT;
	END TRY
	
	BEGIN CATCH		
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN
			
			DROP TABLE IF EXISTS #Temp_W_SEQ;

			--에러 로그 테이블 저장
			INSERT INTO TBL_ERROR_LOG 
			SELECT ERROR_PROCEDURE()	-- 프로시저명
			, ERROR_MESSAGE()			-- 에러메시지
			, ERROR_LINE()				-- 에러라인
			, GETDATE();
		
			SET @RETURN_CODE = -1; -- 저장 실패
			SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('-1');
			
			SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE
		END
			
	END CATCH

	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE

END

GO

