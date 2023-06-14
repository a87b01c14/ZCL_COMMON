*----------------------------------------------------------------------*
***INCLUDE LZFG_COMMONO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0300 OUTPUT.
  SET PF-STATUS '0300'.
*  SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SHOW_EXCEL  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE show_excel OUTPUT.
  DATA: is_java_bean TYPE abap_bool.
  DATA: is_gui_its TYPE c.
  CALL FUNCTION 'GUI_HAS_JAVABEANS'
    IMPORTING
      return = is_java_bean.

  CALL FUNCTION 'GUI_IS_ITS'
    IMPORTING
      return = is_gui_its.
  IF is_java_bean IS INITIAL AND is_gui_its IS INITIAL.
    PERFORM frm_show_excel.
    PERFORM set_excel_protect.
  ELSE.
    PERFORM frm_show_excel_java.
  ENDIF.

ENDMODULE.
