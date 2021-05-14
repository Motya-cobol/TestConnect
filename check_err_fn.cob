      ********************************
      * GET ERROR MESSAGE through GET ERROR MESSAGE APIs 
      *       sqlgintp & sqlggstt
      * Each SQLSTATE & SQLCODE buffers retruned as is without 
      *    Line delimination
      ********************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CHECK_ERR_FN.
       ENVIRONMENT DIVISION.                                   
       CONFIGURATION SECTION.                                  
      * 
       DATA DIVISION.
      * 
       WORKING-STORAGE SECTION.
      * connect fields with variable length 
       01  WS-ERROR       PIC S9(9) COMP-5.
       01  WS-STATE       PIC S9(9) COMP-5.
      * Maximum Buffer Size 
       01  WS-BUFFER-SIZE PIC S9(4) COMP-5  VALUE 1024.
      * Maximum line lenght, no parsing in this function
       01 WS-LINE-LENGTH   PIC S9(4) COMP-5  VALUE 1024.
       01 WS-ERROR-BUFFER PIC X(1024).
       01 WS-STATE-BUFFER PIC X(1024).
      *
       LOCAL-STORAGE SECTION. 
      *
       LINKAGE SECTION.

       COPY "sqlca.cbl".
       COPY "check_err_fn".
      *
       PROCEDURE DIVISION USING SQLCA LN-ERROR.
      * 
           INITIALIZE LN-ERROR
      * GET SQLCODE Message
           CALL "sqlgintp" using
              by value WS-BUFFER-SIZE 
              by value WS-LINE-LENGTH 
              by reference SQLCA
              by reference WS-ERROR-BUFFER 
              returning WS-ERROR.
      * GET SQLSTATE MESSAGE 
           call "sqlggstt" using
              by value WS-BUFFER-SIZE 
              by value WS-LINE-LENGTH 
              by reference SQLSTATE 
              by reference WS-STATE-BUFFER
              returning WS-STATE.
      * Fill in return values of LN-ERROR
      * sqlgintp returns -2 if there is no error (SQLCODE == 0)
           IF WS-ERROR EQUAL -2 THEN 
              MOVE ZERO TO LN-SQLCODE OF LN-ERROR
           ELSE MOVE SQLCODE to LN-SQLCODE OF LN-ERROR
           END-IF           
           MOVE WS-ERROR-BUFFER TO LN-ERROR-BUFFER OF LN-ERROR

      * sqlggstt Returns Positive integer indicating the number of
      *     bytes in the formatted message.
      * if so, move SQLSTATE into LN-ERROR field
      * if sqlggst returned negative, it means there was 
      *    an error retrieveing SQLSTATE message
           IF WS-STATE GREATER THAN ZERO THEN 
              MOVE SQLSTATE TO LN-STATE OF LN-ERROR
           ELSE
              MOVE WS-STATE TO LN-STATE OF LN-ERROR
           END-IF 
           MOVE WS-STATE-BUFFER TO LN-STATE-BUFFER OF LN-ERROR
      
      D     DISPLAY "Error Codes displaying from CHKER_FN" 
      D     DISPLAY "Error Code = " LN-SQLCODE
      D     DISPLAY "Error Buffer = " LN-ERROR-BUFFER
      D     DISPLAY "SQL State = " LN-STATE 
      D     DISPLAY "SQL State Buffer = " LN-STATE-BUFFER

           EXIT.

       END PROGRAM CHECK_ERR_FN.