USE [POMSPortia4]
GO

/****** Object:  StoredProcedure [dbo].[ExpHoldingsRecX]    Script Date: 25/01/2023 15:32:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[ExpHoldingsRecX] AS
--Trunc
TRUNCATE TABLE [Holdings Rec X]

--Portia NOT POMs

INSERT INTO [Holdings Rec X] (Portfolio, [Security], Sedol, Ticker, Portia, POMS, [Rec Difference])

SELECT [Portia Rec].Portfolio AS Portfolio, [Portia Rec].[Security] AS [Security], [POMS Rec].Ticker AS Ticker, [Portia Rec].Sedol AS [Sedol], [Portia Rec].Quantity AS [Portia], COALESCE([POMS Rec].Quantity, '0.00') AS [POMS], SUM(COALESCE([POMS Rec].Quantity, '0.00') - [Portia Rec].Quantity) AS [Rec Difference]

FROM [Portia Rec] LEFT JOIN [POMS Rec] ON [Portia Rec].PfoSedol = [POMS Rec].PfoSedol

GROUP BY [Portia Rec].Portfolio, [Portia Rec].[Security], [POMS Rec].Ticker, [Portia Rec].Sedol, [Portia Rec].Quantity, COALESCE([POMS Rec].Quantity, '0.00'), [POMS Rec].PfoSedol, [Portia Rec].PfoSedol

HAVING ((([Portia Rec].Portfolio)<'zmonth') AND (([POMS Rec].PfoSedol) Is Null))

UNION
--POMS NOT Portia

SELECT Left([POMS Rec].PfoSedol,8) AS Portfolio, [POMS Rec].SecLongName AS [Security], [POMS Rec].Ticker AS Ticker, [POMS Rec].Sedol2 AS Sedol, Coalesce([Portia Rec].Quantity, '0.00') AS [Portia], [POMS Rec].Quantity AS [POMS], SUM([POMS Rec].Quantity - COALESCE([Portia Rec].Quantity, '0.00')) AS [Rec Difference]

FROM [POMS Rec] LEFT JOIN [Portia Rec] ON [POMS Rec].PfoSedol = [Portia Rec].PfoSedol

GROUP BY Left([POMS Rec].PfoSedol,8), [POMS Rec].SecLongName, [POMS Rec].Ticker, [POMS Rec].Sedol2, Coalesce([Portia Rec].Quantity, '0.00'), [POMS Rec].Quantity, [POMS Rec].PfoSedol, [Portia Rec].PfoSedol

HAVING ((([POMS Rec].Quantity)<>0) AND (([POMS Rec].PfoSedol)<'zmonth') AND (([Portia Rec].PfoSedol) Is Null) AND ((Left([POMS Rec].[PfoSedol],8))<'zmonth'))

UNION
--POMS vs Portia

SELECT [Portia Rec].Portfolio AS Portfolio, [POMS Rec].[SecLongName] AS [Security], [POMS Rec].Ticker AS Ticker, COALESCE([Portia Rec].Sedol, [POMS Rec].Sedol2) AS Sedol, [Portia Rec].Quantity AS [Portia], COALESCE([POMS Rec].Quantity, '0.00') AS [POMS], SUM(COALESCE([POMS Rec].Quantity, '0.00') - [Portia Rec].Quantity) AS [Rec Difference]

FROM [POMS Rec] LEFT JOIN [Portia Rec] ON [POMS Rec].PfoSedol = [Portia Rec].PfoSedol

GROUP BY [Portia Rec].Portfolio, [POMS Rec].SecLongName, [POMS Rec].Ticker, COALESCE([Portia Rec].Sedol, [POMS Rec].Sedol2), [Portia Rec].Quantity, [POMS Rec].Quantity, [POMS Rec].Quantity-[Portia Rec].Quantity, [POMS Rec].Quantity

HAVING ((([Portia Rec].Portfolio)<'zmonth') AND (([POMS Rec].[Quantity])<>[Portia Rec].[Quantity]))

ORDER BY Portfolio, [Rec Difference];
GO


