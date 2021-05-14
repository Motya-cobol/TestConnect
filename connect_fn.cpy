       01  LN-CONNECT.
           10 LN-FUNC             PIC X(2).
      * CN for CONNECT
      * CR for CONNECT RESET     
              88 LN-CONNECT-START   VALUE "CN".
              88 LN-CONNECT-RESET   VALUE "CR".
           10 LN-DBNAME      PIC X(9).
           10 LN-USERID      PIC X(20).
           10 LN-PSWD        PIC X(20).
           10 BS-PARAM       PIC S9(10).
           