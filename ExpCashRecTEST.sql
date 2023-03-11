--Export cash differences between Front Office system and IBOR system.

USE [POMSPortia4]
GO

/****** Object:  StoredProcedure [dbo].[ExpCashDiffs]    Script Date: 18/02/2023 16:20:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ExpCashDiffs] AS

INSERT INTO [Cash Diffs] (Portfolio, CCY, Portia, POMS, [Rec Difference])

SELECT Left([POMS Cash Rec].Portfolio,8) AS Portfolio, Right([Portia Cash Rec (Post)].Portfolio,3) AS CCY, [Portia Cash Rec (Post)].[Total Amount] AS [Portia], COALESCE([POMS Cash Rec].Total, '0.00') AS [POMS], SUM([Portia Cash Rec (Post)].[Total Amount] - COALESCE([POMS Cash Rec].Total, '0.00')) AS [Rec Difference]

FROM [Portia Cash Rec (Post)] INNER JOIN [POMS Cash Rec] ON [Portia Cash Rec (Post)].Portfolio = [POMS Cash Rec].Portfolio

GROUP BY Left([Portia Cash Rec (Post)].Portfolio, 8), Right([Portia Cash Rec (Post)].Portfolio, 3), [Portia Cash Rec (Post)].[Total Amount], COALESCE([POMS Cash Rec].Total, '0.00'), [Portia Cash Rec (Post)].Portfolio, [POMS Cash Rec].Portfolio

HAVING ((([POMS Cash Rec].Portfolio) Is Null))

UNION

SELECT Left([POMS Cash Rec].Portfolio,8) AS Portfolio, Right([POMS Cash Rec].Portfolio,3) AS CCY, COALESCE([Portia Cash Rec (Post)].[Total Amount], '0.00') AS [Portia], [POMS Cash Rec].Total AS [POMS], SUM(COALESCE([Portia Cash Rec (Post)].[Total Amount], '0.00') - [POMS Cash Rec].Total) AS [Rec Difference]

FROM [POMS Cash Rec] LEFT JOIN [Portia Cash Rec (Post)] ON [POMS Cash Rec].Portfolio = [Portia Cash Rec (Post)].Portfolio

GROUP BY Left([Portia Cash Rec (Post)].Portfolio, 8), Right([Portia Cash Rec (Post)].Portfolio, 3), Coalesce([Portia Cash Rec (Post)].[Total Amount], '0.00'), [POMS Cash Rec].Total, [POMS Cash Rec].Portfolio, [Portia Cash Rec (Post)].Portfolio, [Portia Cash Rec (Post)].[Total Amount]

HAVING ((([POMS Cash Rec].Total)<>0) AND (([Portia Cash Rec (Post)].Portfolio) Is Null))

UNION

SELECT Left([POMS Cash Rec].Portfolio,8) AS Portfolio, Right([POMS Cash Rec].Portfolio,3) AS CCY, [Portia Cash Rec (Post)].[Total Amount] AS [Portia], [POMS Cash Rec].Total AS [POMS], SUM([Portia Cash Rec (Post)].[Total Amount] - [POMS Cash Rec].Total) AS [Rec Difference]

FROM [Portia Cash Rec (Post)] INNER JOIN [POMS Cash Rec] ON [Portia Cash Rec (Post)].Portfolio = [POMS Cash Rec].Portfolio 

GROUP BY Left([POMS Cash Rec].Portfolio,8), Right([POMS Cash Rec].Portfolio,3), [Portia Cash Rec (Post)].[Total Amount], [POMS Cash Rec].Total, [POMS Cash Rec].Portfolio

HAVING ((([Portia Cash Rec (Post)].[Total Amount])<>[POMS Cash Rec].[Total]) AND (([POMS Cash Rec].Portfolio)<'zmonth') 
AND (IIf(Right([POMS Cash Rec].Portfolio,3) ='GBp','M','NM') <> 'NM')
)
ORDER BY Portfolio, CCY;
GO


