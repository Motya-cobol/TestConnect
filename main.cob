       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
      * 
       DATA DIVISION.
      * 
       WORKING-STORAGE SECTION.
       COPY "connect_fn".
       COPY "check_err_fn".
       COPY "read_fn".       
      * connect fields with variable length 
       01  WS-DBNAME            PIC X(9).
       01  WS-USERID            PIC X(20).
       01  WS-PSWD              PIC X(20).
       01  WS-SEX               PIC X(1).
       01  WS-RECORD-COUNTER    PIC 9(5) VALUE ZERO.
      * 
       LOCAL-STORAGE SECTION. 
      *
       LINKAGE SECTION.
      *
       PROCEDURE DIVISION.
           DISPLAY "Please Enter DataBase Name:" with no advancing
           ACCEPT WS-DBNAME

           DISPLAY "Please Enter User Name:" with no advancing
           ACCEPT WS-USERID 

           DISPLAY "Please Enter Password:" with no advancing
           ACCEPT WS-PSWD 

           INITIALIZE LN-CONNECT 
           MOVE WS-DBNAME TO LN-DBNAME OF LN-CONNECT 
           MOVE WS-USERID TO LN-USERID OF LN-CONNECT 
           MOVE WS-PSWD   TO LN-PSWD OF LN-CONNECT 
      *
           SET LN-CONNECT-START OF LN-CONNECT TO TRUE
           CALL "CONNECT_FN" USING LN-CONNECT LN-ERROR 
           IF LN-SQLCODE OF LN-ERROR EQUAL ZERO THEN
              DISPLAY "Connect Successful"
           ELSE
              DISPLAY "Connect Failed" 
              PERFORM PRINT-ERRORS
           END-IF 
      *
           DISPLAY "Please Enter Employee SEX M/F:" with no advancing
           ACCEPT WS-SEX     
      *
           DISPLAY "Opening cursor..."
           INITIALIZE LN-READ 
           MOVE WS-SEX TO LN-SEX OF LN-READ 
           SET LN-READ-OPEN OF LN-READ-FUNC OF LN-READ TO TRUE
           CALL "READ_FN" USING LN-READ LN-ERROR.
           IF LN-SQLCODE OF LN-ERROR EQUAL ZERO THEN
              DISPLAY "Cursor Open Successful"
           ELSE
              DISPLAY 
              "Error Codes displaying from MAIN AFTER Opening CURSOR"
              PERFORM PRINT-ERRORS
           END-IF
      *
           DISPLAY "Fetching all records from cursor..."                      
           SET LN-READ-FETCH OF LN-READ-FUNC OF LN-READ TO TRUE
           CALL "READ_FN" USING LN-READ LN-ERROR
      * IF first call to READ_FN is successful enter the loop
      *    and fetch all the records that fit WS-SEX criteria    
           IF LN-SQLCODE OF LN-ERROR EQUAL ZERO THEN
              PERFORM UNTIL LN-SQLCODE OF LN-ERROR EQUAL +100
                 ADD 1 TO WS-RECORD-COUNTER
                 DISPLAY LN-FIRST-NAME OF LN-READ SPACE
                         LN-LAST-NAME OF LN-READ      
                 CALL "READ_FN" USING LN-READ LN-ERROR                          
              END-PERFORM
           END-IF 
      *
      * IF CALL READ_FN retuned with errors
           IF LN-SQLCODE OF LN-ERROR NOT EQUAL +100 THEN           
              DISPLAY 
              "Error Codes displaying from MAIN AFTER Fetching CURSOR"
              PERFORM PRINT-ERRORS
           END-IF
      *
           DISPLAY "Total Records Fetched: " WS-RECORD-COUNTER
      *
           DISPLAY "Resetting connection"
           SET LN-CONNECT-RESET OF LN-CONNECT TO TRUE
           CALL "CONNECT_FN" USING LN-CONNECT LN-ERROR 
           IF LN-SQLCODE OF LN-ERROR EQUAL ZERO THEN
              DISPLAY "Resetting connection Successful"
           ELSE 
              DISPLAY "Reset Conection Failed"
              PERFORM PRINT-ERRORS
           END-IF 
      *
           DISPLAY "Testing wrong connect function..."
           MOVE "BS" TO LN-FUNC IN LN-CONNECT
           CALL "CONNECT_FN" USING LN-CONNECT LN-ERROR 
           IF LN-SQLCODE OF LN-ERROR EQUAL ZERO THEN
              DISPLAY "That's Weird. This shouldn't have happened"
           ELSE 
              DISPLAY 
                 "Testing wrong connect function failed as it should"
              PERFORM PRINT-ERRORS
           END-IF 
           
           STOP RUN.
       PRINT-ERRORS SECTION.
      *          
           DISPLAY "Error Code = " LN-SQLCODE
           DISPLAY "Error Buffer = " LN-ERROR-BUFFER
           DISPLAY "SQL State = " LN-STATE 
           DISPLAY "SQL State Buffer = " LN-STATE-BUFFER     
           .
       END PROGRAM MAIN.