REPORT zemployes_report.

*---------------------------------------------------------------------*
* Database table declaration
*---------------------------------------------------------------------*
TABLES zemployees_data.

*---------------------------------------------------------------------*
* Selection screen
*---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

SELECT-OPTIONS:
  s_empid FOR zemployees_data-emp_id,
  s_dept  FOR zemployees_data-department.

SELECTION-SCREEN END OF BLOCK b1.

*---------------------------------------------------------------------*
* Local class definition
*---------------------------------------------------------------------*
CLASS lcl_employee_report DEFINITION FINAL.

  PUBLIC SECTION.

    METHODS:
      run.

  PRIVATE SECTION.

    DATA:
      mt_employees TYPE STANDARD TABLE OF zemployees_data
                   WITH EMPTY KEY,
      mo_alv       TYPE REF TO cl_salv_table.

    METHODS:
      get_data,

      display_alv,

      enable_alv_functions,

      configure_columns
        RAISING
          cx_salv_not_found,

      configure_display,

      configure_layout.

ENDCLASS.

*---------------------------------------------------------------------*
* Local class implementation
*---------------------------------------------------------------------*
CLASS lcl_employee_report IMPLEMENTATION.

*---------------------------------------------------------------------*
* Main controller method
*---------------------------------------------------------------------*
  METHOD run.

* Retrieve employee records from the database
    get_data( ).

* Stop processing if no matching records are found
    IF mt_employees IS INITIAL.

      MESSAGE s001(zemp_msg)
        DISPLAY LIKE 'E'.

      RETURN.

    ENDIF.

* Display employee records in ALV
    display_alv( ).

  ENDMETHOD.

*---------------------------------------------------------------------*
* Retrieve employee records from the database
*---------------------------------------------------------------------*
  METHOD get_data.

* Clear any previously selected records
    CLEAR mt_employees.

* Retrieve records based on the selection-screen criteria
    SELECT *
      FROM zemployees_data
      INTO TABLE mt_employees
      WHERE emp_id     IN s_empid
        AND department IN s_dept.

  ENDMETHOD.

*---------------------------------------------------------------------*
* Create, configure and display the SALV output
*---------------------------------------------------------------------*
  METHOD display_alv.

    DATA:
      lx_salv_msg       TYPE REF TO cx_salv_msg,
      lx_salv_not_found TYPE REF TO cx_salv_not_found.

    TRY.

* Create the SALV table object
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table = mo_alv
          CHANGING
            t_table      = mt_employees ).

* Configure the SALV output
        enable_alv_functions( ).
        configure_columns( ).
        configure_display( ).
        configure_layout( ).

* Display the employee report
        mo_alv->display( ).

*---------------------------------------------------------------------*
* Handle a missing ALV column
*---------------------------------------------------------------------*
      CATCH cx_salv_not_found INTO lx_salv_not_found.

        MESSAGE s003(zemp_msg)
          DISPLAY LIKE 'E'.

*---------------------------------------------------------------------*
* Handle SALV framework errors
*---------------------------------------------------------------------*
      CATCH cx_salv_msg INTO lx_salv_msg.

        MESSAGE s002(zemp_msg)
          DISPLAY LIKE 'E'.

    ENDTRY.

  ENDMETHOD.

*---------------------------------------------------------------------*
* Enable standard ALV toolbar functions
*---------------------------------------------------------------------*
  METHOD enable_alv_functions.

    DATA:
      lo_functions TYPE REF TO cl_salv_functions_list.

* Get the SALV functions controller
    lo_functions = mo_alv->get_functions( ).

* Enable sorting, filtering, printing, export and other functions
    lo_functions->set_all( abap_true ).

  ENDMETHOD.

*---------------------------------------------------------------------*
* Configure the ALV columns
*---------------------------------------------------------------------*
  METHOD configure_columns.

    DATA:
      lo_columns TYPE REF TO cl_salv_columns_table,
      lo_column  TYPE REF TO cl_salv_column_table.

* Get the SALV columns controller
    lo_columns = mo_alv->get_columns( ).

* Automatically optimize all column widths
    lo_columns->set_optimize( abap_true ).

*---------------------------------------------------------------------*
* Hide the technical client field
*---------------------------------------------------------------------*
    lo_column ?= lo_columns->get_column( 'MANDT' ).
    lo_column->set_visible( abap_false ).

*---------------------------------------------------------------------*
* Employee ID column
*---------------------------------------------------------------------*
    lo_column ?= lo_columns->get_column( 'EMP_ID' ).

    lo_column->set_short_text(
      'Emp. ID' ).

    lo_column->set_medium_text(
      'Employee ID' ).

    lo_column->set_long_text(
      'Employee Identifier' ).

*---------------------------------------------------------------------*
* Employee Name column
*---------------------------------------------------------------------*
    lo_column ?= lo_columns->get_column( 'EMP_NAME' ).

    lo_column->set_short_text(
      'Name' ).

    lo_column->set_medium_text(
      'Employee Name' ).

    lo_column->set_long_text(
      'Employee Name' ).

*---------------------------------------------------------------------*
* Department column
*---------------------------------------------------------------------*
    lo_column ?= lo_columns->get_column( 'DEPARTMENT' ).

    lo_column->set_short_text(
      'Dept.' ).

    lo_column->set_medium_text(
      'Department' ).

    lo_column->set_long_text(
      'Employee Department' ).

*---------------------------------------------------------------------*
* Salary column
*---------------------------------------------------------------------*
    lo_column ?= lo_columns->get_column( 'SALARY' ).

    lo_column->set_short_text(
      'Salary' ).

    lo_column->set_medium_text(
      'Salary Amount' ).

    lo_column->set_long_text(
      'Employee Salary Amount' ).

*---------------------------------------------------------------------*
* Currency column
*---------------------------------------------------------------------*
    lo_column ?= lo_columns->get_column( 'CURRENCY' ).

    lo_column->set_short_text(
      'Curr.' ).

    lo_column->set_medium_text(
      'Currency' ).

    lo_column->set_long_text(
      'Salary Currency' ).

*---------------------------------------------------------------------*
* Created By column
*---------------------------------------------------------------------*
    lo_column ?= lo_columns->get_column( 'CREATED_BY' ).

    lo_column->set_short_text(
      'Created By' ).

    lo_column->set_medium_text(
      'Created By' ).

    lo_column->set_long_text(
      'Record Created By' ).

*---------------------------------------------------------------------*
* Created On column
*---------------------------------------------------------------------*
    lo_column ?= lo_columns->get_column( 'CREATED_ON' ).

    lo_column->set_short_text(
      'Created On' ).

    lo_column->set_medium_text(
      'Created On' ).

    lo_column->set_long_text(
      'Record Creation Date' ).

*---------------------------------------------------------------------*
* Changed By column
*---------------------------------------------------------------------*
    lo_column ?= lo_columns->get_column( 'CHANGED_BY' ).

    lo_column->set_short_text(
      'Changed By' ).

    lo_column->set_medium_text(
      'Changed By' ).

    lo_column->set_long_text(
      'Record Last Changed By' ).

*---------------------------------------------------------------------*
* Changed On column
*---------------------------------------------------------------------*
    lo_column ?= lo_columns->get_column( 'CHANGED_ON' ).

    lo_column->set_short_text(
      'Changed On' ).

    lo_column->set_medium_text(
      'Changed On' ).

    lo_column->set_long_text(
      'Record Last Changed On' ).

  ENDMETHOD.

*---------------------------------------------------------------------*
* Configure the ALV title and display settings
*---------------------------------------------------------------------*
  METHOD configure_display.

    DATA:
      lo_display   TYPE REF TO cl_salv_display_settings,
      lv_row_count TYPE i,
      lv_row_text  TYPE char10,
      lv_title     TYPE lvc_title.

* Determine the number of displayed employee records
    DESCRIBE TABLE mt_employees LINES lv_row_count.

* Convert the integer count to character format
    WRITE lv_row_count TO lv_row_text LEFT-JUSTIFIED.

* Build the dynamic report title
    CONCATENATE
      'Employee Management Report - Records:'
      lv_row_text
      INTO lv_title
      SEPARATED BY space.

* Get the SALV display settings
    lo_display = mo_alv->get_display_settings( ).

* Set the dynamic title
    lo_display->set_list_header( lv_title ).

* Enable alternating row formatting
    lo_display->set_striped_pattern( abap_true ).

  ENDMETHOD.

*---------------------------------------------------------------------*
* Configure ALV layout management
*---------------------------------------------------------------------*
  METHOD configure_layout.

    DATA:
      lo_layout     TYPE REF TO cl_salv_layout,
      ls_layout_key TYPE salv_s_layout_key.

* Get the SALV layout controller
    lo_layout = mo_alv->get_layout( ).

* Use the current report name as the layout identifier
    ls_layout_key-report = sy-repid.

* Assign the layout key
    lo_layout->set_key( ls_layout_key ).

* Allow users to save user-specific and global layouts
    lo_layout->set_save_restriction(
      if_salv_c_layout=>restrict_none ).

* Allow a saved layout to be marked as the default layout
    lo_layout->set_default( abap_true ).

  ENDMETHOD.

ENDCLASS.

*---------------------------------------------------------------------*
* Main report event
*---------------------------------------------------------------------*
START-OF-SELECTION.

  DATA:
    lo_report TYPE REF TO lcl_employee_report.

* Create the employee report controller object
  CREATE OBJECT lo_report.

* Execute the employee report
  lo_report->run( ).
