*&---------------------------------------------------------------------*
*& Report ZDEMO_RESIZE_PICTURE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdemo_resize_picture.
"选择上传文件名
DATA(lv_filename) = zcl_common=>get_file_name( iv_filter = '*.JPEG' ).
CHECK lv_filename IS NOT INITIAL.
"打开文件
DATA(ls_return) = zcl_common=>upload_file( iv_filename = lv_filename ).
IF ls_return-subrc <> 0.
  MESSAGE '文件打开错误' TYPE 'S' DISPLAY LIKE 'E'.
  RETURN.
ENDIF.
"字节转xstring
DATA(lv_content_ori) = zcl_common=>binary_to_xstring( iv_filelength = ls_return-filelength data_tab = ls_return-data_tab ).
CHECK lv_content_ori IS NOT INITIAL.
"调整图片大小
DATA(lv_content_small) = zcl_common=>resize_image( iv_original = lv_content_ori iv_max_height = 500 iv_max_width = 500 ).
"拆分文件路径
DATA(ls_split) = zcl_common=>split_file( lv_filename ).
"获取保存路径
DATA(lv_filename1) = zcl_common=>save_file_dialog( iv_filename = ls_split-filename ).
"xstring转字节
DATA(lt_tab) = zcl_common=>xstring_to_binary( iv_xstring = lv_content_small ).
"下载图片到本地
DATA(rs_return1) = zcl_common=>download_file( iv_filename = lv_filename1 data_tab = lt_tab ).
IF rs_return1-type = 'E'.
  MESSAGE rs_return1-message TYPE 'S' DISPLAY LIKE 'E'.
  RETURN.
ENDIF.
