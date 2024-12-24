
/*
-- 생성자 :	이동호
-- 등록일 :	2024.04.22
-- 설 명  :	@P_ORD_NO 주문 번호가 있을경우 상세정보 출력 없으면 리스트 출력
-- 수정자 : 
-- 수정일 : 2024.09.03 최수민 상세 출력시 LOT 거래처 코드 조회
			2024.10.01 최수민 입출고목록 : 출고 && 제품(NOT 벌크) 만 출력
-- 실행문 : 

PR_MO_WMS_REPORT_LIST '2240923009','',''
PR_MO_WMS_REPORT_LIST '','',''

*/
CREATE PROCEDURE [dbo].[PR_MO_WMS_REPORT_LIST]
( 	
	@P_ORD_NO			NVARCHAR(11) = '',	-- 주문번호
	@P_FROM_ORD_DT		NVARCHAR(8)	= '',	-- 주문(발주) 일자
	@P_TO_ORD_DT		NVARCHAR(8)	= ''	-- 주문(발주) 일자
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	BEGIN TRY 


	--입/출고 리스트 출력
	IF @P_ORD_NO = '' 
	BEGIN

		IF @P_FROM_ORD_DT = '' AND @P_TO_ORD_DT = ''
		BEGIN
			SET @P_FROM_ORD_DT = FORMAT(DATEADD(DAY, -5, GETDATE()), 'yyyyMMdd') --당일 기준 -5일
			SET @P_TO_ORD_DT = FORMAT(DATEADD(DAY, 2, GETDATE()), 'yyyyMMdd') --당일기준 +2
		END

		SELECT 2 AS IO_GB																			--구분 > 2:출고, 1:입고
			 , '출고' AS IO_GB_NAME
			 , HDR.ORD_NO																			--주문번호
			 , HDR.DELIVERY_REQ_DT AS ORD_DT														--출고예정일(컬럼명은 주문날짜로 해야함)
			 , HDR.VEN_CODE																			--거래처코드
			 , VEN.VEN_NAME																			--거래처명
			 , ISNULL(C.DELIVERY_NAME, '') AS DELIVERY_NAME											--배송지명
			 , HDR.ORD_STAT AS STATUS_CODE															--상태코드
			 , D.CD_NM AS STATUS_NAME																--상태명
			 , (CASE WHEN HDR.ORD_STAT IN ('10','25') AND ISNULL(PICKING_QTY_SUM, 0) > 0 THEN 'U'
					 WHEN HDR.ORD_STAT IN ('10','25') AND ISNULL(PICKING_QTY_SUM, 0) = 0 THEN 'N'
					 ELSE 'S'
				END ) AS PICKING_STAT																--검수 수량 및 PLT 수량 수정 중인 경우 확전 된건지를 판단
			 , (CASE WHEN HDR.ORD_STAT IN ('10','25') AND ISNULL(PLT_SUM_CNT, 0) > 0 THEN 'U' ELSE 'S' END) AS PLT_STAT	-- PLT 수정이력 체크
		  FROM PO_ORDER_HDR AS HDR
		 INNER JOIN (SELECT ORD_NO, MAX(SCAN_CODE) AS SCAN_CODE, MAX(ORD_QTY) AS ORD_QTY_SUM, MAX(PICKING_QTY) AS PICKING_QTY_SUM FROM PO_ORDER_DTL GROUP BY ORD_NO) AS ODTL ON HDR.ORD_NO = ODTL.ORD_NO
		 INNER JOIN CD_PRODUCT_CMN AS CMN ON ODTL.SCAN_CODE = CMN.SCAN_CODE 
		  LEFT OUTER JOIN (SELECT ORD_NO, (ISNULL(PLT_KPP_QTY11, 0) + ISNULL(PLT_KPP_QTY12, 0) + ISNULL(PLT_AJ_QTY11, 0) + ISNULL(PLT_AJ_QTY12, 0)) AS PLT_SUM_CNT
							 FROM PO_ORDER_PLT
						  ) AS PLT ON HDR.ORD_NO = PLT.ORD_NO
		 INNER JOIN TBL_COMM_CD_MST AS D ON D.CD_CL = 'ORD_STAT' AND HDR.ORD_STAT = D.CD_ID
		 INNER JOIN CD_PARTNER_MST AS VEN ON HDR.VEN_CODE = VEN.VEN_CODE
		  LEFT OUTER JOIN CD_PARTNER_DELIVERY AS C ON HDR.VEN_CODE = C.VEN_CODE AND HDR.DELIVERY_CODE = C.DELIVERY_CODE
		 WHERE HDR.DELIVERY_REQ_DT BETWEEN @P_FROM_ORD_DT AND @P_TO_ORD_DT
		   AND HDR.ORD_STAT IN ('10','25','33','35','40') --가접수, 주문취소 제외
		   AND CMN.ITM_FORM IN ('1', '2')
		 ORDER BY STATUS_CODE, ORD_DT DESC, ORD_NO DESC

		--;WITH TBL AS (
		--	SELECT 
		--		2 AS IO_GB,																					--구분 > 2:출고, 1:입고
		--		A.ORD_NO,																					--주문번호
		--		A.ORD_DT,																					--주문날짜
		--		A.VEN_CODE,																					--거래처코드								
		--		B.VEN_NAME,																					--거래처명
		--		(CASE WHEN A.DELIVERY_CODE IS NULL THEN '기본' ELSE C.DELIVERY_NAME END) AS DELIVERY_NAME,	--배송지			
		--		D.CD_ID AS [STATUS_CODE],																	--상태코드	
		--		D.CD_NM AS [STATUS_NAME],																	--상태명			
		--		--A.PICKING_TOTAL_AMT AS TOTAL_AMT,															--피킹합계금액
		--		--PLT.PLT_AJ_QTY11,
		--		--PLT.PLT_AJ_QTY12,
		--		--PLT.PLT_KPP_QTY11,
		--		--PLT.PLT_KPP_QTY12,
		--		ODTL.ORD_QTY_SUM,
		--		ODTL.PICKING_QTY_SUM,
		--		PLT.PLT_SUM_CNT
		--	FROM PO_ORDER_HDR AS A 
		--		INNER JOIN (		
		--			SELECT ORD_NO, SUM(ORD_QTY) AS ORD_QTY_SUM, SUM(PICKING_QTY) AS PICKING_QTY_SUM 
		--				FROM PO_ORDER_DTL GROUP BY ORD_NO
		--		) AS ODTL ON A.ORD_NO = ODTL.ORD_NO
		--		INNER JOIN CD_PARTNER_MST AS B ON A.VEN_CODE = B.VEN_CODE
		--		LEFT OUTER JOIN CD_PARTNER_DELIVERY AS C ON A.VEN_CODE = C.VEN_CODE AND A.DELIVERY_CODE = C.DELIVERY_CODE
		--		INNER JOIN TBL_COMM_CD_MST AS D ON D.CD_CL = 'ORD_STAT' AND A.ORD_STAT = D.CD_ID
		--		LEFT OUTER JOIN (
		--				SELECT ORD_NO, (ISNULL(PLT_KPP_QTY11, 0) + ISNULL(PLT_KPP_QTY12, 0) + ISNULL(PLT_AJ_QTY11, 0) + ISNULL(PLT_AJ_QTY12, 0)) AS PLT_SUM_CNT FROM PO_ORDER_PLT
		--			) AS PLT ON A.ORD_NO = PLT.ORD_NO

		--	WHERE A.ORD_DT BETWEEN @P_FROM_ORD_DT AND @P_TO_ORD_DT
		--			AND A.ORD_STAT IN ('10','25','33','35','40') --가접수, 주문취소 제외
		--	UNION ALL									
		--	SELECT 
		--		1 AS IO_GB,																					--구분 > 2:출고, 1:입고
		--		A.ORD_NO,																					--주문번호
		--		A.ORD_DT,																					--주문날짜
		--		A.VEN_CODE,																					--거래처코드
		--		B.VEN_NAME,																					--거래처명
		--		(CASE WHEN A.DELIVERY_CODE IS NULL THEN '기본' ELSE C.DELIVERY_NAME END) AS DELIVERY_NAME,	--배송지
		--		D.CD_ID AS [STATUS_CODE],																	--상태코드	
		--		D.CD_NM AS [STATUS_NAME],																	--상태명	
		--		--A.PUR_TOTAL_AMT AS TOTAL_AMT,																--입고/매입 합계금액
		--		--0 AS PLT_AJ_QTY11,
		--		--0 AS PLT_AJ_QTY12,
		--		--0 AS PLT_KPP_QTY11,
		--		--0 AS PLT_KPP_QTY12,
		--		ODTL.ORD_QTY_SUM,
		--		ODTL.PICKING_QTY_SUM,
		--		0 AS PLT_SUM_CNT
		--	FROM PO_PURCHASE_HDR AS A 
		--		INNER JOIN (		
		--			SELECT ORD_NO, SUM(ORD_QTY) AS ORD_QTY_SUM, SUM(PUR_QTY) AS PICKING_QTY_SUM 
		--				FROM PO_PURCHASE_DTL GROUP BY ORD_NO
		--		) AS ODTL ON A.ORD_NO = ODTL.ORD_NO
		--		INNER JOIN CD_PARTNER_MST AS B ON A.VEN_CODE = B.VEN_CODE				
		--		LEFT OUTER JOIN CD_PARTNER_DELIVERY AS C ON A.VEN_CODE = C.VEN_CODE AND A.DELIVERY_CODE = C.DELIVERY_CODE				
		--		INNER JOIN TBL_COMM_CD_MST AS D ON D.CD_CL = 'PUR_STAT' AND A.PUR_STAT = D.CD_ID
		--	WHERE A.ORD_DT BETWEEN @P_FROM_ORD_DT AND @P_TO_ORD_DT
		--			AND A.PUR_STAT IN ('10','25','33','35','40') --가접수, 주문취소 제외
		--) 

		--SELECT TOP 1000
		--	IO_GB,																		--구분 > 2:출고, 1:입고
		--	(CASE WHEN IO_GB = 2 THEN '출고' ELSE '입고' END) AS IO_GB_NAME,
		--	ORD_NO,																		--주문번호
		--	ORD_DT,																		--주문날짜
		--	VEN_CODE,																	--거래처코드
		--	VEN_NAME,																	--거래처명
		--	DELIVERY_NAME,																--배송지
		--	STATUS_CODE,																--주문/발주 상태코드	
		--	STATUS_NAME,																--주문/발주 상태NM
		--	--ORD_QTY_SUM,
		--	--PICKING_QTY_SUM,
		--	(
		--		CASE 
		--			WHEN STATUS_CODE IN ('10','25') AND ISNULL(PICKING_QTY_SUM, 0) > 0 THEN 'U'
		--			WHEN STATUS_CODE IN ('10','25') AND ISNULL(PICKING_QTY_SUM, 0) = 0 THEN 'N'
		--			ELSE 'S' 
		--		END
		--	) AS PICKING_STAT,															--검수 수량 및 PLT 수량 수정 중인 경우 확전 된건지를 판단
		--	(
		--		CASE 
		--			WHEN STATUS_CODE IN ('10','25') AND ISNULL(PLT_SUM_CNT, 0) > 0 THEN 'U'					
		--			ELSE 'S'
		--		END
		--	) AS PLT_STAT														
						
		--FROM TBL 						
		--ORDER BY STATUS_CODE, IO_GB DESC, ORD_DT DESC, ORD_NO DESC

	END
	ELSE
	BEGIN
		
		--입/출고 상세 정보

		DECLARE @IO_GB INT = LEFT(@P_ORD_NO, 1)
		IF @IO_GB = 2 
		BEGIN
			--출고 상세정보
			SELECT
				@IO_GB AS IO_GB,
				(CASE WHEN @IO_GB = 2 THEN '출고' WHEN @IO_GB = 1 THEN '입고' END ) AS IO_GB_NAME,		
				A.ORD_NO,																					--주문번호
				A.VEN_CODE,																					--거래처코드
				B.VEN_NAME,																					--거래처명
				C.CAR_NO,																					--차량번호
				D.CD_NM AS CAR_GB_NM,																		--차량구분
				(CASE WHEN A.DELIVERY_CODE IS NULL THEN '기본' ELSE E.DELIVERY_NAME END) AS DELIVERY_NAME,	--배송지명
				F.TRANS_SECTION,																			--운송구간
				A.R_ADDR,																					--주소
				A.R_ADDR_DTL,																				--상세주소
				ORD_ST.CD_ID AS [STATUS_CODE],																--상태코드	
				ORD_ST.CD_NM AS [STATUS_NAME],																--상태명																				
				(
					CASE 
						WHEN ORD_ST.CD_ID IN ('10','25') AND ISNULL(PICKING_QTY_SUM, 0) > 0 THEN 'U'
						WHEN ORD_ST.CD_ID IN ('10','25') AND ISNULL(PICKING_QTY_SUM, 0) = 0 THEN 'N'
						ELSE 'S' 
					END
				) AS PICKING_STAT,																			--검수 수량 및 PLT 수량 수정 중인 경우 확전 된건지를 판단
				CASE WHEN A.TRANS_YN = 'N' THEN 'Y' ELSE IIF(C.ORD_NO IS NULL, 'N', 'Y') END AS SCALE_STAT,	--계근대 정보 등록 여부(Y : PDA 저장 가능, N : 계근정보 미등록(PDA 저장 불가능 처리))		
				G.CD_ID	AS LOT_PARTNER_GB,																	--LOT거래처구분
				'' AS PLT_STAT
			FROM PO_ORDER_HDR AS A
				INNER JOIN (		
					SELECT ORD_NO, SUM(ORD_QTY) AS ORD_QTY_SUM, SUM(PICKING_QTY) AS PICKING_QTY_SUM 
						FROM PO_ORDER_DTL GROUP BY ORD_NO
				) AS ODTL ON A.ORD_NO = ODTL.ORD_NO
				
				INNER JOIN CD_PARTNER_MST AS B ON A.VEN_CODE = B.VEN_CODE
				INNER JOIN TBL_COMM_CD_MST AS ORD_ST ON ORD_ST.CD_CL = 'ORD_STAT' AND A.ORD_STAT = ORD_ST.CD_ID
				LEFT OUTER JOIN PO_SCALE AS C ON A.ORD_NO = C.ORD_NO
				LEFT OUTER JOIN TBL_COMM_CD_MST AS D ON D.CD_CL = 'CAR_GB' AND C.CAR_GB = D.CD_ID
				LEFT OUTER JOIN CD_PARTNER_DELIVERY AS E ON A.VEN_CODE = E.VEN_CODE AND A.DELIVERY_CODE = E.DELIVERY_CODE
				LEFT OUTER JOIN CD_DELIVERY_PRICE AS F ON A.DELIVERY_PRICE_SEQ = F.SEQ
				LEFT OUTER JOIN PO_ORDER_PLT AS PLT ON A.ORD_NO = PLT.ORD_NO
				LEFT OUTER JOIN TBL_COMM_CD_MST AS G ON G.CD_CL = 'LOT_PARTNER_GB' AND A.VEN_CODE = G.MGMT_ENTRY_1
			WHERE A.ORD_NO = @P_ORD_NO AND A.ORD_STAT IN ('10','25','33','35','40') --가접수, 주문취소 제외

		END
		ELSE IF @IO_GB = 1
		BEGIN
			--입고 상세정보
			SELECT												
				@IO_GB AS IO_GB,
				(CASE WHEN @IO_GB = 2 THEN '출고' WHEN @IO_GB = 1 THEN '입고' END ) AS IO_GB_NAME,
				A.ORD_NO,																					--주문번호
				A.VEN_CODE,																					--거래처코드
				B.VEN_NAME,																					--거래처명
				C.CAR_NO,																					--차량번호
				D.CD_NM AS CAR_GB_NM,																		--차량구분
				(CASE WHEN A.DELIVERY_CODE IS NULL THEN '기본' ELSE E.DELIVERY_NAME END) AS DELIVERY_NAME,	--배송지명
				F.TRANS_SECTION,																			--운송구간
				A.R_ADDR,																					--주소
				A.R_ADDR_DTL,																				--상세주소		
				PUR_ST.CD_ID AS [STATUS_CODE],																--상태코드	
				PUR_ST.CD_NM AS [STATUS_NAME],																--상태명					
				(
					CASE 
						WHEN PUR_ST.CD_ID IN ('10','25') AND ISNULL(PICKING_QTY_SUM, 0) > 0 THEN 'U'
						WHEN PUR_ST.CD_ID IN ('10','25') AND ISNULL(PICKING_QTY_SUM, 0) = 0 THEN 'N'
						ELSE 'S' 
					END
				) AS PICKING_STAT,																			--검수 수량 및 PLT 수량 수정 중인 경우 확전 된건지를 판단				
				CASE WHEN A.TRANS_YN = 'N' THEN 'Y' ELSE IIF(C.ORD_NO IS NULL, 'N', 'Y') END AS SCALE_STAT,	--계근대 정보 등록 여부(Y : PDA 저장 가능, N : 계근정보 미등록(PDA 저장 불가능 처리))
				G.CD_ID	AS LOT_PARTNER_GB,																	--LOT거래처구분
				'' AS PLT_STAT
			FROM PO_PURCHASE_HDR AS A
				INNER JOIN (		
					SELECT ORD_NO, SUM(ORD_QTY) AS ORD_QTY_SUM, SUM(PUR_QTY) AS PICKING_QTY_SUM 
						FROM PO_PURCHASE_DTL GROUP BY ORD_NO
				) AS ODTL ON A.ORD_NO = ODTL.ORD_NO
				INNER JOIN CD_PARTNER_MST AS B ON A.VEN_CODE = B.VEN_CODE
				INNER JOIN TBL_COMM_CD_MST AS PUR_ST ON PUR_ST.CD_CL = 'PUR_STAT' AND A.PUR_STAT = PUR_ST.CD_ID
				LEFT OUTER JOIN PO_SCALE AS C ON A.ORD_NO = C.ORD_NO
				LEFT OUTER JOIN TBL_COMM_CD_MST AS D ON D.CD_CL = 'CAR_GB' AND C.CAR_GB = D.CD_ID
				LEFT OUTER JOIN CD_PARTNER_DELIVERY AS E ON A.VEN_CODE = E.VEN_CODE AND A.DELIVERY_CODE = E.DELIVERY_CODE
				LEFT OUTER JOIN CD_DELIVERY_PRICE AS F ON A.DELIVERY_PRICE_SEQ = F.SEQ
				LEFT OUTER JOIN TBL_COMM_CD_MST AS G ON G.CD_CL = 'LOT_PARTNER_GB' AND A.VEN_CODE = G.MGMT_ENTRY_1

			WHERE A.ORD_NO = @P_ORD_NO AND A.PUR_STAT IN ('10','25','33','35','40') --가접수, 주문취소 제외
		END
		
	END

	
	END TRY
	
	BEGIN CATCH		
		--에러 로그 테이블 저장
		INSERT INTO TBL_ERROR_LOG 
		SELECT ERROR_PROCEDURE()	-- 프로시저명
		, ERROR_MESSAGE()			-- 에러메시지
		, ERROR_LINE()				-- 에러라인
		, GETDATE()	
	END CATCH
	
END

GO

