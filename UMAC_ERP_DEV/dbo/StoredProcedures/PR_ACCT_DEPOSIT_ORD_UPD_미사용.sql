
/*

-- 생성자 :	윤현빈
-- 등록일 :	2024.06.25
-- 수정자 : -
-- 수정일 : -
-- 설 명  : 주문별 입금처리 업데이트 처리 TEST
-- 실행문 : EXEC PR_ACCT_DEPOSIT_ORD_UPD 'UM20127', '01', 400000, @R_RETURN_CODE OUT, @R_RETURN_MESSAGE OUT

SELECT @R_RETURN_CODE, @R_RETURN_MESSAGE

*/
CREATE PROCEDURE [dbo].[PR_ACCT_DEPOSIT_ORD_UPD_미사용]
( 	
	@P_VEN_CODE			NVARCHAR(11),			-- 거래처코드
	@P_DEPOSIT_GB		NVARCHAR(2),			-- 입금구분
	@P_PRE_DEPOSIT_AMT	INT,					-- 변경전 입금금액
	@P_DEPOSIT_NO		NVARCHAR(11),			-- 입금번호
	@P_MODE				NVARCHAR(1),			-- 상태
	--@P_MOID				NVARCHAR(100),--
	@R_RETURN_CODE 		INT 			OUTPUT,	-- 리턴코드
	@R_RETURN_MESSAGE 	NVARCHAR(10) 	OUTPUT 	-- 리턴메시지
	
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SET @R_RETURN_CODE = 0									-- 리턴코드(저장완료)
	SET @R_RETURN_MESSAGE = DBO.GET_ERR_MSG('0')			-- 리턴메시지
	DECLARE @DEPOSIT_DT	NVARCHAR(8) = FORMAT(GETDATE(), 'yyyyMMdd')
	DECLARE @DEPOSIT_FLAG NVARCHAR(1) = 'N' -- 예치금 플래그 추가

	BEGIN TRAN
	BEGIN TRY 	
	
		--DECLARE	@V_DEPOSIT_AMT_SUM INT = @P_PRE_DEPOSIT_AMT;
		
		-- 업데이트된 입금내역에 걸려있는 주문서 삭제 처리
		--UPDATE PA_ACCT_DEPOSIT_ORD
		--	SET DEL_YN = 'Y'
		--	WHERE VEN_CODE = @P_VEN_CODE 
		--	  AND DEPOSIT_NO = @P_DEPOSIT_NO
		--;
		
		-- 업데이트된 입금내역에 걸려있는 주문서 삭제 처리
		UPDATE PA_ACCT_DEPOSIT_ORD
			SET DEL_YN = 'Y'
		   WHERE VEN_CODE = @P_VEN_CODE 
			 AND DEPOSIT_NO = @P_DEPOSIT_NO
			 AND DEL_YN = 'N'


		-- 예치금이 있을 시 해당 거래처 주문서별 입금내역 모두 N 처리 (임시)
		IF EXISTS (				
					SELECT VEN_CODE
						FROM PA_ACCT_DEPOSIT_ORD 
						WHERE VEN_CODE = @P_VEN_CODE 
							AND DEPOSIT_AMT < 0
							AND DEL_YN = 'N'
						GROUP BY VEN_CODE
						)
		BEGIN
			SET @DEPOSIT_FLAG = 'Y';

			UPDATE PA_ACCT_DEPOSIT_ORD
				SET DEL_YN = 'Y'
			   WHERE VEN_CODE = 
				   (
					SELECT VEN_CODE
						FROM PA_ACCT_DEPOSIT_ORD 
						WHERE VEN_CODE = @P_VEN_CODE 
							AND DEPOSIT_AMT < 0
							AND DEL_YN = 'N'
						GROUP BY VEN_CODE
					)
		     AND DEL_YN = 'N'
			 AND SALE_TOTAL_AMT = 0
		END

		;

		IF @P_MODE = 'U'
		BEGIN
			DECLARE @SALE_DT NVARCHAR(8) = '',
					@ORD_NO NVARCHAR(11) = '',
					@SALE_TOTAL_AMT INT
			;

			DECLARE CURSOR_ORD CURSOR FOR 

				SELECT SALE_DT, ORD_NO, SALE_TOTAL_AMT
					FROM PA_ACCT_DEPOSIT_ORD 
				   WHERE VEN_CODE = @P_VEN_CODE 
					 AND DEPOSIT_NO = @P_DEPOSIT_NO
					 AND DEL_YN = 'Y' 
						--AND SALE_TOTAL_AMT > 0 
					 AND DEPOSIT_AMT >= 0
					GROUP BY SALE_DT, ORD_NO, SALE_TOTAL_AMT
					ORDER BY ORD_NO DESC

			OPEN CURSOR_ORD
 
			FETCH NEXT FROM CURSOR_ORD
				INTO @SALE_DT, @ORD_NO, @SALE_TOTAL_AMT
			WHILE @@FETCH_STATUS = 0 
			BEGIN

				UPDATE PA_ACCT_DEPOSIT_ORD
					SET DEPOSIT_FISH = 'N'
				   WHERE SALE_DT = @SALE_DT
					 AND ORD_NO = @ORD_NO
					 AND DEL_YN = 'N'
				;

				IF @SALE_TOTAL_AMT != 0 
				BEGIN
					-- 삭제처리한 주문서 그대로 새 주문서 처럼 인서트
					MERGE INTO PA_ACCT_DEPOSIT_ORD AS A
						USING (SELECT 1 AS daul) AS B
						ON (A.SALE_DT = @SALE_DT AND ORD_NO = @ORD_NO AND A.VEN_CODE = @P_VEN_CODE AND DEPOSIT_NO = '' AND DEL_YN = 'N' AND SALE_TOTAL_AMT = @SALE_TOTAL_AMT)
					WHEN NOT MATCHED THEN
						INSERT (
							SALE_DT
							, ORD_NO
							, VEN_CODE
							, SALE_TOTAL_AMT
							, DEPOSIT_GB
							, DEPOSIT_NO
							, MOID
							, DEPOSIT_AMT
							, DEPOSIT_DT
							, DEPOSIT_FISH
							, IDATE
						)
						VALUES
						(
							@SALE_DT
							, @ORD_NO
							, @P_VEN_CODE
							, @SALE_TOTAL_AMT
							, '' 
							, ''
							, ''
							, 0
							, ''
							, 'N'
							, GETDATE()
						)
						;
				END

				FETCH NEXT FROM CURSOR_ORD
    				INTO @SALE_DT, @ORD_NO, @SALE_TOTAL_AMT
			END
 
			CLOSE CURSOR_ORD
			DEALLOCATE CURSOR_ORD

		END
		
		COMMIT;

	END TRY
	BEGIN CATCH	
				
		IF @@TRANCOUNT > 0
		BEGIN 
 
			IF CURSOR_STATUS('global', 'CURSOR_ORD') >= 0
			BEGIN
				CLOSE CURSOR_ORD;
				DEALLOCATE CURSOR_ORD;
			END

			ROLLBACK TRAN
			
			--에러 로그 테이블 저장
			INSERT INTO TBL_ERROR_LOG 
			SELECT ERROR_PROCEDURE()			-- 프로시저명
					, ERROR_MESSAGE()			-- 에러메시지
					, ERROR_LINE()				-- 에러라인
					, GETDATE()	

			SET @R_RETURN_CODE = -1
			SET @R_RETURN_MESSAGE = ERROR_MESSAGE()
			
		END 
	END CATCH
	
END

GO

