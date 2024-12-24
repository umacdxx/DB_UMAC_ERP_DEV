
/*
-- 생성자 :	강세미
-- 등록일 :	2024.11.26
-- 수정자 : -
-- 수정일 : - 
-- 설 명	: 마스터 운송비 조회
-- 실행문 : dbo.GET_DELIVERY_PRICE('RENT_COST',1,'1')
			dbo.GET_DELIVERY_PRICE('TRANS_COST',1,'2')
*/
CREATE FUNCTION [dbo].[GET_DELIVERY_PRICE](
	@P_COST_TYPE VARCHAR(10),
	@P_DELIVERY_PRICE_SEQ INT = 0,
	@P_CAR_GB NVARCHAR(1) = 0
)
RETURNS INT
AS
BEGIN
	DECLARE @PRICE			INT = 0
	
	SELECT @PRICE = CASE 
                    WHEN @P_COST_TYPE = 'RENT_COST' THEN 
                       CASE @P_CAR_GB
                           WHEN '1' THEN RENT_COST_1
                           WHEN '2' THEN RENT_COST_2
                           WHEN '3' THEN RENT_COST_3
                           WHEN '4' THEN RENT_COST_4
                           WHEN '5' THEN RENT_COST_5
                       END
                    WHEN @P_COST_TYPE = 'TRANS_COST' THEN 
                       CASE @P_CAR_GB
                           WHEN '1' THEN TRANS_COST_1
                           WHEN '2' THEN TRANS_COST_2
                           WHEN '3' THEN TRANS_COST_3
                           WHEN '4' THEN TRANS_COST_4
                           WHEN '5' THEN TRANS_COST_5
                       END
                   ELSE 0
               END
	FROM CD_DELIVERY_PRICE
	WHERE SEQ = @P_DELIVERY_PRICE_SEQ;

RETURN ISNULL(@PRICE, 0)
END

GO

