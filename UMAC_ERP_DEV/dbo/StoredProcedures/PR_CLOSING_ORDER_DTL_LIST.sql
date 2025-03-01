/*
-- 생성자 :	강세미
-- 등록일 :	2024.09.12
-- 수정자 : 2024.12.03 강세미- 담당자 조회조건 수정
			2024.12.03 강세미- 배송지마스터 JOIN 수정, 배송지명 조회 컬럼 추가
			2024.12.12 강세미- 정렬순서 변경, 차량번호 조회 추가
-- 수정일 : - 
-- 설 명  : 건별 월매출마감 내역
-- 실행문 : EXEC PR_CLOSING_ORDER_DTL_LIST '202411','', '', '', 'ETC','','','prdGroupGrid'
*/
CREATE PROCEDURE [dbo].[PR_CLOSING_ORDER_DTL_LIST]
	@P_CLOSE_DT			NVARCHAR(6),			-- 마감월
	@P_DEPT_CODE		NVARCHAR(25),			-- 조직코드
	@P_CLOSE_STAT		NCHAR(1),				-- 마감여부
	@P_VEN_CODE			NVARCHAR(7),			-- 거래처코드
	@P_MGNT_USER_ID		NVARCHAR(300),			-- 담당자ID (',' 구분)
	@P_ISSUE_GB 		NVARCHAR(1),			-- 발행구분
	@P_SCAN_CODE 		NVARCHAR(14),			-- 제품코드
	@P_GRID_TYPE		NVARCHAR(20)			-- Grid 구분 prdGroupGrid: 품목별 venGroupGrid: 거래처별
AS 
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	BEGIN TRY 
		
		  SELECT A.PICKING_QTY AS QTY,
				 ( CASE WHEN E.VEN_GB = '4' THEN ROUND(A.PICKING_SPRC * A.PICKING_QTY, 0)
						ELSE ROUND((A.PICKING_SPRC + A.PICKING_SVAT) * A.PICKING_QTY / 1.1, 0) END ) AS PICKING_TOTAL_SPRC, -- 공급가 합계
				 ( CASE WHEN E.VEN_GB = '4' THEN 0
						ELSE (A.PICKING_SPRC + A.PICKING_SVAT) * A.PICKING_QTY - ROUND(((A.PICKING_SPRC + A.PICKING_SVAT) * A.PICKING_QTY / 1.1), 0) END ) AS PICKING_TOTAL_SVAT,  -- 부가세 합계
				 ( CASE WHEN E.VEN_GB = '4' THEN ROUND(A.PICKING_SPRC, 0) * A.PICKING_QTY
						ELSE (A.PICKING_SPRC + A.PICKING_SVAT) * A.PICKING_QTY END ) AS PICKING_TOTAL_SAMT, -- 합계
				 ( CASE WHEN E.VEN_GB = '4' THEN A.PICKING_SPRC
						ELSE A.PICKING_SPRC + A.PICKING_SVAT END ) AS PICKING_SALE, -- 판매가
				 A.PICKING_SPRC AS PICKING_SPRC, -- 공급가
				 A.PICKING_SVAT AS PICKING_SVAT, -- 부가세
				 A.ORD_NO,
				 A.SCAN_CODE,
				 A.REMARKS_SALES,
				 B.DELIVERY_DEC_DT,
				 B.VEN_CODE,
				 B.CLOSE_STAT,
				 B.ISSUE_GB,
				 B.CLOSE_NO,
				 FORMAT(CAST(B.CLOSE_DT AS DATE), 'yyyy-MM-dd') AS CLOSE_DT,
				 B.CLOSE_REMARKS,
				 ISNULL(B.DOUZONE_FLAG, 'N') AS DOUZONE_FLAG,
				 C.ITM_NAME,
				 C.WEIGHT_GB,
				 D.CAR_NO,
				 CASE WHEN C.WEIGHT_GB = 'WT' THEN D.NET_WGHT ELSE 0 END AS NET_WGHT,
				 CASE WHEN C.WEIGHT_GB = 'WT' THEN D.OFFICIAL_WGHT ELSE 0 END AS OFFICIAL_WGHT,
				 CASE WHEN C.WEIGHT_GB = 'WT' THEN D.NET_WGHT - D.OFFICIAL_WGHT ELSE 0 END AS GAP_WGHT,
				 ISNULL(D.CLOSE_WGHT, 0) AS CLOSE_WGHT,
				 E.VEN_NAME,
				 E.VEN_GB,
				 H.CD_NM AS ISSUE_GB_NM,
				 (CONCAT_WS('/', IIF(I.DELIVERY_NAME_DEP1 IS NULL, NULL, I.DELIVERY_NAME_DEP1),
								 IIF(D.REMARKS IS NULL, NULL, D.REMARKS))) AS UP_DELIVERY_NAME_REMARKS,
				 I.DELIVERY_NAME_DEP2 AS DELIVERY_NAME,
				 J.LOT_CNT,
				 J.LOT_NO,
				 J.LOT_PICKING_QTY
			FROM PO_ORDER_DTL AS A
			INNER JOIN PO_ORDER_HDR AS B
				ON A.ORD_NO = B.ORD_NO
			INNER JOIN CD_PRODUCT_CMN AS C
				ON A.SCAN_CODE = C.SCAN_CODE
			LEFT OUTER JOIN PO_SCALE AS D
				ON A.ORD_NO = D.ORD_NO
			INNER JOIN CD_PARTNER_MST AS E
				ON B.VEN_CODE = E.VEN_CODE
			LEFT OUTER JOIN TBL_USER_MST AS F
				ON E.MGNT_USER_ID = F.[USER_ID]
			LEFT OUTER JOIN TBL_COMM_CD_MST AS H
				ON H.CD_CL = 'ISSUE_GB' AND B.ISSUE_GB = H.CD_ID 
			LEFT OUTER JOIN 
					( SELECT 
							A.VEN_CODE,
							A.DELIVERY_CODE, 
							(CASE WHEN A.DELIVERY_GB = '1' THEN '' ELSE A.DELIVERY_NAME END ) AS DELIVERY_NAME_DEP2,	--배송지명
							B.DELIVERY_NAME AS DELIVERY_NAME_DEP1														--배송그룹명
						FROM CD_PARTNER_DELIVERY AS A
						LEFT OUTER JOIN CD_PARTNER_DELIVERY AS B ON A.VEN_CODE = B.VEN_CODE AND CONCAT(SUBSTRING(A.DELIVERY_CODE, 1, 5), '01') = B.DELIVERY_CODE					
					) AS I ON  B.DELIVERY_CODE = I.DELIVERY_CODE AND B.VEN_CODE = I.VEN_CODE
			LEFT OUTER JOIN (
				SELECT ORD_NO, 
					   SCAN_CODE, 
					   STRING_AGG(LOT_NO, ',') AS LOT_NO, 
					   STRING_AGG(PICKING_QTY, ',') AS LOT_PICKING_QTY, 
					   COUNT(LOT_NO) AS LOT_CNT
				  FROM PO_ORDER_LOT
				 GROUP BY ORD_NO, SCAN_CODE ) AS J 
				 ON A.ORD_NO = J.ORD_NO AND A.SCAN_CODE = J.SCAN_CODE
			WHERE B.CLOSE_DT LIKE @P_CLOSE_DT + '%' 
				AND B.ORD_STAT IN ('35', '40')
				AND 1 = (CASE WHEN @P_DEPT_CODE = '' THEN 1 WHEN @P_DEPT_CODE <> '' AND F.DEPT_CODE LIKE @P_DEPT_CODE + '%' THEN 1 ELSE 0 END)
				AND (
						@P_MGNT_USER_ID = ''
						OR
						( E.MGNT_USER_ID IN (SELECT VALUE FROM STRING_SPLIT(@P_MGNT_USER_ID, ','))
							OR ( 'ETC' IN (SELECT VALUE FROM STRING_SPLIT(@P_MGNT_USER_ID, ','))
								 AND (E.MGNT_USER_ID IS NULL OR E.MGNT_USER_ID = ''))
						)
					)
				AND 1 = (CASE WHEN @P_CLOSE_STAT = '' THEN 1 WHEN @P_CLOSE_STAT <> '' AND B.CLOSE_STAT = @P_CLOSE_STAT THEN 1 ELSE 0 END)
				AND 1 = (CASE WHEN @P_VEN_CODE = '' THEN 1 WHEN @P_VEN_CODE <> '' AND B.VEN_CODE = @P_VEN_CODE THEN 1 ELSE 0 END)
				AND 1 = (CASE WHEN @P_ISSUE_GB = '' THEN 1 WHEN @P_ISSUE_GB <> '' AND B.ISSUE_GB = @P_ISSUE_GB THEN 1 ELSE 0 END)
				AND 1 = (CASE WHEN @P_SCAN_CODE = '' THEN 1 WHEN @P_SCAN_CODE <> '' AND A.SCAN_CODE = @P_SCAN_CODE THEN 1 ELSE 0 END)
			ORDER BY CASE WHEN @P_GRID_TYPE = 'prdGroupGrid' THEN C.ITM_NAME ELSE E.VEN_NAME END,
					 B.DELIVERY_DEC_DT,
					 --CASE WHEN @P_GRID_TYPE = 'prdGroupGrid' THEN B.DELIVERY_DEC_DT END, 
				     CASE WHEN @P_GRID_TYPE <> 'prdGroupGrid' THEN C.ITM_NAME END
					 --CASE WHEN @P_GRID_TYPE <> 'prdGroupGrid' THEN B.DELIVERY_DEC_DT END


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

