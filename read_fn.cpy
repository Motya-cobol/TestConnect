      *    This is a copybook for passing parameters to READ_FN
      *    Parameters are passed by reference
      *    Example: 
      *       1) To open cursor for retrieving male employees
      *          SET LN-READ-FUNC OF LN-READ TO TRUE
      *          MOVE 'M' to LN-SEX
      *       2) To update current cursor record
      *          SET LN-READ-UPDATE OF LN-READ TO TRUE
      *          MOVE value to be updated to 
      *             LN-SEX
      *       At the moment only functionality for updating sex 
      *          of the employee is supported
       01  LN-READ.
           10 LN-READ-FUNC             PIC X(2).
      * OP for Open cursor
      * CL for Close cursor
      * FE for Fetch record
      * UP for Update record
              88 LN-READ-OPEN   VALUE "OP".
              88 LN-READ-CLOSE  VALUE "CL".
              88 LN-READ-FETCH  VALUE "FE".
              88 LN-READ-UPDATE VALUE "UP".
           10 LN-FIRST-NAME     PIC X(12).
           10 LN-LAST-NAME      PIC X(15).
           10 LN-SEX            PIC X(1).
           10 BS-PARAM       PIC S9(10).