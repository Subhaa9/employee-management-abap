EMPLOYEE MANAGEMENT AND REPORTING SYSTEM

Project Overview

The Employee Management and Reporting System is a personal SAP ABAP portfolio project developed to demonstrate the creation of a complete reporting application.

The application retrieves fictional employee records from a custom SAP database table and displays the results in a professional ALV report.

This project demonstrates practical knowledge of the SAP ABAP Dictionary, Open SQL, selection screens, internal tables, object-oriented ABAP, SALV reporting, Table Maintenance Generator, exception handling, testing, and technical documentation.

All employee records used in this project are fictional and are intended only for learning, testing, and portfolio demonstration.


BUSINESS REQUIREMENT

The objective of this project is to create an SAP ABAP reporting application that allows users to retrieve and view fictional employee records.

The application supports the following requirements:

- Maintain fictional employee records in a custom database table
- Filter records by employee ID
- Filter records by department
- Allow single values, ranges, multiple values, and exclusions
- Retrieve records using Open SQL
- Display matching records in an ALV report
- Display a clear message when no matching records are found
- Provide standard ALV sorting, filtering, printing, and export functions
- Display salary values with the corresponding currency
- Track record creation and modification information
- Allow users to save personalized ALV layouts


SAP OBJECTS

1. Database Table

Object Name: ZEMPLOYEES_DATA

Purpose:

The table stores fictional employee information.

Primary Key:

- MANDT
- EMP_ID

Fields:

- MANDT: SAP client
- EMP_ID: Unique employee identifier
- EMP_NAME: Employee name
- DEPARTMENT: Employee department
- SALARY: Employee salary amount
- CURRENCY: Salary currency key
- CREATED_BY: User who created the record
- CREATED_ON: Date on which the record was created
- CHANGED_BY: User who last changed the record
- CHANGED_ON: Date on which the record was last changed

The table is client-dependent because MANDT is included as the first primary-key field.


2. Executable Report

Object Name: ZEMPLOYES_REPORT

Purpose:

The report retrieves employee records from ZEMPLOYEES_DATA and displays the results using CL_SALV_TABLE.

Selection Criteria:

- Employee ID
- Department


3. Function Group

Object Name: ZEMP_FG

Purpose:

The function group contains the generated Table Maintenance Generator objects for ZEMPLOYEES_DATA.


4. Message Class

Object Name: ZEMP_MSG

Messages:

- 001: No employee records found for the selected criteria
- 002: An error occurred while displaying the employee report
- 003: A required ALV column could not be found


5. Transaction Code

Object Name: ZEMP_REPORT

Purpose:

The transaction code allows users to execute ZEMPLOYES_REPORT without opening SE38.


APPLICATION FLOW

User
  |
  v
Selection Screen
  |
  v
ZEMPLOYES_REPORT
  |
  v
Open SQL Query
  |
  v
ZEMPLOYEES_DATA
  |
  v
Internal Table
  |
  v
CL_SALV_TABLE
  |
  v
ALV Output


MAIN FEATURES

Selection Screen

The report provides selection options for:

- Employee ID
- Department

The selection options support:

- Single values
- Ranges
- Multiple values
- Inclusive selections
- Exclusive selections
- Blank selections

When both selection fields are blank, the report retrieves all available employee records from the current SAP client.


Database Retrieval

The report uses Open SQL to retrieve employee records.

The selection criteria are passed directly to the database query. This avoids selecting unnecessary records and filtering them later in the ABAP application server.


No-Data Handling

After retrieving the employee records, the report checks whether the internal table is empty.

If no records match the selection criteria, the report displays the following message:

No employee records found for the selected criteria

The report then stops processing and does not open an empty ALV.


ALV Output

The report uses CL_SALV_TABLE to display the employee records.

The ALV output provides:

- Sorting
- Filtering
- Spreadsheet export
- Printing
- Optimized column widths
- User-friendly column headings
- Alternating row formatting
- Dynamic record count
- Saved layout support

The technical MANDT field is hidden because it is not required by business users.


Currency Configuration

The SALARY field uses the CURRENCY field as its currency reference.

Configuration:

- Amount field: SALARY
- Reference table: ZEMPLOYEES_DATA
- Reference field: CURRENCY

This configuration allows SAP to interpret and display every salary amount using the corresponding currency key.


AUDIT FIELDS

The table contains the following audit fields:

- CREATED_BY
- CREATED_ON
- CHANGED_BY
- CHANGED_ON

Expected behavior for a new record:

- CREATED_BY contains the current SAP user
- CREATED_ON contains the current SAP system date
- CHANGED_BY contains the current SAP user
- CHANGED_ON contains the current SAP system date

Expected behavior when an existing record is updated:

- CREATED_BY remains unchanged
- CREATED_ON remains unchanged
- CHANGED_BY is updated with the current SAP user
- CHANGED_ON is updated with the current SAP system date

These fields can be populated during SM30 maintenance by using an appropriate Table Maintenance Generator event before the data is saved.


TECHNICAL CONCEPTS USED

This project demonstrates the following SAP ABAP concepts:

- ABAP Dictionary database table
- Client-dependent table design
- Primary-key configuration
- Standard SAP data elements
- Currency reference configuration
- Table Maintenance Generator
- Selection screens
- SELECT-OPTIONS
- Open SQL
- Internal tables
- Local ABAP classes
- Object-oriented modularization
- Methods
- Exception handling
- Message classes
- CL_SALV_TABLE
- ALV functions
- ALV column configuration
- ALV display settings
- ALV layout management
- Custom transaction code
- Functional testing
- GitHub portfolio documentation


PROGRAM STRUCTURE

The ABAP report is modularized using a local class.

The main methods include:

RUN

Controls the overall report execution.

GET_DATA

Retrieves employee records from ZEMPLOYEES_DATA using the selection-screen criteria.

DISPLAY_ALV

Creates, configures, and displays the SALV report.

ENABLE_ALV_FUNCTIONS

Enables standard ALV functions such as sorting, filtering, printing, and spreadsheet export.

CONFIGURE_COLUMNS

Optimizes column widths, hides MANDT, and assigns user-friendly column headings.

CONFIGURE_DISPLAY

Creates the dynamic ALV title, displays the number of selected records, and enables alternating row formatting.

CONFIGURE_LAYOUT

Allows users to save and reuse personalized ALV layouts.


TABLE MAINTENANCE

A Table Maintenance Generator was created for ZEMPLOYEES_DATA.

Maintenance information:

- Maintenance transaction: SM30
- Function group: ZEMP_FG
- Maintenance type: One-step maintenance

Table maintenance should only be available to authorized users.


TESTING

The following test scenarios were completed:

1. Execute without filters

Expected result:

All employee records are displayed.


2. Filter by employee ID

Expected result:

Only the selected employee is displayed.


3. Filter by department

Expected result:

Only employees belonging to the selected department are displayed.


4. Filter by employee ID and department

Expected result:

The record is displayed only when both selection criteria match.


5. Use mismatched selection criteria

Expected result:

The report displays the no-records-found message.


6. Enter an invalid employee ID

Expected result:

The report displays the no-records-found message and does not open the ALV.


7. Enter an employee ID range

Expected result:

Only employee records within the selected range are displayed.


8. Select multiple employee IDs

Expected result:

Only the selected employee records are displayed.


9. Exclude an employee ID

Expected result:

All matching employees except the excluded employee are displayed.


10. Test ALV sorting and filtering

Expected result:

The displayed records can be sorted and filtered without changing the database data.


11. Test spreadsheet export

Expected result:

The displayed fictional employee records can be exported using the standard ALV function.


12. Verify salary and currency

Expected result:

Salary values are displayed with the correct corresponding currency.


13. Save an ALV layout

Expected result:

The saved layout is available for reuse when the report is executed again.


HOW TO RUN THE APPLICATION

Option 1: Execute using the custom transaction

1. Open the SAP command field.
2. Enter ZEMP_REPORT.
3. Press Enter.
4. Enter optional employee ID or department criteria.
5. Execute the report.

Option 2: Execute using SE38

1. Open transaction SE38.
2. Enter ZEMPLOYES_REPORT.
3. Choose Execute.
4. Enter optional selection criteria.
5. Execute the selection screen.
6. Review the matching records in the ALV output.


REPOSITORY CONTENTS

The repository contains:

- Complete ABAP report source code
- Database table design information
- Fictional sample employee data
- Application architecture details
- SAP object inventory
- Functional test cases
- Project documentation


SECURITY AND AUTHORIZATION

Employee and salary information can be sensitive in a real implementation.

A production-quality solution should include:

- Report execution authorization
- Table maintenance authorization
- Salary-data access controls
- Appropriate authorization groups
- Controlled transport management
- Data privacy requirements
- Data retention policies

Direct table maintenance should not be provided to unauthorized users.


PERFORMANCE CONSIDERATIONS

The report applies the user’s selection criteria directly in the Open SQL statement.

This ensures that only matching records are transferred from the database to the ABAP application server.

For this learning project, the report retrieves the complete employee table structure because all business fields are displayed.

For a production implementation:

- Select only the required database columns
- Avoid unrestricted selection from very large tables
- Avoid database queries inside loops
- Evaluate secondary indexes based on measured access patterns
- Review database performance using appropriate SAP tools
- Consider result limits or pagination for large datasets


DATA PRIVACY

This repository contains only fictional employee records.

The repository does not contain:

- Real employee information
- Production data
- Customer-specific source code
- Company-confidential business logic
- SAP credentials
- Passwords
- API keys
- Authentication tokens
- Internal server details
- SAP system addresses
- Transport request numbers

Any screenshots added to the repository should be reviewed, cropped, and redacted before publication.


LIMITATIONS

- The project is intended for learning and portfolio demonstration.
- The application does not implement a complete employee lifecycle.
- CL_SALV_TABLE is primarily used for display and reporting.
- Table Maintenance Generator events run only during generated table maintenance.
- TMG events do not run when another ABAP program performs a direct database insert or update.
- Programs performing direct database changes must populate the audit fields separately.


FUTURE ENHANCEMENTS

Possible future improvements include:

- Department check table
- Department foreign-key relationship
- Department search help
- Custom authorization object
- Timestamp fields
- Employee active or inactive status
- Salary range selection
- Additional reporting and aggregation
- ABAP Unit tests
- Application logging
- CDS-based reporting
- RAP-based user interface
- abapGit integration


DISCLAIMER

This is an independent SAP ABAP learning and portfolio project.

The project contains fictional information only. It does not contain SAP standard source code, real employee information, production data, customer implementation details, or proprietary business information.
