/*
-- 생성자 :	강세미
-- 등록일 :	2024.06.17
-- 수정자 : 2024.12.06 강세미- 거래구분 컬럼 조회 추가
-- 설 명  : 매출입내역수정 > 매출입내역 조회
-- 실행문 : EXEC PR_SALES_LIST '','20240125','20240725','','',''
*/
CREATE PROCEDURE [dbo].[PR_SALES_LIST]
	@P_VEN_CODE			VARCHAR(7),				-- 거래처코드
	@P_FROM_SALE_DT		VARCHAR(8),				-- 조회시작일자
	@P_TO_SALE_DT		VARCHAR(8),				-- 조회종료일자
	@P_IO_GB			VARCHAR(1),				-- 입출고구분
	@P_SALE_CFM_YN		VARCHAR(1),				-- 매출입확정여부
	@P_ORD_NO			VARCHAR(11),			-- 주문번호
	@P_MGNT_USER_ID		NVARCHAR(20) = ''		-- 담당자아이디
AS 
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	BEGIN TRY 
		
		WITH TEMP AS (
			SELECT 
				A.DT,
				A.CFM_DT,
				A.ORD_NO,
				A.VEN_CODE,
				COUNT(1) AS ITM_QTY,
				SUM(ISNULL(A.TOTAL_AMT, 0)) AS TOTAL_AMT,
				A.IO_STAT,
				B.VEN_NAME,
				B.VEN_GB,
				CASE 
					WHEN A.TABLE_TYPE = 'SALE' THEN 
						CASE WHEN C.DEPOSIT_AMT > 0 THEN 'N' ELSE 'Y' END
					ELSE 'Y'
				END AS CANCEL_AVL_YN
			FROM (
				SELECT AA.SALE_DT AS DT, AA.SALE_CFM_DT AS CFM_DT, AA.ORD_NO, AA.VEN_CODE, ISNULL(AA.SALE_TOTAL_AMT, 0) AS TOTAL_AMT, 'SALE' AS TABLE_TYPE, BB.ORD_STAT AS IO_STAT
				FROM SL_SALE AS AA
					INNER JOIN PO_ORDER_HDR AS BB ON AA.ORD_NO = BB.ORD_NO
				UNION ALL
				SELECT AA.PUR_DT AS DT, AA.PUR_CFM_DT AS CFM_DT, AA.ORD_NO, AA.VEN_CODE, ISNULL(AA.PUR_TOTAL_AMT, 0) AS TOTAL_AMT, 'PUR' AS TABLE_TYPE, BB.PUR_STAT AS IO_STAT
				FROM PUR_INFO AS AA
					INNER JOIN PO_PURCHASE_HDR AS BB ON AA.ORD_NO = BB.ORD_NO
			) AS A
			INNER JOIN CD_PARTNER_MST AS B ON A.VEN_CODE = B.VEN_CODE
			LEFT OUTER JOIN (
				SELECT ORD_NO, SUM(DEPOSIT_AMT) AS DEPOSIT_AMT
				FROM PA_ACCT_DEPOSIT_ORD
				GROUP BY ORD_NO
			) AS C ON A.ORD_NO = C.ORD_NO
			WHERE 
				A.DT BETWEEN @P_FROM_SALE_DT AND @P_TO_SALE_DT
				AND (@P_VEN_CODE = '' OR A.VEN_CODE = @P_VEN_CODE)
				AND (@P_IO_GB = '' OR @P_IO_GB = LEFT(A.ORD_NO, 1))
				AND (@P_SALE_CFM_YN = '' 
					OR (@P_SALE_CFM_YN = 'Y' AND ISNULL(CFM_DT, '') <> '') 
					OR (@P_SALE_CFM_YN = 'N' AND ISNULL(CFM_DT, '') = '')
				)
				AND (@P_ORD_NO = '' OR A.ORD_NO = @P_ORD_NO)
				AND 1 = (CASE WHEN @P_MGNT_USER_ID = '' THEN 1 WHEN @P_MGNT_USER_ID = 'ETC' AND (B.MGNT_USER_ID IS NULL OR B.MGNT_USER_ID = '') THEN 1 WHEN @P_MGNT_USER_ID <> '' AND B.MGNT_USER_ID = @P_MGNT_USER_ID THEN 1 ELSE 0 END)
			GROUP BY A.DT, A.CFM_DT, A.VEN_CODE, A.ORD_NO, A.IO_STAT, B.VEN_NAME, B.VEN_GB, C.DEPOSIT_AMT, A.TABLE_TYPE
		)
		SELECT 
			DT,
			CFM_DT,
			ORD_NO,
			VEN_CODE,
			VEN_GB,
			ITM_QTY,
			TOTAL_AMT,
			IO_STAT,
			VEN_NAME,
			CANCEL_AVL_YN
		FROM TEMP
		ORDER BY DT DESC, ORD_NO DESC
		;

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
