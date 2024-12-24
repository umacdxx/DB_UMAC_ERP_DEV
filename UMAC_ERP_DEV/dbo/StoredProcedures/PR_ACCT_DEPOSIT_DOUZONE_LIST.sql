/*
-- 생성자 :	최수민
-- 등록일 :	2024.12.17
-- 수정자 : -
-- 수정일 : - 
-- 설 명  : 더존 입금정산 연동 프로시저 조회 (토스, 일반계좌)
-- 실행문 : EXEC PR_ACCT_DEPOSIT_DOUZONE_LIST '20241205'
			EXEC PR_ACCT_DEPOSIT_DOUZONE_LIST '20241218'
*/
CREATE PROCEDURE [dbo].[PR_ACCT_DEPOSIT_DOUZONE_LIST]
	@P_DEPOSIT_DT			NVARCHAR(8)			-- 입금일
AS 
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	BEGIN TRY 
	EXEC UMAC_CERT_OPEN_KEY;

		--토스 계좌번호, 예금주명, 토스 더존 거래처 코드, 토스 더존 거래처명 불러오기
		DECLARE @TOSS_ACCT_NO			NVARCHAR(20) = '',
				@TOSS_ACCT_NAME			NVARCHAR(50) = '',
				@TOSS_PARTNER_CD		NVARCHAR(50) = '',
				@TOSS_PARTNER_NAME		NVARCHAR(50) = ''
				;
		SELECT @TOSS_ACCT_NO = CD_NM
			 , @TOSS_ACCT_NAME = CD_DESCRIPTION
			 , @TOSS_PARTNER_CD = MGMT_ENTRY_2
			 , @TOSS_PARTNER_NAME = MGMT_ENTRY_DESCRIPTION_2
		  FROM TBL_COMM_CD_MST
		 WHERE CD_CL = 'GENERAL_ACC_NO_LIST'
		   AND MGMT_ENTRY_1 = 'TOSS';


		WITH VIEW_DEPOSIT AS (
			-- 토스(가상계좌, 카드) 데이터 출력
			SELECT TOSS.PAIDOUTDATE
				 , 'TOSS' AS VEN_CODE
				 , @TOSS_PARTNER_NAME AS VEN_NAME
				 , @TOSS_PARTNER_CD AS PARTNER_CD
				 , @TOSS_ACCT_NO AS ACCT_NO
				 , @TOSS_ACCT_NAME AS ACCT_NAME
				 , @TOSS_PARTNER_CD AS TOSS_PARTNER_CD
				 , SUM(TOSS.AMOUNT) AS AMOUNT
				 , SUM(TOSS.FEE) AS FEE
				 , SUM(TOSS.PAYOUTAMOUNT) AS PAYOUTAMOUNT
			  FROM PA_TOSS_DEPOSIT AS TOSS
			 WHERE TOSS.PAIDOUTDATE = @P_DEPOSIT_DT
			 GROUP BY TOSS.PAIDOUTDATE

			UNION ALL

			-- 일반계좌 입금 데이터 출력
			SELECT DEPOSIT_DT AS PAIDOUTDATE
				 , ACCT.VEN_CODE
				 , PTN.VEN_NAME
				 , PTN.PARTNER_CD
				 , PTCL.CRYP_CMSV_ACCT_NO AS ACCT_NO
				 , COM.CD_DESCRIPTION AS ACCT_NAME
				 , COM.MGMT_ENTRY_2 AS TOSS_PARTNER_CD
				 , SUM(DEPOSIT_AMT) AS AMOUNT
				 , 0 AS FEE
				 , SUM(DEPOSIT_AMT) AS PAYOUTAMOUNT	
			  FROM PA_ACCT_DEPOSIT AS ACCT
			 INNER JOIN HCMS_ACCT_TRSC_PTCL AS PTCL ON ACCT.MOID = PTCL.MOID
												   AND PTCL.RCV_WDRW_DV_CD = '1'
												   AND PTCL.CRYP_CMSV_ACCT_NO IN (SELECT CD_NM FROM TBL_COMM_CD_MST WHERE CD_CL = 'GENERAL_ACC_NO_LIST')
			 INNER JOIN TBL_COMM_CD_MST AS COM ON CD_CL = 'GENERAL_ACC_NO_LIST' AND COM.CD_NM = PTCL.CRYP_CMSV_ACCT_NO
			 INNER JOIN CD_PARTNER_MST AS PTN ON ACCT.VEN_CODE = PTN.VEN_CODE
			 WHERE DEPOSIT_GB = '02' --일반계좌
			   AND DEPOSIT_DT = @P_DEPOSIT_DT
			 GROUP BY DEPOSIT_DT, ACCT.VEN_CODE, PTN.VEN_NAME, COM.CD_DESCRIPTION, PTCL.CRYP_CMSV_ACCT_NO, PTN.PARTNER_CD, COM.MGMT_ENTRY_2
		)
		SELECT ROW_NUMBER() OVER (ORDER BY T.PAIDOUTDATE) AS DOUZONE_SEQ																				--더존 PRIMARY KEY
			 , T.VEN_CODE																																--거래처코드
			 , T.PARTNER_CD																																--더존 거래처코드
			 , T.VEN_NAME AS PARTNER_NM																													--거래처명
			 , 0.0 AS PICKING_QTY																														--총 검수수량
			 , T.AMOUNT AS PICKING_SAMT																													--입금금액
			 , T.PAYOUTAMOUNT AS PICKING_SPRC																											--매출금액(입금금액 - 수수료)
			 , T.FEE AS PICKING_SVAT																													--수수료
			 , T.PAYOUTAMOUNT AS TOTAL_PICKING_SPRC																										--매출금액 총 합
			 , T.FEE AS TOTAL_PICKING_SVAT																												--수수료 총 합
			 , CONVERT(CHAR(8), GETDATE(), 112) AS WRT_DT																								--작성일(더존으로 전표 넘기는 날)
			 , T.PAIDOUTDATE AS ACTG_DT																													--회계일(입금일)
			 , T.PAIDOUTDATE AS CLOSE_DT																												--마감일자
			 , SUBSTRING(T.PAIDOUTDATE, 5, 8) AS TAX_MD																									--회계일(MMDD)
			 , CONCAT(T.PAIDOUTDATE, ' 외상대 입금') AS CNSUL_DC																						--품의내역
			 , CONCAT(T.VEN_NAME, ' 입금 (', T.PAIDOUTDATE, ')') AS NOTE_DC																				--적요
			 , T.ACCT_NO AS MGMT_ENTRY_1																												--입금 계좌번호
			 , T.ACCT_NAME AS MGMT_ENTRY_2																												--계좌 수신명
			 , T.TOSS_PARTNER_CD AS MGMT_ENTRY_3																										--토스 더존 거래처코드
			 , CONCAT(ISNULL(T.VEN_NAME, ''), ' 수수료 (', T.PAIDOUTDATE, ')') AS MGMT_ENTRY_4															--적요 (토스-수수료)
			 , CONCAT(ISNULL(T.ACCT_NAME, ''), ' 외상대 결제') AS MGMT_ENTRY_5																			--적요 (토스-미수금)
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
			 , NULL AS MGMT_ENTRY_6																														--관리항목6 (선택)
		  FROM VIEW_DEPOSIT AS T

		
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

