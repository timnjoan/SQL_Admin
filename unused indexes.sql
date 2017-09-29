--SELECT OBJECT_NAME(S.[OBJECT_ID]) AS [OBJECT NAME], 
--       I.[NAME] AS [INDEX NAME], 
--       USER_SEEKS, 
--       USER_SCANS, 
--       USER_LOOKUPS, 
--       USER_UPDATES,
--	  S.last_user_seek,
--	  S.last_user_scan 
--FROM   SYS.DM_DB_INDEX_USAGE_STATS AS S 
--       INNER JOIN SYS.INDEXES AS I ON I.[OBJECT_ID] = S.[OBJECT_ID] AND I.INDEX_ID = S.INDEX_ID 
--WHERE  OBJECTPROPERTY(S.[OBJECT_ID],'IsUserTable') = 1
--       AND S.database_id = DB_ID()

SELECT 
o.name AS ObjectName
, i.name AS IndexName
, i.index_id AS IndexID
, dm_ius.user_seeks AS UserSeek
, dm_ius.user_scans AS UserScans
, dm_ius.user_lookups AS UserLookups
, dm_ius.user_updates AS UserUpdates
, p.TableRows
, 'DROP INDEX ' + QUOTENAME(i.name)
+ ' ON ' + QUOTENAME(s.name) + '.'
+ QUOTENAME(OBJECT_NAME(dm_ius.OBJECT_ID)) AS 'drop statement'
FROM sys.dm_db_index_usage_stats dm_ius
INNER JOIN sys.indexes i ON i.index_id = dm_ius.index_id 
AND dm_ius.OBJECT_ID = i.OBJECT_ID
INNER JOIN sys.objects o ON dm_ius.OBJECT_ID = o.OBJECT_ID
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
INNER JOIN (SELECT SUM(p.rows) TableRows, p.index_id, p.OBJECT_ID
FROM sys.partitions p GROUP BY p.index_id, p.OBJECT_ID) p
ON p.index_id = dm_ius.index_id AND dm_ius.OBJECT_ID = p.OBJECT_ID
WHERE OBJECTPROPERTY(dm_ius.OBJECT_ID,'IsUserTable') = 1
AND dm_ius.database_id = DB_ID()
AND i.type_desc = 'nonclustered'
AND i.is_primary_key = 0
AND i.is_unique_constraint = 0
ORDER BY (dm_ius.user_seeks + dm_ius.user_scans + dm_ius.user_lookups) ASC

/*
DROP INDEX [IX_AuditTicketGroupHistory_PriceDelta_covering] ON [Audit].[TicketGroupHistory]
DROP INDEX [_dta_index_TicketGroupHistory_6_221203463__K4_K8_K2_K5] ON [Audit].[TicketGroupHistory]

DROP INDEX [IX_Events_1] ON [dbo].[Events]
DROP INDEX [IX_Events_2] ON [dbo].[Events]
DROP INDEX [IX_lookup_StubHubEvent_Venues] ON [dbo].[lookup_StubHubEvent_Venues]
DROP INDEX [IX_Events] ON [dbo].[Events]

DROP INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]

DROP INDEX [IX_ELMAH_Error_App_Time_Seq] ON [dbo].[ELMAH_Error]

DROP INDEX [IX_BuyOrder_AssignedUserID] ON [dbo].[BuyOrder]
DROP INDEX [IX_ShareLog_BrokerID] ON [dbo].[ShareLog]
DROP INDEX [IX_ExceptionLog_BrokerID] ON [dbo].[ExceptionLog]
DROP INDEX [IX_Broker_CompanyName] ON [dbo].[Broker]
DROP INDEX [IX_ShareTicketGroup_BrokerID] ON [dbo].[ShareTicketGroup]
DROP INDEX [IX_Event_BrokerID] ON [dbo].[Event]
DROP INDEX [IX_SellOrder_SellOrderStatusTypeID] ON [dbo].[SellOrder]
DROP INDEX [IX_ClientPhone_IsDefault] ON [dbo].[ClientPhone]
DROP INDEX [IX_ClientAddress_IsDefault] ON [dbo].[ClientAddress]
DROP INDEX [IX_Client_ClientCategoryID] ON [dbo].[Client]
DROP INDEX [IX_OrderPayment_OrderID] ON [dbo].[OrderPayment]
DROP INDEX [IX_OrderNote_OrderID] ON [dbo].[OrderNote]
DROP INDEX [IX_ContentLog_ContentID] ON [dbo].[ContentLog]
DROP INDEX [IX_BuyOrder_BuyOrderStatusTypeID] ON [dbo].[BuyOrder]
DROP INDEX [IX_ShareLog_LogDateTime] ON [dbo].[ShareLog]
DROP INDEX [IX_ExceptionLog_DateTimeStamp] ON [dbo].[ExceptionLog]
DROP INDEX [IX_Venue_DestinationMergeID] ON [dbo].[Venue]
DROP INDEX [IDX_SellOrderTicketGroup_AVDGetTicketsGUID] ON [dbo].[SellOrderTicketGroup]
DROP INDEX [IX_Event_DestinationMergeID] ON [dbo].[Event]
DROP INDEX [IX_ClientPhone_ClientSearch] ON [dbo].[ClientPhone]
DROP INDEX [IX_ClientEmail_IsDefault] ON [dbo].[ClientEmail]
DROP INDEX [IX_EmailLog_SendDateTime] ON [dbo].[EmailLog]
DROP INDEX [IX_ContentLog_DateTimeStamp] ON [dbo].[ContentLog]
DROP INDEX [IX_ClientAddress_ClientSearch] ON [dbo].[ClientAddress]
DROP INDEX [IX_OrderPayment_OrderTypeID] ON [dbo].[OrderPayment]
DROP INDEX [IX_OrderNote_OrderNoteTypeID] ON [dbo].[OrderNote]
DROP INDEX [IDX_SeasonProduction_SecondaryEventID] ON [dbo].[SeasonProduction]
DROP INDEX [IX_BuyOrderTicketGroup_BuyOrderTicketGroupGUID] ON [dbo].[BuyOrderTicketGroup]
DROP INDEX [IX_Venue_RegionID] ON [dbo].[Venue]
DROP INDEX [IX_ShareLog_ShareLogTypeID] ON [dbo].[ShareLog]
DROP INDEX [IX_TicketGroup_SecondaryEventID] ON [dbo].[TicketGroup]
DROP INDEX [IX_ShareTicketGroup_PrimaryEventID] ON [dbo].[ShareTicketGroup]
DROP INDEX [IX_ClientEmail_ClientSearch] ON [dbo].[ClientEmail]
DROP INDEX [IX_PaymentTransaction_PaymentTransactionTypeID] ON [dbo].[PaymentTransaction]
DROP INDEX [IX_OrderNote_OrderTypeID] ON [dbo].[OrderNote]
DROP INDEX [IDX_SellOrder_TrackingNumber] ON [dbo].[SellOrder]
DROP INDEX [IX_PaymentTransaction_DateTimeStamp] ON [dbo].[PaymentTransaction]
DROP INDEX [IX_ContentLog_OrderTypeID] ON [dbo].[ContentLog]
DROP INDEX [IX_Client_ClientSearch] ON [dbo].[Client]
DROP INDEX [IX_OrderPyament_OrderPaymentStatusID] ON [dbo].[OrderPayment]
DROP INDEX [IX_ShareTicketGroup_SecondaryEventID] ON [dbo].[ShareTicketGroup]
DROP INDEX [IDX_SeasonProduction_VenueID] ON [dbo].[SeasonProduction]
DROP INDEX [IDX_BuyOrder_TrackingNumber] ON [dbo].[BuyOrder]
DROP INDEX [IX_ShareTicketGroup_ProductionTickets] ON [dbo].[ShareTicketGroup]
DROP INDEX [IDX_SeasonProduction_PrimaryEventID] ON [dbo].[SeasonProduction]
DROP INDEX [IDX_ShareTicketGroup_Search] ON [dbo].[ShareTicketGroup]
DROP INDEX [IX_BuyOrder_Search_Canceled] ON [dbo].[BuyOrder]
DROP INDEX [IX_ShareTicketGroup_VenueID] ON [dbo].[ShareTicketGroup]
DROP INDEX [IX_SellOrder_Search_Canceled] ON [dbo].[SellOrder]
DROP INDEX [IDX_OrderPayment_CreditCardID] ON [dbo].[OrderPayment]
DROP INDEX [IX_BuyOrder_Search_Updated] ON [dbo].[BuyOrder]
DROP INDEX [IDX_ShareTicketGroup_SelectProductions] ON [dbo].[ShareTicketGroup]
DROP INDEX [IX_Client_EIBOClientID] ON [dbo].[Client]
DROP INDEX [IDX_WebOrderTicketGroup_ProductionID_TM_Event_ID] ON [dbo].[WebOrderTicketGroup]
DROP INDEX [IDX_BuyOrderTicketGroup_IsConsignment] ON [dbo].[BuyOrderTicketGroup]
DROP INDEX [IDX_BuyOrder_CreateDateTime_ClientID] ON [dbo].[BuyOrder]
DROP INDEX [IDX_SellOrder_SellOrderStatusTypeIDCovering] ON [dbo].[SellOrder]
*/