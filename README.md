# Linux DB2 GnuCobol EmbeddedSQL
This is a simple project demosntrating working with embedded SQL cursors in GnuCobol.  
It connects to the sample database with username and password.  
Opens cursor with a parameter and fetches all the records form the EMPLOYEE table that fit the paramter.  
As records are being fetched, the user can update the selection criteria.  
At the end, the user is given an option of saving all the changes or rolling them back.  

## Prerequisites
1. Community edition DB2 for Linux.
    * the project uses typical install with SAMPLE database.
2. IBM Data Server Driver Package software.
3. GnuCobol version 3.1 or later.
4. Debugging is done via D comments of GnuCobol and **cobcd** wrapper that works with gdb.
    * **cobcd** - GnuCobol debugger with VScode extension. All the credit goes to Bob Dubner from COBOLworx.
        For all the technical inquries and HOWTOs please contact them at info@cobolworx.com
    * For **cobcd** to work with full functionality your gdb needs to be version 8.3 or later
        Keep in mind that default UBUNTU 18.04 comes with version 8.1 - **Not good enough**

## Compling and running
1. Set up DB2 environment by running IBM supplied bash script.
    `. /home/db2instance/sqllib/db2profile` Replace "db2instance" with your default DB2 instance
    The project assumes that DB2 is installed with a separate instance and its password. Or DB admin has created appropriate login credentials for the developer. This is done to separate DB admin and production environment on your workstation.
2. Start DB2 by `db2start`    
2. `make demo`
3. `./demo`
    * Follow the prompts. You need to have access to default SAMPLE database with user and password.

## List of files and naming conventions
This is not a typical COBOL application. But since it's GnuCobol, I approached this project as if it's a normal C code. Meaning, short files that code for separate functionality.
### File Extensions
`.cob` - Files that do not requre DB2 precompile.  
`.sqb` - Files that need DB2 precompile.  
`.cbm` - COBOL files containing main entry point. For those new to COBOL, it's like main() in C. There should be  only one file with `cbm` extension. In this example `main.cbm` - Main for coding CLI user interraction.  
`.cpy` - COBOL copybook. For those new to COBOL, it's like `.h` in C  
  
`check_err_fn.*` - Functionality for checking DB2 erors by calling DB2 API  
`connect_fn.*` - Functionally for connecting to DB2/terminating connetion, commiting/rollng back the changes.  
`read_fn.*` - Functionality for reading/updating/inserting rows. This is where we use DB2 cursor.  
