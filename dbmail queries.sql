look for a hanging proc call
CREATE PROCEDURE dbo.sysmail_help_configure_sp


sysmail_help_queue_sp @queue_type = 'Mail'

sysmail_start_sp

SELECT is_broker_enabled FROM sys.databases WHERE name = 'msdb';

USE msdb ;
GO

-- Show the subject, the time that the mail item row was last
-- modified, and the log information.
-- Join sysmail_faileditems to sysmail_event_log 
-- on the mailitem_id column.
-- In the WHERE clause list items where danw was in the recipients,
-- copy_recipients, or blind_copy_recipients.
-- These are the items that would have been sent
-- to danw.

SELECT items.subject,
    items.last_mod_date
    ,l.description FROM dbo.sysmail_faileditems as items
INNER JOIN dbo.sysmail_event_log AS l
    ON items.mailitem_id = l.mailitem_id
WHERE items.recipients LIKE '%msto%'  
    OR items.copy_recipients LIKE '%msto%' 
    OR items.blind_copy_recipients LIKE '%msto%'
GO


--The mail could not be sent to the recipients because of the mail server failure. (Sending Mail using Account 1 (2017-07-19T06:02:57). Exception Message: Cannot send mails to mail server. (The operation has timed out.).
--)

--DELETE 
--Database Mail Test
--Database Mail Test
--DSE Columbus Blue Jackets as of 07192017
--DSE Vancouver Canucks as of 07192017

sp_who2

EXEC msdb.dbo.sysmail_help_principalprofile_sp;

EXEC msdb.dbo.l;

EXEC msdb.dbo.sysmail_help_queue_sp @queue_type = 'mail';
-- if not RECEIVES_OCCURRING, then try stopping and restarting
sysmail_stop_sp

sysmail_start_sp

SELECT sent_account_id, sent_date FROM msdb.dbo.sysmail_sentitems;

SELECT * FROM dbo.sysmail_mailitems

--DELETE dbo.sysmail_mailitems
--WHERE sent_status <> 1

SELECT * FROM msdb.dbo.sysmail_event_log
ORDER BY 1 desc;

SELECT * FROM ExternalMailQueue

delete from msdb.dbo.sysmail_unsentitems;

--DELETE FROM ExternalMailQueue


exec msdb.dbo.sysmail_stop_sp -- stop DatabaseMail.exe, so it does not try hard
ALTER QUEUE ExternalMailQueue WITH STATUS = ON
set nocount on
declare @Conversation_handle uniqueidentifier;
declare @message_type nvarchar(256);
declare @counter bigint;
declare @counter2 bigint;
set @counter = (select count(*) from ExternalMailQueue) -- count millions of queued messages
set @counter2=0
-- now do until nothing is left in the queue
while (@counter2<=@counter)
begin
    receive @Conversation_handle = conversation_handle, @message_type = message_type_name from ExternalMailQueue    -- pop messages from the queue
set @counter2 = @counter2 + 1
end

exec msdb.dbo.sysmail_start_sp -- start DatabaseMail.exe again

EXEC msdb.dbo.sysmail_help_queue_sp -- verify that there is nothing left in the queue