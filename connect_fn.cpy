      *    This is a copybook for passing parameters to CONNECT_FN
      *    Example: to start new DB2 connection
      *       SET LN-CONNECT-START OF LN-CONNECT TO TRUE
      *       MOVE connect credentials to 
      *          LN-DBNAME, LN-USERID, LN-PSWD
      * 
       01  LN-CONNECT.
           10 LN-FUNC             PIC X(2).
      * CN for CONNECT
      * CR for CONNECT RESET    
      * CM for CONNECT COMMIT
      * RB for CONNECT ROLLBACK 
              88 LN-CONNECT-START     VALUE "CN".
              88 LN-CONNECT-RESET     VALUE "CR".
              88 LN-CONNECT-COMMIT    VALUE "CM".
              88 LN-CONNECT-ROLLBACK  VALUE "RB".
      * DATABASE name
           10 LN-DBNAME      PIC X(9).
      * User ID     
           10 LN-USERID      PIC X(20).
      * Password
           10 LN-PSWD        PIC X(20).
      * Buffer for passing parameters by reference.
           10 BS-PARAM       PIC S9(10).
           