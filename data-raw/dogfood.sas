title 'Dog Food: One Way Completely Randomized Manova Design';
* Source: Multivariate Statistical Methods: Practical Applications
          Course Notes, R. Hamer, 1989;
data dogfood;
   input formula $ @;
   do dog=1 to 4;
      input start amount @@;
      output;
      end;
   label formula ='Dog food type'
         start   ='Time to start eating'
         amount  ='Amount eaten';
datalines;
OLD    0 100   1 97    1 88   0 92
NEW    0  95   1 85    2 82   3 89
MAJOR  1  77   5 84    3 78   1 89
ALPS   2  72   3 82    4 85   0 74
;
