CREATE TABLE [dbo].[AuditTable](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Device] [varchar](50) NULL,
    [LedColor] [varchar](50) NULL,
    [EventEnqueuedUtcTime] [datetime] NULL
) ON [PRIMARY]