
/*
-- 생성자 :	이동호
-- 등록일 :	2024.07.12
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 안심키 카드결제 리스트 출력
-- 실행문 : EXEC PR_TOSSPAY_XPAY_LIST

*/
CREATE PROCEDURE [dbo].[PR_TOSSPAY_XPAY_LIST]

AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	 
	BEGIN TRY 
	
		SELECT 
			T.*,
			TCD.CD_NM AS ISSUER_CODE_NM
		FROM (
			SELECT  
				XPAY.MID,				--상점아이디			
				XPAY.PAYTYPE,			--결제수단코드 : SC0010 :카드, SC0030:계좌이체, SC0040:무통장입금
				(CASE WHEN XPAY.PAYTYPE = 'SC0010' THEN '카드' ELSE '' END) AS PAYTYPENAME,
				XPAY.[TRANSACTION],												--거래번호
				XPAY.OID,														--주문번호
				XPAY.FINANCECODE AS ISSUER_CODE,								--토스 카드사 코드
				XPAY.FINANCECODE,												--결제기관코드								
				XPAY.FINANCENAME,												--결제기관코드명
				XPAY.BUYERID,													--구매자 아이디
				XPAY.AMOUNT,													--거래금액
				XPAY.USEESCROW,													--최종 에스크로 적용 여부 : Y/N												
				CONVERT(CHAR(10), CONVERT(DATE, XPAY.PAYDATE), 23) AS PAYDATE,	--결제일시
				XPAY.AUTHNMUNBER,												--승인번호
				XPAY.[STATUS],													--10: 거래 성공, 11: 거래 실패, 20: 취소/환불성공, 21: 취소/환불실패
				USE_YN															--입금처리 사용여부 Y,N
			FROM TBL_TOSSPAY_XPAY AS XPAY LEFT OUTER JOIN (
				SELECT OID FROM TBL_TOSSPAY_XPAY WHERE [STATUS] IN('20', '21') GROUP BY OID, [STATUS] 
			) AS OPAY ON XPAY.OID = OPAY.OID		
			WHERE OPAY.OID IS NULL AND XPAY.USE_YN = 'N'
		) AS T
			LEFT OUTER JOIN TBL_COMM_CD_MST AS TCD ON TCD.CD_CL = 'TOSS_CARD_XPAY' AND TCD.CD_ID = T.ISSUER_CODE

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

