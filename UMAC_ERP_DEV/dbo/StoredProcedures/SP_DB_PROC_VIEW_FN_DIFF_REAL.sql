
/*

-- 생성자 :	이동호
-- 등록일 :	2024.07.02
-- 수정자 :
-- 수정일 : 
-- 설 명  : UMAC_ERP_DEV TO 운영서버 UMAC_ERP 프로시저, 뷰, 함수 비교
-- 실행문 : 
EXEC SP_DB_PROC_VIEW_FN_DIFF_REAL
--
*/
CREATE PROCEDURE [dbo].[SP_DB_PROC_VIEW_FN_DIFF_REAL]
	@P_METHOD VARCHAR(10) = '' -- UPDATE 데이터 UMAC_ERP_DEV -> UMAC_ERP 일괄 업데이트
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	

	IF @P_METHOD = 'UPDATE'
		DELETE [REAL_UMAC_ERP].UMAC_ERP.DBO.TBL_SCRIPT

	PRINT '===== UMAC_ERP_DEV > 운영서버 UMAC_ERP ====='


	DECLARE CURSOR_TABLE CURSOR FOR
	
		SELECT [definition], [name], [type]
			FROM UMAC_ERP_DEV.sys.sql_modules sm 
			INNER JOIN UMAC_ERP_DEV.sys.all_objects ao 
			ON sm.object_id = ao.object_id 
			ORDER BY modify_date DESC

	OPEN CURSOR_TABLE
		

	DECLARE @definition NVARCHAR(max)
	DECLARE @name NVARCHAR(150)
	DECLARE @type NVARCHAR(25)
	DECLARE @NUM INT = 0	
	
	

	FETCH NEXT FROM CURSOR_TABLE INTO @definition, @name, @type
		
	WHILE(@@FETCH_STATUS=0)

	BEGIN
	
		IF EXISTS(
			SELECT * FROM [REAL_UMAC_ERP].UMAC_ERP.sys.sql_modules sm 
					INNER JOIN [REAL_UMAC_ERP].UMAC_ERP.sys.all_objects ao 
						ON sm.object_id = ao.object_id 
							WHERE [name] = @name
		)
		BEGIN

			IF NOT EXISTS(
				SELECT * FROM [REAL_UMAC_ERP].UMAC_ERP.sys.sql_modules sm 
						INNER JOIN [REAL_UMAC_ERP].UMAC_ERP.sys.all_objects ao 
							ON sm.object_id = ao.object_id 
								WHERE [name] = @name AND [definition] = @definition
			)
			BEGIN

				IF @name NOT IN ('SP_DB_PROC_VIEW_FN_DIFF', 'SP_DB_TABLE_DIFF', 'SP_DB_TABLE_DIFF_REAL', 'SP_DB_PROC_VIEW_FN_DIFF_REAL')
				BEGIN

					PRINT 'DB : UMAC_ERP | 비매칭 | ' + @type + ' : ' + @name	
																
					IF @P_METHOD = 'UPDATE'
					BEGIN					
							
							SET @definition = REPLACE(REPLACE(REPLACE(REPLACE(@definition, 'CREATE PROCEDURE', 'ALTER PROCEDURE'), 'CREATE FUNCTION','ALTER FUNCTION'), 'CREATE VIEW','ALTER VIEW'), 'CREATE TRIGGER','ALTER TRIGGER')
						
							INSERT INTO REAL_UMAC_ERP.UMAC_ERP.DBO.TBL_SCRIPT([TYPE], NM, [TEXT]) SELECT @type, @name, @definition;
																								
					END

					SET @NUM = @NUM + 1

				END
				
				
			END
				
		END
		ELSE
		BEGIN

			IF @name NOT IN ('SP_DB_PROC_VIEW_FN_DIFF', 'SP_DB_TABLE_DIFF', 'SP_DB_TABLE_DIFF_REAL', 'SP_DB_PROC_VIEW_FN_DIFF_REAL')
			BEGIN

				PRINT 'DB : UMAC_ERP | NO | ' + @type + ' : ' + @name

				IF @P_METHOD = 'UPDATE'
				BEGIN

					
					INSERT INTO REAL_UMAC_ERP.UMAC_ERP.DBO.TBL_SCRIPT([TYPE], NM, [TEXT]) SELECT @type, @name, @definition;
					
				END 

				SET @NUM = @NUM + 1
			END 

			
		END
	
					
	FETCH NEXT FROM CURSOR_TABLE INTO @definition, @name, @type

	END

	CLOSE CURSOR_TABLE
	DEALLOCATE CURSOR_TABLE

	IF @NUM = 0
		PRINT '차이 없음'


	--PRINT ''
	--PRINT ''
	--PRINT '===== 운영 서버 UMAC_ERP > UMAC_ERP_DEV ====='

	--DECLARE CURSOR_TABLE CURSOR FOR
	
	--	SELECT [definition], [name], [type]
	--		FROM [REAL_UMAC_ERP].UMAC_ERP.sys.sql_modules sm 
	--		INNER JOIN [REAL_UMAC_ERP].UMAC_ERP.sys.all_objects ao 
	--		ON sm.object_id = ao.object_id 
	--		ORDER BY modify_date DESC

	--OPEN CURSOR_TABLE
		

	--SET @definition = ''
	--SET @name = ''
	--SET @type = ''
	--SET @NUM = 0

	--FETCH NEXT FROM CURSOR_TABLE INTO @definition, @name, @type
		
	--WHILE(@@FETCH_STATUS=0)

	--BEGIN

	--	IF EXISTS(
	--		SELECT * FROM UMAC_ERP_DEV.sys.sql_modules sm 
	--				INNER JOIN UMAC_ERP_DEV.sys.all_objects ao 
	--					ON sm.object_id = ao.object_id 
	--						WHERE [name] = @name
	--	)
	--	BEGIN

	--		IF NOT EXISTS(
	--			SELECT * FROM UMAC_ERP_DEV.sys.sql_modules sm 
	--					INNER JOIN UMAC_ERP_DEV.sys.all_objects ao 
	--						ON sm.object_id = ao.object_id 
	--							WHERE [name] = @name AND [definition] = @definition
	--		)
	--		BEGIN
	--			PRINT 'DB : UMAC_ERP_DEV | 비매칭 | ' + @type + ' : ' + @name	

	--			SET @NUM = @NUM + 1
	--		END
				
	--	END
	--	ELSE
	--	BEGIN

	--		PRINT 'DB : UMAC_ERP_DEV | NO | ' + @type + ' : ' + @name
			
	--		SET @NUM = @NUM + 1
	--	END
	
					
	--FETCH NEXT FROM CURSOR_TABLE INTO @definition, @name, @type

	--END

	--CLOSE CURSOR_TABLE
	--DEALLOCATE CURSOR_TABLE

	--IF @NUM = 0
	--	PRINT '차이 없음'



	SET @definition = ''
	SET @name = ''
	SET @type = ''
	SET @NUM = 0
	

END

GO

