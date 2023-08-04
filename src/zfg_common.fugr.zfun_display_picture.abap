FUNCTION zfun_display_picture.
*"----------------------------------------------------------------------
*"*"本地接口：
*"  IMPORTING
*"     REFERENCE(IV_FILENAME) TYPE  RLGRAP-FILENAME
*"     REFERENCE(IO_PICTURE) TYPE REF TO  CL_GUI_PICTURE OPTIONAL
*"----------------------------------------------------------------------

  DATA(ls_return) = zcl_common=>read_file( iv_filename = iv_filename ) .
  CHECK ls_return-return-type = 'S'.
  DATA(ls_split) = zcl_common=>split_file( iv_filename = iv_filename ).
  DATA(lv_ext) =  to_lower( ls_split-pure_extension ).
  CHECK lv_ext = 'gif' OR lv_ext = 'jpg' OR lv_ext = 'jpeg' OR lv_ext = 'png' OR lv_ext = 'bmp'.
  DATA(lv_url) = zcl_common=>create_url( iv_subtype = ls_split-pure_extension data_tab = ls_return-data_tab ).
  CHECK lv_url IS NOT INITIAL.
  gv_url = lv_url.
  gt_pic_tab = ls_return-data_tab.
  gv_filename = ls_split-filename.
  IF io_picture IS SUPPLIED AND io_picture IS BOUND.
    CALL METHOD io_picture->load_picture_from_url
      EXPORTING
        url    = gv_url
      EXCEPTIONS
        OTHERS = 4.
  ELSE.
    CALL SCREEN 100 STARTING AT 30 1.
  ENDIF.



ENDFUNCTION.
