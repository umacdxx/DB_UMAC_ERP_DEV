
CREATE VIEW [dbo].[VIEW_ORDER_DTL_SAMPLE_SUM] AS
						SELECT A.ORD_NO
						     , MAX(A.SEQ) AS SEQ
							 , A.SCAN_CODE
							 , SUM(A.ORD_QTY) AS ORD_QTY
							 , SUM(A.ORD_SAMT) AS ORD_SAMT
							 , SUM(A.ORD_SPRC) AS ORD_SPRC
							 , SUM(A.ORD_SVAT) AS ORD_SVAT
							 , SUM(A.PICKING_QTY) AS PICKING_QTY
							 , SUM(A.PICKING_SAMT) AS PICKING_SAMT
							 , SUM(A.PICKING_SPRC) AS PICKING_SPRC
							 , SUM(A.PICKING_SVAT) AS PICKING_SVAT
						FROM (
							SELECT A.ORD_NO
							     , A.SEQ
								 , A.SCAN_CODE
								 , A.ORD_QTY
								 , A.ORD_SAMT
								 , A.ORD_SPRC
								 , A.ORD_SVAT
								 , A.PICKING_QTY
								 , A.PICKING_SAMT
								 , A.PICKING_SPRC
								 , A.PICKING_SVAT
								FROM PO_ORDER_DTL AS A WITH (NOLOCK)
							UNION ALL
							SELECT B.ORD_NO
							     , 0 AS SEQ
								 , B.SCAN_CODE
								 , B.ORD_QTY
								 , 0 AS ORD_SAMT
								 , 0 AS ORD_SPRC
								 , 0 AS ORD_SVAT
								 , B.PICKING_QTY
								 , 0 AS PICKING_SAMT
								 , 0 AS PICKING_SPRC
								 , 0 AS PICKING_SVAT
								FROM PO_ORDER_SAMPLE AS B WITH (NOLOCK)
						) AS A
						GROUP BY A.ORD_NO, A.SCAN_CODE

GO

