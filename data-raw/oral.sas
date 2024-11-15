*--------------------------------------------------------------
* Effects of delay in oral practice of second language learning
*       grp 1 = 4 week delay (exptl grp)
*       grp 2 = 0 delay (control grp)
*--------------------------------------------------------------;
data oral;
    input subjno grp listen speak read write;
    length group $ 8;
    if grp=1 then group='EXPTL';
    if grp=2 then group='CONTROL';
    drop grp;
cards;
 1 1 34 66 39 97
 2 1 35 60 39 95
 3 1 32 57 39 94
 4 1 29 53 39 97
 5 1 37 58 40 96
 6 1 35 57 34 90
 7 1 34 51 37 84
 8 1 25 42 37 80
 9 1 29 52 37 85
10 1 25 47 37 94
11 1 34 55 35 88
12 1 24 42 35 88
13 1 25 59 32 82
14 1 34 57 35 89
15 1 35 57 39 97
16 1 29 41 36 82
17 1 25 44 30 65
18 1 28 51 39 96
19 1 25 42 38 86
20 1 30 43 38 91
21 1 27 50 39 96
22 1 25 46 38 85
23 1 22 33 27 72
24 1 19 30 35 77
25 1 26 45 37 90
26 1 27 38 33 77
27 1 30 36 22 62
28 1 36 50 39 92
 1 2 33 56 36 81
 2 2 21 39 33 74
 3 2 29 47 35 89
 4 2 22 42 34 85
 5 2 39 61 40 97
 6 2 34 58 38 94
 7 2 29 38 34 76
 8 2 21 42 38 83
 9 2 18 35 28 58
10 2 36 51 36 83
11 2 25 45 36 67
12 2 33 43 36 86
13 2 29 50 37 94
14 2 30 50 34 84
15 2 34 49 38 94
16 2 30 42 34 77
17 2 25 47 36 66
13 2 32 37 38 88
19 2 22 44 22 85
20 2 30 35 35 77
21 2 34 45 38 95
22 2 31 50 37 96
23 2 21 36 19 43
24 2 26 42 33 73
25 2 30 49 36 88
26 2 23 37 36 82
27 2 21 43 30 85
28 2 30 45 34 70
;
title '2 sample T-Square data from Timm';
title2 'Effects of delay on oral practice';
* (1) Standard analysis with GLM;
PROC GLM DATA=ORAL;
        CLASS GROUP;
        MODEL LISTEN--WRITE = GROUP / ss3;
        MANOVA H = GROUP / SHORT;
Title3 'Output from Proc GLM';
 
* (2) A similar analysis is produced by CANDISC
      but with more detail & output data sets;
PROC CANDISC DATA=ORAL
             OUT=DISC            /* output disc. function scores */
             OUTSTAT=CANSTAT;    /* output SSCP matrices         */
     CLASS GROUP;
     VAR   LISTEN SPEAK READ WRITE;
     Title3 'Output from CANDISC Procedure';
 
/* CANDISC produces two output data sets:
     DISC contains the original scores + discriminant function scores
     CANSTAT contains the various SSCP and other matrices (identified
          by a _TYPE_ variable
*/
proc print data=disc;
     id subjno group;
     Var LISTEN--WRITE CAN1;
     Title3 'Scores on discriminant function';
 
proc ttest data=disc;
     class group;
     var can1;
title3 'Univariate t-test on discriminant scores ';
run;
/*  The section below is used to calculate Hotelling's T2
    from the CANDISC output, to show that T2 = square of
    univariate t-value from discriminant scores
*/
data canstat;
     set canstat;
     If _TYPE_='BSSCP' |     /* The QH (between) SSCP matrix */
        _TYPE_='PSSCP' |     /* The QE (within)  SSCP matrix */
       (_TYPE_='MEAN' & GROUP ^=' ') ;
proc print data=canstat;
     By _TYPE_ NOTSORTED;    /* the _TYPE_s are not alphabetical */
     Id _TYPE_;
     Title3 'QH QE and MEAN from CANSTAT';
run;
Data QH QE YDOT;
     Set CANSTAT;
     Drop GROUP _TYPE_ ;
     If _TYPE_='BSSCP' then output QH;
     If _TYPE_='PSSCP' then output QE;
     If _TYPE_='MEAN'  then output YDOT;
 
proc iml;
  reset autoname  fw=8;
 
      /* GET the matrices from CANDISC */
  use YDOT ;
  read all into YDOT ;
  use QE ;
  read all into QE [colname=LAB];
  use QH ;
  read all into QH ;
  GPS ={ 'EXPTL' 'CONTROL'};
  print 'Output from PROC IML';
  print "Group means, QH and QE matrices";
  print YDOT[rowname=GPS colname=LAB];
  print QH[  rowname=LAB colname=LAB];
  print QE[  rowname=LAB colname=LAB];
       *--- COMPUTE HOTELLING'S T-SQUARE;
  S = QE/{54};
  YDIFF = ( YDOT[1,] - YDOT[2,])`;
  TSQUARE = ((28#28)/56)# YDIFF` * INV(S) * YDIFF;
* print "Pooled Variance-Covariance Matrix";
* print S[ rowname=LAB colname=LAB];
  print 'Difference in means',
        YDIFF[ rowname=LAB];
  print "Hotelling's T-Square", TSQUARE;
quit;
