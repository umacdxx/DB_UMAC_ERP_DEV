/*
-- 생성자 :	강세미
-- 등록일 :	2024.05.28
-- 수정자 : 2024.12.04 강세미 - B/L 신규 컬럼 추가
-- 수정일 : - 
-- 설 명  : 수입발주관리 리스트 조회
-- 실행문 : 
EXEC PR_IM_ORDER_MANAGE_LIST '', '', '','','',''
*/
CREATE PROCEDURE [dbo].[PR_IM_ORDER_MANAGE_LIST]
( 
	@P_PO_NO		NVARCHAR(15) = '',		-- PO번호
	@P_VEN_CODE		NVARCHAR(7) = '',		-- 발주월
	@P_START_DT		NVARCHAR(8) = '',		-- 조회시작일자
	@P_END_DT		NVARCHAR(8) = '',		-- 조회종료일자
	@P_SLIP_TYPE	NVARCHAR(20) = '',		-- 전표상태구분
	@P_SLIP_YN		NVARCHAR(1) = ''		-- 전표상태값
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
 
	BEGIN TRY 
		SELECT A.PO_NO,
               A.PO_NAME,
               A.PO_ORD_DT,
               A.LC_NO,
               A.LC_CLOSE_DT,
               A.BL_NO,
               A.BL_NO_2,
               A.BL_NO_3,
               A.BL_DT,
               A.BL_DT_2,
               A.BL_DT_3,
               A.CURRENCY_TYPE,
               ISNULL(A.TT_EXCHANGE_RATE,0) AS TT_EXCHANGE_RATE,
			   ISNULL(A.TT_EXCHANGE_RATE,0) AS LC_EXCHANGE_RATE,
               A.CUSTOMS_CL_DT,
               (SELECT ISNULL(SUM(FRGN_WPRC_AMT), 0)
				FROM IM_ORDER_DTL
				WHERE PO_NO = A.PO_NO) AS FRGN_WPRC_AMT_SUM,
               (SELECT ISNULL(SUM(WPRC_AMT), 0)
                FROM IM_ORDER_DTL
                WHERE PO_NO = A.PO_NO) AS WPRC_AMT_SUM,
               B.VEN_NAME,
               (CASE WHEN E.ALTRN_SLIP = 'Y' THEN '생성' ELSE '미생성' END) AS ALTRN_SLIP,
               (CASE WHEN E.COST_CFM = 'Y' THEN '확정' ELSE '미확정' END) AS COST_CFM,
               (CASE WHEN A.NOT_DELIVERED_SLIP = 'Y' THEN '생성' ELSE '미생성' END) AS NOT_DELIVERED_SLIP,
               (CASE WHEN A.PUR_SLIP = 'Y' THEN '생성' ELSE '미생성' END) AS PUR_SLIP,
               D.FILE_CNT,
               C.SKU
            FROM IM_ORDER_HDR A
				INNER JOIN CD_PARTNER_MST B ON A.VEN_CODE = B.VEN_CODE
				INNER JOIN (SELECT COUNT(1) AS SKU, PO_NO
							FROM IM_ORDER_DTL A
							WHERE PO_NO = A.PO_NO GROUP BY PO_NO ) AS C ON C.PO_NO = A.PO_NO
				LEFT OUTER JOIN (SELECT COUNT(1) AS FILE_CNT, PO_NO
							FROM IM_ORDER_UPLOAD A
							WHERE PO_NO = A.PO_NO GROUP BY PO_NO ) AS D ON D.PO_NO = A.PO_NO
				LEFT OUTER JOIN IM_COST_HDR E ON A.PO_NO = E.PO_NO
            WHERE 1 = (CASE WHEN @P_PO_NO = '' THEN 1 WHEN @P_PO_NO <> '' AND A.PO_NO = @P_PO_NO THEN 1 ELSE 0 END)
				AND 1 = (CASE WHEN @P_VEN_CODE = '' THEN 1 WHEN @P_VEN_CODE <> '' AND A.VEN_CODE = @P_VEN_CODE THEN 1 ELSE 0 END)
				AND 1 = (CASE WHEN @P_START_DT = ''  OR @P_END_DT = '' THEN 1 
							  WHEN A.PO_ORD_DT BETWEEN @P_START_DT AND @P_END_DT THEN 1 ELSE 0 END)
				AND 1 = (CASE WHEN @P_SLIP_TYPE = '' THEN 1
							  WHEN @P_SLIP_TYPE = 'PUR_SLIP' AND A.PUR_SLIP = @P_SLIP_YN THEN 1
							  WHEN @P_SLIP_TYPE = 'ALTRN_SLIP' AND E.ALTRN_SLIP = @P_SLIP_YN THEN 1 
							  WHEN @P_SLIP_TYPE = 'NOT_DELIVERED_SLIP' AND A.NOT_DELIVERED_SLIP = @P_SLIP_YN THEN 1
							  WHEN @P_SLIP_TYPE = 'COST_CFM' AND E.COST_CFM = @P_SLIP_YN THEN 1 ELSE 0 END)
            ORDER BY A.PO_NO

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

