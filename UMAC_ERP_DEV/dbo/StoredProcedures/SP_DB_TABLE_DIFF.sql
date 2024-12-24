
/*

-- 생성자 :	이동호
-- 등록일 :	2024.07.20
-- 수정자 : 
-- 수정일 : 
-- 설 명  : UMAC_ERP_DEV TO UMAC_ERP 테이블 및 컬럼 비교
-- 실행문 : EXEC SP_DB_TABLE_DIFF
*/
CREATE PROCEDURE [dbo].[SP_DB_TABLE_DIFF]
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	
	PRINT '===== UMAC_ERP_DEV > UMAC_ERP ====='
	PRINT ''

	DECLARE @othercol sysname
	DECLARE @COLNAME  sysname
	DECLARE @DATATYPE NVARCHAR(128)
	DECLARE @CHARLEN INT
	DECLARE @NUMERICLEN TINYINT
	DECLARE @NUMERIC_SCALE INT

	DECLARE @usSql NVARCHAR(max)
	DECLARE @NUM INT = 0

	DECLARE CURSOR_TABLE CURSOR FOR
	
		SELECT  TABLE_NAME FROM UMAC_ERP_DEV.INFORMATION_SCHEMA.COLUMNS GROUP BY TABLE_NAME

	OPEN CURSOR_TABLE
		
	DECLARE @TABLE_NAME NVARCHAR(150)
				
	FETCH NEXT FROM CURSOR_TABLE INTO @TABLE_NAME
		
	WHILE(@@FETCH_STATUS=0)

	BEGIN
			
	--####################################################

	

				IF EXISTS(
							SELECT C.* FROM UMAC_ERP_DEV.sys.columns AS C
									INNER JOIN UMAC_ERP_DEV.sys.tables T ON C.object_id = T.object_id
										WHERE T.name=@TABLE_NAME AND C.name NOT IN (
																					SELECT JC.name FROM UMAC_ERP.sys.columns JC
																						INNER JOIN UMAC_ERP.sys.tables JT ON JC.object_id = JT.object_id
																								WHERE JT.name =@TABLE_NAME
																					)
							)
				BEGIN

					DECLARE COL_CR CURSOR FOR 

					SELECT C.name FROM UMAC_ERP_DEV.sys.columns AS C 
						INNER JOIN UMAC_ERP_DEV.sys.tables T 
							ON C.object_id = T.object_id
								WHERE T.name=@TABLE_NAME 
									AND C.name NOT IN (
														SELECT JC.name FROM UMAC_ERP.sys.columns JC 
															INNER JOIN UMAC_ERP.sys.tables JT 
																ON JC.object_id = JT.object_id
																	WHERE JT.name =@TABLE_NAME
														)
		
					OPEN COL_CR

					FETCH NEXT FROM COL_CR INTO @othercol

					WHILE @@FETCH_STATUS = 0
					BEGIN
							
							SET @COLNAME = ''
							
							SELECT  @COLNAME = COLUMN_NAME, @DATATYPE = DATA_TYPE, @CHARLEN = CHARACTER_MAXIMUM_LENGTH, @NUMERICLEN = NUMERIC_PRECISION,@NUMERIC_SCALE = NUMERIC_SCALE
							FROM UMAC_ERP_DEV.INFORMATION_SCHEMA.COLUMNS 
								WHERE TABLE_NAME = @TABLE_NAME AND COLUMN_NAME=@othercol
							ORDER BY ORDINAL_POSITION	
		 

							PRINT 'DB : UMAC_ERP | TABLE NAME : ' + @TABLE_NAME + ' | 비매칭 컬럼 : ' + @COLNAME
							
							--IF @DATATYPE = 'decimal' OR @DATATYPE = 'numeric'
							-- BEGIN
							--	SET @usSql = 'ALTER TABLE ' + @TABLE_NAME + ' ADD ' + @COLNAME + ' ' + @DATATYPE + ' (' + CONVERT(VARCHAR(3),@NUMERICLEN )  + ',' + CONVERT(VARCHAR(3), @NUMERIC_SCALE) +') ' 
				
							-- END
							--ELSE
							--BEGIN
							--	SET @usSql = 'ALTER TABLE ' + @TABLE_NAME + ' ADD ' + @COLNAME + ' ' + @DATATYPE + ' (' + CONVERT(VARCHAR(3), @CHARLEN) +') ' 
							--END
			
						--PRINT @usSql
						--EXEC sp_executesql @usSql

						SET @NUM = @NUM + 1
					FETCH NEXT FROM COL_CR INTO @othercol
					END
	
					CLOSE COL_CR
					DEALLOCATE COL_CR
				END

	SET @TABLE_NAME = ''	
	--#####################################################
	FETCH NEXT FROM CURSOR_TABLE INTO @TABLE_NAME

	END

	CLOSE CURSOR_TABLE
	DEALLOCATE CURSOR_TABLE

	--=========================================================
	
	PRINT ''
	PRINT ''
	PRINT '===== UMAC_ERP > UMAC_ERP_DEV ====='
	PRINT ''

	SET @DATATYPE = ''
	SET @CHARLEN  = 0
	SET @NUMERICLEN = 0
	SET @NUMERIC_SCALE = 0
	SET @usSql = ''

	DECLARE CURSOR_TABLE CURSOR FOR
	
		SELECT  TABLE_NAME FROM UMAC_ERP.INFORMATION_SCHEMA.COLUMNS GROUP BY TABLE_NAME

	OPEN CURSOR_TABLE
		
	SET @TABLE_NAME = ''
				
	FETCH NEXT FROM CURSOR_TABLE INTO @TABLE_NAME
		
	WHILE(@@FETCH_STATUS=0)

	BEGIN

	--####################################################

				IF EXISTS(
							SELECT C.* FROM UMAC_ERP.sys.columns AS C
									INNER JOIN UMAC_ERP.sys.tables T ON C.object_id = T.object_id
										WHERE T.name=@TABLE_NAME AND C.name NOT IN (
																					SELECT JC.name FROM UMAC_ERP_DEV.sys.columns JC
																						INNER JOIN UMAC_ERP_DEV.sys.tables JT ON JC.object_id = JT.object_id
																								WHERE JT.name =@TABLE_NAME
																					)
							)
				BEGIN

					DECLARE COL_CR CURSOR FOR 

					SELECT C.name FROM UMAC_ERP.sys.columns AS C 
						INNER JOIN UMAC_ERP.sys.tables T 
							ON C.object_id = T.object_id
								WHERE T.name=@TABLE_NAME 
									AND C.name NOT IN (
														SELECT JC.name FROM UMAC_ERP_DEV.sys.columns JC 
															INNER JOIN UMAC_ERP_DEV.sys.tables JT 
																ON JC.object_id = JT.object_id
																	WHERE JT.name =@TABLE_NAME
														)
		
					OPEN COL_CR

					FETCH NEXT FROM COL_CR INTO @othercol

					WHILE @@FETCH_STATUS = 0
					BEGIN
							SELECT  @COLNAME = COLUMN_NAME, @DATATYPE = DATA_TYPE, @CHARLEN = CHARACTER_MAXIMUM_LENGTH, @NUMERICLEN = NUMERIC_PRECISION,@NUMERIC_SCALE = NUMERIC_SCALE
							FROM UMAC_ERP.INFORMATION_SCHEMA.COLUMNS 
								WHERE TABLE_NAME = @TABLE_NAME AND COLUMN_NAME=@othercol
							ORDER BY ORDINAL_POSITION	
		 

							PRINT 'DB : UMAC_ERP_DEV | TABLE NAME : ' + @TABLE_NAME + ' | NO 컬럼 : ' + @COLNAME
							
							--IF @DATATYPE = 'decimal' OR @DATATYPE = 'numeric'
							-- BEGIN
							--	SET @usSql = 'ALTER TABLE ' + @TABLE_NAME + ' ADD ' + @COLNAME + ' ' + @DATATYPE + ' (' + CONVERT(VARCHAR(3),@NUMERICLEN )  + ',' + CONVERT(VARCHAR(3), @NUMERIC_SCALE) +') ' 
				
							-- END
							--ELSE
							--BEGIN
							--	SET @usSql = 'ALTER TABLE ' + @TABLE_NAME + ' ADD ' + @COLNAME + ' ' + @DATATYPE + ' (' + CONVERT(VARCHAR(3), @CHARLEN) +') ' 
							--END
			
						--PRINT @usSql
						--EXEC sp_executesql @usSql
						SET @NUM = @NUM + 1
					FETCH NEXT FROM COL_CR INTO @othercol
					END
	
					CLOSE COL_CR
					DEALLOCATE COL_CR
				END

		
	--#####################################################
	FETCH NEXT FROM CURSOR_TABLE INTO @TABLE_NAME

	END

	CLOSE CURSOR_TABLE
	DEALLOCATE CURSOR_TABLE


	IF @NUM = 0 
		PRINT '차이 없음'

END

GO

