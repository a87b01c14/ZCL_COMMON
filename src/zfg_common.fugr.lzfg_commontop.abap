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
