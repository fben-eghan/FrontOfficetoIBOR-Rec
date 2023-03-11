/*
The output of the stored procedure would be a table called "Holdings Diffs" which contains information about discrepancies between the holdings data from the Portia and POMS systems.

The table would have the following columns:

Portfolio: the portfolio identifier, which is either the first 8 characters of the PfoSedol value in the case of POMS, or the portfolio name in the case of Portia.
Security: the name of the security.
Sedol: the SEDOL identifier for the security.
Ticker: the ticker symbol for the security.
Portia: the quantity of the security held in the Portia system.
POMS: the quantity of the security held in the POMS system.
Rec Difference: the difference between the Portia and POMS quantities for the security.
An example output of the procedure might look like this:

Portfolio	Security	Sedol	  Ticker	Portia	POMS	Rec Difference
ABCDEFGH	XYZ Inc.	1234567 	XYZ	  1000	  950	    -50
HIJKLMNO	ABC Corp	7890123 	ABC	  500	    0	      -500
PQRSTUVW	DEF Inc.	3456789 	DEF	  200	    220	    20

In this example, the first row indicates that for the security with Sedol 123456, the Portia system shows a quantity of 1000, while the POMS system shows a quantity of 950.
The "Rec Difference" column shows a negative value of -50, indicating that the Portia system holds 50 fewer units of the security than the POMS system.
The second row indicates that for the security with Sedol 789012, the Portia system shows a quantity of 500, while the POMS system shows a quantity of 0,
indicating that the Portia system holds 500 more units of the security than the POMS system. 
The third row indicates that for the security with Sedol 345678, the Portia system shows a quantity of 200, while the POMS system shows a quantity of 220,
indicating that the POMS system holds 20 more units of the security than the Portia system.
*\
