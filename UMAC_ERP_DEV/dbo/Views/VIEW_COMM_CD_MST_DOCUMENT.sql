


/*
-- 생성자 :	이동호
-- 등록일 :	2024.04.17
-- 설 명  : 주문 첨부서류 공통테이블 정보 출력
-- 수정자 :
-- 수정일 :
-- 설 명  :	
-- 실행문 : 
*/
CREATE VIEW [dbo].[VIEW_COMM_CD_MST_DOCUMENT] AS

	SELECT CD_ID1, CD_NM1, CD_ID2, CD_NM2, CD_ID3, CD_NM3, CD_ID4, CD_NM4 FROM (
		SELECT 
			'1' AS CD_ID1, (SELECT CD_NM FROM TBL_COMM_CD_MST WHERE CD_CL = 'DOCUMENT_REQ' AND CD_ID = '1') AS CD_NM1,
			'2' AS CD_ID2, (SELECT CD_NM FROM TBL_COMM_CD_MST WHERE CD_CL = 'DOCUMENT_REQ' AND CD_ID = '2') AS CD_NM2,
			'3' AS CD_ID3, (SELECT CD_NM FROM TBL_COMM_CD_MST WHERE CD_CL = 'DOCUMENT_REQ' AND CD_ID = '3') AS CD_NM3,
			'4' AS CD_ID4, (SELECT CD_NM FROM TBL_COMM_CD_MST WHERE CD_CL = 'DOCUMENT_REQ' AND CD_ID = '4') AS CD_NM4
	) AS TBL

GO

