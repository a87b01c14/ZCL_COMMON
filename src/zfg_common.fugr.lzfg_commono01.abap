*----------------------------------------------------------------------*
***INCLUDE LZFG_COMMONO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0300 OUTPUT.
  SET PF-STATUS 'GUI_300'.
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
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'GUI_100'.
  SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SHOW_PICTURE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE show_picture OUTPUT.
  IF go_picture IS INITIAL.
    CREATE OBJECT go_picture_container
      EXPORTING
        container_name              = 'PICTURE'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5.
    CHECK sy-subrc = 0.
    CREATE OBJECT go_picture
      EXPORTING
        parent = go_picture_container.

    CALL METHOD go_picture->set_display_mode
      EXPORTING
        display_mode = cl_gui_picture=>display_mode_fit.

* Set 3D Border
    CALL METHOD go_picture->set_3d_border
      EXPORTING
        border = 1.
  ENDIF.
  CHECK go_picture IS BOUND.
  CALL METHOD go_picture->load_picture_from_url
    EXPORTING
      url = gv_url.
ENDMODULE.
