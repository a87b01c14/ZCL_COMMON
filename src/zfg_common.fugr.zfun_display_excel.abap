FUNCTION zfun_display_excel.
*"----------------------------------------------------------------------
*"*"本地接口：
*"  IMPORTING
*"     VALUE(IV_XLSM) TYPE  CHAR1 OPTIONAL
*"     VALUE(IV_AUTOPRINT) TYPE  CHAR1 OPTIONAL
*"     VALUE(IV_FILENAME) TYPE  STRING OPTIONAL
*"     REFERENCE(IO_EXCEL) TYPE REF TO  ZCL_EXCEL
*"  EXCEPTIONS
*"      ZCX_EXCEL
*"----------------------------------------------------------------------

  cl_excel = io_excel.
  g_filename = iv_filename.
  g_xlsm = iv_xlsm.
  g_autoprint = iv_autoprint.
  CALL SCREEN 300.



ENDFUNCTION.
