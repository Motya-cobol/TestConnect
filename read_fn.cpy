       01  LN-READ.
           10 LN-READ-FUNC             PIC X(2).
      * OP for Open cursor
      * CL for Close cursor
      * FE for Fetch record     
              88 LN-READ-OPEN   VALUE "OP".
              88 LN-READ-CLOSE  VALUE "CL".
              88 LN-READ-FETCH  VALUE "FE".
           10 LN-FIRST-NAME     PIC X(12).
           10 LN-LAST-NAME      PIC X(15).
           10 LN-SEX            PIC X(1).
           10 BS-PARAM       PIC S9(10).