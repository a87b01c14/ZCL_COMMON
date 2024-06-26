*----------------------------------------------------------------------*
***INCLUDE LZFG_COMMONI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXCEL_EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE excel_exit INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      PERFORM release_objects.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      free_object go_picture.
      free_object go_picture_container.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
