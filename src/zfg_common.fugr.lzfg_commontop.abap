FUNCTION-POOL zfg_common.                   "MESSAGE-ID ..

* INCLUDE LZFG_COMMOND...                    " Local class definition

TYPE-POOLS: ckmpr.

TYPES:
*       Hilfstabelle zur Umschlüsselung PSP-Element (extern / intern)
  BEGIN OF f_psp_ext_int,
    ext LIKE bapi2027_pc_list-wbs_element,
    int LIKE cki_pae_pp-pspnr,
  END OF f_psp_ext_int,
  psp_ext_int TYPE f_psp_ext_int OCCURS 0.

TABLES:
*       Mandanten-Tabelle: Bewertungskreis = Werk oder Buchungskreis
  tcurm.

* excel显示 begin
DATA: cl_writer   TYPE REF TO zif_excel_writer,
      cl_error    TYPE REF TO zcx_excel,
      cl_excel    TYPE REF TO zcl_excel,
      g_xlsm      TYPE char1,
      g_autoprint TYPE char1,
      g_filename  TYPE string.
DATA:error          TYPE REF TO i_oi_error,
     t_errors       TYPE STANDARD TABLE OF REF TO i_oi_error WITH NON-UNIQUE DEFAULT KEY,
     retcode        TYPE soi_ret_string,
     cl_control     TYPE REF TO i_oi_container_control, "OIContainerCtrl
     cl_document    TYPE REF TO i_oi_document_proxy,   "Office Dokument
     cl_spreadsheet TYPE REF TO i_oi_spreadsheet.
DATA: xdata     TYPE xstring,             " Will be used for sending as email
      t_rawdata TYPE solix_tab,           " Will be used for downloading or open directly
      bytecount TYPE i.                   " Will be used for downloading or open directly
* excel显示 end

* 图片显示 begin
DATA go_picture_container TYPE REF TO cl_gui_custom_container.
DATA go_picture TYPE REF TO cl_gui_picture.
DATA gv_url TYPE epssurl.
DATA gt_pic_tab TYPE zcl_common=>tt_pic_tab.
DATA gv_filename TYPE rlgrap-filename.
* 图片显示 end


DEFINE free_object.
  IF &1 IS NOT INITIAL.
    CALL METHOD &1->free.
    FREE &1.
  ENDIF.
end-of-definition.
