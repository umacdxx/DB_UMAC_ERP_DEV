/*
-- 생성자 :	강세미
-- 등록일 :	2024.02.05
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 운송비관리 저장
-- 실행문 : EXEC PR_DELIVERY_PRICE_PUT ''
-- SELECT * FROM PR_DELIVERY_PRICE_PUT
*/
CREATE PROCEDURE [dbo].[PR_DELIVERY_PRICE_PUT]
	@P_SEQ INT,								-- SEQ
	@P_TRANS_SECTION NVARCHAR(6),		-- 운송구간
	@P_TRANS_GB NVARCHAR(1), 			-- 운송구분
	@P_TRANS_GB_NM NVARCHAR(6), 		-- 운송구분명
	@P_TRANS_COST_1 INT, 	-- 5톤운송비
	@P_RENT_COST_1 INT, 					-- 5톤용차비
	@P_TRANS_COST_2 INT, 				-- 14톤운송비
	@P_RENT_COST_2 INT, 					-- 14톤용차비
	@P_TRANS_COST_3 INT, 				-- 18톤운송비
	@P_RENT_COST_3 INT, 					-- 18톤용차비
	@P_TRANS_COST_4 INT, 				-- 탱크운송비
	@P_RENT_COST_4 INT, 					-- 탱크용차비
	@P_TRANS_COST_5 INT, 				-- 벌크운송비
	@P_RENT_COST_5 INT, 					-- 벌크용차비
	@P_EMP_ID NVARCHAR(20), 			-- 아이디
	@P_MODE NVARCHAR(1) 		
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @SEQ_NEW INT						-- NEW SEQ
	DECLARE @RETURN_CODE INT = 0			-- 리턴코드
	DECLARE @RETURN_MESSAGE NVARCHAR(20) = '저장되었습니다.'		-- 리턴메시지

	SET @P_TRANS_GB = CASE WHEN @P_TRANS_GB_NM = '해남 출발' THEN '1' ELSE '2' END

	BEGIN TRY 
		IF @P_MODE = 'I'
			BEGIN

				IF EXISTS (
					SELECT 1 
					  FROM CD_DELIVERY_PRICE
					 WHERE TRANS_SECTION = @P_TRANS_SECTION
						AND TRANS_GB = @P_TRANS_GB
				 )
				 BEGIN
					SET @RETURN_CODE = 9
					SET @RETURN_MESSAGE = '중복된 데이터가 있습니다.'
				 END
				 ELSE
					 BEGIN
						SELECT @SEQ_NEW = ISNULL(MAX(SEQ)+1,1)
						  FROM CD_DELIVERY_PRICE

						INSERT INTO CD_DELIVERY_PRICE(
										SEQ,
										TRANS_SECTION,
										TRANS_GB,
										TRANS_COST_1,
										RENT_COST_1,
										TRANS_COST_2,
										RENT_COST_2,
										TRANS_COST_3,
										RENT_COST_3,
										TRANS_COST_4,
										RENT_COST_4,
										TRANS_COST_5,
										RENT_COST_5,
										IDATE,
										IEMP_ID
										) VALUES (
										@SEQ_NEW,
										@P_TRANS_SECTION,
										@P_TRANS_GB,
										@P_TRANS_COST_1,
										@P_RENT_COST_1,
										@P_TRANS_COST_2,
										@P_RENT_COST_2,
										@P_TRANS_COST_3,
										@P_RENT_COST_3,
										@P_TRANS_COST_4,
										@P_RENT_COST_4,
										@P_TRANS_COST_5,
										@P_RENT_COST_5,
										GETDATE(), 
										@P_EMP_ID
										)
					 END
				END
		ELSE IF @P_MODE = 'U'
			BEGIN
				--IF EXISTS (
				--	SELECT 1 
				--	  FROM CD_DELIVERY_PRICE
				--	 WHERE TRANS_SECTION = @P_TRANS_SECTION
				--		AND TRANS_GB = @P_TRANS_GB
				-- )
				-- BEGIN
				--	SET @RETURN_CODE = 9
				--	SET @RETURN_MESSAGE = '중복된 데이터가 있습니다.'
				-- END
				-- ELSE
					BEGIN
						UPDATE CD_DELIVERY_PRICE 
							SET TRANS_GB = @P_TRANS_GB,
								 TRANS_SECTION = @P_TRANS_SECTION,
								 TRANS_COST_1 = @P_TRANS_COST_1,
				   			 RENT_COST_1 = @P_RENT_COST_1,
								 TRANS_COST_2 = @P_TRANS_COST_2,
								 RENT_COST_2 = @P_RENT_COST_2,
								 TRANS_COST_3 = @P_TRANS_COST_3,
								 RENT_COST_3 = @P_RENT_COST_3,
								 TRANS_COST_4 = @P_TRANS_COST_4,
								 RENT_COST_4 = @P_RENT_COST_4,
								 TRANS_COST_5 = @P_TRANS_COST_5,
								 RENT_COST_5 = @P_RENT_COST_5,
								 UDATE = GETDATE(),
								 UEMP_ID = @P_EMP_ID
						 WHERE SEQ = @P_SEQ
					END
			END
		ELSE
			BEGIN
				DELETE CD_DELIVERY_PRICE
				 WHERE SEQ = @P_SEQ
			END

	END TRY
	BEGIN CATCH		
		--에러 로그 테이블 저장
		INSERT INTO TBL_ERROR_LOG 
		SELECT ERROR_PROCEDURE()	-- 프로시저명
		, ERROR_MESSAGE()			-- 에러메시지
		, ERROR_LINE()				-- 에러라인
		, GETDATE()	

		SET @RETURN_CODE = -1 -- 저장 실패
		SET @RETURN_MESSAGE = DBO.GET_ERR_MSG('-1')
	END CATCH
	
	
	SELECT @RETURN_CODE AS RETURN_CODE, @RETURN_MESSAGE AS RETURN_MESSAGE
END

GO

