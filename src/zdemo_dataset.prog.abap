*&---------------------------------------------------------------------*
*& Report ZDEMO_DATASET
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdemo_dataset.
"选择上传文件名
DATA(lv_filename) = zcl_common=>get_file_name( ).
CHECK lv_filename IS NOT INITIAL.
"上传到服务器
DATA(rs_return) = zcl_common=>upload_file_to_server( iv_filename = lv_filename ).
IF rs_return-return-type = 'E'.
  MESSAGE rs_return-return-message TYPE 'S' DISPLAY LIKE 'E'.
  RETURN.
ENDIF.
"拆分文件路径
DATA(ls_split) = zcl_common=>split_file( rs_return-filename ).
"获取保存路径
DATA(lv_filename1) = zcl_common=>save_file_dialog( iv_filename = ls_split-filename ).
"从服务器下载文件到本地
DATA(rs_return1) = zcl_common=>download_file_from_server( iv_filename_server = rs_return-filename iv_filename_client = lv_filename1 ).
IF rs_return1-type = 'E'.
  MESSAGE rs_return1-message TYPE 'S' DISPLAY LIKE 'E'.
  RETURN.
ENDIF.
