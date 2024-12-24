/*
-- 생성자 :	윤현빈
-- 등록일 :	2024.04.12
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 생산 현재고(장부) 저장
-- 실행문 : EXEC PR_IV_PRODUCT_STAT_PUT 'N','333','','','','',0,0,'','PR_PROD_STOCK_REGISTER_PUT';
-- 수정 : 2024.05.20 윤현빈, BOM/SET 재고처리부분 공통프로시저 사용하도록 수정
*/
CREATE PROCEDURE [dbo].[PR_IV_PRODUCT_STAT_PUT]
	@P_MODIFY_YN		NVARCHAR(1),		-- #(필수)당일 수정여부(수정:Y, 신규:N)
	@P_SCAN_CODE		NVARCHAR(14),	-- #(필수)상품코드
	@P_LOT_NO			NVARCHAR(30),	-- LOT 번호
	@P_PROD_GB			NVARCHAR(1),		-- 생산구분 (BOM/SET)
	@P_PROD_GB_CD		NVARCHAR(3),		-- 생산구분코드 (BOM/SET CODE)
	@P_LAST_PUR_DT		NVARCHAR(8),		-- 최종 매입일자
	@P_LAST_SALE_DT		NVARCHAR(8),		-- 최종 매출일자
	@P_PRE_PROD_QTY		NUMERIC(15, 2),		-- 변경이전수량 (@P_MODIFY_YN: Y 인 경우만 해당)
	@P_PRE_PROD_APP_QTY	NUMERIC(15, 2),		-- 변경이전수량 (@P_MODIFY_YN: Y 인 경우만 해당)
	@P_PRE_PROD_GB_CD	VARCHAR(3),			-- 변경이전 BOM/SET CODE (@P_MODIFY_YN: Y 인 경우만 해당)
	@P_CHG_QTY			NUMERIC(15, 2),		-- #(필수)변경수량
	@P_CHG_APP_QTY		NUMERIC(15, 2),		-- #(필수)변경 확정수량
	@P_PROCEDUAL_NM		VARCHAR(30),		-- 프로시저 or 실행 히스토리 이름	
	@P_PROD_DT			NVARCHAR(10),	-- 생산일자
	@P_EMP_ID			NVARCHAR(20),		-- 등록자
	@P_CONFIRM_YN		NVARCHAR(2),		-- 확정 여부
	@R_RETURN_CODE 		INT 			OUTPUT,	-- 리턴코드
	@R_RETURN_MESSAGE 	NVARCHAR(10) 	OUTPUT 	-- 리턴메시지
	
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	--DECLARE @V_MAX_SEQ		INT

	BEGIN TRAN
	BEGIN TRY 
		
		DECLARE @V_R_YN NVARCHAR(1); -- 알병이 생기면 부자재 처리할 때 SUM 처야하기 때문에 변수 생성
		SELECT @V_R_YN = CASE WHEN COUNT(*) > 1 THEN 'R' ELSE 'N' END FROM CD_LOT_MST WHERE PROD_DT = @P_PROD_DT AND SCAN_CODE = @P_SCAN_CODE


		--(공통) 상품 재고 업데이트 
		-- 생산 미래일자는 현재고 처리 x
		-- 확정된 것만 재고 처리
		IF @P_PROD_DT <= CONVERT(VARCHAR(8), GETDATE(), 112) AND @P_PROCEDUAL_NM = 'PR_PROD_STOCK_REGISTER_PUT' AND @P_CONFIRM_YN = 'Y'
		BEGIN
			--EXEC PR_IV_PRODUCT_STAT_HDR_PUT @P_SCAN_CODE, @P_CHG_APP_QTY, @P_PROCEDUAL_NM, @P_PRE_PROD_APP_QTY, @P_LOT_NO, '', '', @R_RETURN_CODE OUTPUT, @R_RETURN_MESSAGE OUTPUT;
			EXEC PR_IV_PRODUCT_STAT_HDR_PUT @P_SCAN_CODE, @P_CHG_APP_QTY, @P_PROCEDUAL_NM, 0, @P_LOT_NO, '', '', @R_RETURN_CODE OUTPUT, @R_RETURN_MESSAGE OUTPUT;
		END	

		/*
		 * 생산 공박스 처리
		 */
		DECLARE @V_EMPTY_BOX_SCAN_CODE NVARCHAR(14), @V_EMPTY_BOX_QTY INT, @V_EMPTY_BOX_PRE_QTY INT;

		SELECT @V_EMPTY_BOX_SCAN_CODE = A.MGMT_ENTRY_1														-- 공박스 SCAN_CODE
			 , @V_EMPTY_BOX_QTY = ISNULL(CEILING(CAST(@P_CHG_APP_QTY AS FLOAT) / b.IPSU_QTY), 0)			-- 생산수량 / 박스 입수량
			 , @V_EMPTY_BOX_PRE_QTY = ISNULL(CEILING(CAST(@P_PRE_PROD_APP_QTY AS FLOAT) / b.IPSU_QTY), 0)	-- 이전생산수량 / 박스 입수량
			FROM TBL_COMM_CD_MST AS A 
			INNER JOIN CD_BOX_MST AS B ON A.CD_ID = B.ITM_CODE
			INNER JOIN CD_PRODUCT_CMN AS C ON A.CD_ID = C.ITM_CODE
		   WHERE A.CD_CL = 'MAPPING_PRD_BOX'
			 AND C.SCAN_CODE = @P_SCAN_CODE
		;

		IF @V_EMPTY_BOX_SCAN_CODE IS NOT NULL
		BEGIN
		-- 알병 추가로 인해 동일한일자에 동일한 SCAN_CODE가 생산 가능하여 공박스 와 같은 부재료들 수정 및 저장이 애매해짐.
		-- 때문에 아래 로직 추가
			DECLARE @V_R_PROD_QTY INT;
			DECLARE @V_EMPTY_BOX_R_QTY INT;
			IF @V_R_YN = 'R'
			BEGIN
				SELECT @V_R_PROD_QTY = CASE WHEN @P_CONFIRM_YN = 'N' THEN SUM(PROD_QTY) ELSE SUM(PROD_APP_QTY) END
					FROM CD_LOT_MST
				   WHERE PROD_DT = @P_PROD_DT
					 AND SCAN_CODE = @P_SCAN_CODE
				;

				SELECT @V_EMPTY_BOX_R_QTY = ISNULL(CEILING(CAST(@V_R_PROD_QTY AS FLOAT) / b.IPSU_QTY), 0)			-- 생산수량 / 박스 입수량
					FROM TBL_COMM_CD_MST AS A 
					INNER JOIN CD_BOX_MST AS B ON A.CD_ID = B.ITM_CODE
					INNER JOIN CD_PRODUCT_CMN AS C ON A.CD_ID = C.ITM_CODE
				   WHERE A.CD_CL = 'MAPPING_PRD_BOX'
					 AND C.SCAN_CODE = @P_SCAN_CODE
				;
			END

			MERGE INTO PD_MAT_USAGE AS A
				USING (select 1 as dual) AS B
				ON A.PROD_DT = @P_PROD_DT AND A.SCAN_CODE = @P_SCAN_CODE AND A.COMP_CODE = @V_EMPTY_BOX_SCAN_CODE AND MAT_GB = '5'
			WHEN MATCHED THEN
				UPDATE SET
					A.INPUT_QTY = CASE WHEN @V_R_YN = 'R' THEN @V_EMPTY_BOX_R_QTY ELSE @V_EMPTY_BOX_QTY END
					, A.UDATE = GETDATE()
					, A.UEMP_ID = @P_EMP_ID
			WHEN NOT MATCHED THEN
				INSERT
				(
					PROD_DT
					, SCAN_CODE
					, COMP_CODE
					, MAT_GB
					, YYYYMM
					, INPUT_QTY
					, IDATE
					, IEMP_ID
					, UDATE
					, UEMP_ID
				)
				VALUES
				(
					@P_PROD_DT
					, @P_SCAN_CODE
					, @V_EMPTY_BOX_SCAN_CODE
					, '5'
					, CONVERT(NVARCHAR(6), @P_PROD_DT, 112)
					, @V_EMPTY_BOX_QTY
					, GETDATE()
					, @P_EMP_ID
					, NULL
					, NULL
				)
			;

			SET @V_EMPTY_BOX_QTY = @V_EMPTY_BOX_QTY * (-1);
			SET @V_EMPTY_BOX_PRE_QTY = @V_EMPTY_BOX_PRE_QTY * (-1);
			-- 공박스 상품 재고 업데이트 
			-- 생산 미래일자는 현재고 처리 x
			IF @P_PROD_DT <= CONVERT(VARCHAR(8), GETDATE(), 112) AND @P_PROCEDUAL_NM = 'PR_PROD_STOCK_REGISTER_PUT' AND @P_CONFIRM_YN = 'Y'
			BEGIN
				--EXEC PR_IV_PRODUCT_STAT_HDR_PUT @V_EMPTY_BOX_SCAN_CODE, @V_EMPTY_BOX_QTY, @P_PROCEDUAL_NM, @V_EMPTY_BOX_PRE_QTY, @P_LOT_NO, '', '', @R_RETURN_CODE OUTPUT, @R_RETURN_MESSAGE OUTPUT;
				EXEC PR_IV_PRODUCT_STAT_HDR_PUT @V_EMPTY_BOX_SCAN_CODE, @V_EMPTY_BOX_QTY, @P_PROCEDUAL_NM, 0, @P_LOT_NO, '', '', @R_RETURN_CODE OUTPUT, @R_RETURN_MESSAGE OUTPUT;
			END
		END
	
		/*
		 * 생산 BOM or SET 처리 START
		 */
		--SELECT @V_MAX_SEQ = ISNULL(MAX(LOG_SEQ) + 1, 1) FROM IV_PRODUCT_STAT_LOG
	
		IF @P_PROD_GB != '' 
		BEGIN
		-- 3_1. BOM or SET 테이블 변수 생성
			DECLARE @TMP_PROD_GB TABLE      
			(    
			    ID 			INT IDENTITY(1,1),
				SCAN_CODE 		NVARCHAR(14),
				ITM_CODE 		NVARCHAR(6),
				CHG_QTY 		NUMERIC(15, 2),
				CHG_APP_QTY 		NUMERIC(15, 2),
				PRE_PROD_QTY 	NUMERIC(15, 2),
				PRE_PROD_APP_QTY 	NUMERIC(15, 2)
			) 
		
			IF @P_PROD_GB = 'B'
			BEGIN
				INSERT INTO @TMP_PROD_GB(SCAN_CODE, ITM_CODE, CHG_QTY, CHG_APP_QTY, PRE_PROD_QTY, PRE_PROD_APP_QTY)
				SELECT B.BOM_COMP_CD
				     , C.ITM_CODE
				     , -B.COMP_QTY * @P_CHG_QTY 
				     , -B.COMP_QTY * @P_CHG_APP_QTY 
				     , CASE WHEN @P_MODIFY_YN = 'Y' AND @P_PROD_GB_CD = @P_PRE_PROD_GB_CD THEN B.COMP_QTY * @P_PRE_PROD_QTY ELSE 0 END 
				     , CASE WHEN @P_MODIFY_YN = 'Y' AND @P_PROD_GB_CD = @P_PRE_PROD_GB_CD THEN B.COMP_QTY * @P_PRE_PROD_APP_QTY ELSE 0 END 
					FROM CD_BOM_HDR 			AS A
					INNER JOIN CD_BOM_DTL 		AS B ON A.BOM_CD 		= B.BOM_CD
					INNER JOIN CD_PRODUCT_CMN 	AS C ON B.BOM_COMP_CD 	= C.SCAN_CODE 
				   WHERE 1=1
				     AND A.BOM_CD = @P_PROD_GB_CD
				UNION ALL
				-- 당일 BOM/SET 수정 시 
				SELECT B.BOM_COMP_CD
				     , C.ITM_CODE
				     , B.COMP_QTY * @P_PRE_PROD_QTY 
				     , B.COMP_QTY * @P_PRE_PROD_APP_QTY 
				     , 0
					 , 0
					FROM CD_BOM_HDR 			AS A
					INNER JOIN CD_BOM_DTL 		AS B ON A.BOM_CD 		= B.BOM_CD
					INNER JOIN CD_PRODUCT_CMN 	AS C ON B.BOM_COMP_CD 	= C.SCAN_CODE 
				   WHERE 1=1
				     AND A.BOM_CD 		= @P_PRE_PROD_GB_CD
				     AND @P_PROD_GB_CD 	!= @P_PRE_PROD_GB_CD
				  ORDER BY B.BOM_COMP_CD
			END
			ELSE IF @P_PROD_GB = 'S'
			BEGIN 
				INSERT INTO @TMP_PROD_GB(SCAN_CODE, ITM_CODE, CHG_QTY, CHG_APP_QTY, PRE_PROD_QTY, PRE_PROD_APP_QTY)
				SELECT B.SET_COMP_CD
				     , C.ITM_CODE
				     , -B.COMP_QTY * @P_CHG_QTY 
				     , -B.COMP_QTY * @P_CHG_APP_QTY 
				     , CASE WHEN @P_MODIFY_YN = 'Y' AND @P_PROD_GB_CD = @P_PRE_PROD_GB_CD THEN B.COMP_QTY * @P_PRE_PROD_QTY ELSE 0 END 
				     , CASE WHEN @P_MODIFY_YN = 'Y' AND @P_PROD_GB_CD = @P_PRE_PROD_GB_CD THEN B.COMP_QTY * @P_PRE_PROD_APP_QTY ELSE 0 END 
					FROM CD_SET_HDR 			AS A
					INNER JOIN CD_SET_DTL 		AS B ON A.SET_CD 		= B.SET_CD
					INNER JOIN CD_PRODUCT_CMN 	AS C ON B.SET_COMP_CD 	= C.SCAN_CODE 
				   WHERE 1=1
				     AND A.SET_CD = @P_PROD_GB_CD
				UNION ALL 
				-- 당일 BOM/SET 수정 시
				SELECT B.SET_COMP_CD
				     , C.ITM_CODE
				     , B.COMP_QTY * @P_PRE_PROD_QTY 
				     , B.COMP_QTY * @P_PRE_PROD_APP_QTY 
				     , 0
					 , 0
					FROM CD_SET_HDR 			AS A
					INNER JOIN CD_SET_DTL 		AS B ON A.SET_CD 		= B.SET_CD
					INNER JOIN CD_PRODUCT_CMN 	AS C ON B.SET_COMP_CD 	= C.SCAN_CODE 
				   WHERE 1=1
				     AND A.SET_CD 		= @P_PRE_PROD_GB_CD
				     AND @P_PROD_GB_CD 	!= @P_PRE_PROD_GB_CD
				  ORDER BY B.SET_COMP_CD
			END
		/*
		 * BOM or SET 재고 로그 처리
		 * (2024-09-03 추가) CAP생산이 있다면 해당하는 루뎅 추가
		 */
			DECLARE @MAX_ID INT = (SELECT MAX(ID) FROM @TMP_PROD_GB)
			DECLARE @CUR_ID INT = 1

			WHILE @CUR_ID <= @MAX_ID
			BEGIN
				DECLARE @T_SCAN_CODE NVARCHAR(14), @T_CHG_QTY NUMERIC(15, 2), @T_CHG_APP_QTY NUMERIC(15, 2), @T_PRE_PROD_QTY NUMERIC(15, 2), @T_PRE_PROD_APP_QTY NUMERIC(15, 2)
				
				SELECT @T_SCAN_CODE = A.SCAN_CODE
				     , @T_CHG_QTY = A.CHG_QTY
					 , @T_CHG_APP_QTY = A.CHG_APP_QTY
				     , @T_PRE_PROD_QTY = A.PRE_PROD_QTY * -1
				     , @T_PRE_PROD_APP_QTY = A.PRE_PROD_APP_QTY * -1
					FROM @TMP_PROD_GB AS A
				   WHERE A.ID = @CUR_ID
				   ;

				IF @P_MODIFY_YN = 'Y'
				BEGIN
					--UPDATE PD_BOM_SET_HIST
					--	SET COMP_QTY = @T_CHG_QTY
					--	  , COMP_APP_QTY = @T_CHG_APP_QTY
					--	  , CFM_FLAG = 'Y'
					--	  , UDATE = GETDATE()
					--	  , UEMP_ID = @P_EMP_ID
					--   WHERE PROD_DT = @P_PROD_DT
					--     AND PROD_GB = @P_PROD_GB
					--     AND BOM_SET_CD = @P_PROD_GB_CD
					--     AND LOT_NO = @P_LOT_NO
					--     AND BOM_SET_COMP_CD = @T_SCAN_CODE
					--;
					MERGE INTO PD_BOM_SET_HIST AS A
						USING (SELECT 1 AS DUAL) AS B
						ON (A.PROD_DT = @P_PROD_DT
					    AND A.PROD_GB = @P_PROD_GB
					    AND A.BOM_SET_CD = @P_PROD_GB_CD
					    AND A.LOT_NO = @P_LOT_NO
					    AND A.BOM_SET_COMP_CD = @T_SCAN_CODE
						)
					WHEN MATCHED THEN
						UPDATE 
						SET COMP_QTY = @T_CHG_QTY
							, COMP_APP_QTY = @T_CHG_APP_QTY
							, CFM_FLAG = @P_CONFIRM_YN
							, UDATE = GETDATE()
							, UEMP_ID = @P_EMP_ID
					WHEN NOT MATCHED THEN
						INSERT 
						(
							PROD_DT
						  , PROD_GB
						  , BOM_SET_CD
						  , LOT_NO
						  , BOM_SET_COMP_CD
						  , COMP_QTY
						  , COMP_APP_QTY
						  , CFM_FLAG
						  , IDATE
						  , IEMP_ID
						)
						VALUES 
						(
							@P_PROD_DT
						  , @P_PROD_GB
						  , @P_PROD_GB_CD
						  , @P_LOT_NO
						  , @T_SCAN_CODE
						  , @T_CHG_QTY
						  , @T_CHG_APP_QTY
						  , 'Y'
						  , GETDATE()
						  , @P_EMP_ID
						)
					;
				END
				ELSE IF @P_MODIFY_YN = 'N'
				BEGIN
					INSERT INTO PD_BOM_SET_HIST 
					(
						PROD_DT
					  , PROD_GB
					  , BOM_SET_CD
					  , LOT_NO
					  , BOM_SET_COMP_CD
					  , COMP_QTY
					  , COMP_APP_QTY
					  , IDATE
					  , IEMP_ID
					)
					VALUES
					(
						@P_PROD_DT
					  , @P_PROD_GB
					  , @P_PROD_GB_CD
					  , @P_LOT_NO
					  , @T_SCAN_CODE
					  , @T_CHG_QTY
					  , @T_CHG_APP_QTY
					  , GETDATE()
					  , @P_EMP_ID
					)
					;
				END

				/*
				 * CAP생산이 있다면 해당하는 루뎅 추가
				 */
				DECLARE @V_LUTEN_CODE NVARCHAR(14), @PRE_LUTEN_QTY INT;
				SET @V_LUTEN_CODE = NULL;
				
				SELECT @V_LUTEN_CODE = MGMT_ENTRY_1 FROM TBL_COMM_CD_MST AS A WHERE A.CD_CL = 'MAPPING_CAP_LUTEN' AND A.CD_ID = @T_SCAN_CODE

				---- BOM이 CAP 상품일 때
				IF @V_LUTEN_CODE IS NOT NULL
				BEGIN

				-- 알병 추가로 인해 동일한일자에 동일한 SCAN_CODE가 생산 가능하여 공박스 와 같은 부재료들 수정 및 저장이 애매해짐.
				-- 때문에 아래 로직 추가
					DECLARE @V_R_COMP_QTY INT;
					IF @V_R_YN = 'R'
					BEGIN
						SELECT @V_R_COMP_QTY = CASE WHEN @P_CONFIRM_YN = 'Y' THEN SUM(COMP_APP_QTY) * (-1) ELSE SUM(COMP_QTY) * (-1) END
							FROM PD_BOM_SET_HIST
						   WHERE PROD_DT = @P_PROD_DT
							 AND PROD_GB = @P_PROD_GB
							 AND BOM_SET_CD = @P_PROD_GB_CD
							 AND BOM_SET_COMP_CD = @T_SCAN_CODE
						;
					END

					IF @P_MODIFY_YN = 'Y'
					BEGIN
						UPDATE PD_MAT_USAGE
							SET INPUT_QTY = CASE WHEN @V_R_YN = 'R' THEN @V_R_COMP_QTY ELSE @T_CHG_APP_QTY * (-1) END
							  , UDATE = GETDATE()
							  , UEMP_ID = @P_EMP_ID
						   WHERE PROD_DT = @P_PROD_DT 
						     AND SCAN_CODE = @P_SCAN_CODE
							 AND COMP_CODE = @T_SCAN_CODE
							 AND MAT_GB = '1'
						;
					END

					ELSE IF @P_MODIFY_YN = 'N'
					BEGIN
						MERGE INTO PD_MAT_USAGE AS A
						USING (SELECT 1 AS DUAL) AS B
						ON (
							A.PROD_DT = @P_PROD_DT
						AND A.SCAN_CODE = @P_SCAN_CODE
						AND A.COMP_CODE = @T_SCAN_CODE
						)
						WHEN MATCHED THEN
							UPDATE SET
								INPUT_QTY = INPUT_QTY + @T_CHG_APP_QTY * (-1)
							  , UDATE = GETDATE()
							  , UEMP_ID = @P_EMP_ID
						WHEN NOT MATCHED THEN
							INSERT
							(
								PROD_DT
							  , SCAN_CODE
							  , COMP_CODE
							  , MAT_GB
							  , YYYYMM
							  , INPUT_QTY
							  , IDATE
							  , IEMP_ID
							  , UDATE
							  , UEMP_ID
							)
							VALUES
							(
								@P_PROD_DT
							  , @P_SCAN_CODE
							  , @T_SCAN_CODE
							  , '1'
							  , CONVERT(NVARCHAR(6), @P_PROD_DT, 112)
							  , @T_CHG_APP_QTY * (-1)
							  , GETDATE()
							  , @P_EMP_ID
							  , NULL
							  , NULL
							)
							
						--INSERT INTO PD_MAT_USAGE
						--(
						--	PROD_DT
						--  , SCAN_CODE
						--  , COMP_CODE
						--  , MAT_GB
						--  , YYYYMM
						--  , INPUT_QTY
						--  , IDATE
						--  , IEMP_ID
						--  , UDATE
						--  , UEMP_ID
						--)
						--VALUES
						--(
						--	@P_PROD_DT
						--  , @P_SCAN_CODE
						--  , @T_SCAN_CODE
						--  , '1'
						--  , CONVERT(NVARCHAR(6), @P_PROD_DT, 112)
						--  , @T_CHG_APP_QTY * (-1)
						--  , GETDATE()
						--  , @P_EMP_ID
						--  , NULL
						--  , NULL
						--)
						;
					END
				END
				  
				-- BOM 재고처리
				-- 생산 미래일자는 현재고 처리 x
				IF @P_PROD_DT <= CONVERT(VARCHAR(8), GETDATE(), 112) AND @P_PROCEDUAL_NM = 'PR_PROD_STOCK_REGISTER_PUT' AND @P_CONFIRM_YN = 'Y'
				BEGIN
			  		--EXEC PR_IV_PRODUCT_STAT_HDR_PUT @T_SCAN_CODE, @T_CHG_APP_QTY, @P_PROCEDUAL_NM, @T_PRE_PROD_APP_QTY, '', '', '', @R_RETURN_CODE OUTPUT, @R_RETURN_MESSAGE OUTPUT;
			  		EXEC PR_IV_PRODUCT_STAT_HDR_PUT @T_SCAN_CODE, @T_CHG_APP_QTY, @P_PROCEDUAL_NM, 0, '', '', '', @R_RETURN_CODE OUTPUT, @R_RETURN_MESSAGE OUTPUT;
				END
				
				SET @CUR_ID = @CUR_ID + 1
			END
		END
		
		SET @R_RETURN_CODE = 0
		SET @R_RETURN_MESSAGE = '저장되었습니다.'
				
		--ERR 테스트
--		DECLARE @P INT = 0
--		SET @P = 1/0
		--ERR 테스트//

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
				, GETDATE()	

			SET @R_RETURN_CODE = -41 -- BOM/SET 저장 실패
			SET @R_RETURN_MESSAGE = DBO.GET_ERR_MSG('-41')

		END 
				
	END CATCH

END

GO

