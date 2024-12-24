


/*
-- 생성자 :	이동호
-- 등록일 :	2024.06.07
-- 수정자 : -
-- 수정일 : - 
-- 설 명	: 토스 결제수단 공통코드 값으로 변환
-- 실행문 : 
*/
CREATE FUNCTION [dbo].[GET_TOSS_DEPOSIT_GB](
	@P_METHOD NVARCHAR(30)	
)
RETURNS NVARCHAR(30)
AS
BEGIN
	
	DECLARE @RETMSG AS VARCHAR(30);
	
	--SELECT * FROM TBL_COMM_CD_MST WHERE CD_CL='DEPOSIT_GB'

	SET @RETMSG = CASE @P_METHOD 
						WHEN '카드' THEN '03'
						WHEN '가상계좌' THEN '01'
						ELSE ''
					END	
	RETURN @RETMSG
END

GO

