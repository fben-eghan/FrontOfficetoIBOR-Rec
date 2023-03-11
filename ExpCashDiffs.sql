USE POMSPortia4;
GO
-- This stored procedure is used to calculate cash differences between Portia and POMS systems and insert them into the [Cash Diffs] table.

CREATE PROCEDURE [dbo].[ExpCashDiffs]
AS
BEGIN

-- Insert cash differences for portfolios that exist in Portia but not in POMS or where the total in POMS is zero.
INSERT INTO [Cash Diffs] (Portfolio, CCY, Portia, POMS, [Rec Difference])
SELECT
LEFT(pr.Portfolio, 8) AS Portfolio,
RIGHT(pr.Portfolio, 3) AS CCY,
pr.[Total Amount] AS Portia,
COALESCE(pcr.Total, 0) AS POMS,
SUM(pr.[Total Amount] - COALESCE(pcr.Total, 0)) AS [Rec Difference]
FROM [Portia Cash Rec (Post)] pr
LEFT JOIN [POMS Cash Rec] pcr ON pr.Portfolio = pcr.Portfolio
WHERE pcr.Portfolio IS NULL OR pcr.Total = 0
GROUP BY LEFT(pr.Portfolio, 8), RIGHT(pr.Portfolio, 3), pr.[Total Amount], pcr.Total
HAVING pr.[Total Amount] <> COALESCE(pcr.Total, 0)

-- Union with cash differences for portfolios that exist in POMS but not in Portia or where the total in Portia is zero.
UNION

SELECT
    LEFT(pcr.Portfolio, 8) AS Portfolio,
    RIGHT(pcr.Portfolio, 3) AS CCY,
    COALESCE(pr.[Total Amount], 0) AS Portia,
    pcr.Total AS POMS,
    SUM(COALESCE(pr.[Total Amount], 0) - pcr.Total) AS [Rec Difference]
FROM [POMS Cash Rec] pcr
LEFT JOIN [Portia Cash Rec (Post)] pr ON pcr.Portfolio = pr.Portfolio
WHERE pcr.Total <> 0 AND (pcr.Portfolio < 'zmonth' OR RIGHT(pcr.Portfolio, 3) <> 'GBp')
GROUP BY LEFT(pcr.Portfolio, 8), RIGHT(pcr.Portfolio, 3), pr.[Total Amount], pcr.Total
HAVING COALESCE(pr.[Total Amount], 0) <> pcr.Total

-- Order the results by Portfolio and CCY.
ORDER BY Portfolio, CCY;
