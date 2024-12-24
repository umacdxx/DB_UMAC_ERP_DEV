/*
-- 생성자 :	최수민
-- 등록일 :	2024.10.14
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 월매입마감 더존 연동할 목록 조회
-- 실행문 : EXEC PR_CLOSING_PURCHASE_DOUZONE_LIST 'UM10003','202410'
*/
CREATE PROCEDURE [dbo].[PR_CLOSING_PURCHASE_DOUZONE_LIST]
	@P_VEN_CODE			NVARCHAR(7),			-- 거래처코드
	@P_CLOSE_DT			NVARCHAR(6)				-- 마감월
AS 
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	BEGIN TRY 
	EXEC UMAC_CERT_OPEN_KEY;
		
		WITH VIEW_SUM_DTL AS (
			SELECT DTL.SCAN_CODE
				 , HDR.CLOSE_DT
				 , 1 AS ISSUE_GB
				 , HDR.VEN_CODE
				 , SUM(DTL.PUR_QTY) AS PICKING_QTY
			 	 , ROUND(SUM(DTL.PUR_WAMT), 0) AS PICKING_SAMT
			 	 , CASE WHEN PTN.VEN_GB = '3' THEN ROUND(SUM(DTL.PUR_WAMT), 0) ELSE ROUND(SUM(DTL.PUR_WAMT) / 1.1, 0) END AS PICKING_SPRC
				 , CASE WHEN PTN.VEN_GB = '3' THEN 0 ELSE ROUND(SUM(DTL.PUR_WAMT) - (SUM(DTL.PUR_WAMT) / 1.1), 0) END AS PICKING_SVAT
				 , COUNT(DTL.SCAN_CODE) AS PICKING_CNT
			  FROM PO_PURCHASE_HDR AS HDR
			 INNER JOIN PO_PURCHASE_DTL AS DTL ON HDR.ORD_NO = DTL.ORD_NO
			 INNER JOIN CD_PARTNER_MST AS PTN ON HDR.VEN_CODE = PTN.VEN_CODE
			 WHERE HDR.CLOSE_STAT = 'Y'
			   AND HDR.CLOSE_DT LIKE @P_CLOSE_DT + '%'
			   AND HDR.VEN_CODE = @P_VEN_CODE
			 GROUP BY DTL.SCAN_CODE, HDR.CLOSE_DT, HDR.VEN_CODE, PTN.VEN_GB
		),
		VIEW_TOTAL_SUM AS (
			SELECT CLOSE_DT AS ACTG_DT
				 , SUM(PICKING_SPRC) AS TOTAL_PICKING_SPRC
				 , SUM(PICKING_SVAT) AS TOTAL_PICKING_SVAT
			  FROM VIEW_SUM_DTL
			 GROUP BY CLOSE_DT
		)
		SELECT ROW_NUMBER() OVER (ORDER BY VSUM.CLOSE_DT) AS DOUZONE_SEQ																			--더존 PRIMARY KEY
			 , VSUM.SCAN_CODE																														--스캔코드
			 , CMN.ITM_NAME																															--제품명
			 , CASE WHEN CMN.WEIGHT_GB = 'WT' THEN 'KG' ELSE 'C/N' END AS SIZE_NM																	--규격 (수량 C/N / 중량 KG)
			 , LRG.LRG_CODE																															--대분류코드
			 , MID.MID_CODE																															--중분류코드
			 , VSUM.VEN_CODE																														--거래처코드
			 , PTN.VEN_NAME AS PARTNER_NM																											--거래처명
			 , PTN.PARTNER_CD																														--더존 거래처코드
			 , PTN.BUSI_NO																															--사업자등록번호
			 , PTN.VEN_GB																															--거래처구분
			 , PTN.DIRECT_EXPORT_YN																													--직수출구분
			 , ISNULL(VSUM.PICKING_QTY, 0) AS PICKING_QTY																							--총 검수수량
			 , ISNULL(VSUM.PICKING_SAMT, 0) AS PICKING_SAMT																							--공급가 + 부가세
			 , ISNULL(VSUM.PICKING_SPRC, 0)	AS PICKING_SPRC																							--공급가
			 , ISNULL(VSUM.PICKING_SVAT, 0)	AS PICKING_SVAT																							--부가세
			 , ISNULL(VSPRC.TOTAL_PICKING_SPRC, 0) AS TOTAL_PICKING_SPRC																			--공급가 총 합
			 , ISNULL(VSPRC.TOTAL_PICKING_SVAT, 0) AS TOTAL_PICKING_SVAT																			--부가세 총 합
			 , CD93.CD_ID AS D93																													--저장품 구분 (DOUZONE_D93)
			 , CD93.CD_NM AS D93_NM																													--저장품 구분명
			 , CD95.CD_ID AS D95																													--원재료 구분 (DOUZONE_D95)
			 , CD95.CD_NM AS D95_NM																													--저장품 구분
			 , NULL	AS D96																															--제품매출 구분 (DOUZONE_D96)
			 , NULL AS D96_NM																														--제품매출 구분명
			 , CONVERT(CHAR(8), GETDATE(), 112) AS WRT_DT																							--작성일(더존으로 전표 넘기는 날)
			 , VSUM.CLOSE_DT																														--마감일자
			 , REPLACE(EOMONTH(VSUM.CLOSE_DT), '-', '') AS ACTG_DT																					--회계일(월말)
			 , SUBSTRING(VSUM.CLOSE_DT, 5, 8) AS TAX_MD																								--회계일(MMDD)
			 , CONCAT(ITM_NAME, ' ', FORMAT(CAST(PICKING_QTY AS INT), '#,0'), CASE WHEN WEIGHT_GB = 'WT' THEN 'KG' ELSE 'EA' END, ' (', VEN_NAME, ')') AS NOTE_DC	--적요 (상품명 + 마감수량 + EA/KG  + (거래처명))
			 , '21' AS TAX_SALE																														--과세매입
			 , '과세매입' AS TAX_SALE_NM																											--과세매입명
			 , B.MGMT_ENTRY_1 AS ISSUE_TO																											--발행대상
			 , B.MGMT_ENTRY_DESCRIPTION_1 AS ISSUE_TO_NM																							--발행대상명
			 , PEMP.USER_NM AS RCVP_NM																												--세금계산서 수신자명
			 , PEMP.MAIL_ID AS RCVP_EMAIL_NM																										--세금계산서 수신자 이메일명
			 , DBO.GET_DECRYPT(PEMP.MOBIL_NO) AS RCVP_HP_NO																							--세금계산서 수신자 핸드폰번호
			 , NULL AS CNSUL_DC																														--품의내역
			 , NULL AS MGMT_ENTRY_1																													--관리항목1(선택)
			 , NULL AS MGMT_ENTRY_2																													--관리항목2(선택)
			 , NULL AS MGMT_ENTRY_3																													--관리항목3(선택)
			 , NULL AS MGMT_ENTRY_4																													--관리항목3(선택)
			 , NULL AS MGMT_ENTRY_5																													--관리항목5(선택)
			 , NULL AS MGMT_ENTRY_6																													--관리항목6(선택)
		  FROM VIEW_SUM_DTL AS VSUM
		 INNER JOIN CD_PRODUCT_CMN AS CMN ON VSUM.SCAN_CODE = CMN.SCAN_CODE
		 INNER JOIN CD_MID_MST AS MID ON CMN.MID_CODE = MID.MID_CODE
		 INNER JOIN CD_LRG_MST AS LRG ON MID.LRG_CODE = LRG.LRG_CODE
		 INNER JOIN TBL_COMM_CD_MST AS B ON B.CD_CL = 'ISSUE_GB' AND B.CD_ID = VSUM.ISSUE_GB
		 INNER JOIN CD_PARTNER_MST AS PTN ON VSUM.VEN_CODE = PTN.VEN_CODE
		  LEFT OUTER JOIN TBL_DOUZONE_MGMT_ITEM AS DZ ON VSUM.SCAN_CODE = DZ.SCAN_CODE
		  LEFT OUTER JOIN TBL_COMM_CD_MST AS CD93 ON CD93.CD_CL = 'DOUZONE_D93' AND DZ.MGMT_ENTRY_1 = CD93.CD_ID
		  LEFT OUTER JOIN TBL_COMM_CD_MST AS CD95 ON CD95.CD_CL = 'DOUZONE_D95' AND DZ.MGMT_ENTRY_2 = CD95.CD_ID
		  LEFT OUTER JOIN CD_PARTNER_EMP AS PEMP ON VSUM.VEN_CODE = PEMP.VEN_CODE AND ASGNR = 'Y'
		  LEFT OUTER JOIN VIEW_TOTAL_SUM AS VSPRC ON VSUM.CLOSE_DT = VSPRC.ACTG_DT
		 ORDER BY VSUM.CLOSE_DT
		  

	EXEC UMAC_CERT_CLOSE_KEY -- CLOSE
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

