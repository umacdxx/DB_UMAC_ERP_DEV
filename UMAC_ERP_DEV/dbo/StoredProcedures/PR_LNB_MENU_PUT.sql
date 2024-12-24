/*
-- 생성자 : 이동호
-- 등록일 : 2023.12.08
-- 수정자 : -
-- 수정일 : - 
-- 설 명	: 메뉴 등록, 수정, 삭제
-- 실행문 : 

*/
CREATE PROCEDURE [dbo].[PR_LNB_MENU_PUT]
	@P_MODE NVARCHAR(1),								-- I : 등록, U : 수정
	@P_SEQ INT = '', 										-- KEY
	@P_MENU_ICON NVARCHAR(50) = '', 				-- 메뉴아이콘
	@P_MENU_NM NVARCHAR(100) = '', 				-- 메뉴명
	@P_MENU_GB INT = '', 								-- 메뉴구분
	@P_MENU_CODE NVARCHAR(100) = '', 			-- 메뉴코드
	@P_UP_MENU_CODE NVARCHAR(100) = '', 		-- 상위메뉴코드
	@P_SORT_ORDER NVARCHAR(2) = '', 				-- 정렬순서
	@P_DEL_YN NVARCHAR(1) = '', 						-- 삭제여부
	@P_MENU_LINK NVARCHAR(150) = '', 				-- 메뉴링크
	@P_HELP NVARCHAR(4000) = '', 						-- HELP			
	@P_UEMP_ID NVARCHAR(13) = '' 					-- 수정아이디
AS
BEGIN
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	SET @P_MENU_ICON = IIF(@P_MENU_ICON IS NULL, '', @P_MENU_ICON)
	SET @P_MENU_LINK = IIF(@P_MENU_LINK IS NULL, '', @P_MENU_LINK)
	SET @P_HELP = IIF(@P_HELP IS NULL, '', @P_HELP)
	SET @P_SORT_ORDER = IIF(@P_SORT_ORDER IS NULL, '', @P_SORT_ORDER)

	DECLARE @RETURN_CODE INT = 0						-- 결과코드 정상 : '0', 실패 : -1
	DECLARE @RETURN_MESSAGE VARCHAR(50) = 'OK'	-- 결과메시지
			
	BEGIN TRY 
	
		IF @P_MODE = 'I'
		BEGIN	
		--등록			

			DECLARE @TOTAL_CNT INT = 0;			
			SELECT @TOTAL_CNT = COUNT(*) FROM TBL_MENU_INFO WHERE MENU_CODE = @P_MENU_CODE			
			
			IF @TOTAL_CNT > 0 
			BEGIN
				SET @RETURN_CODE = -1
				SET @RETURN_MESSAGE = '이미 등록된 메뉴코드가 있습니다.'
			END
			ELSE 
			BEGIN
				
				SET @TOTAL_CNT = 0

				SELECT @TOTAL_CNT = MAX(SEQ) FROM TBL_MENU_INFO
				SET @TOTAL_CNT = IIF(@TOTAL_CNT IS NULL, 1, @TOTAL_CNT + 1)

				INSERT INTO TBL_MENU_INFO (SEQ, MENU_CODE, MENU_NM, MENU_GB, MENU_ICON, MENU_LINK, UP_MENU_CODE, SORT_ORDER, HELP, DEL_YN, IDATE, IEMP_ID, UDATE, UEMP_ID)
				SELECT @TOTAL_CNT, 
					@P_MENU_CODE, 
					@P_MENU_NM, 
					@P_MENU_GB,				
					@P_MENU_ICON, 
					@P_MENU_LINK, 
					@P_UP_MENU_CODE, 
					@P_SORT_ORDER, 					
					@P_HELP, 
					'N',
					GETDATE(), 
					@P_UEMP_ID,
					NULL,
					NULL 
				
				IF LEN(@P_MENU_LINK) != 0 -- MENU_LINK 없는 상위메뉴 저장 방지
					BEGIN
						-- 기본 권한 추가 (시스템관리자)
						EXEC PR_ROLE_MENU_PUT 'ROLE01', @P_MENU_CODE, @P_UEMP_ID
					END
			END
			
		END
		ELSE IF @P_MODE = 'U'
		BEGIN		
		--수정							
		
			DECLARE @SORT_ORDER INT = 0;			
			SELECT @SORT_ORDER = SORT_ORDER FROM TBL_MENU_INFO WHERE MENU_CODE = @P_MENU_CODE

			DECLARE @_MENU_CODE NVARCHAR(25) = '';
			DECLARE @_SORT_ORDER INT = 0;

			IF @SORT_ORDER < @P_SORT_ORDER
			BEGIN	
				-- 기존 순번보다 큰 순번으로 변경시 업데이트 목록 추출
				DECLARE MyCUR CURSOR FOR
					SELECT MENU_CODE AS _MENU_CODE, SORT_ORDER AS _SORT_ORDER FROM TBL_MENU_INFO 
						WHERE UP_MENU_CODE = @P_UP_MENU_CODE 
							AND SORT_ORDER <= @P_SORT_ORDER
							AND SORT_ORDER >= @SORT_ORDER
							AND MENU_CODE NOT IN (@P_MENU_CODE)							
			END
			ELSE
			BEGIN
				-- 기존 순번보다 낮은 순번으로 변경시 업데이트 목록 추출
				DECLARE MyCUR CURSOR FOR
					SELECT MENU_CODE AS _MENU_CODE, SORT_ORDER AS _SORT_ORDER FROM TBL_MENU_INFO 
						WHERE UP_MENU_CODE = @P_UP_MENU_CODE 
							AND SORT_ORDER >= @P_SORT_ORDER
							AND SORT_ORDER <= @SORT_ORDER
							AND MENU_CODE NOT IN (@P_MENU_CODE)			
			END
				-- 순번 순차 업데이트 처리
				OPEN MyCUR						
				FETCH NEXT FROM MyCUR INTO @_MENU_CODE, @_SORT_ORDER
				WHILE @@FETCH_STATUS = 0
				BEGIN ------------				
						
					IF @SORT_ORDER < @P_SORT_ORDER					
						SET @_SORT_ORDER = @_SORT_ORDER - 1											
					ELSE					
						SET @_SORT_ORDER = @_SORT_ORDER + 1			
						
					UPDATE TBL_MENU_INFO SET SORT_ORDER = @_SORT_ORDER WHERE MENU_CODE = @_MENU_CODE																								

					FETCH NEXT FROM MyCUR INTO @_MENU_CODE, @_SORT_ORDER					
				END ------------
				CLOSE MyCUR
				DEALLOCATE MyCUR		
				-- 순번 순차 업데이트 처리 //

				-- 메뉴 정보 업데이트
				UPDATE TBL_MENU_INFO SET 
							MENU_NM = @P_MENU_NM, 
							MENU_ICON = @P_MENU_ICON,
							MENU_LINK = @P_MENU_LINK, 
							SORT_ORDER = @P_SORT_ORDER, 
							DEL_YN = @P_DEL_YN, 
							HELP = @P_HELP,
							UEMP_ID = @P_UEMP_ID,
							UDATE = GETDATE()
					WHERE SEQ = @P_SEQ	

				-- 메뉴 삭제여부를 Y로 수정한 경우 권한 테이블에서 해당 메뉴 삭제
				IF (@P_DEL_YN = 'Y')
				BEGIN
					DELETE TBL_ROLE_MENU WHERE MENU_CODE = @P_MENU_CODE
					DELETE TBL_USER_ROLE_MST WHERE MENU_CODE = @P_MENU_CODE
				END
				
		END
		
						 						 	 					 	 					 	 				
	END TRY
	BEGIN CATCH	

		IF CURSOR_STATUS('global', 'MyCUR') >= 0
		BEGIN
			CLOSE CURSOR_ORD_PUT;
			DEALLOCATE CURSOR_ORD_PUT;
		END

		SET @RETURN_CODE  = -1
		SET @RETURN_MESSAGE  = ERROR_MESSAGE()			
		--에러 로그 테이블 저장
		INSERT INTO TBL_ERROR_LOG 
		SELECT ERROR_PROCEDURE()	-- 프로시저명
		, ERROR_MESSAGE()			-- 에러메시지
		, ERROR_LINE()				-- 에러라인
		, GETDATE()
						        				        		
	END CATCH
	
	--결과 출력
	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE
	
	
END

GO

