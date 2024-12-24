
/*

-- 생성자 :	윤현빈
-- 등록일 :	2024.10.21
-- 설 명  : 무자료 생성
-- 샘플 어떻게 처리할지 나중에 생각해보기
-- 실행문 : 
EXEC PR_NO_DOC_CREATE '','','','',''

*/
CREATE PROCEDURE [dbo].[PR_NO_DOC_CREATE]
( 
	@P_ORD_NO	NVARCHAR(11) = '',	-- 주문번호
	@P_IS_ALL	NVARCHAR(1) = '', -- 전체여부
	@P_JSONDT	VARCHAR(8000) = '',
	@P_EMP_ID	NVARCHAR(20)		-- 아이디
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @RETURN_CODE	INT = 0										-- 리턴코드(저장완료)
	DECLARE @RETURN_MESSAGE NVARCHAR(MAX) = DBO.GET_ERR_MSG('0')		-- 리턴메시지
	
	BEGIN TRAN
	BEGIN TRY 

		DECLARE @V_DELIVERY_DEC_DT NVARCHAR(8);

		SELECT @V_DELIVERY_DEC_DT = DELIVERY_DEC_DT FROM PO_ORDER_HDR WHERE ORD_NO = @P_ORD_NO
--==============================================================================
-- 1. 부분 수량 수정 시
--==============================================================================
		IF @P_IS_ALL = 'N'
		BEGIN
	----------------------------------------
	-- 1_1. 대시보드 데이터 처리
	----------------------------------------
			EXEC PR_AGGR_OIL_ITM_SALE_DEDUCT @P_ORD_NO, @RETURN_CODE OUT, @RETURN_MESSAGE OUT;

	----------------------------------------
	-- #주문서 디테일 반복문
	----------------------------------------
			DECLARE @TMP_ITEM TABLE (
				SCAN_CODE NVARCHAR(14),
				ORG_PICKING_QTY DECIMAL(17, 4),
				PICKING_QTY DECIMAL(17, 4)
			)
		
			INSERT INTO @TMP_ITEM
			SELECT SCAN_CODE, ORG_PICKING_QTY, PICKING_QTY
				FROM 
					OPENJSON ( @P_JSONDT )   
						WITH (    
							SCAN_CODE NVARCHAR(14) '$.SCAN_CODE',
							ORG_PICKING_QTY DECIMAL(17,4) '$.ORG_PICKING_QTY',
							PICKING_QTY DECIMAL(17,4) '$.PICKING_QTY'
						)
				
			DECLARE CURSOR_NO_DOC CURSOR FOR

				SELECT A.SCAN_CODE, A.ORG_PICKING_QTY, A.PICKING_QTY
					FROM @TMP_ITEM A
					INNER JOIN CD_PRODUCT_CMN AS B ON A.SCAN_CODE = B.SCAN_CODE
			
			OPEN CURSOR_NO_DOC

			DECLARE @P_SCAN_CODE NVARCHAR(14),
					@P_ORG_PICKING_QTY DECIMAL(17,4),
					@P_PICKING_QTY DECIMAL(17,4)

			FETCH NEXT FROM CURSOR_NO_DOC INTO @P_SCAN_CODE, @P_ORG_PICKING_QTY, @P_PICKING_QTY

				WHILE(@@FETCH_STATUS=0)
				BEGIN
					
					IF @P_PICKING_QTY != 0
					BEGIN
	----------------------------------------
	-- 1_2. 무자료 데이터 생성
	----------------------------------------
						INSERT INTO PO_NO_DOC 
						(
							ORD_NO
						  , SCAN_CODE
						  , ORD_QTY
						  , ORD_SPRC
						  , ORD_SVAT
						  , ORD_SAMT
						  , PICKING_QTY
						  , PICKING_SPRC
						  , PICKING_SVAT
						  , PICKING_SAMT
						  , PICKING_EMP_NO
						  , PICKING_SDATE
						  , PICKING_EDATE
						  , REMARKS
						  , REMARKS_SALES
						  , IDATE
						  , IEMP_ID
						)
						SELECT A.ORD_NO
							 , A.SCAN_CODE
							 , A.ORD_QTY
							 , A.ORD_SPRC
							 , A.ORD_SVAT
							 , A.ORD_SAMT
							 , @P_PICKING_QTY		-- 입력한 삭제수량
							 , A.PICKING_SPRC
							 , A.PICKING_SVAT
							 , (A.PICKING_SPRC + A.PICKING_SVAT) * @P_PICKING_QTY	-- 삭제수량으로 계산된 금액
							 , A.PICKING_EMP_NO
							 , A.PICKING_SDATE
							 , A.PICKING_EDATE
							 , A.REMARKS
							 , A.REMARKS_SALES
							 , GETDATE()
							 , @P_EMP_ID
							FROM PO_ORDER_DTL AS A
						   WHERE ORD_NO = @P_ORD_NO
						     AND SCAN_CODE = @P_SCAN_CODE
						;
	----------------------------------------
	-- 1_3. 주문서 디테일 업데이트 및 재고조정 데이터 처리
	-- 기존수량 == 삭제수량 -> 로우 삭제
	-- 기존수량 != 삭제수량 -> (기종수량 - 삭제수량) 업데이트
	----------------------------------------
						-- 기존수량 == 삭제수량 -> 로우 삭제
						IF @P_ORG_PICKING_QTY = @P_PICKING_QTY
						BEGIN
						----------------------------------------
						-- 1_3_1. 재고조정 데이터 처리
						----------------------------------------
							INSERT INTO IV_STOCK_ADJUST
							(
								ITM_CODE
							  , SCAN_CODE
							  , INV_DT
							  , INV_GB
							  , LOT_NO
							  , REQ_QTY
							  , CFM_FLAG
							  , CFM_DT
							  , APP_QTY
							  , REMARKS
							  , IDATE
							  , IEMP_ID
							  , UDATE
							  , UEMP_ID
							)
							SELECT B.ITM_CODE
								 , A.SCAN_CODE
								 , @V_DELIVERY_DEC_DT
								 , '8'
								 , ISNULL(A.LOT_NO, '')
								 , A.PICKING_QTY * (-1)
								 , 'Y'
								 , @V_DELIVERY_DEC_DT
								 , A.PICKING_QTY * (-1)
								 , ''
								 , GETDATE()
								 , @P_EMP_ID
								 , NULL
								 , NULL
								FROM PO_ORDER_LOT AS A
								INNER JOIN CD_PRODUCT_CMN AS B ON A.SCAN_CODE = B.SCAN_CODE
							   WHERE A.ORD_NO = @P_ORD_NO
								 AND A.SCAN_CODE = @P_SCAN_CODE
							;

							DELETE FROM PO_ORDER_DTL WHERE ORD_NO = @P_ORD_NO AND SCAN_CODE = @P_SCAN_CODE;
							DELETE FROM PO_ORDER_LOT WHERE ORD_NO = @P_ORD_NO AND SCAN_CODE = @P_SCAN_CODE;
						END

						-- 기존수량 != 삭제수량 -> (기종수량 - 삭제수량) 업데이트
						ELSE
						BEGIN
							UPDATE PO_ORDER_DTL 
								SET PICKING_QTY = (@P_ORG_PICKING_QTY - @P_PICKING_QTY)
								  , PICKING_SAMT = (PICKING_SPRC + PICKING_SVAT) * (@P_ORG_PICKING_QTY - @P_PICKING_QTY)
							   WHERE ORD_NO = @P_ORD_NO 
								 AND SCAN_CODE = @P_SCAN_CODE
							;

							-- LOT가 한개 이상일 때
							IF 1 < (SELECT COUNT(*) FROM PO_ORDER_LOT WHERE ORD_NO = @P_ORD_NO AND SCAN_CODE = @P_SCAN_CODE)
							BEGIN
								DECLARE @ORD_NO NVARCHAR(11);
								DECLARE @SCAN_CODE NVARCHAR(14);
								DECLARE @LOT_NO NVARCHAR(30);
								
								DECLARE @V_IS_FINISH NVARCHAR(2);
								DECLARE @V_RESULT_PICKING_QTY DECIMAL(15,2)
								SET @V_IS_FINISH = 'N';
								SET @V_RESULT_PICKING_QTY = @P_PICKING_QTY;

								DECLARE CURSOR_LOT CURSOR FOR
								SELECT ORD_NO
								     , SCAN_CODE
									 , LOT_NO 
									FROM PO_ORDER_LOT 
								   WHERE ORD_NO = @P_ORD_NO 
								     AND SCAN_CODE = @P_SCAN_CODE 
								   ORDER BY LOT_NO DESC
								;

								OPEN CURSOR_LOT;
								FETCH NEXT FROM CURSOR_LOT INTO @ORD_NO, @SCAN_CODE, @LOT_NO;
								----------------------------------------
								-- #주문서 LOT별 반복문 시작
								----------------------------------------
								WHILE @@FETCH_STATUS = 0
								BEGIN
									IF @V_IS_FINISH = 'N'
									BEGIN
										IF @V_RESULT_PICKING_QTY > 0
										BEGIN
											SELECT @V_RESULT_PICKING_QTY = @V_RESULT_PICKING_QTY - PICKING_QTY
												FROM PO_ORDER_LOT 
												WHERE ORD_NO = @ORD_NO
												  AND SCAN_CODE = @SCAN_CODE
												  AND LOT_NO = @LOT_NO
											;
										END

										IF @V_RESULT_PICKING_QTY >= 0
										BEGIN
						----------------------------------------
						-- 1_3_1. 재고조정 데이터 처리
						----------------------------------------
											INSERT INTO IV_STOCK_ADJUST
											(
												ITM_CODE
											  , SCAN_CODE
											  , INV_DT
											  , INV_GB
											  , LOT_NO
											  , REQ_QTY
											  , CFM_FLAG
											  , CFM_DT
											  , APP_QTY      
											  , REMARKS
											  , IDATE
											  , IEMP_ID
											  , UDATE
											  , UEMP_ID
											)
											SELECT B.ITM_CODE
												 , A.SCAN_CODE
												 , @V_DELIVERY_DEC_DT
												 , '8'
												 , ISNULL(A.LOT_NO, '')
												 , A.PICKING_QTY * (-1)
												 , 'Y'
												 , @V_DELIVERY_DEC_DT
												 , A.PICKING_QTY * (-1)
												 , ''
												 , GETDATE()
												 , @P_EMP_ID
												 , NULL
												 , NULL
												FROM PO_ORDER_LOT AS A
												INNER JOIN CD_PRODUCT_CMN AS B ON A.SCAN_CODE = B.SCAN_CODE
											   WHERE A.ORD_NO = @P_ORD_NO
												 AND A.SCAN_CODE = @P_SCAN_CODE
												 AND A.LOT_NO = @LOT_NO
											;
											DELETE FROM PO_ORDER_LOT WHERE ORD_NO = @ORD_NO AND SCAN_CODE = @SCAN_CODE AND LOT_NO = @LOT_NO;
										END
										ELSE
										BEGIN
						----------------------------------------
						-- 1_3_1. 재고조정 데이터 처리
						----------------------------------------
											INSERT INTO IV_STOCK_ADJUST
											(
												ITM_CODE
											  , SCAN_CODE
											  , INV_DT
											  , INV_GB
											  , LOT_NO
											  , REQ_QTY
											  , CFM_FLAG
											  , CFM_DT
											  , APP_QTY
											  , REMARKS
											  , IDATE
											  , IEMP_ID
											  , UDATE
											  , UEMP_ID
											)
											SELECT B.ITM_CODE
												 , A.SCAN_CODE
												 , @V_DELIVERY_DEC_DT
												 , '8'
												 , ISNULL(A.LOT_NO, '')
												 --, @V_RESULT_PICKING_QTY
												 , (@V_RESULT_PICKING_QTY + A.PICKING_QTY) * (-1)
												 , 'Y'
												 , @V_DELIVERY_DEC_DT
												 --, @V_RESULT_PICKING_QTY
												 , (@V_RESULT_PICKING_QTY + A.PICKING_QTY) * (-1)
												 , ''
												 , GETDATE()
												 , @P_EMP_ID
												 , NULL
												 , NULL
												FROM PO_ORDER_LOT AS A
												INNER JOIN CD_PRODUCT_CMN AS B ON A.SCAN_CODE = B.SCAN_CODE
											   WHERE A.ORD_NO = @P_ORD_NO
												 AND A.SCAN_CODE = @P_SCAN_CODE
												 AND A.LOT_NO = @LOT_NO
											;

											UPDATE PO_ORDER_LOT 
												--SET PICKING_QTY = PICKING_QTY + @V_RESULT_PICKING_QTY
												SET PICKING_QTY = @V_RESULT_PICKING_QTY * (-1)
												WHERE ORD_NO = @ORD_NO
													AND SCAN_CODE = @SCAN_CODE
													AND LOT_NO = @LOT_NO
											;
											SET @V_IS_FINISH = 'Y'
										END
									END
									FETCH NEXT FROM CURSOR_LOT INTO @ORD_NO, @SCAN_CODE, @LOT_NO;
								END;
								CLOSE CURSOR_LOT;
								DEALLOCATE CURSOR_LOT;
							END

							-- LOT가 한개일 때
							ELSE 
							BEGIN
						----------------------------------------
						-- 1_3_1. 재고조정 데이터 처리
						----------------------------------------
								INSERT INTO IV_STOCK_ADJUST
								(
									ITM_CODE
									, SCAN_CODE
									, INV_DT
									, INV_GB
									, LOT_NO
									, REQ_QTY
									, CFM_FLAG
									, CFM_DT
									, APP_QTY
									, REMARKS
									, IDATE
									, IEMP_ID
									, UDATE
									, UEMP_ID
								)
								SELECT B.ITM_CODE
										, A.SCAN_CODE
										, @V_DELIVERY_DEC_DT
										, '8'
										, ISNULL(A.LOT_NO, '')
										, @P_PICKING_QTY * (-1)
										, 'Y'
										, @V_DELIVERY_DEC_DT
										, @P_PICKING_QTY * (-1)
										, ''
										, GETDATE()
										, @P_EMP_ID
										, NULL
										, NULL
									FROM PO_ORDER_LOT AS A
									INNER JOIN CD_PRODUCT_CMN AS B ON A.SCAN_CODE = B.SCAN_CODE
									WHERE A.ORD_NO = @P_ORD_NO
										AND A.SCAN_CODE = @P_SCAN_CODE
								;
								UPDATE PO_ORDER_LOT SET PICKING_QTY = (PICKING_QTY - @P_PICKING_QTY) WHERE ORD_NO = @P_ORD_NO AND SCAN_CODE = @P_SCAN_CODE;
							END
						END
					END
					FETCH NEXT FROM CURSOR_NO_DOC INTO @P_SCAN_CODE, @P_ORG_PICKING_QTY, @P_PICKING_QTY
				END

			CLOSE CURSOR_NO_DOC
			DEALLOCATE CURSOR_NO_DOC

	----------------------------------------
	-- 1_4. 주문서 헤더 및 주문별 입근내역 업데이트
	----------------------------------------
			MERGE INTO PO_ORDER_HDR AS A
				USING (
					SELECT ORD_NO
					     , SUM(PICKING_SAMT) AS SUM_PICKING_SAMT
						FROM PO_ORDER_DTL
					   WHERE ORD_NO = @P_ORD_NO 
					   GROUP BY ORD_NO
				) AS B
				ON A.ORD_NO = B.ORD_NO
			WHEN MATCHED THEN
				UPDATE SET 
					A.PICKING_TOTAL_AMT = B.SUM_PICKING_SAMT
			      , A.PICKING_TOTAL_SPRC = CAST(B.SUM_PICKING_SAMT / 1.1 AS DECIMAL(17, 4))
			;

			MERGE INTO PA_ACCT_DEPOSIT_ORD AS A
				USING (
					SELECT ORD_NO
					     , SUM(PICKING_SAMT) AS SUM_PICKING_SAMT
						FROM PO_ORDER_DTL
					   WHERE ORD_NO = @P_ORD_NO 
					   GROUP BY ORD_NO
				) AS B
				ON A.ORD_NO = B.ORD_NO
			WHEN MATCHED THEN
				UPDATE SET
					SALE_TOTAL_AMT = B.SUM_PICKING_SAMT
			;
	----------------------------------------
	-- 1_5. 대시보드 재 집계
	-- 주문서가 없어진게 아니고 수정됐기 때문에 재 집계 필요.
	----------------------------------------
			EXEC PR_AGGR_OIL_ITM_SALE_PUT @P_ORD_NO, @RETURN_CODE OUT, @RETURN_MESSAGE OUT;

	----------------------------------------
	-- 5. 매출 데이터 처리
	----------------------------------------
			DECLARE @V_VEN_CODE1 NVARCHAR(7)
			DECLARE @V_DELIVERY_DEC_DT1 NVARCHAR(8);

			SELECT @V_VEN_CODE1 = VEN_CODE, @V_DELIVERY_DEC_DT1 = DELIVERY_DEC_DT FROM PO_ORDER_HDR WHERE ORD_NO = @P_ORD_NO;
			DELETE FROM SL_SALE WHERE ORD_NO = @P_ORD_NO;	-- 주문서별 매출 데이터 삭제


			CREATE TABLE #TEMP_ITM_DATA1 (
				DELIVERY_DEC_DT NVARCHAR(8),
				SCAN_CODE NVARCHAR(14)
			);

			INSERT INTO #TEMP_ITM_DATA1
			SELECT A.DELIVERY_DEC_DT
				 , B.SCAN_CODE
				FROM PO_ORDER_HDR AS A
				INNER JOIN PO_ORDER_DTL AS B ON A.ORD_NO = B.ORD_NO
			   WHERE A.ORD_NO = @P_ORD_NO
			;

			-- 거래처별 매출, 무자료인 데이터만 있다면 매출에서 로우 삭제
			DELETE A
				FROM SL_SALE_VEN AS A
			   WHERE A.SALE_DT = @V_DELIVERY_DEC_DT1
				 AND A.VEN_CODE = @V_VEN_CODE1
				 AND A.ORD_CNT = 1
			;

			-- 제품별 매출, 무자료인 데이터만 있다면 매출에서 로우 삭제
			DELETE A
				FROM SL_SALE_ITEM AS A
				INNER JOIN #TEMP_ITM_DATA1 AS B ON A.SALE_DT = B.DELIVERY_DEC_DT AND A.SCAN_CODE = B.SCAN_CODE
			   WHERE A.ORD_CNT = 1
			;

			DROP TABLE #TEMP_ITM_DATA1;

			-- 매출 집계 start
			DECLARE @JSON NVARCHAR(MAX)
 
			SELECT @JSON =
			(SELECT ORD_NO 
			 FROM PO_ORDER_HDR
			 WHERE ORD_STAT IN ('35', '40')
			 FOR JSON PATH)
 
			EXEC PR_SL_SALE_PUT @JSON, 'admin'
			-- 매출 집계 end

		END

--==============================================================================
-- 2. 주문서 전체 무자료 처리 시
--==============================================================================
		ELSE
		BEGIN
	----------------------------------------
	-- 1. 무자료 데이터 생성
	----------------------------------------
			INSERT INTO PO_NO_DOC 
			(
				ORD_NO
			  , SCAN_CODE
			  , ORD_QTY
			  , ORD_SPRC
			  , ORD_SVAT
			  , ORD_SAMT
			  , PICKING_QTY
			  , PICKING_SPRC
			  , PICKING_SVAT
			  , PICKING_SAMT
			  , PICKING_EMP_NO
			  , PICKING_SDATE
			  , PICKING_EDATE
			  , REMARKS
			  , REMARKS_SALES
			  , IDATE
			  , IEMP_ID
			)
			SELECT A.ORD_NO
				 , A.SCAN_CODE
				 , A.ORD_QTY
				 , A.ORD_SPRC
				 , A.ORD_SVAT
				 , A.ORD_SAMT
				 , A.PICKING_QTY
				 , A.PICKING_SPRC
				 , A.PICKING_SVAT
				 , A.PICKING_SAMT
				 , A.PICKING_EMP_NO
				 , A.PICKING_SDATE
				 , A.PICKING_EDATE
				 , A.REMARKS
				 , A.REMARKS_SALES
				 , GETDATE()
				 , @P_EMP_ID
				FROM PO_ORDER_DTL AS A
			   WHERE ORD_NO = @P_ORD_NO
			;

	----------------------------------------
	-- 2. 대시보드 데이터 처리
	----------------------------------------
			EXEC PR_AGGR_OIL_ITM_SALE_DEDUCT @P_ORD_NO, @RETURN_CODE OUT, @RETURN_MESSAGE OUT;

			-- 무자료인 데이터만 있다면 매출에서 로우 삭제
			DELETE FROM AG_ORDER_OIL
			   WHERE AGGR_KG_QTY = 0
				 AND AGGR_AMT = 0
			;

			-- 무자료인 데이터만 있다면 매출에서 로우 삭제
			DELETE FROM AG_ORDER_ITM
				WHERE AGGR_EA_QTY = 0
				  AND AGGR_KG_QTY = 0
				  AND AGGR_AMT = 0
			;

			-- 무자료인 데이터만 있다면 매출에서 로우 삭제
			DELETE FROM AG_SALE
				WHERE AGGR_EA_AMT = 0
				  AND AGGR_KG_AMT = 0
				  AND AGGR_AMT = 0
			;
	----------------------------------------
	-- 3. 재고조정 데이터 처리
	----------------------------------------
			INSERT INTO IV_STOCK_ADJUST
			(
				ITM_CODE
			  , SCAN_CODE
			  , INV_DT
			  , INV_GB
			  , LOT_NO
			  , REQ_QTY
			  , CFM_FLAG
			  , CFM_DT
			  , APP_QTY
			  , REMARKS
			  , IDATE
			  , IEMP_ID
			  , UDATE
			  , UEMP_ID
			)
			SELECT B.ITM_CODE
				 , A.SCAN_CODE
				 , @V_DELIVERY_DEC_DT
				 , '8'
				 , ISNULL(C.LOT_NO, '')
				 , ISNULL(C.PICKING_QTY, A.PICKING_QTY) * (-1)
				 , 'Y'
				 , @V_DELIVERY_DEC_DT
				 , ISNULL(C.PICKING_QTY, A.PICKING_QTY) * (-1)
				 , ''
				 , GETDATE()
				 , @P_EMP_ID
				 , NULL
				 , NULL
				FROM PO_ORDER_DTL AS A
				INNER JOIN CD_PRODUCT_CMN AS B ON A.SCAN_CODE = B.SCAN_CODE
				LEFT OUTER JOIN PO_ORDER_LOT AS C ON A.ORD_NO = C.ORD_NO
			   WHERE A.ORD_NO = @P_ORD_NO
			;

	----------------------------------------
	-- 4. 주문서 및 계근 데이터 삭제
	----------------------------------------
			DECLARE @V_VEN_CODE2 NVARCHAR(7)
			DECLARE @V_DELIVERY_DEC_DT2 NVARCHAR(8);

			SELECT @V_VEN_CODE2 = VEN_CODE, @V_DELIVERY_DEC_DT2 = DELIVERY_DEC_DT FROM PO_ORDER_HDR WHERE ORD_NO = @P_ORD_NO;

			CREATE TABLE #TEMP_ITM_DATA2 (
				DELIVERY_DEC_DT NVARCHAR(8),
				SCAN_CODE NVARCHAR(14)
			);

			INSERT INTO #TEMP_ITM_DATA2
			SELECT A.DELIVERY_DEC_DT
				 , B.SCAN_CODE
				FROM PO_ORDER_HDR AS A
				INNER JOIN PO_ORDER_DTL AS B ON A.ORD_NO = B.ORD_NO
			   WHERE A.ORD_NO = @P_ORD_NO
			;

			DELETE FROM PO_ORDER_HDR WHERE ORD_NO = @P_ORD_NO;		-- 주문서 HDR 삭제
			DELETE FROM PO_ORDER_DTL WHERE ORD_NO = @P_ORD_NO;		-- 주문서 DTL 삭제
			DELETE FROM PO_ORDER_LOT WHERE ORD_NO = @P_ORD_NO;		-- 주문서 LOT 삭제
			DELETE FROM PO_ORDER_PLT WHERE ORD_NO = @P_ORD_NO;		-- 주문서 PLT 삭제
			DELETE FROM PO_ORDER_SAMPLE WHERE ORD_NO = @P_ORD_NO;	-- 주문서 SAMPLE 삭제
			DELETE FROM PA_ACCT_DEPOSIT_ORD WHERE ORD_NO = @P_ORD_NO;	-- 주문별 입금처리내역 삭제

			DELETE FROM PO_SCALE WHERE ORD_NO = @P_ORD_NO;			-- 계근 데이터 삭제
			DELETE FROM PO_SCALE_GROUP WHERE ORD_NO = @P_ORD_NO;	-- 계근 그룹 데이터 삭제

	----------------------------------------
	-- 5. 매출 데이터 처리
	----------------------------------------
			DELETE FROM SL_SALE WHERE ORD_NO = @P_ORD_NO;	-- 주문서별 매출 데이터 삭제

			-- 거래처별 매출, 무자료인 데이터만 있다면 매출에서 로우 삭제
			DELETE A
				FROM SL_SALE_VEN AS A
			   WHERE A.SALE_DT = @V_DELIVERY_DEC_DT2
				 AND A.VEN_CODE = @V_VEN_CODE2
				 AND A.ORD_CNT = 1
			;
			-- 제품별 매출, 무자료인 데이터만 있다면 매출에서 로우 삭제
			DELETE A
				FROM SL_SALE_ITEM AS A
				INNER JOIN #TEMP_ITM_DATA2 AS B ON A.SALE_DT = B.DELIVERY_DEC_DT AND A.SCAN_CODE = B.SCAN_CODE
			   WHERE A.ORD_CNT = 1
			;

			DROP TABLE #TEMP_ITM_DATA2;

			-- 매출 집계 start
			DECLARE @JSON2 NVARCHAR(MAX)
 
			SELECT @JSON2 =
			(SELECT ORD_NO 
			 FROM PO_ORDER_HDR
			 WHERE ORD_STAT IN ('35', '40')
			 FOR JSON PATH)
 
			EXEC PR_SL_SALE_PUT @JSON2, 'admin'
			-- 매출 집계 end
		
	----------------------------------------
	-- 6. 마감 데이터 처리
	--    이건 개발 후 처리해야할듯
	----------------------------------------
		END

	COMMIT;
	END TRY
	
	BEGIN CATCH	
		
		IF @@TRANCOUNT > 0
		BEGIN 
			ROLLBACK TRAN
			SET @RETURN_CODE = -1
			SET @RETURN_MESSAGE = ERROR_MESSAGE()
			
			DROP TABLE IF EXISTS #TEMP_ITM_DATA;
			
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

