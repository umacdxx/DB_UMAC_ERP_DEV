


/*
-- 생성자 :	이동호
-- 등록일 :	2024.06.07
-- 수정자 : -
-- 수정일 : - 
-- 설 명	: 토스 결제 처리상태
-- 실행문 : 
*/
CREATE FUNCTION [dbo].[GET_TOSS_STAT](
	@P_STAT NVARCHAR(30)	
)
RETURNS NVARCHAR(30)
AS
BEGIN
	
	DECLARE @RETMSG AS VARCHAR(30);
	

    --/// 토스 : 결제 처리상태(가상계좌, 신용카드)
    --/// 결제 처리 상태입니다.
    --/// READY: 결제를 생성하면 가지게 되는 초기 상태입니다.인증 전까지는 READY 상태를 유지합니다.
    --/// IN_PROGRESS: 결제수단 정보와 해당 결제수단의 소유자가 맞는지 인증을 마친 상태입니다.결제 승인 API를 호출하면 결제가 완료됩니다.
    --/// WAITING_FOR_DEPOSIT: 가상계좌 결제 흐름에만 있는 상태로, 결제 고객이 발급된 가상계좌에 입금하는 것을 기다리고 있는 상태입니다.
    --/// DONE: 인증된 결제수단 정보, 고객 정보로 요청한 결제가 승인된 상태입니다.
    --/// CANCELED: 승인된 결제가 취소된 상태입니다.
    --/// PARTIAL_CANCELED: 승인된 결제가 부분 취소된 상태입니다.
    --/// ABORTED: 결제 승인에 실패한 상태입니다.
    --/// EXPIRED: 요청된 결제의 유효 시간 30분이 지나 거래가 취소된 상태입니다.IN_PROGRESS 상태에서 결제 승인 API를 호출하지 않으면 EXPIRED가 됩니다.

	--/// 가상계좌는 WAITING_FOR_DEPOSIT  상태 이후 부터 진행

	SET @RETMSG = CASE @P_STAT 
						WHEN 'READY' THEN ''
						WHEN 'IN_PROGRESS' THEN ''
						WHEN 'WAITING_FOR_DEPOSIT' THEN '입금대기'
						WHEN 'DONE' THEN '입금완료'
						WHEN 'CANCELED' THEN '입금취소'
						WHEN 'PARTIAL_CANCELED' THEN '부분취소'
						WHEN 'ABORTED' THEN '승인실패'
						WHEN 'EXPIRED' THEN '거래취소'
						ELSE ''
					END
	
	RETURN @RETMSG
END

GO

