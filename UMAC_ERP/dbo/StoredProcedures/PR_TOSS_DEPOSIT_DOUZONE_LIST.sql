/*
-- 생성자 :	최수민
-- 등록일 :	2024.12.17
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 더존 토스정산 연동 프로시저 조회
-- 실행문 : EXEC PR_TOSS_DEPOSIT_DOUZONE_LIST '20241205'
			EXEC PR_TOSS_DEPOSIT_DOUZONE_LIST '20240813'
*/
CREATE PROCEDURE [dbo].[PR_TOSS_DEPOSIT_DOUZONE_LIST]
	@P_DEPOSIT_DT			NVARCHAR(8) = NULL			-- 입금일
AS 
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	BEGIN TRY 
	EXEC UMAC_CERT_OPEN_KEY;

		--토스 계좌번호, 예금주명, 토스 더존 거래처 코드, 토스 더존 거래처명 불러오기
		DECLARE @TOSS_PARTNER_CD		NVARCHAR(50) = '',
				@TOSS_PARTNER_NAME		NVARCHAR(50) = ''
				;
		SELECT @TOSS_PARTNER_CD = MGMT_ENTRY_2
			 , @TOSS_PARTNER_NAME = MGMT_ENTRY_DESCRIPTION_2
		  FROM TBL_COMM_CD_MST
		 WHERE CD_CL = 'GENERAL_ACC_NO_LIST'
		   AND MGMT_ENTRY_1 = 'TOSS';

		-- 입금일자 설정
		SET @P_DEPOSIT_DT = ISNULL(@P_DEPOSIT_DT, CONVERT(CHAR(8), GETDATE() -1, 112));

		WITH VIEW_TOSS AS (
			--가상계좌
			SELECT TOSS.PAIDOUTDATE
				 , TOSS.METHOD
				 , TOSS.ACQUIRERCODE AS ACCT_CODE
				 , COM.CD_NM AS ACCT_NAME
				 , ISS.VEN_CODE
				 , SUM(TOSS.AMOUNT) AS AMOUNT
			  FROM PA_TOSS_DEPOSIT AS TOSS
			 INNER JOIN PA_ACCT_ISSUE AS ISS ON TOSS.ORDERID = ISS.MOID
			 INNER JOIN TBL_COMM_CD_MST AS COM ON TOSS.ACQUIRERCODE = COM.CD_ID AND COM.CD_CL = 'TOSS_BANK'
			 WHERE TOSS.PAIDOUTDATE = @P_DEPOSIT_DT
			 GROUP BY TOSS.PAIDOUTDATE, TOSS.METHOD, TOSS.ACQUIRERCODE, COM.CD_NM, ISS.VEN_CODE

			UNION ALL

			--카드
			SELECT TOSS.PAIDOUTDATE
				 , TOSS.METHOD
				 , TOSS.ACQUIRERCODE AS ACCT_CODE
				 , COM.CD_NM AS ACCT_NAME
				 , ACCT.VEN_CODE
				 , SUM(TOSS.AMOUNT) AS AMOUNT
			  FROM PA_TOSS_DEPOSIT AS TOSS
			 INNER JOIN PA_ACCT_DEPOSIT AS ACCT ON TOSS.ORDERID = ACCT.MOID
			 INNER JOIN TBL_COMM_CD_MST AS COM ON TOSS.ACQUIRERCODE = COM.CD_ID AND COM.CD_CL = 'TOSS_CARD_XPAY'
			 WHERE TOSS.METHOD = '카드'
			   AND ACCT.DEPOSIT_DT = @P_DEPOSIT_DT
			 GROUP BY TOSS.PAIDOUTDATE, TOSS.METHOD, TOSS.ACQUIRERCODE, COM.CD_NM, ACCT.VEN_CODE
		)
		SELECT ROW_NUMBER() OVER (ORDER BY T.PAIDOUTDATE) AS DOUZONE_SEQ																				--더존 PRIMARY KEY
			 , T.VEN_CODE																																--거래처코드
			 , PTN.PARTNER_CD																															--더존 거래처코드
			 , PTN.VEN_NAME AS PARTNER_NM																												--거래처명
			 , 0.0 AS PICKING_QTY																														--총 검수수량
			 , T.AMOUNT AS PICKING_SAMT																													--입금금액
			 , 0.0 AS PICKING_SPRC																														--매출금액(입금금액 - 수수료)
			 , 0.0 AS PICKING_SVAT																														--수수료
			 , 0.0 AS TOTAL_PICKING_SPRC																												--매출금액 총 합
			 , 0.0 AS TOTAL_PICKING_SVAT																												--수수료 총 합
			 , CONVERT(CHAR(8), GETDATE(), 112) AS WRT_DT																								--작성일(더존으로 전표 넘기는 날)
			 , T.PAIDOUTDATE AS ACTG_DT																													--회계일(입금일)
			 , T.PAIDOUTDATE AS CLOSE_DT																												--마감일자
			 , SUBSTRING(T.PAIDOUTDATE, 5, 8) AS TAX_MD																									--회계일(MMDD)
			 , CONCAT(T.PAIDOUTDATE, ' 토스입금내역') AS CNSUL_DC																						--품의내역
			 , CONCAT(PTN.VEN_NAME, ' ', T.METHOD, ' 입금 (', T.PAIDOUTDATE, ')') AS NOTE_DC															--적요
			 , @TOSS_PARTNER_CD AS MGMT_ENTRY_1																											--토스 더존 거래처코드
			 , @TOSS_PARTNER_NAME AS MGMT_ENTRY_2																										--토스 더존 거래처코드명
			 , NULL AS SCAN_CODE																														--스캔코드
			 , NULL AS ITM_NAME																															--제품명
			 , NULL AS SIZE_NM																															--규격 (수량 C/N / 중량 KG)
			 , NULL AS LRG_CODE																															--대분류코드 (TOSS/일반 구분)
			 , NULL AS MID_CODE																															--중분류코드
			 , NULL AS BUSI_NO																															--사업자등록번호
			 , NULL AS VEN_GB																															--거래처구분
			 , NULL AS DIRECT_EXPORT_YN																													--직수출구분
			 , NULL AS RCVP_NM																															--세금계산서 수신자명
			 , NULL AS RCVP_EMAIL_NM																													--세금계산서 수신자 이메일명
			 , NULL AS RCVP_HP_NO																														--세금계산서 수신자 핸드폰번호
			 , NULL AS D93																																--저장품 구분 (DOUZONE_D93)
			 , NULL AS D93_NM																															--저장품 구분명
			 , NULL AS D95																																--원재료 구분 (DOUZONE_D95)
			 , NULL AS D95_NM																															--원재료 구분명
			 , NULL AS D96																																--제품매출 구분 (DOUZONE_D96)
			 , NULL AS D96_NM																															--제품매출 구분명
			 , NULL AS TAX_SALE																															--과세매입매출
			 , NULL AS TAX_SALE_NM																														--과세매입매출명
			 , NULL AS ISSUE_TO																															--발행대상
			 , NULL AS ISSUE_TO_NM																														--발행대상명
			 , NULL AS MGMT_ENTRY_3																														--관리항목3 (선택)
			 , NULL AS MGMT_ENTRY_4																														--관리항목4 (선택)
			 , NULL AS MGMT_ENTRY_5																														--관리항목5 (선택)
			 , NULL AS MGMT_ENTRY_6																														--관리항목6 (선택)
		  FROM VIEW_TOSS AS T
		 INNER JOIN CD_PARTNER_MST AS PTN ON T.VEN_CODE = PTN.VEN_CODE

		
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

