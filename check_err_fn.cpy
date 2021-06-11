      *    This is a copybook for passing and receiving 
      *       parameters to CHECK_ERR_FN
      *    LN-SQLCODE is SQLCODE
      *    LN-ERROR-BUFFER is varchar(1024) to hold unformatted 
      *       error text
      *    LN-STAE is SQLSTATE
      *    LN-STAE is varchar(1024) to hold unformatted 
      *       sql state text      
       01  LN-ERROR.
           10    LN-SQLCODE        PIC S9(9) COMP-5 VALUE 0.
           10    LN-ERROR-BUFFER   PIC X(1024) VALUE " ".
           10    LN-STATE          PIC S9(9) COMP-5 VALUE 0.
           10    LN-STATE-BUFFER   PIC X(1024) VALUE " ".
           10    LN-TRAILING-BUFFER        PIC X(1024) VALUE " ".