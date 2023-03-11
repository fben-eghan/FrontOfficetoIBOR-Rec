USE [POMSPortia4]
GO

/****** Object:  StoredProcedure [dbo].[ExpHoldingsRecX]    Script Date: 25/01/2023 15:32:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ExpHoldingsRec] AS
BEGIN
    --Clear table
    TRUNCATE TABLE [Holdings Diffs]

    --Portia NOT POMs
    INSERT INTO [Holdings Diffs] (Portfolio, [Security], Sedol, Ticker, Portia, POMS, [Rec Difference])
    SELECT p.Portfolio, p.[Security], p.Sedol, p.Ticker, p.Quantity AS [Portia], COALESCE(m.Quantity, '0.00') AS [POMS], SUM(COALESCE(m.Quantity, '0.00') - p.Quantity) AS [Rec Difference]
    FROM [Portia Rec] AS p
    LEFT JOIN [POMS Rec] AS m ON p.PfoSedol = m.PfoSedol
    WHERE p.Portfolio < 'zmonth' AND m.PfoSedol IS NULL
    GROUP BY p.Portfolio, p.[Security], p.Sedol, p.Ticker, p.Quantity, COALESCE(m.Quantity, '0.00')

    UNION

    --POMS NOT Portia
    SELECT LEFT(m.PfoSedol, 8) AS Portfolio, m.SecLongName AS [Security], m.Sedol2 AS Sedol, m.Ticker, COALESCE(p.Quantity, '0.00') AS [Portia], m.Quantity AS [POMS], SUM(m.Quantity - COALESCE(p.Quantity, '0.00')) AS [Rec Difference]
    FROM [POMS Rec] AS m
    LEFT JOIN [Portia Rec] AS p ON m.PfoSedol = p.PfoSedol
    WHERE m.Quantity <> 0 AND m.PfoSedol < 'zmonth' AND p.PfoSedol IS NULL AND LEFT(m.PfoSedol, 8) < 'zmonth'
    GROUP BY LEFT(m.PfoSedol, 8), m.SecLongName, m.Sedol2, m.Ticker, COALESCE(p.Quantity, '0.00'), m.Quantity

    UNION

    --POMS vs Portia
    SELECT p.Portfolio, m.SecLongName AS [Security], COALESCE(p.Sedol, m.Sedol2) AS Sedol, m.Ticker, p.Quantity AS [Portia], COALESCE(m.Quantity, '0.00') AS [POMS], SUM(COALESCE(m.Quantity, '0.00') - p.Quantity) AS [Rec Difference]
    FROM [Portia Rec] AS p
    JOIN [POMS Rec] AS m ON p.PfoSedol = m.PfoSedol
    WHERE p.Portfolio < 'zmonth' AND m.Quantity <> p.Quantity
    GROUP BY p.Portfolio, m.SecLongName, COALESCE(p.Sedol, m.Sedol2), m.Ticker, p.Quantity, COALESCE(m.Quantity, '0.00');
