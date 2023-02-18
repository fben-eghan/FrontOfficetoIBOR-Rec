--Create Table for Securities Holdings Differences between Front Ofiice system and IBOR System.
USE [POMSPortia4]
GO

/****** Object:  Table [dbo].[Holdings Rec 2]    Script Date: 25/01/2023 12:53:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Holdings Rec X](
	[Portfolio] [varchar](50) NULL,
	[Security] [varchar](50) NULL,
	[Ticker] [varchar](50) NULL,
	[Sedol] [varchar](50) NULL,
	[Portia] [decimal](28, 2) NULL,
	[POMS] [decimal](28, 2) NULL,
	[Rec Difference] [decimal](28, 2) NULL
) ON [PRIMARY]
GO


