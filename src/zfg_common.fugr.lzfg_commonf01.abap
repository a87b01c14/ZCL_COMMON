*----------------------------------------------------------------------*
***INCLUDE LZFG_COMMONF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  RELEASE_OBJECTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM release_objects .

  IF NOT cl_document IS INITIAL.
    CALL METHOD cl_document->close_document
      IMPORTING
        error   = error
        retcode = retcode.

    FREE cl_document.
    IF retcode NE 'OK'.
      LEAVE PROGRAM.
    ENDIF.
  ENDIF.


  IF NOT cl_control IS INITIAL.
    CALL METHOD cl_control->destroy_control
      IMPORTING
        error   = error
        retcode = retcode.
    FREE cl_control.
    IF retcode NE 'OK'.
      LEAVE PROGRAM.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FRM_SHOW_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM frm_show_excel .
  DATA: has TYPE i.
  CHECK NOT cl_writer IS BOUND.
  IF g_xlsm = 'X'.
    CREATE OBJECT cl_writer TYPE zcl_excel_writer_xlsm.
  ELSE.
    CREATE OBJECT cl_writer TYPE zcl_excel_writer_2007.
  ENDIF.

  xdata = cl_writer->write_file( cl_excel ).
  t_rawdata = cl_bcs_convert=>xstring_to_solix( iv_xstring = xdata ).
  bytecount = xstrlen( xdata ).

  c_oi_container_control_creator=>get_container_control( IMPORTING control = cl_control
                                                                   error   = error
                                                                   retcode = retcode ).
  PERFORM handle_error USING 'X'.
  cl_control->init_control( EXPORTING  inplace_enabled       = 'X'
                                       no_flush              = 'X'
                                       inplace_show_toolbars = ''
                                       r3_application_name   = 'Document Container'
                                       parent                = cl_gui_container=>screen0
                            IMPORTING  error                 = error
                                       retcode               = retcode
                            EXCEPTIONS OTHERS                = 2 ).

  PERFORM handle_error USING 'X'.
  cl_control->get_document_proxy( EXPORTING document_type  = 'Excel.Sheet'                " EXCEL
                                            no_flush       = ' '
                                  IMPORTING document_proxy = cl_document
                                            error          = error
                                            retcode        = retcode ).

* Errorhandling should be inserted here
  PERFORM handle_error USING 'X'.
  cl_document->open_document_from_table( EXPORTING document_size  = bytecount
                                                   document_table = t_rawdata
                                                   open_inplace   = 'X'
                                         IMPORTING error          = error
                                                   retcode        = retcode ).
  PERFORM handle_error USING 'X'.



  CALL METHOD cl_document->has_spreadsheet_interface
*    EXPORTING
*      no_flush     = 'X'
    IMPORTING
      is_available = has
      error        = error
      retcode      = retcode.

  PERFORM handle_error USING 'X'.

  CALL METHOD cl_document->get_spreadsheet_interface
    EXPORTING
      no_flush        = ' '
    IMPORTING
      sheet_interface = cl_spreadsheet
      error           = error
      retcode         = retcode.

  PERFORM handle_error USING 'X'.
  IF g_autoprint = 'X'.
    PERFORM print_data.
    CLEAR g_autoprint.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  FRM_SHOW_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM frm_show_excel_java .
  DATA: has TYPE i.
  DATA: lo_viewer TYPE REF TO c_oi_document_viewer.
  CHECK NOT cl_writer IS BOUND.
  IF g_xlsm = 'X'.
    CREATE OBJECT cl_writer TYPE zcl_excel_writer_xlsm.
  ELSE.
    CREATE OBJECT cl_writer TYPE zcl_excel_writer_2007.
  ENDIF.

  xdata = cl_writer->write_file( cl_excel ).
  t_rawdata = cl_bcs_convert=>xstring_to_solix( iv_xstring = xdata ).
  bytecount = xstrlen( xdata ).

  lo_viewer = NEW c_oi_document_viewer( ).
  lo_viewer->i_oi_document_viewer~init_viewer( EXPORTING  parent             = cl_gui_container=>screen0
                                               EXCEPTIONS cntl_error         = 0
                                                          cntl_install_error = 1
                                                          dp_install_error   = 2
                                                          dp_error           = 3
                                                          OTHERS             = 4 ).

  CHECK sy-subrc = 0.
  lo_viewer->i_oi_document_viewer~view_document_from_table( EXPORTING  size                 = bytecount
                                                                       type                 = 'application'
                                                                       subtype              = 'vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                                                                       show_inplace         = 'X'
                                                            CHANGING   document_table       = t_rawdata
                                                            EXCEPTIONS dp_invalid_parameter = 0
                                                                       dp_error_general     = 1
                                                                       cntl_error           = 2
                                                                       not_initialized      = 3
                                                                       invalid_parameter    = 4
                                                                       OTHERS               = 5
                                                                      ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRINT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_data .
  CALL METHOD cl_document->print_document
    EXPORTING
*     no_flush    = ' '
      prompt_user = 'X'
    IMPORTING
      error       = error
      retcode     = retcode.
  PERFORM handle_error USING ''.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SAVE_AS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save_as_data .
  DATA:
    default_filename TYPE string,
    l_filename       TYPE string,
    i_filename(100)  TYPE c.

  IF g_filename IS NOT INITIAL.
    default_filename =  g_filename && '.XLSX'.
  ELSE.
    default_filename = 'Export.XLSX'.
  ENDIF.
*
*  PERFORM save_dialog USING default_filename CHANGING l_filename.

  i_filename = default_filename.

  CALL METHOD cl_document->save_as
    EXPORTING
      file_name   = i_filename
*     no_flush    = 'X'
      prompt_user = 'X'
    IMPORTING
      error       = error
      retcode     = retcode.
  PERFORM handle_error USING ''.
ENDFORM.

FORM handle_error USING ex.

  IF retcode NE 'OK'.
    CALL METHOD error->get_message
      IMPORTING
        message_id     = sy-msgid
        message_number = sy-msgno
        param1         = sy-msgv1
        param2         = sy-msgv2
        param3         = sy-msgv3
        param4         = sy-msgv4.
    CLEAR retcode.
    MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno WITH sy-msgv1
                                                      sy-msgv2
                                                      sy-msgv3
                                                      sy-msgv4.
    IF ex = 'X'.

      PERFORM release_objects.
      LEAVE TO SCREEN 0.

    ENDIF.
  ENDIF.
ENDFORM.


FORM set_excel_protect.
  CALL METHOD cl_spreadsheet->protect
    EXPORTING
      protect = 'X'
*     no_flush = ' '
    IMPORTING
      error   = error
      retcode = retcode.
  PERFORM handle_error USING 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0300 INPUT.
  DATA:ok_code1 TYPE sy-ucomm.
  ok_code1 = sy-ucomm.
  CLEAR sy-ucomm.
  CASE ok_code1.
    WHEN 'PRINT'.
      PERFORM print_data.
    WHEN 'SAVE_AS'.
      PERFORM save_as_data.
  ENDCASE.
ENDMODULE.
