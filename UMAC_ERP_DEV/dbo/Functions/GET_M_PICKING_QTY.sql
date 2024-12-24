



/*
-- 생성자 :	이동호
-- 등록일 :	2024.10.11
-- 수정자 : -
-- 수정일 : - 
-- 설 명	: 피킹처리 할때 본품,샘플 구분 피킹 수량 RETURN
-- 실행문 : 
	

*/
CREATE FUNCTION [dbo].[GET_M_PICKING_QTY](
	@P_ORD_QTY				NUMERIC(15,2) = 0,
	@P_ORD_QTY_SAMPLE		NUMERIC(15,2) = 0,
	@P_PICKING_QTY			NUMERIC(15,2) = 0,	
	@P_ORD_GB				NVARCHAR(15) = ''
)
RETURNS VARCHAR(30)
AS
BEGIN

	DECLARE @C_PICKING_QTY NUMERIC(15,2) = 0
	DECLARE @C_PICKING_QTY_SAMPLE NUMERIC(15,2) = 0
	DECLARE @RET_PICKING_QTY NUMERIC(15,2) = 0
	
	-- 하나의 제품에 샘플이 포함 되었는지 판단
	IF @P_ORD_QTY > 0 AND @P_ORD_QTY_SAMPLE > 0
	BEGIN

		--본품 수량 과 샘플 수량의 합이 피킹 수량 보다 큰 경우
		IF (@P_ORD_QTY + @P_ORD_QTY_SAMPLE) > @P_PICKING_QTY
		BEGIN

			--본품 수량이 피킹 수량 보다 작을 경우
			IF @P_ORD_QTY > @P_PICKING_QTY 
			BEGIN							
				--샘플 피킹 수량은 : 0
				SET @C_PICKING_QTY_SAMPLE = 0							
			END
			ELSE
			BEGIN
				--샘플 피킹 수량 : 피킹 수량 - 주문 수량
				SET @C_PICKING_QTY_SAMPLE = @P_PICKING_QTY - @P_ORD_QTY
				--본품 피킹 수량 : 주문 수량
				SET @C_PICKING_QTY = @P_ORD_QTY													
			END
						
		END
		ELSE 
		BEGIN
			--샘플 피킹수량
			SET @C_PICKING_QTY_SAMPLE = @P_ORD_QTY_SAMPLE
			--본품 피킹수량
			SET @C_PICKING_QTY = @P_ORD_QTY		

		END

	END
	-- 샘플 제품일 경우
	ELSE IF @P_ORD_QTY = 0 AND @P_ORD_QTY_SAMPLE > 0
	BEGIN					
		SET @C_PICKING_QTY_SAMPLE = @P_PICKING_QTY
	END
	



	IF @P_ORD_GB = 'SAMPLE'		
		SET @RET_PICKING_QTY = @C_PICKING_QTY_SAMPLE
	ELSE
		SET @RET_PICKING_QTY = @C_PICKING_QTY


	RETURN @RET_PICKING_QTY
END

GO

