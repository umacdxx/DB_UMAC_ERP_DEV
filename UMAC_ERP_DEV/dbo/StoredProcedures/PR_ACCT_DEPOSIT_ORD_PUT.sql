
/*

-- 생성자 :	이동호
-- 등록일 :	2024.06.24

-- 수정자 : 이동호
-- 수정일 : 2024.12.12
-- 수정내용 : PA_ACCT_DEPOSIT_ORD.DEL_YN 컬럼 삭제 사용 안하는 컬럼

-- 설 명  : 주문별 입금처리 등록
-- 실행문 : 


DECLARE @R_RETURN_CODE 		INT
DECLARE @R_RETURN_MESSAGE 	NVARCHAR(2000)
EXEC PR_ACCT_DEPOSIT_ORD_PUT 'UM20127', '01', 100000, '1', '1',@R_RETURN_CODE OUT, @R_RETURN_MESSAGE OUT
GO
DECLARE @R_RETURN_CODE 		INT
DECLARE @R_RETURN_MESSAGE 	NVARCHAR(2000)
EXEC PR_ACCT_DEPOSIT_ORD_PUT 'UM20127', '01', 200000, '2', '2',@R_RETURN_CODE OUT, @R_RETURN_MESSAGE OUT
GO
DECLARE @R_RETURN_CODE 		INT
DECLARE @R_RETURN_MESSAGE 	NVARCHAR(2000)
EXEC PR_ACCT_DEPOSIT_ORD_PUT 'UM20127', '01', 710000, '3', '3',@R_RETURN_CODE OUT, @R_RETURN_MESSAGE OUT
GO
DECLARE @R_RETURN_CODE 		INT
DECLARE @R_RETURN_MESSAGE 	NVARCHAR(2000)
EXEC PR_ACCT_DEPOSIT_ORD_PUT 'UM20127', '01', 5000, '4', '4',@R_RETURN_CODE OUT, @R_RETURN_MESSAGE OUT


SELECT @R_RETURN_CODE, @R_RETURN_MESSAGE


SELECT * FROM PA_ACCT_DEPOSIT_ORD
*/
CREATE PROCEDURE [dbo].[PR_ACCT_DEPOSIT_ORD_PUT]
( 	
	@P_VEN_CODE			NVARCHAR(11),			-- 거래처코드
	@P_DEPOSIT_GB		NVARCHAR(2),			-- 입금구분
	@P_DEPOSIT_AMT		NUMERIC(17,4),			-- 입금금액
	@P_MOID				NVARCHAR(100),			-- PG주문번호
	@P_DEPOSIT_NO		NVARCHAR(11),			-- 입금번호
	@P_DEPOSIT_DT		NVARCHAR(11),			-- 입금날짜
	@P_IDATE			DATETIME,				-- 입금일자
	@R_RETURN_CODE 		INT 			OUTPUT,	-- 리턴코드
	@R_RETURN_MESSAGE 	NVARCHAR(2000) 	OUTPUT 	-- 리턴메시지
	
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SET @R_RETURN_CODE = 0									-- 리턴코드(저장완료)
	SET @R_RETURN_MESSAGE = DBO.GET_ERR_MSG('0')			-- 리턴메시지
	DECLARE @DEPOSIT_DT	NVARCHAR(8) = @P_DEPOSIT_DT

	BEGIN TRAN
	BEGIN TRY 	
		DECLARE	@DEPOSIT_NO NVARCHAR(11) = ''
		DECLARE @IN_AMT INT
		DECLARE @IDATE DATETIME				
		DECLARE @V_DEPOSIT_AMT NUMERIC(17,4) = @P_DEPOSIT_AMT
		DECLARE @DEPOSIT_AMT_SUM NUMERIC(17,4) = 0	
		DECLARE @DEPOSIT_AMT_TOAL_SUM NUMERIC(17,4) = 0
		DECLARE @SALE_DT NVARCHAR(8) = '',
				@ORD_NO NVARCHAR(11) = '',
				@SALE_TOTAL_AMT NUMERIC(17,4),			
				@DEPOSIT_AMT NUMERIC(17,4)
				
		DECLARE CURSOR_ORD CURSOR FOR 
			
			SELECT SALE_DT, ORD_NO, SALE_TOTAL_AMT, DEPOSIT_NO, DEPOSIT_AMT 
				FROM PA_ACCT_DEPOSIT_ORD 
					WHERE VEN_CODE = @P_VEN_CODE 
						AND DEPOSIT_FISH = 'N' 
						AND SALE_TOTAL_AMT > 0 					
					ORDER BY SALE_DT ASC, ORD_NO ASC

		OPEN CURSOR_ORD
 
		FETCH NEXT FROM CURSOR_ORD
			INTO @SALE_DT, @ORD_NO, @SALE_TOTAL_AMT, @DEPOSIT_NO, @DEPOSIT_AMT
		WHILE @@FETCH_STATUS = 0 
		BEGIN
			
			--해당 주문건의 입금된 총합
			SELECT 
					@SALE_TOTAL_AMT = ISNULL(SUM(SALE_TOTAL_AMT), 0),
					@DEPOSIT_AMT_SUM = ISNULL(SUM(DEPOSIT_AMT), 0)					
				FROM PA_ACCT_DEPOSIT_ORD 
					WHERE ORD_NO = @ORD_NO

			--SET @DEPOSIT_AMT_TOAL_SUM = @DEPOSIT_AMT_TOAL_SUM + @DEPOSIT_AMT_SUM

			--@P_DEPOSIT_AMT	: 입금 금액	: 2100000			
			--@SALE_TOTAL_AMT	: 매출 금액 > 2000000
			--@DEPOSIT_AMT		: 기존 입금된 금액 > 1000000
			--@DEPOSIT_AMT_SUM	: 해당 주문건의 입금된 총합 : 2000000
		
			IF (@DEPOSIT_AMT_SUM + @V_DEPOSIT_AMT) > @SALE_TOTAL_AMT
			BEGIN				
				SET @DEPOSIT_AMT = @SALE_TOTAL_AMT - @DEPOSIT_AMT_SUM			
			END
			ELSE 
			BEGIN
				SET @DEPOSIT_AMT = @V_DEPOSIT_AMT
			END
			
			IF(@V_DEPOSIT_AMT > 0 AND @DEPOSIT_AMT > 0)
			BEGIN 																 

				INSERT INTO PA_ACCT_DEPOSIT_ORD (SALE_DT, ORD_NO, VEN_CODE, SALE_TOTAL_AMT, DEPOSIT_GB, DEPOSIT_NO, MOID, DEPOSIT_AMT, DEPOSIT_DT, DEPOSIT_FISH, IDATE)
					SELECT 
						@SALE_DT,			--출고일자
						@ORD_NO,			--주문번호
						@P_VEN_CODE,		--거래처 코드
						0,					--판매금액 : 0원처리 부모가 판매금액 할당되어 있음
						@P_DEPOSIT_GB,		--입금구분
						@P_DEPOSIT_NO,		--입금번호
						@P_MOID, 			--PG주문아이디						
						@DEPOSIT_AMT,		--입금금액																					
						@DEPOSIT_DT, 						
						(CASE WHEN (@DEPOSIT_AMT_SUM + @V_DEPOSIT_AMT) < @SALE_TOTAL_AMT THEN 'N' ELSE 'Y' END ), 
						(CASE WHEN @P_IDATE IS NULL THEN GETDATE() ELSE @P_IDATE END)
				
				-- 판매금액보다 해당 주문건의 입금금액 총합이 클경우 해당 주문건의 입금처리 내역 일괄 입금완료 처리
				IF @SALE_TOTAL_AMT <= (@DEPOSIT_AMT_SUM + @V_DEPOSIT_AMT) BEGIN
					UPDATE PA_ACCT_DEPOSIT_ORD SET DEPOSIT_FISH = 'Y' WHERE ORD_NO = @ORD_NO
				END
			END
					
			SET @V_DEPOSIT_AMT = (@V_DEPOSIT_AMT + @DEPOSIT_AMT_SUM) - @SALE_TOTAL_AMT
			
			FETCH NEXT FROM CURSOR_ORD
    			INTO @SALE_DT, @ORD_NO, @SALE_TOTAL_AMT, @DEPOSIT_NO, @DEPOSIT_AMT
		END
 
		CLOSE CURSOR_ORD
		DEALLOCATE CURSOR_ORD

		-- 매출금액이 0원인 입금내역은 삭제 처리 ( 미수금 내역에 필요없는 데이터 )
		DELETE PA_ACCT_DEPOSIT_ORD WHERE VEN_CODE = @P_VEN_CODE AND SALE_TOTAL_AMT = 0 AND DEPOSIT_AMT = 0

		-- 커서에 ORD_NO가 없으므로 가장 최근 주문서 셀렉
		IF @ORD_NO = ''
		BEGIN
			SELECT TOP 1 @ORD_NO = ORD_NO FROM PA_ACCT_DEPOSIT_ORD WHERE VEN_CODE = @P_VEN_CODE AND DEPOSIT_FISH = 'Y' ORDER BY SALE_DT DESC, ORD_NO DESC
		END

		--초과 입금 금액 업데이트		
		IF @V_DEPOSIT_AMT >= 1
		BEGIN			
		
			--마지막 주문번호가 미수금 처리로 인한 ROW > 1 인 경우 마지막 날짜 기준 업데이트
			SELECT TOP 1 @IDATE = IDATE FROM PA_ACCT_DEPOSIT_ORD WHERE ORD_NO = @ORD_NO ORDER BY IDATE DESC 
			
			INSERT INTO PA_ACCT_DEPOSIT_ORD (SALE_DT, ORD_NO, VEN_CODE, SALE_TOTAL_AMT, DEPOSIT_GB, DEPOSIT_NO, MOID, DEPOSIT_AMT, DEPOSIT_DT, DEPOSIT_FISH, IDATE)
				SELECT TOP 1 SALE_DT, ORD_NO, VEN_CODE, 0, DEPOSIT_GB, @P_DEPOSIT_NO, MOID, -@V_DEPOSIT_AMT , DEPOSIT_DT, DEPOSIT_FISH, IDATE AS IDATE 
					FROM PA_ACCT_DEPOSIT_ORD WHERE ORD_NO = @ORD_NO AND IDATE = @IDATE 
																				
		END
	
		COMMIT;

	END TRY
	BEGIN CATCH	
				
		IF @@TRANCOUNT > 0
		BEGIN 
			ROLLBACK TRAN
						
			IF CURSOR_STATUS('global', 'CURSOR_ORD') >= 0
			BEGIN				
				CLOSE CURSOR_ORD
				DEALLOCATE CURSOR_ORD
			END

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
