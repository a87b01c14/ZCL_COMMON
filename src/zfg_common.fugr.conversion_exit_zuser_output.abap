FUNCTION conversion_exit_zuser_output .
*"--------------------------------------------------------------------
*"*"局部接口：
*"  IMPORTING
*"     VALUE(INPUT) TYPE  CLIKE
*"  EXPORTING
*"     VALUE(OUTPUT) TYPE  CLIKE
*"--------------------------------------------------------------------

  TYPES: BEGIN OF lty_output,
           input  TYPE user_addr-bname,
           output TYPE user_addr-name_textc,
         END OF lty_output.
  STATICS lt_output TYPE HASHED TABLE OF lty_output WITH UNIQUE KEY input.
  DATA:lv_uname TYPE user_addr-name_textc.
  READ TABLE lt_output INTO DATA(ls_output) WITH TABLE KEY input = input.
  IF sy-subrc = 0.
    output = ls_output-output.
  ELSE.
    SELECT SINGLE name_textc INTO lv_uname FROM user_addr WHERE bname = input.
    IF sy-subrc EQ 0.
      output = lv_uname.
    ELSE.
      output = input.
    ENDIF.
    INSERT VALUE #( input = input output = output ) INTO TABLE lt_output.
  ENDIF.

ENDFUNCTION.
