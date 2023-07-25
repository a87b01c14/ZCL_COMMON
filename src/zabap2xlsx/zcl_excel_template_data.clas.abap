class ZCL_EXCEL_TEMPLATE_DATA definition
  public
  final
  create public .

public section.

  types:
    tt_sheet_titles TYPE STANDARD TABLE OF zexcel_sheet_title WITH DEFAULT KEY .
  types:
    BEGIN OF ts_template_data_sheet,
             sheet TYPE zexcel_sheet_title,
             data  TYPE REF TO data,
           END OF ts_template_data_sheet .
  types:
    tt_template_data_sheets TYPE STANDARD TABLE OF ts_template_data_sheet WITH DEFAULT KEY .

  data MT_DATA type TT_TEMPLATE_DATA_SHEETS read-only .

  methods ADD
    importing
      !IV_SHEET type ZEXCEL_SHEET_TITLE
      !IV_DATA type DATA .
  methods ADD_DATA
    importing
      !IS_DATA type ZCL_EXCEL_TEMPLATE_DATA=>TS_TEMPLATE_DATA_SHEET .
  methods CONSTRUCTOR
    importing
      !IT_DATA type ZCL_EXCEL_TEMPLATE_DATA=>TT_TEMPLATE_DATA_SHEETS optional .
  PROTECTED SECTION.
private section.
ENDCLASS.



CLASS ZCL_EXCEL_TEMPLATE_DATA IMPLEMENTATION.


  METHOD add.
    FIELD-SYMBOLS: <ls_data_sheet> TYPE ts_template_data_sheet,
                   <any>           TYPE any.

    APPEND INITIAL LINE TO mt_data ASSIGNING <ls_data_sheet>.
    <ls_data_sheet>-sheet = iv_sheet.
    CREATE DATA  <ls_data_sheet>-data LIKE iv_data.

    ASSIGN <ls_data_sheet>-data->* TO <any>.
    <any> = iv_data.

  ENDMETHOD.


  METHOD add_data.
    APPEND is_data TO mt_data.
  ENDMETHOD.


  METHOD constructor.
    mt_data = it_data.
  ENDMETHOD.
ENDCLASS.
