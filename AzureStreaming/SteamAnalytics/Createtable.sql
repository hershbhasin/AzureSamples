CREATE TABLE [dbo].[AuditTable](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [device] [varchar](50) NULL,
    [tenant] [varchar](50) NULL,
    project [varchar](50) NULL,
    [username] [varchar](50) NULL,
    [action] [varchar](150) NULL,
    [EventEnqueuedUtcTime] [datetime] NULL
) ON [PRIMARY]