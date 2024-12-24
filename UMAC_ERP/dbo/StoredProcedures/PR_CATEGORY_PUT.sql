
/*
-- 생성자 : 이동호
-- 등록일 : 2024.01.05
-- 수정자 : -
-- 수정일 : - 
-- 설 명	: 상품 카테고리 관리
-- 실행문 : 

*/

CREATE PROCEDURE [dbo].[PR_CATEGORY_PUT]
(
	@P_MODE NVARCHAR(1),								-- I : 등록, U : 수정, D : 삭제
	@P_TYPE NVARCHAR(3),								-- LRG : 대분류 , MID : 중분류
	@P_LRG_CODE NVARCHAR(4) = '', 					-- 대분류 코드
	@P_LRG_NAME NVARCHAR(20) = '', 				-- 대분류명칭
	@P_MID_CODE NVARCHAR(4) = '', 					-- 중분류코드
	@P_MID_NAME NVARCHAR(20) = '', 				-- 중분류명칭			
	@P_UEMP_ID NVARCHAR(13) = '' 					-- 아이디
)
AS
BEGIN
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
		
	DECLARE @RETURN_CODE INT = 0							-- 결과코드 정상 : '0', 실패 : -1
	DECLARE @RETURN_MESSAGE VARCHAR(50) = 'OK'		-- 결과메시지
	DECLARE @TOTAL_CNT INT = 0;			
	BEGIN TRY 
	
		IF @P_MODE = 'I'
		BEGIN	
			--PRINT '등록'			
			IF @P_TYPE = 'LRG'
			BEGIN
			--PRINT '대분류				
				SELECT @TOTAL_CNT = COUNT(*) FROM CD_LRG_MST WHERE LRG_CODE = @P_LRG_CODE
				IF @TOTAL_CNT > 0 
				BEGIN 
					SET @RETURN_CODE = -1
					SET @RETURN_MESSAGE = '이미 등록된 대분류 코드가 있습니다.'
				END
				ELSE
				BEGIN
					INSERT INTO CD_LRG_MST(LRG_CODE, LRG_NAME, IDATE, IEMP_ID) VALUES (@P_LRG_CODE, @P_LRG_NAME, GETDATE(), @P_UEMP_ID)
				END
			END
			ELSE IF @P_TYPE = 'MID'
			BEGIN
			--PRINT '중분류							
				SELECT @TOTAL_CNT = COUNT(*) FROM CD_MID_MST WHERE MID_CODE = @P_MID_CODE
				IF @TOTAL_CNT > 0 
				BEGIN 
					SET @RETURN_CODE = -1
					SET @RETURN_MESSAGE = '이미 등록된 중분류 코드가 있습니다.'
				END
				ELSE
				BEGIN
					INSERT INTO CD_MID_MST(MID_CODE, LRG_CODE, MID_NAME, IDATE, IEMP_ID) VALUES (@P_MID_CODE, @P_LRG_CODE, @P_MID_NAME, GETDATE(), @P_UEMP_ID)
				END
			END
		END
		ELSE IF @P_MODE = 'U'
		BEGIN 
			IF @P_TYPE = 'LRG'
			BEGIN
			--PRINT '대분류				
				UPDATE CD_LRG_MST SET LRG_NAME = @P_LRG_NAME, UDATE = GETDATE(), UEMP_ID = @P_UEMP_ID WHERE LRG_CODE = @P_LRG_CODE
			END
			ELSE IF @P_TYPE = 'MID'
			BEGIN
			--PRINT '중분류							
				UPDATE CD_MID_MST SET MID_NAME = @P_MID_NAME, UDATE = GETDATE(), UEMP_ID = @P_UEMP_ID WHERE MID_CODE = @P_MID_CODE
			END			
		END 
		ELSE IF @P_MODE = 'D'
		BEGIN 
			IF @P_TYPE = 'LRG'
			BEGIN
			--PRINT '대분류		
				
				-- 카테고리가 이미 상품에 등록되어 있는지 판단 후 등록된 카테고리가 없을 경우 카테고리 삭제
				SELECT @TOTAL_CNT = COUNT(*) FROM CD_PRODUCT_CMN AS CMN 
					INNER JOIN CD_MID_MST AS MID ON CMN.MID_CODE = MID.MID_CODE
					WHERE MID.LRG_CODE = @P_LRG_CODE

				IF @TOTAL_CNT > 0
				BEGIN
						SET @RETURN_CODE = -1
						SET @RETURN_MESSAGE = '상품에 등록된 카테고리 입니다.'
				END
				ELSE
				BEGIN
						DELETE CD_LRG_MST WHERE LRG_CODE = @P_LRG_CODE
						DELETE CD_MID_MST WHERE LRG_CODE = @P_LRG_CODE
				END

			END
			ELSE IF @P_TYPE = 'MID'
			BEGIN
			--PRINT '중분류							
				
				-- 카테고리가 이미 상품에 등록되어 있는지 판단 후 등록된 카테고리가 없을 경우 카테고리 삭제
				SELECT @TOTAL_CNT = COUNT(*) FROM CD_PRODUCT_CMN WHERE MID_CODE = @P_MID_CODE
				IF @TOTAL_CNT > 0
				BEGIN
						SET @RETURN_CODE = -1
						SET @RETURN_MESSAGE = '상품에 등록된 카테고리 입니다.'
				END
				ELSE
				BEGIN					
						DELETE CD_MID_MST WHERE MID_CODE = @P_MID_CODE
				END

			END			
		END 
						
									 						 	 					 	 					 	 				
	END TRY
	BEGIN CATCH	
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

