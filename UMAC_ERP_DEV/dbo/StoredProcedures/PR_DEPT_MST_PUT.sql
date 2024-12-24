/*
-- 생성자 :	이동호
-- 등록일 :	2023.12.28
-- 수정자 : -
-- 수정일 : - 
-- 설 명  :  조직마스터 저장 프로시져
-- 실행문 : 
EXEC PR_DEPT_MST_PUT 'U', '010105', '경기도사무소', '0101', '3', 1, '', 'Y', ''
*/

CREATE PROCEDURE [dbo].[PR_DEPT_MST_PUT]
(
	@P_MODE NVARCHAR(1),								-- I : 등록, U : 수정
	@P_DEPT_CODE NVARCHAR(25), 					-- 조직코드 : KEY
	@P_DEPT_NAME NVARCHAR(20), 					-- 조직명
	@P_UPPER_DEPT NVARCHAR(20), 					-- 상위코드
	@P_GRADE NVARCHAR(1), 							-- 레벨
	@P_SORT_ORDER INT, 								-- 정렬순서
	@P_DOUZONE_DEPT_CD NVARCHAR(10) = '', 		-- 더존부서코드
	@P_USE_YN NVARCHAR(1), 							-- 사용여부			
	@P_UEMP_NO NVARCHAR(13) 						-- 사원번호    
)
AS
BEGIN
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SET @P_DOUZONE_DEPT_CD = IIF(@P_DOUZONE_DEPT_CD IS NULL, '', @P_DOUZONE_DEPT_CD)
	
	DECLARE @RETURN_CODE INT = 0							-- 결과코드 정상 : '0', 실패 : -1
	DECLARE @RETURN_MESSAGE VARCHAR(50) = 'OK'		-- 결과메시지
			
	BEGIN TRY 
	
		IF @P_MODE = 'I'
		BEGIN	
			--PRINT '등록'
			
			-- 조직코드 중복 체크
			DECLARE @TOTAL_CNT INT = 0;		
			SELECT @TOTAL_CNT = COUNT(*) FROM TBL_DEPT_MST WHERE DEPT_CODE = @P_DEPT_CODE
			
			IF @TOTAL_CNT > 0 
			BEGIN
				SET @RETURN_CODE = -1
				SET @RETURN_MESSAGE = '이미 등록된 조직코드가 있습니다.'
			END
			ELSE
			BEGIN
			
				INSERT INTO TBL_DEPT_MST 
					SELECT @P_DEPT_CODE, 
						@P_DEPT_NAME, 
						@P_UPPER_DEPT, 
						@P_GRADE, 
						@P_SORT_ORDER, 
						@P_DOUZONE_DEPT_CD, 
						@P_USE_YN, 
						GETDATE(), 
						@P_UEMP_NO, 
						GETDATE(), 
						@P_UEMP_NO
			END
			
		END
		ELSE IF @P_MODE = 'U'
		BEGIN										
			--PRINT '수정'						
			DECLARE @SORT_ORDER INT = 0;	
			SELECT @SORT_ORDER = SORT_ORDER FROM TBL_DEPT_MST WHERE DEPT_CODE = @P_DEPT_CODE

			DECLARE @_DEPT_CODE NVARCHAR(25) = '';
			DECLARE @_SORT_ORDER INT = 0;

			
			IF @SORT_ORDER < @P_SORT_ORDER
			BEGIN	
				-- 기존 순번보다 큰 순번으로 변경시 업데이트 목록 추출
				DECLARE MyCUR CURSOR FOR
					SELECT DEPT_CODE AS _DEPT_CODE, SORT_ORDER AS _SORT_ORDER FROM TBL_DEPT_MST 
						WHERE UPPER_DEPT = @P_UPPER_DEPT 
							AND SORT_ORDER <= @P_SORT_ORDER
							AND SORT_ORDER >= @SORT_ORDER
							AND DEPT_CODE NOT IN (@P_DEPT_CODE)							
			END
			ELSE
			BEGIN
				-- 기존 순번보다 낮은 순번으로 변경시 업데이트 목록 추출
				DECLARE MyCUR CURSOR FOR
					SELECT DEPT_CODE AS _DEPT_CODE, SORT_ORDER AS _SORT_ORDER FROM TBL_DEPT_MST 
						WHERE UPPER_DEPT = @P_UPPER_DEPT 
							AND SORT_ORDER >= @P_SORT_ORDER
							AND SORT_ORDER <= @SORT_ORDER
							AND DEPT_CODE NOT IN (@P_DEPT_CODE)			
			END
			
				OPEN MyCUR						
				FETCH NEXT FROM MyCUR INTO @_DEPT_CODE, @_SORT_ORDER
				WHILE @@FETCH_STATUS = 0
				BEGIN ------------				
				
					IF @SORT_ORDER < @P_SORT_ORDER					
						SET @_SORT_ORDER = @_SORT_ORDER - 1											
					ELSE					
						SET @_SORT_ORDER = @_SORT_ORDER + 1			
															
					UPDATE TBL_DEPT_MST SET SORT_ORDER = @_SORT_ORDER WHERE DEPT_CODE = @_DEPT_CODE 
																								
					FETCH NEXT FROM MyCUR INTO @_DEPT_CODE, @_SORT_ORDER					
				END ------------
				CLOSE MyCUR
				DEALLOCATE MyCUR		
										
				UPDATE TBL_DEPT_MST SET 
						DEPT_NAME = @P_DEPT_NAME, 
						SORT_ORDER = @P_SORT_ORDER, 
						DOUZONE_DEPT_CD = @P_DOUZONE_DEPT_CD, 
						USE_YN = @P_USE_YN
					WHERE DEPT_CODE = @P_DEPT_CODE							
		END
		
						 						 	 					 	 					 	 				
	END TRY
	BEGIN CATCH	

		IF CURSOR_STATUS('global', 'MyCUR') >= 0
		BEGIN
			CLOSE MyCUR;
			DEALLOCATE MyCUR;
		END

		SET @RETURN_CODE  = -1
		SET @RETURN_MESSAGE  = ERROR_MESSAGE()			
		--에러 로그 테이블 저장
		INSERT INTO TBL_ERROR_LOG 
		SELECT ERROR_PROCEDURE()	-- 프로시저명
		, ERROR_MESSAGE()			-- 에러메시지
		, ERROR_LINE()					-- 에러라인
		, GETDATE()
						        				        		
	END CATCH
	
	--결과 출력
	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE
    
END

GO

