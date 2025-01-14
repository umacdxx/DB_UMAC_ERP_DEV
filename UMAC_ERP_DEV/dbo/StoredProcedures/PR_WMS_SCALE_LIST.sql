
/*
-- 생성자 :	최수민
-- 등록일 :	2024.10.03
-- 설 명  : 계근기록부
-- 수정일 : 2024.10.04 최수민 차량번호 조회 추가, 거래처 검색 조건 추가 
-- 실행문 : 

EXEC PR_WMS_SCALE_LIST '20240919', 0, '', '120001'
*/


CREATE PROCEDURE [dbo].[PR_WMS_SCALE_LIST]
( 
	@P_SCALE_DT				NVARCHAR(8)			= '',	-- 계근일자
	@P_IO_GB				NVARCHAR(1)			= '',	-- 입출고구분(입고:1, 출고:2)
	@P_VEN_CODE				NVARCHAR(11)		= '',	-- 거래처코드
	@P_SCAN_CODE			NVARCHAR(14)		= ''	-- 제품코드
)
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
/*

		 SELECT SCALE_DT, COUNT(1)
		  FROM PO_SCALE
		  GROUP BY SCALE_DT
		  ORDER BY COUNT(1) DESC
*/
	BEGIN TRY 
		

		WITH VIEW_ORDER AS (
			SELECT '2' AS IO_GB									--1.매입 , 2.매출 , 3.수입
				 , '매출' AS IO_GB_NM							--매출입구분
				 , SC.ORD_NO									--주문번호
				 , SC.SCALE_DT 									--계근일자
				 , SC.IN_IDATE									--계근대 최초 진입 날짜
				 , SC.CAR_NO									--차량번호
				 , HDR.DELIVERY_CODE							--배송지코드
				 , DTL.SCAN_CODE								--제품코드
				 , DTL.PICKING_QTY AS QTY						--수량
				 , ISNULL(SC.PLT_QTY11, 0) AS PLT_QTY11			--PLT11
				 , ISNULL(SC.PLT_QTY12, 0) AS PLT_QTY12			--PLT12
				 , SC.VEN_CODE									--거래처코드
				 , SC.GROSS_WGHT								--총중량
				 , SC.UNLOAD_WGHT								--공차중량
				 , SC.NET_WGHT									--자차중량(순중량)
				 , SC.OFFICIAL_WGHT								--타차중량
				 , SC.GAP_WGHT									--차이중량
				 , SC.BAG_QTY									--톤백/공백/피 수량
				 , SC.REMARKS									--비고
			  FROM PO_SCALE AS SC
			 INNER JOIN PO_ORDER_HDR AS HDR ON SC.ORD_NO = HDR.ORD_NO
			 INNER JOIN PO_ORDER_DTL AS DTL ON SC.ORD_NO = DTL.ORD_NO
			 WHERE SC.SCALE_DT = @P_SCALE_DT
			   AND HDR.ORD_STAT IN ('25', '33', '35', '40')
		),
		VIEW_PURCHASE AS (
			SELECT '1' AS IO_GB									--1.매입 , 2.매출 , 3.수입
				 , '매입' AS IO_GB_NM							--매출입구분
				 , SC.ORD_NO									--주문번호
				 , SC.SCALE_DT 									--계근일자
				 , SC.IN_IDATE									--계근대 최초 진입 날짜
				 , SC.CAR_NO									--차량번호
				 , HDR.DELIVERY_CODE							--배송지코드
				 , DTL.SCAN_CODE								--제품코드
				 , DTL.PUR_QTY AS QTY							--수량
				 , ISNULL(SC.PLT_QTY11, 0) AS PLT_QTY11			--PLT11
				 , ISNULL(SC.PLT_QTY12, 0) AS PLT_QTY12			--PLT12
				 , SC.VEN_CODE									--거래처코드
				 , SC.GROSS_WGHT								--총중량
				 , SC.UNLOAD_WGHT								--공차중량
				 , SC.NET_WGHT									--자차중량(순중량)
				 , SC.OFFICIAL_WGHT								--타차중량
				 , SC.GAP_WGHT									--차이중량
				 , SC.BAG_QTY									--톤백/공백/피 수량
				 , SC.REMARKS									--비고
			  FROM PO_SCALE AS SC
			 INNER JOIN PO_PURCHASE_HDR AS HDR ON SC.ORD_NO = HDR.ORD_NO
			 INNER JOIN PO_PURCHASE_DTL AS DTL ON SC.ORD_NO = DTL.ORD_NO
			 WHERE SC.SCALE_DT = @P_SCALE_DT
			   AND HDR.PUR_STAT IN ('25', '33', '35', '40')
		),
		VIEW_ORD_PUR AS (
			SELECT DENSE_RANK() OVER (ORDER BY PO_ORD_PUR.IN_IDATE, PO_ORD_PUR.ORD_NO) AS ROW_NUM
				 , PO_ORD_PUR.ORD_NO
				 , PO_ORD_PUR.IO_GB
				 , PO_ORD_PUR.IO_GB_NM
				 , PO_ORD_PUR.SCALE_DT
				 , PO_ORD_PUR.CAR_NO
				 , PO_ORD_PUR.VEN_CODE
				 , PTN.VEN_NAME
				 , PO_ORD_PUR.IN_IDATE
				 , ISNULL(TOP_DELI.DELIVERY_NAME, '') AS UP_DELIVERY_NAME
				 , ISNULL(BOT_DELI.DELIVERY_NAME, '') AS DELIVERY_NAME
				 , PO_ORD_PUR.SCAN_CODE
				 , CMN.ITM_NAME
				 , ISNULL(PO_ORD_PUR.QTY, 0) AS QTY
				 , CASE WHEN CMN.WEIGHT_GB = 'QTY' THEN 'EA' WHEN CMN.WEIGHT_GB = 'WT' THEN 'KG' ELSE '' END AS WEIGHT_GB_NM
				 , CASE WHEN RN = 1 THEN ISNULL(PO_ORD_PUR.PLT_QTY11, 0) ELSE 0 END AS PLT_QTY11
				 , CASE WHEN RN = 1 THEN ISNULL(PO_ORD_PUR.PLT_QTY12, 0) ELSE 0 END AS PLT_QTY12
				 , CASE WHEN RN = 1 THEN ISNULL(PO_ORD_PUR.GROSS_WGHT, 0) ELSE 0 END AS GROSS_WGHT
				 , CASE WHEN RN = 1 THEN ISNULL(PO_ORD_PUR.UNLOAD_WGHT, 0) ELSE 0 END AS UNLOAD_WGHT
				 , CASE WHEN RN = 1 THEN ISNULL(PO_ORD_PUR.NET_WGHT, 0) ELSE 0 END AS NET_WGHT
				 , CASE WHEN RN = 1 THEN ISNULL(PO_ORD_PUR.OFFICIAL_WGHT, 0) ELSE 0 END AS OFFICIAL_WGHT
				 , CASE WHEN RN = 1 THEN ISNULL(PO_ORD_PUR.GAP_WGHT, 0) ELSE 0 END AS GAP_WGHT
				 , CASE WHEN RN = 1 THEN ISNULL(PO_ORD_PUR.BAG_QTY, 0) ELSE 0 END AS BAG_QTY
				 , ISNULL(PO_ORD_PUR.REMARKS, '') AS REMARKS
			  FROM (
					SELECT *, ROW_NUMBER() OVER (PARTITION BY ORD_NO ORDER BY IN_IDATE) AS RN FROM VIEW_ORDER
					UNION ALL
					SELECT *, ROW_NUMBER() OVER (PARTITION BY ORD_NO ORDER BY IN_IDATE) AS RN FROM VIEW_PURCHASE
					) AS PO_ORD_PUR
			  LEFT OUTER JOIN CD_PARTNER_DELIVERY AS TOP_DELI ON PO_ORD_PUR.VEN_CODE = TOP_DELI.VEN_CODE AND PO_ORD_PUR.DELIVERY_CODE = TOP_DELI.DELIVERY_CODE AND TOP_DELI.DELIVERY_GB = 1
			  LEFT OUTER JOIN CD_PARTNER_DELIVERY AS BOT_DELI ON PO_ORD_PUR.VEN_CODE = BOT_DELI.VEN_CODE AND PO_ORD_PUR.DELIVERY_CODE = BOT_DELI.DELIVERY_CODE AND BOT_DELI.DELIVERY_GB = 2
			 INNER JOIN CD_PRODUCT_CMN AS CMN ON PO_ORD_PUR.SCAN_CODE = CMN.SCAN_CODE
			 INNER JOIN CD_PARTNER_MST AS PTN ON PO_ORD_PUR.VEN_CODE = PTN.VEN_CODE
		 )
		 SELECT *
		   FROM VIEW_ORD_PUR
		  WHERE (VEN_CODE = CASE WHEN @P_VEN_CODE <> '' THEN @P_VEN_CODE ELSE VEN_CODE END) 
		    AND (IO_GB = CASE WHEN @P_IO_GB <> '' THEN @P_IO_GB ELSE IO_GB END)
		    AND (SCAN_CODE = CASE WHEN @P_SCAN_CODE <> '' THEN @P_SCAN_CODE ELSE SCAN_CODE END)
		  ORDER BY ROW_NUM



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

