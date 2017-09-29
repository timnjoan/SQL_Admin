SELECT
  migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) AS improvement_measure,
  'CREATE INDEX [missing_index_' + CONVERT (varchar, mig.index_group_handle) + '_' + CONVERT (varchar, mid.index_handle)
  + '_' + LEFT (PARSENAME(mid.statement, 1), 32) + ']'
  + ' ON ' + mid.statement
  + ' (' + ISNULL (mid.equality_columns,'')
    + CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN ',' ELSE '' END
    + ISNULL (mid.inequality_columns, '')
  + ')'
  + ISNULL (' INCLUDE (' + mid.included_columns + ')', '') AS create_index_statement,
  migs.*, mid.database_id, mid.[object_id]
FROM sys.dm_db_missing_index_groups mig
INNER JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
WHERE migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) > 10
ORDER BY migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) DESC

/*
DynastyAPP
CREATE INDEX [missing_index_51_50_BuyOrderTicket] ON [EIBoxOffice].[dbo].[BuyOrderTicket] ([BuyOrderTicketGroupID]) INCLUDE ([BuyOrderTicketID], [Seat], [OriginalBarcode], [FaceValue], [EIBOBuyOrderTicketID])
CREATE INDEX [missing_index_44_43_SellOrder] ON [EIBoxOffice].[dbo].[SellOrder] ([SellOrderStatusTypeID], [AssignedUserID], [WorkStatusTypeID]) INCLUDE ([CreatedDateTime])
CREATE INDEX [missing_index_21_20_Fulfillment] ON [Intranet].[dbo].[Fulfillment] ([UpdateSequence]) INCLUDE ([FulfillmentID])
CREATE INDEX [missing_index_15_14_SellOrder] ON [EIBoxOffice].[dbo].[SellOrder] ([ClientID], [ExternalReferenceNumber])
CREATE INDEX [missing_index_13_12_Production] ON [EIBoxOffice].[dbo].[Production] ([Redirect],[ProductionID], [StatusID]) INCLUDE ([PrimaryEventID], [SecondaryEventID], [VenueID], [EventDate], [EventTime], [IsTBA], [ReqEvent], [ReqVenue], [ReqTime])
CREATE INDEX [missing_index_23_22_TicketGroup] ON [EIBoxOffice].[dbo].[TicketGroup] ([TicketStatusTypeID], [IsConsignment]) INCLUDE ([TicketGroupID], [ShareTypeID], [PrimaryEventID], [VenueID], [TicketWarehouseID], [SubCompanyID], [EventDate], [EventTime], [SeatSection], [SeatRow], [StartingSeat], [EndingSeat], [IsConsecutiveSeating], [Quantity], [IsInHand], [ConsignmentClientID], [AllowSplit], [MaskRow], [MaskSeat], [IsActualTicketCost], [AverageTicketCost], [AverageTicketFace], [AverageTicketPrice], [DeliveryDate], [Description], [HoldSellOrderTicketGroupID], [SourceTicketGroupID], [TicketGroupGUID], [IsTBA], [SortPriority], [CreatedDateTime], [CreatedUserID], [UpdatedDateTime], [UpdatedUserID], [SecondaryEventID], [InternalNote], [OwnerClientID], [IsOutOnConsignment], [ConsignmentOutgoingID], [AverageTaxCreditAmount], [TaxCreditFace], [TaxCreditRate], [ExportCompNumber], [TicketLocationID], [SourceID], [InventoryTypeID], [ProductionID], [InHandDate], [TStoreTicketGroupID], [IsPDFAvailable], [NearTermOptionID], [StandardizedNoteID], [IsInstantDelivery], [ProductionShortNote], [ProductionLongNote], [EIBOTicketGroupID])
CREATE INDEX [missing_index_40_39_TicketStore] ON [Intranet].[dbo].[TicketStore] ([ExpireDate])
CREATE INDEX [missing_index_6553_6552_SoldView] ON [DynastyApp].[dbo].[SoldView] ([ProductionID]) INCLUDE ([InvoiceDate], [Qty], [Dollars], [Profit])
CREATE INDEX [missing_index_82_81_WebOrderLink] ON [EIBoxOffice].[dbo].[WebOrderLink] ([WebOrderID])
CREATE INDEX [missing_index_47_46_TicketGroupIdentity] ON [EIBoxOffice].[dbo].[TicketGroupIdentity] ([TicketGroupIdentityTypeID]) INCLUDE ([TicketGroupIdentityID])
CREATE INDEX [missing_index_4917_4916_TicketGroup] ON [EIBoxOffice].[dbo].[TicketGroup] ([TicketStatusTypeID]) INCLUDE ([TicketGroupID], [PrimaryEventID], [VenueID], [EventDate], [EventTime], [SeatSection], [SeatRow], [IsTBA], [SecondaryEventID])
CREATE INDEX [missing_index_6078_6077_POBulkImport] ON [DynastyApp].[dbo].[POBulkImport] ([BulkImport_BatchID]) INCLUDE ([PO_ID], [PDFElectronicDelivery], [Consecutive], [SH], [TL], [RG], [EB], [MISC], [TS], [ExportCompTotal], [Shared], [MaskSeats], [MaskRow], [AllowSplit], [ProductionID], [Event], [PrimaryEventID], [Opponent], [SecondaryEventID], [Venue], [VenueID], [SubClient], [EventDate], [EventTime], [IsTBA], [IsInHand], [InHandDate], [Quantity], [Section], [Row], [Start], [End], [Cost_total], [List_ea], [InternalNote], [ExternalNote], [StandardNote], [StandardNoteID], [LastUpdateTime], [LastUpdateUserID], [POInternalNote], [POExternalNote], [Error], [ErrorCount], [ErrorMessage], [ErrorColumns], [NewTicketGroupID], [isConsignment], [isInstantDelivery], [NewBOTicketGroupID], [BuyOrderTicketGroupGUID], [BuyOrderID], [Cost_ea], [Cost_ea_comp], [RowNum], [ConsignmentTicketGroupGUID])
CREATE INDEX [missing_index_84_83_WebOrderLink] ON [EIBoxOffice].[dbo].[WebOrderLink] ([WebOrderID])
CREATE INDEX [missing_index_5661_5660_TicketGroupHistory] ON [DynastyApp].[Audit].[TicketGroupHistory] ([PriceDelta]) INCLUDE ([DynastyUserId], [TimeStamp], [UpdateTypeId])
CREATE INDEX [missing_index_6415_6414_SoldView] ON [UAT_DynastyApp].[dbo].[SoldView] ([ProductionID]) INCLUDE ([Status], [Description], [TicketGroupID], [SecTicketGroupID], [InvoiceDate], [Home], [HomeID], [Away], [AwayID], [EventDate], [EventTime], [Venue], [Section], [Row], [BegSeat], [EndSeat], [Qty], [Cost], [Revenue], [TransactionFee], [Dollars], [Profit], [percentage], [DaysOut], [DaysOutCategory], [Vendor], [Customer], [Channel], [Category], [TGStatus], [SOStatus], [InternalNote], [Invoice], [SellOrderID], [PO], [PODate], [Parent], [Child], [Grandchild], [VenueID], [VendorID], [CustomerID], [CustomerCompanyName], [CustomerLastName], [CustomerFirstName], [AverageTicketPrice], [ListPrice], [Fee], [ConsignmentRole], [FaceValue])
CREATE INDEX [missing_index_6544_6543_SoldView] ON [UAT_DynastyApp].[dbo].[SoldView] ([ProductionID]) INCLUDE ([InvoiceDate], [Qty], [Dollars], [Profit])
CREATE INDEX [missing_index_6546_6545_TicketGroupHistory] ON [UAT_DynastyApp].[Audit].[TicketGroupHistory] ([ProductionId]) INCLUDE ([Id], [DynastyUserId], [TimeStamp], [PriceDelta], [UpdateTypeId])
CREATE INDEX [missing_index_6548_6547_TicketGroupHistory] ON [UAT_DynastyApp].[Audit].[TicketGroupHistory] ([PriceDelta]) INCLUDE ([Id], [ProductionId], [DynastyUserId], [TimeStamp], [UpdateTypeId])

DynastyappStubhub
CREATE INDEX [missing_index_51_50_BuyOrderTicket] ON [EIBoxOffice].[dbo].[BuyOrderTicket] ([BuyOrderTicketGroupID]) INCLUDE ([BuyOrderTicketID], [Seat], [OriginalBarcode], [FaceValue], [EIBOBuyOrderTicketID])
CREATE INDEX [missing_index_44_43_SellOrder] ON [EIBoxOffice].[dbo].[SellOrder] ([SellOrderStatusTypeID], [AssignedUserID], [WorkStatusTypeID]) INCLUDE ([CreatedDateTime])
CREATE INDEX [missing_index_21_20_Fulfillment] ON [Intranet].[dbo].[Fulfillment] ([UpdateSequence]) INCLUDE ([FulfillmentID])
CREATE INDEX [missing_index_15_14_SellOrder] ON [EIBoxOffice].[dbo].[SellOrder] ([ClientID], [ExternalReferenceNumber])
CREATE INDEX [missing_index_13_12_Production] ON [EIBoxOffice].[dbo].[Production] ([Redirect],[ProductionID], [StatusID]) INCLUDE ([PrimaryEventID], [SecondaryEventID], [VenueID], [EventDate], [EventTime], [IsTBA], [ReqEvent], [ReqVenue], [ReqTime])
CREATE INDEX [missing_index_23_22_TicketGroup] ON [EIBoxOffice].[dbo].[TicketGroup] ([TicketStatusTypeID], [IsConsignment]) INCLUDE ([TicketGroupID], [ShareTypeID], [PrimaryEventID], [VenueID], [TicketWarehouseID], [SubCompanyID], [EventDate], [EventTime], [SeatSection], [SeatRow], [StartingSeat], [EndingSeat], [IsConsecutiveSeating], [Quantity], [IsInHand], [ConsignmentClientID], [AllowSplit], [MaskRow], [MaskSeat], [IsActualTicketCost], [AverageTicketCost], [AverageTicketFace], [AverageTicketPrice], [DeliveryDate], [Description], [HoldSellOrderTicketGroupID], [SourceTicketGroupID], [TicketGroupGUID], [IsTBA], [SortPriority], [CreatedDateTime], [CreatedUserID], [UpdatedDateTime], [UpdatedUserID], [SecondaryEventID], [InternalNote], [OwnerClientID], [IsOutOnConsignment], [ConsignmentOutgoingID], [AverageTaxCreditAmount], [TaxCreditFace], [TaxCreditRate], [ExportCompNumber], [TicketLocationID], [SourceID], [InventoryTypeID], [ProductionID], [InHandDate], [TStoreTicketGroupID], [IsPDFAvailable], [NearTermOptionID], [StandardizedNoteID], [IsInstantDelivery], [ProductionShortNote], [ProductionLongNote], [EIBOTicketGroupID])
CREATE INDEX [missing_index_40_39_TicketStore] ON [Intranet].[dbo].[TicketStore] ([ExpireDate])
CREATE INDEX [missing_index_6553_6552_SoldView] ON [DynastyApp].[dbo].[SoldView] ([ProductionID]) INCLUDE ([InvoiceDate], [Qty], [Dollars], [Profit])
CREATE INDEX [missing_index_82_81_WebOrderLink] ON [EIBoxOffice].[dbo].[WebOrderLink] ([WebOrderID])
CREATE INDEX [missing_index_47_46_TicketGroupIdentity] ON [EIBoxOffice].[dbo].[TicketGroupIdentity] ([TicketGroupIdentityTypeID]) INCLUDE ([TicketGroupIdentityID])
CREATE INDEX [missing_index_4917_4916_TicketGroup] ON [EIBoxOffice].[dbo].[TicketGroup] ([TicketStatusTypeID]) INCLUDE ([TicketGroupID], [PrimaryEventID], [VenueID], [EventDate], [EventTime], [SeatSection], [SeatRow], [IsTBA], [SecondaryEventID])
CREATE INDEX [missing_index_6078_6077_POBulkImport] ON [DynastyApp].[dbo].[POBulkImport] ([BulkImport_BatchID]) INCLUDE ([PO_ID], [PDFElectronicDelivery], [Consecutive], [SH], [TL], [RG], [EB], [MISC], [TS], [ExportCompTotal], [Shared], [MaskSeats], [MaskRow], [AllowSplit], [ProductionID], [Event], [PrimaryEventID], [Opponent], [SecondaryEventID], [Venue], [VenueID], [SubClient], [EventDate], [EventTime], [IsTBA], [IsInHand], [InHandDate], [Quantity], [Section], [Row], [Start], [End], [Cost_total], [List_ea], [InternalNote], [ExternalNote], [StandardNote], [StandardNoteID], [LastUpdateTime], [LastUpdateUserID], [POInternalNote], [POExternalNote], [Error], [ErrorCount], [ErrorMessage], [ErrorColumns], [NewTicketGroupID], [isConsignment], [isInstantDelivery], [NewBOTicketGroupID], [BuyOrderTicketGroupGUID], [BuyOrderID], [Cost_ea], [Cost_ea_comp], [RowNum], [ConsignmentTicketGroupGUID])
CREATE INDEX [missing_index_84_83_WebOrderLink] ON [EIBoxOffice].[dbo].[WebOrderLink] ([WebOrderID])
CREATE INDEX [missing_index_5661_5660_TicketGroupHistory] ON [DynastyApp].[Audit].[TicketGroupHistory] ([PriceDelta]) INCLUDE ([DynastyUserId], [TimeStamp], [UpdateTypeId])
CREATE INDEX [missing_index_6415_6414_SoldView] ON [UAT_DynastyApp].[dbo].[SoldView] ([ProductionID]) INCLUDE ([Status], [Description], [TicketGroupID], [SecTicketGroupID], [InvoiceDate], [Home], [HomeID], [Away], [AwayID], [EventDate], [EventTime], [Venue], [Section], [Row], [BegSeat], [EndSeat], [Qty], [Cost], [Revenue], [TransactionFee], [Dollars], [Profit], [percentage], [DaysOut], [DaysOutCategory], [Vendor], [Customer], [Channel], [Category], [TGStatus], [SOStatus], [InternalNote], [Invoice], [SellOrderID], [PO], [PODate], [Parent], [Child], [Grandchild], [VenueID], [VendorID], [CustomerID], [CustomerCompanyName], [CustomerLastName], [CustomerFirstName], [AverageTicketPrice], [ListPrice], [Fee], [ConsignmentRole], [FaceValue])

EIBO
CREATE INDEX [missing_index_51_50_BuyOrderTicket] ON [EIBoxOffice].[dbo].[BuyOrderTicket] ([BuyOrderTicketGroupID]) INCLUDE ([BuyOrderTicketID], [Seat], [OriginalBarcode], [FaceValue], [EIBOBuyOrderTicketID])
CREATE INDEX [missing_index_44_43_SellOrder] ON [EIBoxOffice].[dbo].[SellOrder] ([SellOrderStatusTypeID], [AssignedUserID], [WorkStatusTypeID]) INCLUDE ([CreatedDateTime])
CREATE INDEX [missing_index_21_20_Fulfillment] ON [Intranet].[dbo].[Fulfillment] ([UpdateSequence]) INCLUDE ([FulfillmentID])
CREATE INDEX [missing_index_15_14_SellOrder] ON [EIBoxOffice].[dbo].[SellOrder] ([ClientID], [ExternalReferenceNumber])
CREATE INDEX [missing_index_13_12_Production] ON [EIBoxOffice].[dbo].[Production] ([Redirect],[ProductionID], [StatusID]) INCLUDE ([PrimaryEventID], [SecondaryEventID], [VenueID], [EventDate], [EventTime], [IsTBA], [ReqEvent], [ReqVenue], [ReqTime])
CREATE INDEX [missing_index_23_22_TicketGroup] ON [EIBoxOffice].[dbo].[TicketGroup] ([TicketStatusTypeID], [IsConsignment]) INCLUDE ([TicketGroupID], [ShareTypeID], [PrimaryEventID], [VenueID], [TicketWarehouseID], [SubCompanyID], [EventDate], [EventTime], [SeatSection], [SeatRow], [StartingSeat], [EndingSeat], [IsConsecutiveSeating], [Quantity], [IsInHand], [ConsignmentClientID], [AllowSplit], [MaskRow], [MaskSeat], [IsActualTicketCost], [AverageTicketCost], [AverageTicketFace], [AverageTicketPrice], [DeliveryDate], [Description], [HoldSellOrderTicketGroupID], [SourceTicketGroupID], [TicketGroupGUID], [IsTBA], [SortPriority], [CreatedDateTime], [CreatedUserID], [UpdatedDateTime], [UpdatedUserID], [SecondaryEventID], [InternalNote], [OwnerClientID], [IsOutOnConsignment], [ConsignmentOutgoingID], [AverageTaxCreditAmount], [TaxCreditFace], [TaxCreditRate], [ExportCompNumber], [TicketLocationID], [SourceID], [InventoryTypeID], [ProductionID], [InHandDate], [TStoreTicketGroupID], [IsPDFAvailable], [NearTermOptionID], [StandardizedNoteID], [IsInstantDelivery], [ProductionShortNote], [ProductionLongNote], [EIBOTicketGroupID])
CREATE INDEX [missing_index_40_39_TicketStore] ON [Intranet].[dbo].[TicketStore] ([ExpireDate])
CREATE INDEX [missing_index_6553_6552_SoldView] ON [DynastyApp].[dbo].[SoldView] ([ProductionID]) INCLUDE ([InvoiceDate], [Qty], [Dollars], [Profit])
CREATE INDEX [missing_index_82_81_WebOrderLink] ON [EIBoxOffice].[dbo].[WebOrderLink] ([WebOrderID])
CREATE INDEX [missing_index_47_46_TicketGroupIdentity] ON [EIBoxOffice].[dbo].[TicketGroupIdentity] ([TicketGroupIdentityTypeID]) INCLUDE ([TicketGroupIdentityID])
CREATE INDEX [missing_index_4917_4916_TicketGroup] ON [EIBoxOffice].[dbo].[TicketGroup] ([TicketStatusTypeID]) INCLUDE ([TicketGroupID], [PrimaryEventID], [VenueID], [EventDate], [EventTime], [SeatSection], [SeatRow], [IsTBA], [SecondaryEventID])
CREATE INDEX [missing_index_6078_6077_POBulkImport] ON [DynastyApp].[dbo].[POBulkImport] ([BulkImport_BatchID]) INCLUDE ([PO_ID], [PDFElectronicDelivery], [Consecutive], [SH], [TL], [RG], [EB], [MISC], [TS], [ExportCompTotal], [Shared], [MaskSeats], [MaskRow], [AllowSplit], [ProductionID], [Event], [PrimaryEventID], [Opponent], [SecondaryEventID], [Venue], [VenueID], [SubClient], [EventDate], [EventTime], [IsTBA], [IsInHand], [InHandDate], [Quantity], [Section], [Row], [Start], [End], [Cost_total], [List_ea], [InternalNote], [ExternalNote], [StandardNote], [StandardNoteID], [LastUpdateTime], [LastUpdateUserID], [POInternalNote], [POExternalNote], [Error], [ErrorCount], [ErrorMessage], [ErrorColumns], [NewTicketGroupID], [isConsignment], [isInstantDelivery], [NewBOTicketGroupID], [BuyOrderTicketGroupGUID], [BuyOrderID], [Cost_ea], [Cost_ea_comp], [RowNum], [ConsignmentTicketGroupGUID])
CREATE INDEX [missing_index_84_83_WebOrderLink] ON [EIBoxOffice].[dbo].[WebOrderLink] ([WebOrderID])
CREATE INDEX [missing_index_5661_5660_TicketGroupHistory] ON [DynastyApp].[Audit].[TicketGroupHistory] ([PriceDelta]) INCLUDE ([DynastyUserId], [TimeStamp], [UpdateTypeId])

Intranet
CREATE INDEX [missing_index_51_50_BuyOrderTicket] ON [EIBoxOffice].[dbo].[BuyOrderTicket] ([BuyOrderTicketGroupID]) INCLUDE ([BuyOrderTicketID], [Seat], [OriginalBarcode], [FaceValue], [EIBOBuyOrderTicketID])
CREATE INDEX [missing_index_44_43_SellOrder] ON [EIBoxOffice].[dbo].[SellOrder] ([SellOrderStatusTypeID], [AssignedUserID], [WorkStatusTypeID]) INCLUDE ([CreatedDateTime])
CREATE INDEX [missing_index_21_20_Fulfillment] ON [Intranet].[dbo].[Fulfillment] ([UpdateSequence]) INCLUDE ([FulfillmentID])
CREATE INDEX [missing_index_15_14_SellOrder] ON [EIBoxOffice].[dbo].[SellOrder] ([ClientID], [ExternalReferenceNumber])
CREATE INDEX [missing_index_13_12_Production] ON [EIBoxOffice].[dbo].[Production] ([Redirect],[ProductionID], [StatusID]) INCLUDE ([PrimaryEventID], [SecondaryEventID], [VenueID], [EventDate], [EventTime], [IsTBA], [ReqEvent], [ReqVenue], [ReqTime])
CREATE INDEX [missing_index_23_22_TicketGroup] ON [EIBoxOffice].[dbo].[TicketGroup] ([TicketStatusTypeID], [IsConsignment]) INCLUDE ([TicketGroupID], [ShareTypeID], [PrimaryEventID], [VenueID], [TicketWarehouseID], [SubCompanyID], [EventDate], [EventTime], [SeatSection], [SeatRow], [StartingSeat], [EndingSeat], [IsConsecutiveSeating], [Quantity], [IsInHand], [ConsignmentClientID], [AllowSplit], [MaskRow], [MaskSeat], [IsActualTicketCost], [AverageTicketCost], [AverageTicketFace], [AverageTicketPrice], [DeliveryDate], [Description], [HoldSellOrderTicketGroupID], [SourceTicketGroupID], [TicketGroupGUID], [IsTBA], [SortPriority], [CreatedDateTime], [CreatedUserID], [UpdatedDateTime], [UpdatedUserID], [SecondaryEventID], [InternalNote], [OwnerClientID], [IsOutOnConsignment], [ConsignmentOutgoingID], [AverageTaxCreditAmount], [TaxCreditFace], [TaxCreditRate], [ExportCompNumber], [TicketLocationID], [SourceID], [InventoryTypeID], [ProductionID], [InHandDate], [TStoreTicketGroupID], [IsPDFAvailable], [NearTermOptionID], [StandardizedNoteID], [IsInstantDelivery], [ProductionShortNote], [ProductionLongNote], [EIBOTicketGroupID])
CREATE INDEX [missing_index_40_39_TicketStore] ON [Intranet].[dbo].[TicketStore] ([ExpireDate])
CREATE INDEX [missing_index_6553_6552_SoldView] ON [DynastyApp].[dbo].[SoldView] ([ProductionID]) INCLUDE ([InvoiceDate], [Qty], [Dollars], [Profit])
CREATE INDEX [missing_index_82_81_WebOrderLink] ON [EIBoxOffice].[dbo].[WebOrderLink] ([WebOrderID])
CREATE INDEX [missing_index_47_46_TicketGroupIdentity] ON [EIBoxOffice].[dbo].[TicketGroupIdentity] ([TicketGroupIdentityTypeID]) INCLUDE ([TicketGroupIdentityID])
CREATE INDEX [missing_index_4917_4916_TicketGroup] ON [EIBoxOffice].[dbo].[TicketGroup] ([TicketStatusTypeID]) INCLUDE ([TicketGroupID], [PrimaryEventID], [VenueID], [EventDate], [EventTime], [SeatSection], [SeatRow], [IsTBA], [SecondaryEventID])
CREATE INDEX [missing_index_6078_6077_POBulkImport] ON [DynastyApp].[dbo].[POBulkImport] ([BulkImport_BatchID]) INCLUDE ([PO_ID], [PDFElectronicDelivery], [Consecutive], [SH], [TL], [RG], [EB], [MISC], [TS], [ExportCompTotal], [Shared], [MaskSeats], [MaskRow], [AllowSplit], [ProductionID], [Event], [PrimaryEventID], [Opponent], [SecondaryEventID], [Venue], [VenueID], [SubClient], [EventDate], [EventTime], [IsTBA], [IsInHand], [InHandDate], [Quantity], [Section], [Row], [Start], [End], [Cost_total], [List_ea], [InternalNote], [ExternalNote], [StandardNote], [StandardNoteID], [LastUpdateTime], [LastUpdateUserID], [POInternalNote], [POExternalNote], [Error], [ErrorCount], [ErrorMessage], [ErrorColumns], [NewTicketGroupID], [isConsignment], [isInstantDelivery], [NewBOTicketGroupID], [BuyOrderTicketGroupGUID], [BuyOrderID], [Cost_ea], [Cost_ea_comp], [RowNum], [ConsignmentTicketGroupGUID])
CREATE INDEX [missing_index_84_83_WebOrderLink] ON [EIBoxOffice].[dbo].[WebOrderLink] ([WebOrderID])
CREATE INDEX [missing_index_5661_5660_TicketGroupHistory] ON [DynastyApp].[Audit].[TicketGroupHistory] ([PriceDelta]) INCLUDE ([DynastyUserId], [TimeStamp], [UpdateTypeId])
CREATE INDEX [missing_index_6544_6543_SoldView] ON [UAT_DynastyApp].[dbo].[SoldView] ([ProductionID]) INCLUDE ([InvoiceDate], [Qty], [Dollars], [Profit])


Listings 2
CREATE INDEX [missing_index_122_121_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID], [Marketplace],[Qty]) INCLUDE ([SaleDate], [Section], [Row], [TransactionAmt], [SectionNumber])
CREATE INDEX [missing_index_2116_2115_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID], [Marketplace]) INCLUDE ([SaleDate], [Section], [Row], [Qty], [TransactionAmt], [SectionNumber])
CREATE INDEX [missing_index_124_123_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([Marketplace],[Qty]) INCLUDE ([GameID], [SaleDate], [Section], [Row], [TransactionAmt], [SectionNumber])
CREATE INDEX [missing_index_1180_1179_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([Marketplace],[Qty]) INCLUDE ([GameID], [TransactionAmt])
CREATE INDEX [missing_index_2494_2493_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID], [Marketplace],[Qty]) INCLUDE ([SaleDate], [Section], [Zone], [Row], [TransactionAmt], [SectionNumber])
CREATE INDEX [missing_index_705_704_Cluster_SqlServer_SqlProcess_Uns] ON [RedGateMonitor].[data].[Cluster_SqlServer_SqlProcess_UnstableSamples] ([CollectionDate]) INCLUDE ([Id])
CREATE INDEX [missing_index_576_575_Cluster_StableSamples] ON [RedGateMonitor].[data].[Cluster_StableSamples] ([CollectionDate]) INCLUDE ([Id])
CREATE INDEX [missing_index_49_48_sysjobhistory] ON [msdb].[dbo].[sysjobhistory] ([step_id]) INCLUDE ([job_id], [run_status], [run_date], [run_time], [run_duration])
CREATE INDEX [missing_index_835_834_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([Marketplace]) INCLUDE ([GameID])
CREATE INDEX [missing_index_1452_1451_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID], [Marketplace],[Qty]) INCLUDE ([TransactionAmt])
CREATE INDEX [missing_index_2213_2212_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID], [Marketplace],[Qty])
CREATE INDEX [missing_index_837_836_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID], [Marketplace])
CREATE INDEX [missing_index_213_212_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID]) INCLUDE ([SaleDate], [Section], [Zone], [Row], [Qty], [TransactionAmt], [Marketplace], [SectionNumber])
CREATE INDEX [missing_index_578_577_Cluster_SqlServer_StableSamples] ON [RedGateMonitor].[data].[Cluster_SqlServer_StableSamples] ([CollectionDate]) INCLUDE ([Id])
CREATE INDEX [missing_index_2215_2214_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([Marketplace],[Qty]) INCLUDE ([GameID])

DynastyReporting
CREATE INDEX [missing_index_122_121_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID], [Marketplace],[Qty]) INCLUDE ([SaleDate], [Section], [Row], [TransactionAmt], [SectionNumber])
CREATE INDEX [missing_index_2116_2115_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID], [Marketplace]) INCLUDE ([SaleDate], [Section], [Row], [Qty], [TransactionAmt], [SectionNumber])
CREATE INDEX [missing_index_124_123_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([Marketplace],[Qty]) INCLUDE ([GameID], [SaleDate], [Section], [Row], [TransactionAmt], [SectionNumber])
CREATE INDEX [missing_index_1180_1179_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([Marketplace],[Qty]) INCLUDE ([GameID], [TransactionAmt])
CREATE INDEX [missing_index_2494_2493_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID], [Marketplace],[Qty]) INCLUDE ([SaleDate], [Section], [Zone], [Row], [TransactionAmt], [SectionNumber])
CREATE INDEX [missing_index_705_704_Cluster_SqlServer_SqlProcess_Uns] ON [RedGateMonitor].[data].[Cluster_SqlServer_SqlProcess_UnstableSamples] ([CollectionDate]) INCLUDE ([Id])
CREATE INDEX [missing_index_576_575_Cluster_StableSamples] ON [RedGateMonitor].[data].[Cluster_StableSamples] ([CollectionDate]) INCLUDE ([Id])
CREATE INDEX [missing_index_49_48_sysjobhistory] ON [msdb].[dbo].[sysjobhistory] ([step_id]) INCLUDE ([job_id], [run_status], [run_date], [run_time], [run_duration])
CREATE INDEX [missing_index_835_834_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([Marketplace]) INCLUDE ([GameID])
CREATE INDEX [missing_index_1452_1451_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID], [Marketplace],[Qty]) INCLUDE ([TransactionAmt])
CREATE INDEX [missing_index_2213_2212_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID], [Marketplace],[Qty])
CREATE INDEX [missing_index_837_836_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID], [Marketplace])
CREATE INDEX [missing_index_213_212_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID]) INCLUDE ([SaleDate], [Section], [Zone], [Row], [Qty], [TransactionAmt], [Marketplace], [SectionNumber])
CREATE INDEX [missing_index_578_577_Cluster_SqlServer_StableSamples] ON [RedGateMonitor].[data].[Cluster_SqlServer_StableSamples] ([CollectionDate]) INCLUDE ([Id])
CREATE INDEX [missing_index_2215_2214_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([Marketplace],[Qty]) INCLUDE ([GameID])

stubhubsalesdata
CREATE INDEX [missing_index_122_121_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID], [Marketplace],[Qty]) INCLUDE ([SaleDate], [Section], [Row], [TransactionAmt], [SectionNumber])
CREATE INDEX [missing_index_2116_2115_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID], [Marketplace]) INCLUDE ([SaleDate], [Section], [Row], [Qty], [TransactionAmt], [SectionNumber])
CREATE INDEX [missing_index_124_123_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([Marketplace],[Qty]) INCLUDE ([GameID], [SaleDate], [Section], [Row], [TransactionAmt], [SectionNumber])
CREATE INDEX [missing_index_1180_1179_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([Marketplace],[Qty]) INCLUDE ([GameID], [TransactionAmt])
CREATE INDEX [missing_index_2494_2493_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID], [Marketplace],[Qty]) INCLUDE ([SaleDate], [Section], [Zone], [Row], [TransactionAmt], [SectionNumber])
CREATE INDEX [missing_index_705_704_Cluster_SqlServer_SqlProcess_Uns] ON [RedGateMonitor].[data].[Cluster_SqlServer_SqlProcess_UnstableSamples] ([CollectionDate]) INCLUDE ([Id])
CREATE INDEX [missing_index_576_575_Cluster_StableSamples] ON [RedGateMonitor].[data].[Cluster_StableSamples] ([CollectionDate]) INCLUDE ([Id])
CREATE INDEX [missing_index_49_48_sysjobhistory] ON [msdb].[dbo].[sysjobhistory] ([step_id]) INCLUDE ([job_id], [run_status], [run_date], [run_time], [run_duration])
CREATE INDEX [missing_index_835_834_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([Marketplace]) INCLUDE ([GameID])
CREATE INDEX [missing_index_1452_1451_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID], [Marketplace],[Qty]) INCLUDE ([TransactionAmt])
CREATE INDEX [missing_index_2213_2212_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID], [Marketplace],[Qty])
CREATE INDEX [missing_index_837_836_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID], [Marketplace])
CREATE INDEX [missing_index_213_212_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([GameID]) INCLUDE ([SaleDate], [Section], [Zone], [Row], [Qty], [TransactionAmt], [Marketplace], [SectionNumber])
CREATE INDEX [missing_index_578_577_Cluster_SqlServer_StableSamples] ON [RedGateMonitor].[data].[Cluster_SqlServer_StableSamples] ([CollectionDate]) INCLUDE ([Id])
CREATE INDEX [missing_index_2215_2214_Sales_DB] ON [StubHubSalesData].[dbo].[Sales_DB] ([Marketplace],[Qty]) INCLUDE ([GameID])
*/