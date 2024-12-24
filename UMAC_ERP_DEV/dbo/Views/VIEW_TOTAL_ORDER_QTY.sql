

/*
-- 생성자 :	최수민
-- 등록일 :	2024.07.08
-- 설 명  : 상품별 총 주문 수량
			박스의 경우 단품의 재고로 환산
-- 수정자 :
-- 수정일 :
-- 수정내용 :

*/
CREATE VIEW [dbo].[VIEW_TOTAL_ORDER_QTY]
AS
	SELECT 
		ISNULL(BOX.ITM_CODE, CMN.ITM_CODE) AS ITM_CODE,
		SUM(IIF(CMN.ITM_FORM = '2', ODT.ORD_QTY * ISNULL(BOX.IPSU_QTY, 0), ODT.ORD_QTY)) AS TOTAL_ORD_QTY
	FROM 
		dbo.PO_ORDER_HDR AS ODH
		INNER JOIN dbo.PO_ORDER_DTL AS ODT ON ODH.ORD_NO = ODT.ORD_NO 
		INNER JOIN dbo.CD_PRODUCT_CMN AS CMN ON ODT.SCAN_CODE = CMN.SCAN_CODE 
		LEFT OUTER JOIN dbo.CD_BOX_MST AS BOX ON CMN.ITM_CODE = IIF(CMN.ITM_FORM = '2', BOX.BOX_CODE, BOX.ITM_CODE)
	WHERE 
		ODH.ORD_STAT IN (SELECT CD_ID FROM dbo.TBL_COMM_CD_MST WHERE CD_CL = 'AVL_INV_STAT')
	GROUP BY 
		ISNULL(BOX.ITM_CODE, CMN.ITM_CODE);

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "BOX"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CMN"
            Begin Extent = 
               Top = 6
               Left = 227
               Bottom = 136
               Right = 418
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ODT"
            Begin Extent = 
               Top = 6
               Left = 456
               Bottom = 136
               Right = 642
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ODH"
            Begin Extent = 
               Top = 6
               Left = 680
               Bottom = 136
               Right = 893
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VIEW_TOTAL_ORDER_QTY';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VIEW_TOTAL_ORDER_QTY';


GO

