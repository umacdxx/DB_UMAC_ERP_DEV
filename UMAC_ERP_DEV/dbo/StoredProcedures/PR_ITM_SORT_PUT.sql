
/*

-- 생성자 :	윤현빈
-- 등록일 :	2024.11.07
-- 설 명  : 일보제품정렬관리 저장
-- 실행문 : 

EXEC PR_ITM_SORT_PUT '',''

*/
CREATE PROCEDURE [dbo].[PR_ITM_SORT_PUT]
( 
	@P_JSONDT			VARCHAR(8000) = '',
	@P_EMP_ID			NVARCHAR(20)				-- 아이디
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @RETURN_CODE	INT = 0										-- 리턴코드(저장완료)
	DECLARE @RETURN_MESSAGE NVARCHAR(MAX) = DBO.GET_ERR_MSG('0')		-- 리턴메시지
	
	BEGIN TRAN
	BEGIN TRY 

		DECLARE @TODAY NVARCHAR(8) = CONVERT(NVARCHAR, GETDATE(), 112);
		DECLARE @YESTERDAY NVARCHAR(8) = CONVERT(NVARCHAR, GETDATE()-1, 112);

		DECLARE @TMP_ITEM TABLE (
		    PARTNER_GB NVARCHAR(2),
			ITM_CATEGORY NVARCHAR(2),
			SCAN_CODE NVARCHAR(14),
			START_DATE NVARCHAR(8),
			SORT_ORDER INT,
			MODE NVARCHAR(1)
		)
		
		INSERT INTO @TMP_ITEM
		SELECT PARTNER_GB, ITM_CATEGORY, SCAN_CODE, START_DATE, SORT_ORDER, MODE
			FROM 
				OPENJSON ( @P_JSONDT )   
					WITH (    
						PARTNER_GB NVARCHAR(2) '$.PARTNER_GB',
						ITM_CATEGORY NVARCHAR(2) '$.ITM_CATEGORY',
						SCAN_CODE NVARCHAR(14) '$.SCAN_CODE',
						START_DATE NVARCHAR(8) '$.START_DATE',
						SORT_ORDER INT '$.SORT_ORDER',
						MODE NVARCHAR(1) '$.MODE'
					)
				
		DECLARE CURSOR_ITM CURSOR FOR

			SELECT A.PARTNER_GB, A.ITM_CATEGORY, B.SCAN_CODE, A.START_DATE, A.SORT_ORDER, MODE 
				FROM @TMP_ITEM A
				INNER JOIN CD_PRODUCT_CMN AS B ON A.SCAN_CODE = B.SCAN_CODE
			
		OPEN CURSOR_ITM

		DECLARE @P_PARTNER_GB NVARCHAR(2),
				@P_ITM_CATEGORY NVARCHAR(2),
				@P_SCAN_CODE NVARCHAR(14),
				@P_START_DATE NVARCHAR(8),
				@P_SORT_ORDER INT,
				@P_MODE NVARCHAR(1)

		FETCH NEXT FROM CURSOR_ITM INTO @P_PARTNER_GB, @P_ITM_CATEGORY, @P_SCAN_CODE, @P_START_DATE, @P_SORT_ORDER, @P_MODE

			WHILE(@@FETCH_STATUS=0)
			BEGIN
----------------------------------------------------------------------
-- 1. 행 추가 시
-- 동일한 제품이 없을 때 인서트
-- 기존에 제품이 없었으면 시작일자 20200101 로 임의 등록
----------------------------------------------------------------------
				IF @P_MODE = 'I'
				BEGIN
					DECLARE @INS_START_DATE NVARCHAR(8);

					IF EXISTS (
						SELECT 1
							FROM RP_ITM_SORT AS A
						   WHERE PARTNER_GB = @P_PARTNER_GB
							 AND ITM_CATEGORY = @P_ITM_CATEGORY
							 AND SCAN_CODE = @P_SCAN_CODE
					)
					BEGIN
						SET @INS_START_DATE = @TODAY;
					END
					ELSE 
					BEGIN
						SET @INS_START_DATE = '20200101';
					END


					INSERT INTO RP_ITM_SORT
					(
						PARTNER_GB
					  , ITM_CATEGORY
					  , SCAN_CODE
					  , START_DATE
					  , END_DATE
					  , SORT_ORDER
					  , IDATE
					  , IEMP_ID
					)
					VALUES
					(
						@P_PARTNER_GB
					  , @P_ITM_CATEGORY
					  , @P_SCAN_CODE
					  , @INS_START_DATE
					  , '99991231'
					  , @P_SORT_ORDER
					  , GETDATE()
					  , @P_EMP_ID
					)
					;
				END
				
----------------------------------------------------------------------
-- 2. 행 삭제 시
-- 오늘 일자일 때 DEL, 과거일자일 떄 END_DATE 업데이트
----------------------------------------------------------------------
				ELSE IF @P_MODE = 'D'
				BEGIN
					IF @P_START_DATE = @TODAY
					BEGIN
						DELETE FROM RP_ITM_SORT 
						   WHERE PARTNER_GB = @P_PARTNER_GB
							 AND ITM_CATEGORY = @P_ITM_CATEGORY
							 AND SCAN_CODE = @P_SCAN_CODE
							 AND START_DATE = @P_START_DATE
						;
					END

					ELSE
					BEGIN
						UPDATE RP_ITM_SORT 
							SET END_DATE = @YESTERDAY
							  , UDATE = GETDATE()
							  , UEMP_ID = @P_EMP_ID
						   WHERE PARTNER_GB = @P_PARTNER_GB
							 AND ITM_CATEGORY = @P_ITM_CATEGORY
							 AND SCAN_CODE = @P_SCAN_CODE
							 AND START_DATE = @P_START_DATE
						;
					END
				END

----------------------------------------------------------------------
-- 3. 행 변경 시
-- 오늘 일자일 때 UPD, 과거일자일 때 기존데이터 [END_DATE = 어제일자] UPD && INS
----------------------------------------------------------------------
				ELSE IF @P_MODE = 'U'
				BEGIN
					IF @P_START_DATE = @TODAY 
					OR @TODAY = (SELECT CONVERT(NVARCHAR, IDATE, 112) FROM RP_ITM_SORT WHERE PARTNER_GB = @P_PARTNER_GB AND ITM_CATEGORY = @P_ITM_CATEGORY AND SCAN_CODE = @P_SCAN_CODE AND START_DATE = @P_START_DATE)
					BEGIN
						UPDATE RP_ITM_SORT 
							SET SORT_ORDER = @P_SORT_ORDER
							  , UDATE = GETDATE()
							  , UEMP_ID = @P_EMP_ID
						   WHERE PARTNER_GB = @P_PARTNER_GB
							 AND ITM_CATEGORY = @P_ITM_CATEGORY
							 AND SCAN_CODE = @P_SCAN_CODE
							 AND START_DATE = @P_START_DATE
						;
					END

					ELSE
					BEGIN
						
						UPDATE RP_ITM_SORT 
							SET END_DATE = @YESTERDAY
							  , UDATE = GETDATE()
							  , UEMP_ID = @P_EMP_ID
						   WHERE PARTNER_GB = @P_PARTNER_GB
							 AND ITM_CATEGORY = @P_ITM_CATEGORY
							 AND SCAN_CODE = @P_SCAN_CODE
							 AND START_DATE < @TODAY
						;

						INSERT INTO RP_ITM_SORT
						(
							PARTNER_GB
						  , ITM_CATEGORY
						  , SCAN_CODE
						  , START_DATE
						  , END_DATE
						  , SORT_ORDER
						  , IDATE
						  , IEMP_ID
						)
						VALUES
						(
							@P_PARTNER_GB
						  , @P_ITM_CATEGORY
						  , @P_SCAN_CODE
						  , @TODAY
						  , '99991231'
						  , @P_SORT_ORDER
						  , GETDATE()
						  , @P_EMP_ID
						)
						;
					END
				END

				FETCH NEXT FROM CURSOR_ITM INTO @P_PARTNER_GB, @P_ITM_CATEGORY, @P_SCAN_CODE, @P_START_DATE, @P_SORT_ORDER, @P_MODE

			END

		CLOSE CURSOR_ITM
		DEALLOCATE CURSOR_ITM

	COMMIT;
	END TRY
	
	BEGIN CATCH	
		
		IF @@TRANCOUNT > 0
		BEGIN 
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

	END CATCH
	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE 
END

GO

