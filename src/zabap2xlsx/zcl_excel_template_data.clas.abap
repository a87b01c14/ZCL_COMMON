CLASS zcl_excel_template_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      tt_sheet_titles TYPE STANDARD TABLE OF zexcel_sheet_title WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ts_template_data_sheet,
        sheet  TYPE zexcel_sheet_title,
        rename TYPE zexcel_sheet_title, "重命名
        clone  TYPE abap_bool, "是否复制sheet
        data   TYPE REF TO data,
      END OF ts_template_data_sheet .
    TYPES:
      tt_template_data_sheets TYPE STANDARD TABLE OF ts_template_data_sheet WITH DEFAULT KEY .

    DATA mt_data TYPE tt_template_data_sheets READ-ONLY .

    METHODS add
      IMPORTING
        !iv_sheet TYPE zexcel_sheet_title
        !iv_data  TYPE data .
    METHODS add_data
      IMPORTING
        !is_data TYPE zcl_excel_template_data=>ts_template_data_sheet .
    METHODS constructor
      IMPORTING
        !it_data TYPE zcl_excel_template_data=>tt_template_data_sheets OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_excel_template_data IMPLEMENTATION.


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
