CLASS zcl_common DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_billing_return,
        fkstk     TYPE likp-fkstk,
        fkivk     TYPE likp-fkivk,
        fkstk_ret TYPE likp-fkstk, "BAPI后交货开票状态
        fkivk_ret TYPE likp-fkivk, "BAPI后公司间开票状态
        return    TYPE bapiret1_t,
        errors    TYPE /syclo/sd_bapivbrkerrors_tab,
        success   TYPE bapivbrksuccess_t,
      END OF ty_billing_return .
    TYPES:
      BEGIN OF ty_dn_return,
        vbeln  TYPE vbeln_vl,
        return TYPE bapiret2_t,
      END OF ty_dn_return .
    TYPES:
      BEGIN OF ty_dn_post_return,
        mblnr  TYPE mblnr,
        mjahr  TYPE mjahr,
        return TYPE bapiret2_t,
      END OF ty_dn_post_return .
    TYPES:
      tt_posnr TYPE STANDARD TABLE OF /cwm/r_posnr .
    TYPES:
      BEGIN OF ty_job_return,
        jobname  TYPE tbtcjob-jobname,
        jobcount TYPE tbtcjob-jobcount,
        return   TYPE bapiret2,
      END OF ty_job_return .
    TYPES:
      BEGIN OF ty_pic_tab,
        line(255) TYPE x,
      END OF ty_pic_tab .
    TYPES:
      tt_pic_tab TYPE STANDARD TABLE OF ty_pic_tab WITH EMPTY KEY .
    TYPES:
      BEGIN OF ty_upload_file_return,
        subrc      LIKE sy-subrc,
        filelength TYPE i,
        data_tab   TYPE tt_pic_tab,
      END OF ty_upload_file_return .
    TYPES:
      BEGIN OF ty_upload_server_return,
        filename TYPE rlgrap-filename, "文件名+扩展名
        return   TYPE bapiret2,
      END OF ty_upload_server_return .
    TYPES:
      BEGIN OF ty_read_file_return,
        data_tab TYPE tt_pic_tab,
        return   TYPE bapiret2,
      END OF ty_read_file_return .
    TYPES:
      BEGIN OF ty_split_file,
        pure_filename  TYPE rlgrap-filename, "纯文件名
        pure_extension TYPE char4, "扩展名
        filename       TYPE rlgrap-filename, "文件名+扩展名
        pathname       TYPE rlgrap-filename, "路径
      END OF ty_split_file .

    CLASS-METHODS authority_check_tcode
      IMPORTING
        !tcode TYPE tcode .
    CLASS-METHODS get_month_lastday
      IMPORTING
        VALUE(iv_begda) TYPE begda
      RETURNING
        VALUE(ev_endda) TYPE endda .
    CLASS-METHODS save_file_dialog
      IMPORTING
        !iv_filename       TYPE rlgrap-filename OPTIONAL
      RETURNING
        VALUE(rv_filename) TYPE rlgrap-filename .
    CLASS-METHODS get_file_name
      IMPORTING
        VALUE(iv_filter) TYPE string DEFAULT cl_gui_frontend_services=>filetype_excel
      RETURNING
        VALUE(rv_file)   TYPE rlgrap-filename .
    CLASS-METHODS download_template
      IMPORTING
        !iv_objid    TYPE w3objid
        !iv_filename TYPE rlgrap-filename .
    CLASS-METHODS upload_excel
      IMPORTING
        !iv_filename     TYPE rlgrap-filename
        !iv_skipped_rows TYPE i
        !iv_skipped_cols TYPE i
        !iv_max_col      TYPE i
        !iv_max_row      TYPE i
      EXPORTING
        !et_table        TYPE STANDARD TABLE
      EXCEPTIONS
        error
        conver_error .
    CLASS-METHODS export_excel
      IMPORTING
        !iv_filename TYPE rlgrap-filename
        !it_table    TYPE STANDARD TABLE
      RAISING
        zcx_excel .
    CLASS-METHODS print_excel
      IMPORTING
        !iv_w3objid   TYPE w3objid
        !it_data      TYPE zcl_excel_template_data=>tt_template_data_sheets
        !iv_xlsm      TYPE abap_bool DEFAULT abap_false
        !iv_autoprint TYPE abap_bool DEFAULT abap_false
        !iv_filename  TYPE string OPTIONAL .
    CLASS-METHODS download_file
      IMPORTING
        !iv_filename     TYPE rlgrap-filename
        VALUE(data_tab)  TYPE zcl_common=>tt_pic_tab
      RETURNING
        VALUE(rs_return) TYPE bapiret2 .
    CLASS-METHODS read_file
      IMPORTING
        !iv_filename     TYPE rlgrap-filename
      RETURNING
        VALUE(rs_return) TYPE zcl_common=>ty_read_file_return .
    CLASS-METHODS upload_file
      IMPORTING
        !iv_filename     TYPE rlgrap-filename
      RETURNING
        VALUE(rs_return) TYPE zcl_common=>ty_upload_file_return .
    CLASS-METHODS remove_file_from_server
      IMPORTING
        !iv_filename     TYPE rlgrap-filename
      RETURNING
        VALUE(rs_return) TYPE bapiret2 .
    CLASS-METHODS download_file_from_server
      IMPORTING
        !iv_filename_server TYPE rlgrap-filename
        !iv_filename_client TYPE rlgrap-filename
      RETURNING
        VALUE(rs_return)    TYPE bapiret2 .
    CLASS-METHODS upload_file_to_server
      IMPORTING
        !iv_filename     TYPE rlgrap-filename
        !iv_path         TYPE rlgrap-filename DEFAULT '/usr/sap/trans'
      RETURNING
        VALUE(rs_return) TYPE zcl_common=>ty_upload_server_return .
    CLASS-METHODS split_file
      IMPORTING
        !iv_filename     TYPE rlgrap-filename
      RETURNING
        VALUE(rs_return) TYPE zcl_common=>ty_split_file .
    CLASS-METHODS create_url
      IMPORTING
        !iv_subtype   TYPE char4
        !data_tab     TYPE zcl_common=>tt_pic_tab
      RETURNING
        VALUE(rv_url) TYPE epssurl .
    CLASS-METHODS resize_image
      IMPORTING
        !iv_original    TYPE xstring
        !iv_max_width   TYPE i DEFAULT 1024
        !iv_max_height  TYPE i DEFAULT 1024
      RETURNING
        VALUE(rv_small) TYPE xstring .
    CLASS-METHODS xstring_to_binary
      IMPORTING
        !iv_xstring     TYPE xstring
      RETURNING
        VALUE(data_tab) TYPE zcl_common=>tt_pic_tab .
    CLASS-METHODS binary_to_xstring
      IMPORTING
        !iv_filelength    TYPE i
        !data_tab         TYPE zcl_common=>tt_pic_tab
      RETURNING
        VALUE(rv_xstring) TYPE xstring .
    CLASS-METHODS show_picture
      IMPORTING
        !iv_filename TYPE rlgrap-filename
        !io_picture  TYPE REF TO cl_gui_picture OPTIONAL .
    CLASS-METHODS get_ojb_number
      IMPORTING
        !iv_obj       TYPE zeobject
        !iv_objkey    TYPE zekey
        !iv_max       TYPE zeseq_max
        !iv_count     TYPE zecount
        !iv_obj_d     TYPE zeobject_d
        !iv_repeat    TYPE zerepeat OPTIONAL
      RETURNING
        VALUE(rv_seq) TYPE zeseq .
    CLASS-METHODS show_progressbar
      IMPORTING
        !iv_current TYPE i
        !iv_total   TYPE i
        !iv_msg     TYPE string OPTIONAL .
    CLASS-METHODS start_job
      IMPORTING
        VALUE(jobname)   TYPE tbtcjob-jobname OPTIONAL
        VALUE(jobuser)   TYPE sy-uname OPTIONAL
        VALUE(report)    TYPE repid
        !variant         TYPE rsvar-variant OPTIONAL
        !params          TYPE rsparams_tt
        !start_date      TYPE tbtcjob-sdlstrtdt OPTIONAL
        !start_time      TYPE tbtcjob-sdlstrttm OPTIONAL
        !eventid         TYPE tbtcjob-eventid OPTIONAL
        !eventparm       TYPE tbtcjob-eventparm OPTIONAL
      RETURNING
        VALUE(rs_return) TYPE zcl_common=>ty_job_return .
    CLASS-METHODS submit_job
      IMPORTING
        !jobname        TYPE tbtcjob-jobname
        !jobcount       TYPE tbtcjob-jobcount
        !jobuser        TYPE sy-uname
        !report         TYPE repid
        !variant        TYPE rsvar-variant
      RETURNING
        VALUE(rv_subrc) TYPE sy-subrc .
    CLASS-METHODS open_job
      IMPORTING
        !jobname        TYPE tbtcjob-jobname
      RETURNING
        VALUE(jobcount) TYPE tbtcjob-jobcount .
    CLASS-METHODS close_job
      IMPORTING
        !jobname        TYPE tbtcjob-jobname
        !jobcount       TYPE tbtcjob-jobcount
        !start_date     TYPE tbtcjob-sdlstrtdt OPTIONAL
        !start_time     TYPE tbtcjob-sdlstrttm OPTIONAL
        !eventid        TYPE tbtcjob-eventid OPTIONAL
        !eventparm      TYPE tbtcjob-eventparm OPTIONAL
      RETURNING
        VALUE(rv_subrc) TYPE sy-subrc .
    CLASS-METHODS am_i_in_job
      EXPORTING
        !in_job   TYPE abap_bool
        !jobcount TYPE btcjobcnt
        !jobname  TYPE btcjob .
    CLASS-METHODS is_variant_exists
      IMPORTING
        !report         TYPE sy-repid
        !variant        TYPE rsvar-variant
      RETURNING
        VALUE(rv_subrc) TYPE sy-subrc .
    CLASS-METHODS get_default_variant .
    CLASS-METHODS get_user_param
      IMPORTING
        !iv_parid       TYPE usparam-parid
      RETURNING
        VALUE(rv_parva) TYPE usparam-parva .
    CLASS-METHODS rv_call_display_transaction
      IMPORTING
        VALUE(bukrs)    TYPE bukrs DEFAULT '    '
        VALUE(gjahr)    TYPE gjahr DEFAULT '0000'
        VALUE(lgnum)    TYPE vbfa-lgnum DEFAULT '   '
        VALUE(posnr)    TYPE vbap-posnr DEFAULT '000000'
        VALUE(vbeln)    TYPE vbuk-vbeln
        VALUE(aufnr)    TYPE vbak-aufnr OPTIONAL
        VALUE(vbtyp)    TYPE vbuk-vbtyp DEFAULT ' '
        VALUE(fi_appli) TYPE vbfal-appli DEFAULT '  ' .
    CLASS-METHODS display_sd_doc
      IMPORTING
        VALUE(vbeln) TYPE vbuk-vbeln .
    CLASS-METHODS display_so
      IMPORTING
        VALUE(vbeln) TYPE vbuk-vbeln .
    CLASS-METHODS display_dn
      IMPORTING
        VALUE(vbeln) TYPE vbuk-vbeln .
    CLASS-METHODS display_iv
      IMPORTING
        !vbeln TYPE vbuk-vbeln .
    CLASS-METHODS display_migo
      IMPORTING
        !vbeln TYPE vbuk-vbeln .
    CLASS-METHODS display_pr
      IMPORTING
        !vbeln TYPE vbuk-vbeln .
    CLASS-METHODS display_po
      IMPORTING
        !vbeln TYPE vbuk-vbeln .
    CLASS-METHODS display_fi
      IMPORTING
        VALUE(bukrs) TYPE bukrs DEFAULT '    '
        VALUE(gjahr) TYPE gjahr DEFAULT '0000'
        VALUE(vbeln) TYPE vbuk-vbeln .
    CLASS-METHODS display_bp
      IMPORTING
        !iv_partner TYPE but000-partner .
    CLASS-METHODS display_co
      IMPORTING
        !aufnr TYPE aufnr .
    CLASS-METHODS display_idoc
      IMPORTING
        !iv_docnum TYPE edidc-docnum .
    CLASS-METHODS add_role
      IMPORTING
        !iv_username  TYPE bapibname-bapibname
        !it_roles     TYPE suid_tt_bapiagr
      RETURNING
        VALUE(return) TYPE tt_bapiret2 .
    CLASS-METHODS swc_call_method
      IMPORTING
        VALUE(objtype) TYPE swotobjid-objtype OPTIONAL
        VALUE(objkey)  TYPE swotobjid-objkey OPTIONAL
        VALUE(object)  TYPE swotrtime-object OPTIONAL
        VALUE(method)  TYPE swo_method DEFAULT 'DISPLAY'
      RETURNING
        VALUE(return)  TYPE swotreturn .
    CLASS-METHODS create_billing_by_so
      IMPORTING
        VALUE(iv_vbeln)  TYPE vbeln
      RETURNING
        VALUE(rv_return) TYPE ty_billing_return .
    CLASS-METHODS create_billing_by_dn
      IMPORTING
        VALUE(iv_vbeln)  TYPE vbeln
      RETURNING
        VALUE(rv_return) TYPE ty_billing_return .
    CLASS-METHODS create_so_dn
      IMPORTING
        VALUE(iv_vbeln)  TYPE vbeln
      RETURNING
        VALUE(rv_return) TYPE ty_dn_return .
    CLASS-METHODS create_sto_dn
      IMPORTING
        VALUE(iv_vbeln)  TYPE vbeln
      RETURNING
        VALUE(rv_return) TYPE ty_dn_return .
    CLASS-METHODS post_dn
      IMPORTING
        VALUE(iv_vbeln)  TYPE likp-vbeln
        !iv_budat        TYPE budat OPTIONAL
        !iv_reslo        TYPE reslo OPTIONAL
      RETURNING
        VALUE(rv_return) TYPE ty_dn_post_return .
    CLASS-METHODS reverse_dn
      IMPORTING
        VALUE(iv_vbeln)  TYPE likp-vbeln
        !iv_budat        TYPE budat OPTIONAL
      RETURNING
        VALUE(rv_return) TYPE ty_dn_post_return .
    CLASS-METHODS delete_dn
      IMPORTING
        VALUE(iv_vbeln)  TYPE likp-vbeln
      RETURNING
        VALUE(rv_return) TYPE bapiret2_t .
    CLASS-METHODS delete_so
      IMPORTING
        VALUE(iv_vbeln)  TYPE vbak-vbeln
        !it_posnr        TYPE tt_posnr OPTIONAL
      RETURNING
        VALUE(rv_return) TYPE bapiret2_t .
    CLASS-METHODS close_so
      IMPORTING
        VALUE(iv_vbeln)  TYPE vbak-vbeln
        !it_posnr        TYPE tt_posnr OPTIONAL
        VALUE(iv_abgru)  TYPE vbap-abgru
      RETURNING
        VALUE(rv_return) TYPE bapiret2_t .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_common IMPLEMENTATION.


  METHOD am_i_in_job.
    CLEAR: in_job, jobcount, jobname.

    IF sy-batch = abap_false.
      RETURN.
    ENDIF.

    CALL FUNCTION 'GET_JOB_RUNTIME_INFO'
      IMPORTING
        jobcount        = jobcount
        jobname         = jobname
      EXCEPTIONS
        no_runtime_info = 1
        OTHERS          = 2.

    in_job = xsdbool( sy-subrc = 0 AND
                                 jobname IS NOT INITIAL ).
  ENDMETHOD.


  METHOD authority_check_tcode.
    AUTHORITY-CHECK OBJECT 'S_TCODE'
           ID 'TCD' FIELD tcode.
    IF sy-subrc NE 0.
      MESSAGE e172(00) WITH tcode.
    ENDIF.
  ENDMETHOD.


  METHOD close_job.
    IF eventid IS NOT INITIAL.
      CALL FUNCTION 'JOB_CLOSE'
        EXPORTING
          jobname              = jobname
          jobcount             = jobcount
          event_id             = eventid
          event_param          = eventparm
        EXCEPTIONS
          cant_start_immediate = 1
          invalid_startdate    = 2
          jobname_missing      = 3
          job_close_failed     = 4
          job_nosteps          = 5
          job_notex            = 6
          lock_failed          = 7
          invalid_target       = 8
          OTHERS               = 9 ##FM_SUBRC_OK.
    ELSE.
      DATA(strtimmed) = COND abap_bool( WHEN start_date IS NOT INITIAL THEN abap_false ELSE abap_true ).
      CALL FUNCTION 'JOB_CLOSE'
        EXPORTING
          jobname              = jobname
          jobcount             = jobcount
          strtimmed            = strtimmed
          sdlstrtdt            = start_date
          sdlstrttm            = start_time
        EXCEPTIONS
          cant_start_immediate = 1
          invalid_startdate    = 2
          jobname_missing      = 3
          job_close_failed     = 4
          job_nosteps          = 5
          job_notex            = 6
          lock_failed          = 7
          invalid_target       = 8
          OTHERS               = 9 ##FM_SUBRC_OK.
    ENDIF.
    rv_subrc = sy-subrc.
  ENDMETHOD.


  METHOD display_co.
    SET PARAMETER ID 'ANR' FIELD  aufnr.
    authority_check_tcode( 'CO03' ).
    CALL TRANSACTION 'CO03' AND SKIP FIRST SCREEN.
  ENDMETHOD.


  METHOD display_dn.
    rv_call_display_transaction( vbeln = vbeln vbtyp = if_sd_doc_category=>delivery ).
  ENDMETHOD.


  METHOD display_fi.
    rv_call_display_transaction( bukrs = bukrs gjahr = gjahr vbeln = vbeln vbtyp = if_sd_doc_category=>invoice_list fi_appli = 'MM' ).
  ENDMETHOD.


  METHOD display_iv.
    rv_call_display_transaction( vbeln = vbeln vbtyp = if_sd_doc_category=>invoice ).
  ENDMETHOD.


  METHOD display_migo.
    rv_call_display_transaction( vbeln = vbeln vbtyp = if_sd_doc_category=>goods_movement ).
  ENDMETHOD.


  METHOD display_po.
    rv_call_display_transaction( vbeln = vbeln vbtyp = if_sd_doc_category=>purchase_order ).
  ENDMETHOD.


  METHOD display_pr.
    rv_call_display_transaction( vbeln = vbeln vbtyp = if_sd_doc_category=>data_collation_is_oil ).
  ENDMETHOD.


  METHOD display_sd_doc.
    rv_call_display_transaction( vbeln ).
  ENDMETHOD.


  METHOD display_so.
    rv_call_display_transaction( vbeln = vbeln vbtyp = if_sd_doc_category=>order ).
  ENDMETHOD.


  METHOD download_template.
    DATA: ls_key      TYPE wwwdatatab,
          lv_filename TYPE string,
          lv_path     TYPE string,
          lv_fullpath TYPE string.

* 判断模版是否存在
    SELECT SINGLE *
      FROM wwwdata
      WHERE relid EQ 'MI'
      AND   objid EQ @iv_objid
      INTO CORRESPONDING FIELDS OF @ls_key.
    IF sy-subrc NE 0.
*   模版&1不存在
      MESSAGE s015(zsd001) WITH iv_objid.
      RETURN.
    ENDIF.

    lv_filename = iv_filename.
* 调用函数打开文件选择框
    cl_gui_frontend_services=>file_save_dialog(
      EXPORTING
        default_extension         = cl_gui_frontend_services=>filetype_excel
        default_file_name         = lv_filename
      CHANGING
        filename                  = lv_filename
        path                      = lv_path
        fullpath                  = lv_fullpath
      EXCEPTIONS
        cntl_error                = 1
        error_no_gui              = 2
        not_supported_by_gui      = 3
        invalid_default_file_name = 4
        OTHERS                    = 5 ).
    IF sy-subrc NE 0.
    ENDIF.
    CHECK lv_fullpath NE ''.

* 下载SMW0模版
    CALL FUNCTION 'DOWNLOAD_WEB_OBJECT'
      EXPORTING
        key         = ls_key
        destination = CONV localfile( lv_fullpath ).
  ENDMETHOD.


  METHOD export_excel.
    DATA: l_filename                TYPE string, "下载文件名
          l_wintitle                TYPE string, "下载对话框标题名
          l_filepath                TYPE string, "文件路径
          l_fullpath                TYPE string, "全文件路径
          l_default                 TYPE string, "默认下载文件名
          l_imgname                 TYPE string, "下载文件名
          l_imgpath                 TYPE string, "文件路径
          l_pure_filename           TYPE string,
          l_pure_extension          TYPE string,
          lv_file                   TYPE xstring,
          lt_file_content           TYPE cpt_x255,
          ls_file_content           TYPE cps_x255,
          lv_file_size              TYPE i,

          lo_excel                  TYPE REF TO zcl_excel,
          lo_reader                 TYPE REF TO zif_excel_reader,
          lo_writer                 TYPE REF TO zif_excel_writer,
          lo_worksheet              TYPE REF TO zcl_excel_worksheet,
          lo_style                  TYPE REF TO zcl_excel_style,
          lo_style_date             TYPE REF TO zcl_excel_style,
          lo_border                 TYPE REF TO zcl_excel_style_border,
          lo_zexcel_cell_style      TYPE zexcel_cell_style,
          lo_zexcel_cell_style_date TYPE zexcel_cell_style,
          lo_iterator               TYPE REF TO zcl_excel_collection_iterator,
          lo_col                    TYPE REF TO zcl_excel_column,
          worksheet_title           TYPE zexcel_sheet_title,
          table_settings            TYPE zexcel_s_table_settings,
          lt_field_catalog          TYPE zexcel_t_fieldcatalog.
    .

    DATA: l_objid(40) TYPE c,
          ls_wdatb    TYPE wwwdatatab,
          l_subrc     TYPE sy-subrc,
          l_msg       TYPE string,
          l_file      TYPE rlgrap-filename.
    DATA: lv_row     TYPE i VALUE 1,
          lv_col     TYPE i,
          lv_col_pic TYPE i,
          lv_rc      TYPE i,
          lv_value   TYPE string.

    DATA: lo_grid      TYPE REF TO cl_gui_alv_grid,
          filt_table   TYPE lvc_t_fidx,
          l_filt_table TYPE int4.

    DATA: lt_fieldcat TYPE lvc_t_fcat,
          dyn_wa      TYPE REF TO data,
          dyn_table   TYPE REF TO data.

    CHECK it_table[] IS NOT INITIAL.
    l_wintitle = iv_filename.
    l_default  = iv_filename.

*&---保存对话框
    CALL METHOD cl_gui_frontend_services=>file_save_dialog
      EXPORTING
*       WINDOW_TITLE        = L_WINTITLE      "对话框的标题
        default_extension   = 'XLSX'            "默认的文件后缀名
        default_file_name   = l_default       "默认文件名
        file_filter         = 'EXCEL文件(*.XLSX)|*.XLS|全部文件 (*.*)|*.*|'            "文件的FILTER
        prompt_on_overwrite = 'X'
*       INITIAL_DIRECTORY   =                  "初始化的目录
      CHANGING
        filename            = l_filename      "保存的文件名
        path                = l_filepath      "文件路径
        fullpath            = l_fullpath      "全文件路径
*       USER_ACTION         =
      EXCEPTIONS
        cntl_error          = 1
        error_no_gui        = 2
        OTHERS              = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ELSE.


**导出文件

*  "EXCEL对象
      CREATE OBJECT lo_writer TYPE zcl_excel_writer_2007.

      table_settings-table_style        = zcl_excel_table=>builtinstyle_light18.
      table_settings-show_row_stripes   = abap_true.
      table_settings-nofilters          = abap_true.
      table_settings-top_left_column    = 'A'.
      table_settings-top_left_row       = 01.
      IF lo_excel IS NOT BOUND.
        CREATE OBJECT lo_excel.
        lo_worksheet    = lo_excel->get_active_worksheet( ).
      ELSE.
        lo_worksheet    = lo_excel->add_new_worksheet( ).
      ENDIF.
*      边框
      lo_border = NEW zcl_excel_style_border( ).
      lo_border->border_color-rgb = zcl_excel_style_color=>c_black.
      lo_border->border_style = zcl_excel_style_border=>c_border_thin.

      lo_style_date = lo_excel->add_new_style( ).
      lo_style_date->number_format->format_code = zcl_excel_style_number_format=>c_format_date_yyyymmdd.
      lo_style_date->borders->allborders = lo_border.
      lo_zexcel_cell_style_date = lo_style_date->get_guid( ).

      lo_style = lo_excel->add_new_style( ).
      lo_style->borders->allborders = lo_border.
      lo_zexcel_cell_style = lo_style->get_guid( ).

      lt_field_catalog = zcl_excel_common=>get_fieldcatalog( ip_table = it_table ).
* 日期类型设置默认格式YYYYMMDD
      LOOP AT lt_field_catalog ASSIGNING FIELD-SYMBOL(<fs_fcat>).
        IF <fs_fcat>-abap_type = cl_abap_typedescr=>typekind_date.
          <fs_fcat>-style = lo_zexcel_cell_style_date.
        ELSE.
          <fs_fcat>-style = lo_zexcel_cell_style.
        ENDIF.
      ENDLOOP.

      lo_worksheet->set_default_excel_date_format( zcl_excel_style_number_format=>c_format_date_yyyymmdd ).
      worksheet_title   = iv_filename.
      lo_worksheet->set_title( worksheet_title ).

      lo_worksheet->bind_table(
        ip_table          = it_table
        it_field_catalog  = lt_field_catalog
        is_table_settings = table_settings ).
      lv_file =  lo_writer->write_file( lo_excel ).

      CLEAR lt_file_content.
      cl_scp_change_db=>xstr_to_xtab(
        EXPORTING
          im_xstring = lv_file
        IMPORTING
          ex_xtab    = lt_file_content
          ex_size    = lv_file_size
      ).



      CHECK l_fullpath IS NOT INITIAL.
      cl_gui_frontend_services=>gui_download(
        EXPORTING
          bin_filesize      = xstrlen( lv_file )
*         FILENAME          = |{ LS_DATA-FILE_NAME }.{ LS_DATA-FILE_EXTE }|
          filename          = l_fullpath
          filetype          = 'BIN'
          confirm_overwrite = abap_true
        IMPORTING
          filelength        = DATA(lv_length)
        CHANGING
          data_tab          = lt_file_content
      ).

*  "打开EXCEL文件
      cl_gui_frontend_services=>execute(
        EXPORTING
          document = l_fullpath "DOCUMENT
      ).

    ENDIF.

  ENDMETHOD.


  METHOD get_file_name.

    DATA: lt_filetable TYPE filetable,
          ls_filetable TYPE file_table,
          lv_rc        TYPE i.

    FREE: lt_filetable.
    CLEAR: lv_rc.

* 调用函数打开文件选择框
    cl_gui_frontend_services=>file_open_dialog(
      EXPORTING
        default_extension       = iv_filter
        file_filter             = iv_filter
      CHANGING
        file_table              = lt_filetable
        rc                      = lv_rc
      EXCEPTIONS
        file_open_dialog_failed = 1
        cntl_error              = 2
        error_no_gui            = 3
        not_supported_by_gui    = 4
        OTHERS                  = 5 ).
    READ TABLE lt_filetable INTO ls_filetable INDEX 1.
    IF sy-subrc EQ 0.
      rv_file = ls_filetable-filename.
    ENDIF.


  ENDMETHOD.


  METHOD open_job.
    CALL FUNCTION 'JOB_OPEN'
      EXPORTING
*       delanfrep        = ' '
*       jobgroup         =
        jobname          = jobname
*       sdlstrtdt        = sy-datum
*       sdlstrttm        = sy-uzeit
      IMPORTING
        jobcount         = jobcount
      EXCEPTIONS
        cant_create_job  = 01
        invalid_job_data = 02
        jobname_missing  = 03.
  ENDMETHOD.


  METHOD rv_call_display_transaction.

    DATA: rc LIKE sy-subrc.
    DATA: mja_help(4).
    DATA: ebelp TYPE ebelp.                                 "n_523104
    DATA: lf_migo TYPE c.                                   "n_729408
    DATA: ls_vbuk TYPE vbuk.

    IF fi_appli = 'MM'.
      CASE vbtyp.
        WHEN if_sd_doc_category=>sales_activities.
*------ Wareneingang---------------------------------------------------*
          SET PARAMETER ID 'MBN' FIELD  vbeln.
          SET PARAMETER ID 'MJA' FIELD  gjahr.
          SET PARAMETER ID 'BUK' FIELD  bukrs.
* note 2521204, lines deleted
          CALL FUNCTION 'MIGO_DIALOG'
            EXPORTING
              i_action            = 'A04'
              i_mblnr             = vbeln
              i_mjahr             = gjahr                    "n_867384
            EXCEPTIONS
              illegal_combination = 1
              OTHERS              = 2.
          IF sy-subrc <> 0.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.
* note 2521204, 1 line deleted
        WHEN if_sd_doc_category=>external_transaction.
*------ Rechnungseingang ----------------------------------------------*
          SET PARAMETER ID 'KBN' FIELD  vbeln.              "<-781160
          SET PARAMETER ID 'GJR' FIELD  gjahr.
*       709168: Since 4.6C there is a MM container document 'Account
*       maintenance', which is to be shown by MR11SHOW in stead of
*       transaction FB03...
*       set parameter id 'BUK' field  bukrs.
          authority_check_tcode( 'MR11SHOW' ).
          CALL TRANSACTION 'MR11SHOW' AND SKIP FIRST SCREEN.
        WHEN if_sd_doc_category=>invoice_list.
*------ Rechnungseingang ----------------------------------------------*
          SET PARAMETER ID 'BLN' FIELD  vbeln.
          SET PARAMETER ID 'GJR' FIELD  gjahr.
          SET PARAMETER ID 'BUK' FIELD  bukrs.
          authority_check_tcode( 'FB03' ).
          CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
        WHEN if_sd_doc_category=>inquiry.
*------ Rechnungseingang (logisitisch) --------------------------------*
          SET PARAMETER ID 'RBN' FIELD  vbeln.
          SET PARAMETER ID 'GJR' FIELD  gjahr.
          authority_check_tcode( 'MIR4' ).
          CALL TRANSACTION 'MIR4' AND SKIP FIRST SCREEN.
        WHEN if_sd_doc_category=>allocation_table.
*----------Aufteiler---------------------------------------------------*
          SET PARAMETER ID 'ABE' FIELD  vbeln.
          authority_check_tcode( 'WA03' ).
          CALL TRANSACTION 'WA03' AND SKIP FIRST SCREEN.
      ENDCASE.
      EXIT.
    ENDIF.


    IF vbtyp IS INITIAL.
*    SELECT SINGLE * FROM VBUK WHERE VBELN = VBELN.
      CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
        EXPORTING
          i_vbeln             = vbeln
        IMPORTING
          es_vbuk             = ls_vbuk
        EXCEPTIONS
          vbeln_not_found     = 1
          vbtyp_not_supported = 2
          vbobj_not_supported = 3
          OTHERS              = 4.
      IF sy-subrc = 0.
        vbtyp = ls_vbuk-vbtyp.
      ENDIF.
    ENDIF.


* Call SD Documentflow BAdI
    DATA: l_sd_documentflow_exit TYPE REF TO if_ex_badi_sd_documentflow,
          active                 TYPE xfeld,
          da_displayed           TYPE c.    " 'X' -> EXIT

    CALL FUNCTION 'GET_HANDLE_SD_DOCUMENTFLOW'
      IMPORTING
        handle = l_sd_documentflow_exit
        active = active.

    IF active = 'X'.
      CALL METHOD l_sd_documentflow_exit->display_transaction
        EXPORTING
          i_vbtyp     = vbtyp
          i_vbeln     = vbeln
          i_tcode     = sy-tcode
          i_posnr     = posnr
        CHANGING
          c_displayed = da_displayed.
      CHECK da_displayed IS INITIAL.
    ENDIF.

*------ Sonderverarbeitung Buchhaltungsbeleg --------------------------*
    TYPES  BEGIN OF ty_doc_num.
    INCLUDE TYPE acc_doc.
    TYPES END OF ty_doc_num.
    DATA: doc_num    TYPE STANDARD TABLE OF ty_doc_num,
          ls_doc_num TYPE ty_doc_num.

    TYPES BEGIN OF ty_xdoc_num.
    TYPES: vbeln        TYPE vbfa-vbeln,
           logsys       TYPE vbrk-logsys,
           not_found(1),
           cpudt        TYPE bkpf-cpudt,
           cputm        TYPE bkpf-cputm,
           gjahr        TYPE bkpf-gjahr.
           INCLUDE TYPE acc_doc.
* start Revenue Recognition Project
    TYPES: xblnr        TYPE vbrk-xblnr,
           set_awtyp    TYPE acchd-awtyp,
           set_awref    TYPE acchd-awref,
           set_aworg    TYPE acchd-aworg,
           set_vbeln    TYPE vbeln_va.
* end Revenue Recognition Project
    TYPES END OF ty_xdoc_num.
    DATA: xdoc_num    TYPE STANDARD TABLE OF ty_xdoc_num,
          ls_xdoc_num TYPE ty_xdoc_num.

* start Revenue Recognition Project
    DATA: set_awtyp TYPE acchd-awtyp,
          set_aworg TYPE acchd-aworg.

    IF cl_sd_doc_category_util=>is_any_accounting( vbtyp ).
      IF vbtyp EQ if_sd_doc_category=>accounting_document_plus.
        IMPORT xdoc_num = xdoc_num FROM MEMORY ID 'FLOW'.
        set_awtyp = 'VBRK'.
      ENDIF.
      IF cl_sd_doc_category_util=>is_any_revenue_recognition( vbtyp ).
        IMPORT xdoc_num = xdoc_num FROM MEMORY ID 'RRFLOW'.
      ENDIF.
* end Revenue Recognition Project

      DELETE xdoc_num WHERE logsys IS NOT INITIAL AND logsys = cl_im_fin_cfin_sd_docflow=>get_logsys_cfin( ).
*   EXPORT in LV05CF01
      LOOP AT xdoc_num INTO ls_xdoc_num WHERE docnr EQ vbeln
                       AND   bukrs EQ bukrs
                       AND   gjahr EQ gjahr.
        MOVE-CORRESPONDING ls_xdoc_num TO ls_doc_num.
        APPEND ls_doc_num TO doc_num.
      ENDLOOP.

* start Revenue Recognition Project
*   Key should be update to XBELNR
      IF NOT ls_xdoc_num-xblnr IS INITIAL AND
             cl_sd_doc_category_util=>is_any_revenue_new_view( vbtyp ) EQ abap_false.
*     Set document number
        ls_xdoc_num-vbeln = ls_xdoc_num-xblnr.
*     Fill VBELN with leading zeroes
        CALL FUNCTION 'FI_ALPHA_CONVERT'
          EXPORTING
            i_string = ls_xdoc_num-vbeln
          IMPORTING
            e_string = ls_xdoc_num-vbeln.
      ENDIF.

      IF cl_sd_doc_category_util=>is_any_revenue_recognition( vbtyp ).
        set_awtyp = ls_xdoc_num-set_awtyp.
        set_aworg = ls_xdoc_num-set_aworg.
      ENDIF.
* BEGIN OF ELIMINATION based on SCR_000089
*    if vbtyp ca vbtyp_revview.
*
**     Call revenue recognition view
*      call function 'SD_REV_REC_DOCUMENT_VIEW'
*        exporting
*          fif_vbeln             = set_vbeln
*          fif_posnr             = posnr
*          fif_awtyp             = set_awtyp
*          fif_awref             = set_awref
*          fif_aworg             = set_aworg
*          fif_sdbukrs           = xdoc_num-bukrs
*          fif_sdbelnr           = xdoc_num-vbeln
*          fif_sdgjahr           = xdoc_num-gjahr
*        exceptions
*          no_selected_criteria  = 1
*          no_control_lines      = 2
*          no_revenue_lines      = 3
*          no_accounting_headers = 4
*          others                = 5.
*
*      if sy-subrc <> 0.
**       Error in revenue recognition
*        message s003(vfrr) with sy-subrc.
*      endif.

*    else.
* end Revenue Recognition Project
* END OF ELIMINATION based on SCR_000089
      CALL FUNCTION 'AC_DOCUMENT_RECORD'
        EXPORTING
          i_awref     = ls_xdoc_num-vbeln
          i_awsys     = ls_xdoc_num-logsys
* start Revenue Recognition Project
          i_awtyp     = set_awtyp
          i_aworg     = set_aworg
* end Revenue Recognition Project
          i_bukrs     = ls_xdoc_num-bukrs
        TABLES
          t_documents = doc_num.
* BEGIN OF ELIMINATION based on SCR_000001
*    endif.
* END OF ELIMINATION based on SCR_000001
    ENDIF.

*------ RV/RM-Belege --------------------------------------------------*
    CASE vbtyp.
      WHEN if_sd_doc_category=>sales_activities.
        INCLUDE sdcas_new_vc01.
*------ Kontakt -------------------------------------------------------*
        IF lc_new_vc01 IS INITIAL.
          SET PARAMETER ID 'VCA' FIELD  vbeln.
          authority_check_tcode( 'VC03' ).
          CALL TRANSACTION 'VC03' AND SKIP FIRST SCREEN.
* Enjoy 99
        ELSE.
          SUBMIT sd_contact_maintain WITH vbeln = vbeln
                                     WITH p_brows = space
                                     WITH p_disp = 'X'
                 AND RETURN.
        ENDIF.
      WHEN if_sd_doc_category=>delivery_shipping_notif.
*------ WS SHP inbound delivery        --------------------------------*
        SET PARAMETER ID 'VLM' FIELD  vbeln.
        authority_check_tcode( 'VL33N' ).
        CALL TRANSACTION 'VL33N' AND SKIP FIRST SCREEN.
      WHEN if_sd_doc_category=>shipment.
*---- Transport -----------------------------------------------------*
        CALL FUNCTION 'LE_SHIPMENT_TRANSACTION_CALL'
          EXPORTING
            i_mode  = 'DISP'
            i_tknum = vbeln.

      WHEN if_sd_doc_category=>inquiry.
*------ Anfrage -------------------------------------------------------*
        SET PARAMETER ID 'AFN' FIELD  vbeln.
        SET PARAMETER ID 'VPO' FIELD  posnr.
        authority_check_tcode( 'VA13' ).
        CALL TRANSACTION 'VA13' AND SKIP FIRST SCREEN.
      WHEN if_sd_doc_category=>quotation.
*------ Angebot -------------------------------------------------------*
        SET PARAMETER ID 'AGN' FIELD  vbeln.
        SET PARAMETER ID 'VPO' FIELD  posnr.
        authority_check_tcode( 'VA23' ).
        CALL TRANSACTION 'VA23' AND SKIP FIRST SCREEN.
      WHEN if_sd_doc_category=>order.
*------ Auftrag -------------------------------------------------------*
        SET PARAMETER ID 'AUN' FIELD  vbeln.
        SET PARAMETER ID 'VPO' FIELD  posnr.
        authority_check_tcode( 'VA03' ).
        CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.
      WHEN if_sd_doc_category=>item_proposal.
*------ Sortiment -----------------------------------------------------*
        SET PARAMETER ID 'AMN' FIELD  vbeln.
        SET PARAMETER ID 'VPO' FIELD  posnr.
        authority_check_tcode( 'VA53' ).
        CALL TRANSACTION 'VA53' AND SKIP FIRST SCREEN.
      WHEN if_sd_doc_category=>sched_agree.
*------ Lieferplan ----------------------------------------------------*
        SET PARAMETER ID 'LPN' FIELD  vbeln.
        SET PARAMETER ID 'VPO' FIELD  posnr.
        authority_check_tcode( 'VA33' ).
        CALL TRANSACTION 'VA33' AND SKIP FIRST SCREEN.
      WHEN if_sd_doc_category=>sched_agree_ext_serv_agent.
*------ Scheduling agreement with external service agent --------------*
        SET PARAMETER ID 'LPN' FIELD  vbeln.                "n_614310
        SET PARAMETER ID 'VPO' FIELD  posnr.
        authority_check_tcode( 'VA33' ).
        CALL TRANSACTION 'VA33' AND SKIP FIRST SCREEN.      "^_n_614310
      WHEN if_sd_doc_category=>contract.
*------ Kontrakt ------------------------------------------------------*
        SET PARAMETER ID 'KTN' FIELD  vbeln.
        SET PARAMETER ID 'VPO' FIELD  posnr.
        authority_check_tcode( 'VA43' ).
        CALL TRANSACTION 'VA43' AND SKIP FIRST SCREEN.
      WHEN if_sd_doc_category=>master_contract.
*------ Gruppenkontrakt------------------------------------------------*
        SET PARAMETER ID 'KTN' FIELD  vbeln.
        SET PARAMETER ID 'VPO' FIELD  posnr.
        authority_check_tcode( 'VA43' ).
        CALL TRANSACTION 'VA43' AND SKIP FIRST SCREEN.
      WHEN if_sd_doc_category=>returns.
*------ Retoure -------------------------------------------------------*
        SET PARAMETER ID 'AUN' FIELD  vbeln.
        SET PARAMETER ID 'VPO' FIELD  posnr.
        authority_check_tcode( 'VA03' ).
        CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.
      WHEN if_sd_doc_category=>order_wo_charge.
*------ Kostenlose Lieferung ------------------------------------------*
        SET PARAMETER ID 'AUN' FIELD  vbeln.
        SET PARAMETER ID 'VPO' FIELD  posnr.
        authority_check_tcode( 'VA03' ).
        CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.
      WHEN if_sd_doc_category=>delivery.
*------ Lieferung -----------------------------------------------------*
        SET PARAMETER ID 'VL ' FIELD  vbeln.
        SET PARAMETER ID 'LLP' FIELD  posnr.      "VPL was the wrong one
        authority_check_tcode( 'VL03N' ).
        CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
      WHEN if_sd_doc_category=>credit_memo_req.
*------ Gutschriftsanforderung ----------------------------------------*
        SET PARAMETER ID 'AUN' FIELD  vbeln.
        SET PARAMETER ID 'VPO' FIELD  posnr.
        authority_check_tcode( 'VA03' ).
        CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.
      WHEN if_sd_doc_category=>debit_memo_req.
*------ Lastschriftanforderung ----------------------------------------*
        SET PARAMETER ID 'AUN' FIELD  vbeln.
        SET PARAMETER ID 'VPO' FIELD  posnr.
        authority_check_tcode( 'VA03' ).
        CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.
*------ Billing Documen Requests---------------------------------------*
      WHEN if_sd_doc_category=>ext_billing_doc_request.
        SET PARAMETER ID 'VFR' FIELD vbeln.
        authority_check_tcode( 'VFR3' ).
        CALL TRANSACTION 'VFR3' AND SKIP FIRST SCREEN.
*------ Preliminary Billing Document---------------------------------------*
      WHEN if_sd_doc_category=>pre_billing_document.
        SET PARAMETER ID 'VFPBD'  FIELD vbeln.
        authority_check_tcode( 'VFP3' ).
        CALL TRANSACTION 'VFP3' AND SKIP FIRST SCREEN.
*------ Invoices    ---------------------------------------------------*
      WHEN if_sd_doc_category=>invoice
        OR if_sd_doc_category=>invoice_cancel
        OR if_sd_doc_category=>credit_memo
        OR if_sd_doc_category=>debit_memo
        OR if_sd_doc_category=>credit_memo_cancel
        OR if_sd_doc_category=>pro_forma_invoice
        OR if_sd_doc_category=>intercompany_invoice
        OR if_sd_doc_category=>intercompany_credit_memo
        OR if_sd_doc_category=>bill_period_end_cred_mem_ib
        OR if_sd_doc_category=>bill_period_end_cred_memo
        OR if_sd_doc_category=>bill_period_end_inv
        OR if_sd_doc_category=>bill_period_end_inv_ib.
        SET PARAMETER ID 'VFP' FIELD  posnr.
        CALL FUNCTION 'BAPI_BILLINGDOC_DISPLAY'
          EXPORTING
            billingdocument = vbeln.
*------ Invoice Lists    ----------------------------------------------*
      WHEN if_sd_doc_category=>invoice_list
        OR if_sd_doc_category=>credit_memo_list.
        CALL FUNCTION 'BAPI_BILLINGDOC_DISPLAY'
          EXPORTING
            billingdocument = vbeln.
      WHEN if_sd_doc_category=>wms_trans_order.
*------ LVS-Transportauftrag ------------------------------------------*
        SET PARAMETER ID 'LGN' FIELD  lgnum.
        SET PARAMETER ID 'TAN' FIELD  vbeln.
        SET PARAMETER ID 'TAP' FIELD  posnr.                "n_605519
        authority_check_tcode( 'LT21' ).
        CALL TRANSACTION 'LT21' AND SKIP FIRST SCREEN.
      WHEN if_sd_doc_category=>goods_movement.
*------ Warenausgang -------------------------------------------------*
*     ursprünglischen Wert merken
        GET PARAMETER ID 'MJA' FIELD mja_help.
        IF gjahr IS INITIAL.
          SET PARAMETER ID 'MJA' FIELD '0000'.
        ELSE.
          SET PARAMETER ID 'MJA' FIELD gjahr.
        ENDIF.
        SET PARAMETER ID 'MBN' FIELD  vbeln.
* note 2521204, lines deleted
        CALL FUNCTION 'MIGO_DIALOG'
          EXPORTING
            i_action            = 'A04'
            i_mblnr             = vbeln
            i_mjahr             = gjahr                    "n_867384
          EXCEPTIONS
            illegal_combination = 1
            OTHERS              = 2.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
* note 2521204, 1 line deleted
*     Wert wieder zurücksetzen
        SET PARAMETER ID 'MJA' FIELD mja_help.
      WHEN if_sd_doc_category=>cancel_goods_movement.
*------ Storno Warenausgang--------------------------------------------*
*     ursprünglischen Wert merken
        GET PARAMETER ID 'MJA' FIELD mja_help.
        IF gjahr IS INITIAL.
          SET PARAMETER ID 'MJA' FIELD '0000'.
        ELSE.
          SET PARAMETER ID 'MJA' FIELD gjahr.
        ENDIF.
        SET PARAMETER ID 'MBN' FIELD  vbeln.
* note 2521204, lines deleted
        CALL FUNCTION 'MIGO_DIALOG'
          EXPORTING
            i_action            = 'A04'
            i_mblnr             = vbeln
            i_mjahr             = gjahr                    "n_867384
          EXCEPTIONS
            illegal_combination = 1
            OTHERS              = 2.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
* note 2521204, 1 line deleted
      WHEN if_sd_doc_category=>goods_receipt.
*------ Wareneingang und Storno Wareneingang --------------------------*
        SET PARAMETER ID 'MBN' FIELD  vbeln.
* note 2521204, lines deleted
        CALL FUNCTION 'MIGO_DIALOG'
          EXPORTING
            i_action            = 'A04'
            i_mblnr             = vbeln
            i_mjahr             = gjahr                    "n_867384
          EXCEPTIONS
            illegal_combination = 1
            OTHERS              = 2.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
* note 2521204, 1 line deleted
      WHEN if_sd_doc_category=>afs.
*------ Lagerbeleg / Dezentrale Warenbewegung -------------------------*
        SET PARAMETER ID 'LGN' FIELD  lgnum.
        SET PARAMETER ID 'LBG' FIELD  vbeln.
        authority_check_tcode( 'LX44' ).
        CALL TRANSACTION 'LX44' AND SKIP FIRST SCREEN.
      WHEN if_sd_doc_category=>returns_delivery_for_order.
*------ Retourenlieferung ---------------------------------------------*
        SET PARAMETER ID 'VL ' FIELD  vbeln.
        SET PARAMETER ID 'LLP' FIELD  posnr.      "VPL was the wrong one
        authority_check_tcode( 'VL03N' ).
        CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
      WHEN if_sd_doc_category=>purchase_order.
*------ Bestellung ----------------------------------------------------*
        SELECT SINGLE bstyp INTO @DATA(lv_bstyp) FROM ekko WHERE ebeln = @vbeln.
        IF sy-subrc = 0.
          ebelp = posnr.   "type conversion numc length 6 -> 5   n_523104
          CASE lv_bstyp.
*-- Anzeigen Anfrage --------------------------------------------------*
            WHEN 'A'.
              SET PARAMETER ID 'ANF' FIELD vbeln.
              authority_check_tcode( 'ME43' ).
              CALL TRANSACTION 'ME43' AND SKIP FIRST SCREEN.

*-- Anzeigen Bestellanforderung ---------------------------------------*
            WHEN 'B'.
              SET PARAMETER ID 'BAN' FIELD vbeln.
              authority_check_tcode( 'ME53N' ).
              CALL TRANSACTION 'ME53N' AND SKIP FIRST SCREEN.

*-- Anzeigen Leistungserfassungsblatt ---------------------------------*
            WHEN 'D'.
              SET PARAMETER ID 'LBL' FIELD vbeln.
              SET PARAMETER ID 'LBD' FIELD 'X'.
              authority_check_tcode( 'ML81N' ).
              CALL TRANSACTION 'ML81N'.

*-- Anzeigen Bestellung -----------------------------------------------*
            WHEN 'F'.
              SET PARAMETER ID 'BES' FIELD vbeln.
              SET PARAMETER ID 'BSP' FIELD ebelp.           "n_523104
              authority_check_tcode( 'ME23N' ).
              CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.

*-- Anzeigen Kontrakt -------------------------------------------------*
            WHEN 'K'.
              SET PARAMETER ID 'CTR' FIELD vbeln.
              authority_check_tcode( 'ME33K' ).
              CALL TRANSACTION 'ME33K' AND SKIP FIRST SCREEN.

*-- Anzeigen Lieferplan -----------------------------------------------*
            WHEN 'L'.
              SET PARAMETER ID 'SAG' FIELD vbeln.
              authority_check_tcode( 'ME33L' ).
              CALL TRANSACTION 'ME33L' AND SKIP FIRST SCREEN.

          ENDCASE.
        ELSE.
          MESSAGE s135(lr) WITH vbeln.
*   Die Bestellung & existiert nicht

        ENDIF.

* ISSUE: 'v' used twice?
      WHEN if_sd_doc_category=>data_collation_is_oil.
*------ Bestellanforderung --------------------------------------------*
        SET PARAMETER ID 'BAN' FIELD vbeln.
        authority_check_tcode( 'ME53N' ).
        CALL TRANSACTION 'ME53N' AND SKIP FIRST SCREEN.

      WHEN if_sd_doc_category=>independent_reqts_plan.
*------ Kundenprimärbedarf---------------------------------------------*
        SET PARAMETER ID 'AUN' FIELD  vbeln.
        SET PARAMETER ID 'VPO' FIELD  posnr.
        authority_check_tcode( 'MD83' ).
        CALL TRANSACTION 'MD83' AND SKIP FIRST SCREEN.
      WHEN if_sd_doc_category=>handling_unit.
*..... Handling Units ...................................
        DATA: ls_venum TYPE hum_venum, lt_venum TYPE hum_venum_t.
        ls_venum-venum = vbeln.
        APPEND ls_venum TO lt_venum.
        CALL FUNCTION 'HU_DISPLAY'
          EXPORTING
            it_venum = lt_venum
*           if_exidv_for_deleted = 'X'                        "n_1137234/1424213
          EXCEPTIONS
            OTHERS   = 0.
      WHEN if_sd_doc_category=>shipment_costs.
*------ Frachtkosten---------------------------------------------------*
        SET PARAMETER ID 'FKK' FIELD  vbeln.
        authority_check_tcode( 'VI03' ).
        CALL TRANSACTION 'VI03' AND SKIP FIRST SCREEN.

* ISSUE service order . or :? Mismatch between fixed values in domain
* and usage in this case statement
      WHEN if_sd_doc_category=>service_order.
*------ Serviceauftrag ------------------------------------------------*
        SET PARAMETER ID 'ANR' FIELD  aufnr.
*     SET PARAMETER ID '   ' FIELD  POSNR.
        authority_check_tcode( 'IW33' ).
        CALL TRANSACTION 'IW33' AND SKIP FIRST SCREEN.
      WHEN if_sd_doc_category=>service_notification.
*------ Servicemeldung ------------------------------------------------*
        SET PARAMETER ID 'IQM' FIELD  aufnr.
*     SET PARAMETER ID '   ' FIELD  POSNR.
        authority_check_tcode( 'IQS3' ).
        CALL TRANSACTION 'IQS3' AND SKIP FIRST SCREEN.

* ISSUE Where does Y come from??
      WHEN if_sd_doc_category=>rebate_agreement.
*-------Bonusabsprache ------------------------------------------------*
        SET PARAMETER ID 'VBO' FIELD vbeln.
        authority_check_tcode( 'VBO3' ).
        CALL TRANSACTION 'VBO3' AND SKIP FIRST SCREEN.
* SPE Goods Movement - Documentation
      WHEN if_sd_doc_category=>goods_movement_documentation.
*-------- Goods Movement - Documentation ------------------------------*
        GET PARAMETER ID 'MJA' FIELD mja_help.
        IF gjahr IS INITIAL.
          SET PARAMETER ID 'MJA' FIELD '0000'.
        ELSE.
          SET PARAMETER ID 'MJA' FIELD gjahr.
        ENDIF.
        SET PARAMETER ID 'MBN' FIELD  vbeln.
* v_n2521204
        CALL FUNCTION 'MIGO_DIALOG'
          EXPORTING
            i_action            = 'A04'
            i_mblnr             = vbeln
            i_mjahr             = gjahr
          EXCEPTIONS
            illegal_combination = 1
            OTHERS              = 2.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
* ^_n2521204
        SET PARAMETER ID 'MJA' FIELD mja_help.
      WHEN if_sd_doc_category=>rough_goods_receipt_is_retail.
*-------- Rough good receipt  ------------------------------------------*
        SET PARAMETER ID 'VLG' FIELD  vbeln.
        authority_check_tcode( 'VL43' ).
        CALL TRANSACTION 'VL43' AND SKIP FIRST SCREEN.
      WHEN if_sd_doc_category=>td_transport_is_oil.         "SO3K015538
*------ Bulk Transportation - shipment --------------------------------*
        SET PARAMETER ID 'OIS' FIELD  vbeln.                "SO3K015538
        CALL TRANSACTION 'O4F3' AND SKIP FIRST SCREEN.      "SO3K015538
      WHEN if_sd_doc_category=>load_conf_reposting_is_oil.  "SO3K015538
*------ TD - load confirmation ----------------------------------------*
        GET PARAMETER ID 'MJA' FIELD mja_help.              "SO7K117317
*      set parameter id 'MJA' field '0000'.                  "SO7K117317            "n_2152042
        IF gjahr IS INITIAL.                                "n_2152042
          SET PARAMETER ID 'MJA' FIELD '0000'.              "n_2152042
        ELSE.                                               "n_2152042
          SET PARAMETER ID 'MJA' FIELD gjahr.               "n_2152042
        ENDIF.                                              "n_2152042

        SET PARAMETER ID 'MBN' FIELD  vbeln.                "SO3K015538
*      CALL TRANSACTION 'MB03' AND SKIP FIRST SCREEN.        "SO3K015538
        CALL FUNCTION 'MIGO_DIALOG'
          EXPORTING
            i_action            = 'A04'
            i_mblnr             = vbeln
            i_mjahr             = gjahr
          EXCEPTIONS
            illegal_combination = 1
            OTHERS              = 2.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
        SET PARAMETER ID 'MJA' FIELD mja_help.              "SO7K117317
      WHEN if_sd_doc_category=>gain_loss_is_oil.            "SO3K015538
*------ TD - gain / loss       ----------------------------------------*
        GET PARAMETER ID 'MJA' FIELD mja_help.              "SO7K117317
        SET PARAMETER ID 'MJA' FIELD '0000'.                "SO7K117317

        SET PARAMETER ID 'MBN' FIELD  vbeln.                "SO3K015538
*      CALL TRANSACTION 'MB03' AND SKIP FIRST SCREEN.        "SO3K015538
        CALL FUNCTION 'MIGO_DIALOG'
          EXPORTING
            i_action            = 'A04'
            i_mblnr             = vbeln
            i_mjahr             = gjahr
          EXCEPTIONS
            illegal_combination = 1
            OTHERS              = 2.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
        SET PARAMETER ID 'MJA' FIELD mja_help.              "SO7K117317
      WHEN if_sd_doc_category=>reentry_into_storage_is_oil. "SO3K015538
*------ TD - return            ----------------------------------------*
        GET PARAMETER ID 'MJA' FIELD mja_help.              "SO7K117317
*      set parameter id 'MJA' field '0000'.                  "SO7K117317            "n_2152042
        IF gjahr IS INITIAL.                                "n_2152042
          SET PARAMETER ID 'MJA' FIELD '0000'.              "n_2152042
        ELSE.                                               "n_2152042
          SET PARAMETER ID 'MJA' FIELD gjahr.               "n_2152042
        ENDIF.                                              "n_2152042

        SET PARAMETER ID 'MBN' FIELD  vbeln.                "SO3K015538
*      CALL TRANSACTION 'MB03' AND SKIP FIRST SCREEN.        "SO3K015538
        CALL FUNCTION 'MIGO_DIALOG'
          EXPORTING
            i_action            = 'A04'
            i_mblnr             = vbeln
            i_mjahr             = gjahr
          EXCEPTIONS
            illegal_combination = 1
            OTHERS              = 2.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
        SET PARAMETER ID 'MJA' FIELD mja_help.              "SO7K117317
      WHEN if_sd_doc_category=>reserv_is_oil.               "SO3K115932
*------ Transport -----------------------------------------------------*
        SET PARAMETER ID 'RES' FIELD  vbeln.                "SO3K115932
        CALL TRANSACTION 'MB23' AND SKIP FIRST SCREEN.      "SO3K115932
      WHEN if_sd_doc_category=>load_conf_goods_receipt_is_oil. "SO3K015538
*------ TD - load confirmation - goods receipt ------------------------*
        GET PARAMETER ID 'MJA' FIELD mja_help.              "SO7K117317
        SET PARAMETER ID 'MJA' FIELD '0000'.                "SO7K117317

        SET PARAMETER ID 'MBN' FIELD  vbeln.                "SO3K015538
*      CALL TRANSACTION 'MB03' AND SKIP FIRST SCREEN.        "SO3K015538
        CALL FUNCTION 'MIGO_DIALOG'
          EXPORTING
            i_action            = 'A04'
            i_mblnr             = vbeln
            i_mjahr             = gjahr
          EXCEPTIONS
            illegal_combination = 1
            OTHERS              = 2.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
        SET PARAMETER ID 'MJA' FIELD mja_help.              "SO7K117317
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.


  METHOD show_progressbar.
    DATA: lv_msg TYPE string.
    IF iv_msg IS INITIAL.
      lv_msg = |{ TEXT-t01 }........ { iv_current }/{ iv_total }|.
    ELSE.
      lv_msg = iv_msg.
    ENDIF.
    cl_progress_indicator=>progress_indicate(
      EXPORTING
        i_text               = lv_msg
        i_processed          = iv_current
        i_total              = iv_total
        i_output_immediately = abap_true ).
  ENDMETHOD.


  METHOD upload_excel.
    DATA:lo_reader      TYPE REF TO zif_excel_reader.
    DATA oref TYPE REF TO cx_root.
    DATA text TYPE string.
    TRY.
        CREATE OBJECT lo_reader TYPE zcl_excel_reader_2007.
        DATA(lo_excel) = lo_reader->load_file( i_filename = iv_filename ).
        DATA(lo_worksheet) = lo_excel->get_active_worksheet( ).
        lo_worksheet->get_table(
          EXPORTING
            iv_skipped_rows = iv_skipped_rows
            iv_skipped_cols = iv_skipped_cols
            iv_max_row      = iv_max_row
            iv_max_col      = iv_max_col
          IMPORTING
            et_table        = et_table ).
      CATCH  cx_root INTO oref."异常捕获
        text = oref->get_text( ).
        MESSAGE text TYPE 'S'  DISPLAY LIKE 'E'.
    ENDTRY.
  ENDMETHOD.


  METHOD get_ojb_number.
*数据定义
    DATA: lwa_ztcommon001 TYPE ztcommon001,
          l_sign          TYPE char1.

*---------------
*判断"对象+KEY"是否存在,若不存在则插入记录
    SELECT SINGLE * INTO lwa_ztcommon001 FROM ztcommon001 WHERE zzobject = iv_obj AND zzkey = iv_objkey.
    IF sy-subrc <> 0.
      lwa_ztcommon001-zzobject = iv_obj."对象类型
      lwa_ztcommon001-zzkey = iv_objkey."对象KEY值
      lwa_ztcommon001-zzobject_d = iv_obj_d."对象类型描述
      lwa_ztcommon001-zzseq_max = iv_max."序列号校验最大值
      lwa_ztcommon001-zzrepeat = iv_repeat."是否允许循环
      lwa_ztcommon001-zzseq = 0."序列号
      CALL FUNCTION 'ZFUN_GET_DATE_REC'
        EXPORTING
          iv_mode = 'I'
        CHANGING
          cs_data = lwa_ztcommon001.
      MODIFY ztcommon001 FROM lwa_ztcommon001.
      COMMIT WORK AND WAIT.
    ENDIF.

*---------------
*加锁对象:
    CALL FUNCTION 'ENQUEUE_EZ_ZTCOMMON001'
      EXPORTING
        mode_ztcommon001 = 'E'
        mandt            = sy-mandt
        zzobject         = iv_obj
        zzkey            = iv_objkey
*       X_ZOBJECT        = ' '
*       X_ZKEY           = ' '
*       _SCOPE           = '2'
*       _WAIT            = ' '
*       _COLLECT         = ' '
      EXCEPTIONS
        foreign_lock     = 1
        system_failure   = 2
        OTHERS           = 3.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

*---------------
*获得可用的KEY
    CLEAR: lwa_ztcommon001.
    SELECT SINGLE * INTO lwa_ztcommon001 FROM ztcommon001 WHERE zzobject = iv_obj AND zzkey = iv_objkey.
    IF sy-subrc <> 0.
      l_sign = 'X'."有错误

    ELSE.
      IF ( lwa_ztcommon001-zzseq + iv_count ) >  iv_max AND lwa_ztcommon001-zzrepeat IS INITIAL.
        l_sign = 'X'."有错误

      ELSE.
        rv_seq = lwa_ztcommon001-zzseq + 1."可用值

        IF iv_obj_d IS NOT INITIAL.
          lwa_ztcommon001-zzobject_d = iv_obj_d."对象类型描述
        ENDIF.
        lwa_ztcommon001-zzseq_max = iv_max."序列号校验最大值
        lwa_ztcommon001-zzseq = lwa_ztcommon001-zzseq + iv_count."记录已占用值
        IF lwa_ztcommon001-zzseq + iv_count > iv_max AND lwa_ztcommon001-zzrepeat = 'X'.
          lwa_ztcommon001-zzseq = lwa_ztcommon001-zzseq + iv_count - iv_max.
        ENDIF.

        CALL FUNCTION 'ZFUN_GET_DATE_REC'
          EXPORTING
            iv_mode = 'M'
          CHANGING
            cs_data = lwa_ztcommon001.
        MODIFY ztcommon001 FROM lwa_ztcommon001.
        COMMIT WORK AND WAIT.
      ENDIF.
    ENDIF.


*---------------
* 解锁对象
    CALL FUNCTION 'DEQUEUE_EZ_ZTCOMMON001'
      EXPORTING
        mode_ztcommon001 = 'E'
        mandt            = sy-mandt
        zzobject         = iv_obj
        zzkey            = iv_objkey
*       X_ZOBJECT        = ' '
*       X_ZKEY           = ' '
*       _SCOPE           = '3'
*       _SYNCHRON        = ' '
*       _COLLECT         = ' '
      .

  ENDMETHOD.


  METHOD add_role.
    DATA: lt_old_roles TYPE STANDARD TABLE OF bapiagr.
    DATA: lt_new_roles TYPE STANDARD TABLE OF bapiagr.
    DATA: lv_tabix LIKE sy-tabix.

    CALL FUNCTION 'BAPI_USER_GET_DETAIL'
      EXPORTING
        username       = iv_username
      TABLES
        activitygroups = lt_old_roles
        return         = return.
    SORT lt_old_roles BY agr_name.

    LOOP AT it_roles INTO DATA(ls_roles).
      READ TABLE lt_old_roles WITH KEY  agr_name  = ls_roles-agr_name
                                        TRANSPORTING NO FIELDS
                                        BINARY SEARCH.
      lv_tabix = sy-tabix.
      IF sy-subrc = 0.
        DELETE lt_old_roles INDEX lv_tabix.
      ENDIF.
    ENDLOOP.

    APPEND LINES OF it_roles TO lt_new_roles.
    APPEND LINES OF lt_old_roles TO lt_new_roles.

    CALL FUNCTION 'BAPI_USER_ACTGROUPS_ASSIGN'
      EXPORTING
        username       = iv_username
      TABLES
        activitygroups = lt_new_roles
        return         = return.
  ENDMETHOD.


  METHOD swc_call_method.
    DATA: container TYPE swconttab.
    IF NOT object IS SUPPLIED.
      CALL FUNCTION 'SWO_CREATE'
        EXPORTING
          objtype = objtype
          objkey  = objkey
*         logical_system = swo_%objid-logsys
        IMPORTING
          object  = object
          return  = return.
    ENDIF.
    CALL FUNCTION 'SWO_INVOKE'
      EXPORTING
        access     = 'C'
        object     = object
        verb       = method
        persistent = ' '
      IMPORTING
        return     = return
      TABLES
        container  = container.
  ENDMETHOD.


  METHOD display_bp.
    swc_call_method( objtype = 'BUS1006' objkey = CONV #( iv_partner ) ).
  ENDMETHOD.


  METHOD display_idoc.
    swc_call_method( objtype = 'IDOC' objkey = CONV #( iv_docnum ) ).
  ENDMETHOD.


  METHOD create_billing_by_so.
    DATA: ls_return TYPE bapiret1.
    DATA: lt_return TYPE STANDARD TABLE OF bapiret1.
    DATA:ls_bapivbrk TYPE bapivbrk,
         lt_bapivbrk TYPE STANDARD TABLE OF bapivbrk.

    CLEAR: ls_return,lt_return[].
    DO 10 TIMES.
      SELECT SINGLE vbeln,fksak FROM vbak INTO @DATA(ls_vbak) WHERE vbeln = @iv_vbeln.
      IF sy-subrc = 0.
        EXIT.
      ELSE.
        WAIT UP TO '0.5' SECONDS.
      ENDIF.
    ENDDO.
    "销售单不存在
    IF ls_vbak IS INITIAL.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'E' id = 'VL' number = '002' message_v1 = iv_vbeln ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message WITH ls_return-message_v1.
      APPEND ls_return TO lt_return.
      rv_return = VALUE #( return = lt_return ).
      RETURN.
    ENDIF.
    SELECT SINGLE vbeln,fkdat,vbtyp FROM vkdfs INTO @DATA(ls_vkdfs) WHERE vbeln = @iv_vbeln.
    "无需开票
    IF ls_vkdfs IS INITIAL.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'S' id = 'VF' number = '016' ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message.
      APPEND ls_return TO lt_return.
      rv_return = VALUE #( return = lt_return ).
      RETURN.
    ENDIF.
    "已完全开票项
    IF ls_vbak-fksak = 'C'.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'E' id = 'VF' number = '017' ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message .
      APPEND ls_return TO lt_return.
      rv_return = VALUE #( return = lt_return ).
      RETURN.
    ENDIF.
    SELECT vbeln,posnr FROM vbap INTO TABLE @DATA(lt_vbap) WHERE vbeln = @iv_vbeln.

    LOOP AT lt_vbap INTO DATA(ls_vbap).
      ls_bapivbrk-bill_date     = ls_vkdfs-fkdat.
      ls_bapivbrk-ref_doc       = ls_vbap-vbeln.
      ls_bapivbrk-ref_item      = ls_vbap-posnr.
      ls_bapivbrk-doc_number    = ls_vbap-vbeln.
      ls_bapivbrk-itm_number    = ls_vbap-posnr.
      ls_bapivbrk-ref_doc_ca    = 'C'.
      APPEND ls_bapivbrk TO lt_bapivbrk.
      CLEAR ls_bapivbrk.
    ENDLOOP.

    CALL FUNCTION 'BAPI_BILLINGDOC_CREATEMULTIPLE'
      EXPORTING
        testrun       = ''
      TABLES
        billingdatain = lt_bapivbrk
        return        = rv_return-return
        errors        = rv_return-errors
        success       = rv_return-success.

    READ TABLE rv_return-success INTO DATA(ls_success) INDEX 1.
    IF sy-subrc = 0 AND ls_success-bill_doc IS NOT INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
      "查底表，确认更新完毕
      DO 600 TIMES.
        SELECT SINGLE @abap_true FROM vbak INTO @DATA(lv_exists) WHERE vbeln = @iv_vbeln AND fksak = 'C'.
        IF sy-subrc = 0.
          EXIT.
        ELSE.
          WAIT UP TO 1 SECONDS.
        ENDIF.
      ENDDO.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ENDIF.
  ENDMETHOD.


  METHOD create_billing_by_dn.
    DATA: ls_return TYPE bapiret1.
    DATA: lt_return TYPE STANDARD TABLE OF bapiret1.
    DATA:ls_bapivbrk TYPE bapivbrk,
         lt_bapivbrk TYPE STANDARD TABLE OF bapivbrk.

    CLEAR: ls_return,lt_return[].
    DO 10 TIMES.
      SELECT SINGLE vbeln,wadat,vbtyp,fkivk,fkstk FROM likp INTO @DATA(ls_likp) WHERE vbeln = @iv_vbeln.
      IF sy-subrc = 0.
        EXIT.
      ELSE.
        WAIT UP TO '0.5' SECONDS.
      ENDIF.
    ENDDO.
    "交货单不存在
    IF ls_likp IS INITIAL.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'E' id = 'VL' number = '002' message_v1 = iv_vbeln ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message WITH ls_return-message_v1.
      APPEND ls_return TO lt_return.
      rv_return-return = lt_return .
      RETURN.
    ENDIF.
    rv_return-fkivk = ls_likp-fkivk.
    rv_return-fkstk = ls_likp-fkstk.
    "无需开票
    IF ls_likp-fkivk IS INITIAL AND ls_likp-fkstk IS INITIAL.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'S' id = 'VF' number = '016' ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message.
      APPEND ls_return TO lt_return.
      rv_return-return = lt_return .
      RETURN.
    ENDIF.
    "已完全开票项
    IF ( ls_likp-fkivk = 'C' AND ls_likp-fkstk IS INITIAL ) OR ( ls_likp-fkstk = 'C' AND ls_likp-fkivk IS INITIAL ).
      CLEAR ls_return.
      ls_return = VALUE #( type = 'E' id = 'VF' number = '017' ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message .
      APPEND ls_return TO lt_return.
      rv_return-return = lt_return .
      RETURN.
    ENDIF.
    SELECT vbeln,posnr FROM lips INTO TABLE @DATA(lt_lips) WHERE vbeln = @iv_vbeln.

    LOOP AT lt_lips INTO DATA(ls_lips).
      ls_bapivbrk-ref_doc     = ls_lips-vbeln.
      ls_bapivbrk-ref_item    = ls_lips-posnr.
      ls_bapivbrk-doc_number  = ls_lips-vbeln.
      ls_bapivbrk-itm_number  = ls_lips-posnr.
      ls_bapivbrk-ref_doc_ca  = 'J'.
      ls_bapivbrk-serv_date   = ls_likp-wadat.
      APPEND ls_bapivbrk TO lt_bapivbrk.
      CLEAR ls_bapivbrk.
    ENDLOOP.

    CALL FUNCTION 'BAPI_BILLINGDOC_CREATEMULTIPLE'
      EXPORTING
        testrun       = ''
      TABLES
        billingdatain = lt_bapivbrk
        return        = rv_return-return
        errors        = rv_return-errors
        success       = rv_return-success.

    READ TABLE rv_return-success INTO DATA(ls_success) INDEX 1.
    IF sy-subrc = 0 AND ls_success-bill_doc IS NOT INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
      "查底表，确认更新完毕,最大等10分钟
      DO 600 TIMES.
*      SELECT SINGLE @abap_true FROM vbrk INTO @DATA(lv_exists) WHERE vbeln = @ls_success-bill_doc.
        SELECT SINGLE fkstk,fkivk FROM likp INTO ( @rv_return-fkstk_ret,@rv_return-fkivk_ret ) WHERE vbeln = @iv_vbeln.
        IF rv_return-fkstk IS NOT INITIAL AND rv_return-fkstk <> 'C'.
          IF rv_return-fkstk_ret = 'C'.
            EXIT.
          ENDIF.
        ELSE.
          IF rv_return-fkivk_ret = 'C'.
            EXIT.
          ENDIF.
        ENDIF.
        WAIT UP TO 1 SECONDS.
      ENDDO.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ENDIF.
  ENDMETHOD.


  METHOD create_so_dn.
    DATA: lv_due_date   TYPE bapidlvcreateheader-due_date,
          ls_dn_items   TYPE bapidlvreftosalesorder,
          lt_dn_items   TYPE TABLE OF bapidlvreftosalesorder,
          ls_return     TYPE bapiret2,
          lv_dn_number  TYPE bapishpdelivnumb-deliv_numb,
          lv_ship_point TYPE bapidlvcreateheader-ship_point.

    CLEAR: ls_return,ls_dn_items,lt_dn_items[].
    DO 10 TIMES.
      SELECT SINGLE vbeln,lfgsk FROM vbakuk INTO @DATA(ls_vbakuk) WHERE vbeln = @iv_vbeln.
      IF sy-subrc = 0.
        EXIT.
      ELSE.
        WAIT UP TO '0.5' SECONDS.
      ENDIF.
    ENDDO.
    "销售单不存在
    IF ls_vbakuk IS INITIAL.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'E' id = 'VL' number = '002' message_v1 = iv_vbeln ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message WITH ls_return-message_v1.
      APPEND ls_return TO rv_return-return.
      RETURN.
    ENDIF.
    "无需交货
    IF ls_vbakuk-lfgsk IS INITIAL.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'S' id = 'VL' number = '461' ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message.
      APPEND ls_return TO rv_return-return.
      RETURN.
    ENDIF.
    "已完全交货
    IF ls_vbakuk-lfgsk = 'C'.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'E' id = 'VL' number = '455' ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message .
      APPEND ls_return TO rv_return-return.
      RETURN.
    ENDIF.

    SELECT vbeln,posnr,kwmeng,vrkme FROM vbap INTO TABLE @DATA(lt_vbap) WHERE vbeln = @iv_vbeln.

    LOOP AT lt_vbap INTO DATA(ls_vbap).
      CLEAR ls_dn_items.
      ls_dn_items-ref_doc    = ls_vbap-vbeln.
      ls_dn_items-ref_item   = ls_vbap-posnr.
      ls_dn_items-dlv_qty    = ls_vbap-kwmeng.
      ls_dn_items-sales_unit = ls_vbap-vrkme.
      APPEND ls_dn_items TO lt_dn_items.
    ENDLOOP.
*    ship_point = '1000'.
    lv_due_date = '99991231'.
    CALL FUNCTION 'BAPI_OUTB_DELIVERY_CREATE_SLS'
      EXPORTING
*       ship_point        = ship_point
        due_date          = lv_due_date
      IMPORTING
        delivery          = rv_return-vbeln
      TABLES
        sales_order_items = lt_dn_items
        return            = rv_return-return.

    LOOP AT rv_return-return TRANSPORTING NO FIELDS WHERE type CA 'AEX'.
      EXIT.
    ENDLOOP.
    IF sy-subrc <> 0 AND rv_return-vbeln IS NOT INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
      "查底表，确认更新完毕
      DO 600 TIMES.
        SELECT SINGLE @abap_true FROM likp INTO @DATA(lv_exists) WHERE vbeln = @rv_return-vbeln.
        IF sy-subrc = 0.
          EXIT.
        ELSE.
          WAIT UP TO 1 SECONDS.
        ENDIF.
      ENDDO.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ENDIF.
  ENDMETHOD.


  METHOD create_sto_dn.
    DATA: lv_due_date      TYPE bapidlvcreateheader-due_date,
          ls_dn_items      TYPE bapidlvreftosto,
          lt_dn_items      TYPE TABLE OF bapidlvreftosto,
          lt_created_items TYPE TABLE OF bapidlvitemcreated,
          ls_return        TYPE bapiret2,
          lv_dn_number     TYPE bapishpdelivnumb-deliv_numb,
          lv_ship_point    TYPE bapidlvcreateheader-ship_point.

    CLEAR: ls_return,ls_dn_items,lt_dn_items[].
    DO 10 TIMES.
      SELECT SINGLE ebeln FROM ekko INTO @DATA(ls_ekko) WHERE ebeln = @iv_vbeln.
      IF sy-subrc = 0.
        EXIT.
      ELSE.
        WAIT UP TO '0.5' SECONDS.
      ENDIF.
    ENDDO.
    "STO单不存在
    IF ls_ekko IS INITIAL.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'E' id = 'VL' number = '002' message_v1 = iv_vbeln ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message WITH ls_return-message_v1.
      APPEND ls_return TO rv_return-return.
      RETURN.
    ENDIF.
    SELECT SINGLE vbeln FROM vetvg INTO @DATA(ls_vetvg) WHERE vbeln = @iv_vbeln.
    "无需交货或交货完成
    IF ls_vetvg IS INITIAL.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'E' id = 'VL' number = '455' ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message .
      APPEND ls_return TO rv_return-return.
      RETURN.
    ENDIF.

    SELECT ebeln,ebelp,menge,meins FROM ekpo INTO TABLE @DATA(lt_ekpo) WHERE ebeln = @iv_vbeln.

    LOOP AT lt_ekpo INTO DATA(ls_ekpo).
      CLEAR ls_dn_items.
      ls_dn_items-ref_doc    = ls_ekpo-ebeln.
      ls_dn_items-ref_item   = ls_ekpo-ebelp.
      ls_dn_items-dlv_qty    = ls_ekpo-menge.
      ls_dn_items-sales_unit = ls_ekpo-meins.
      APPEND ls_dn_items TO lt_dn_items.
    ENDLOOP.
*    ship_point = '1000'.
    lv_due_date = '99991231'.
    CALL FUNCTION 'BAPI_OUTB_DELIVERY_CREATE_STO'
      EXPORTING
*       ship_point        = ship_point
        due_date          = lv_due_date
      IMPORTING
        delivery          = rv_return-vbeln
      TABLES
        stock_trans_items = lt_dn_items
        created_items     = lt_created_items
        return            = rv_return-return.
    "检查创建的行项目数
    IF rv_return-vbeln IS NOT INITIAL.
      IF lines( lt_created_items ) <> lines( lt_dn_items ).
        CLEAR ls_return.
        ls_return = VALUE #( type = 'E' id = '00' number = '001' message = TEXT-t04  ).
        MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message .
        APPEND ls_return TO rv_return-return.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
        RETURN.
      ENDIF.
    ENDIF.
    LOOP AT rv_return-return TRANSPORTING NO FIELDS WHERE type CA 'AEX'.
      EXIT.
    ENDLOOP.
    IF sy-subrc <> 0 AND rv_return-vbeln IS NOT INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
      "查底表，确认更新完毕
      DO 600 TIMES.
        SELECT SINGLE @abap_true FROM likp INTO @DATA(lv_exists) WHERE vbeln = @rv_return-vbeln.
        IF sy-subrc = 0.
          EXIT.
        ELSE.
          WAIT UP TO 1 SECONDS.
        ENDIF.
      ENDDO.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ENDIF.
  ENDMETHOD.


  METHOD post_dn.
    DATA: ls_return           TYPE bapiret2,
          ls_header_data      TYPE bapiobdlvhdrcon,
          ls_header_control   TYPE bapiobdlvhdrctrlcon,
          lt_header_deadlines TYPE STANDARD TABLE OF bapidlvdeadln,
          lt_item_data        TYPE STANDARD TABLE OF bapiobdlvitemcon,
          ls_item_data        TYPE bapiobdlvitemcon,
          lt_item_control     TYPE STANDARD TABLE OF bapiobdlvitemctrlcon,
          ls_item_control     TYPE bapiobdlvitemctrlcon,
          lt_item_spl         TYPE TABLE OF /spe/bapiobdlvitemconf,
          ls_item_spl         TYPE /spe/bapiobdlvitemconf.
    DATA: lv_timestamp_utc TYPE tzntstmps.
    CLEAR: ls_return.
    DO 10 TIMES.
      SELECT SINGLE vbeln,wbstk,wadat FROM likpuk INTO @DATA(ls_likp) WHERE vbeln = @iv_vbeln.
      IF sy-subrc = 0.
        EXIT.
      ELSE.
        WAIT UP TO '0.5' SECONDS.
      ENDIF.
    ENDDO.
    "交货单不存在
    IF ls_likp IS INITIAL.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'E' id = 'VL' number = '002' message_v1 = iv_vbeln ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message WITH ls_return-message_v1.
      APPEND ls_return TO rv_return-return.
      RETURN.
    ENDIF.
    "交货已过账
    IF ls_likp-wbstk = 'C'.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'E' id = 'VL' number = '602' ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message .
      APPEND ls_return TO rv_return-return.
      RETURN.
    ENDIF.

    SELECT vbeln,posnr,matnr,lfimg,lgmng,charg,lgort,meins,vrkme,umvkz,umvkn FROM lips INTO TABLE @DATA(lt_lips) WHERE vbeln = @iv_vbeln.
    LOOP AT lt_lips INTO DATA(ls_lips).
      CLEAR  ls_item_data.
      ls_item_data-deliv_numb      = iv_vbeln.
      ls_item_data-deliv_item      = ls_lips-posnr.
      ls_item_data-material        = ls_lips-matnr.
      ls_item_data-dlv_qty         = ls_lips-lfimg.
      ls_item_data-dlv_qty_imunit  = ls_lips-lgmng.
      ls_item_data-base_uom        = ls_lips-meins.
      ls_item_data-sales_unit      = ls_lips-vrkme.
      ls_item_data-fact_unit_nom   = ls_lips-umvkz.
      ls_item_data-fact_unit_denom = ls_lips-umvkn.
      ls_item_data-batch           = ls_lips-charg.
      APPEND ls_item_data TO lt_item_data.

      CLEAR  ls_item_control.
      ls_item_control-deliv_numb   = iv_vbeln.
      ls_item_control-deliv_item   = ls_lips-posnr.
      ls_item_control-chg_delqty   = 'X' .
      APPEND ls_item_control TO  lt_item_control.

      IF iv_reslo IS SUPPLIED AND iv_reslo IS NOT INITIAL.
        CLEAR ls_item_spl.
        ls_item_spl-deliv_numb  = iv_vbeln .
        ls_item_spl-deliv_item  = ls_lips-posnr .
        ls_item_spl-stge_loc    = iv_reslo. "更改库位
        APPEND ls_item_spl TO lt_item_spl.
      ENDIF.

    ENDLOOP.

    ls_header_data-deliv_numb     = iv_vbeln.
    ls_header_control-deliv_numb  = iv_vbeln.
    ls_header_control-post_gi_flg = 'X'.
    ls_header_control-volume_flg  = 'X'.
    IF iv_budat IS SUPPLIED AND iv_budat IS NOT INITIAL.
      ls_likp-wadat = iv_budat.
    ENDIF.
    lv_timestamp_utc = |{ ls_likp-wadat }{ sy-uzeit }|.
    lt_header_deadlines[] = VALUE #( deliv_numb = iv_vbeln
                                     ( timetype = 'WSHDRLFDAT' timestamp_utc = lv_timestamp_utc )"交货时间
                                     ( timetype = 'WSHDRWADAT' timestamp_utc = lv_timestamp_utc )"发货时间
                                     ( timetype = 'WSHDRLDDAT' timestamp_utc = lv_timestamp_utc )"装入时间
                                     ( timetype = 'WSHDRTDDAT' timestamp_utc = lv_timestamp_utc )"运输计划时间
                                     ( timetype = 'WSHDRKODAT' timestamp_utc = lv_timestamp_utc )"领货时间
                                   ).

    CALL FUNCTION 'BAPI_OUTB_DELIVERY_CONFIRM_DEC'
      EXPORTING
        header_data      = ls_header_data
        header_control   = ls_header_control
        delivery         = iv_vbeln
      TABLES
        item_data        = lt_item_data
        item_control     = lt_item_control
        item_data_spl    = lt_item_spl
        header_deadlines = lt_header_deadlines
        return           = rv_return-return.

    LOOP AT rv_return-return TRANSPORTING NO FIELDS WHERE type CA 'AEX'.
      EXIT.
    ENDLOOP.
    IF sy-subrc <> 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
      "查底表，确认更新完毕
      DO 600 TIMES.
        SELECT SINGLE wbstk INTO @DATA(lv_wbstk) FROM likp WHERE vbeln = @iv_vbeln AND wbstk = 'C'.
        IF sy-subrc = 0.
          EXIT."退出循环
        ELSE.
          WAIT UP TO '1' SECONDS.
        ENDIF.
      ENDDO.

      CHECK lv_wbstk = 'C'.
      SELECT vbeln,mjahr FROM vbfa AS a
        WHERE vbelv = @iv_vbeln AND vbtyp_n = 'R'
        AND NOT EXISTS ( SELECT smbln FROM m_mbmps WHERE smbln = a~vbeln AND sjahr = a~mjahr )
        ORDER BY erdat DESCENDING, erzet DESCENDING
        INTO TABLE @DATA(lt_vbfa)
        UP TO 1 ROWS.
      CHECK sy-subrc = 0.
      rv_return-mblnr = lt_vbfa[ 1 ]-vbeln.
      rv_return-mjahr = lt_vbfa[ 1 ]-mjahr.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ENDIF.
  ENDMETHOD.


  METHOD delete_dn.
    DATA: ls_return         TYPE bapiret2,
          ls_header_data    TYPE bapiobdlvhdrcon,
          ls_header_control TYPE bapiobdlvhdrctrlcon,
*          lt_header_deadlines TYPE STANDARD TABLE OF bapidlvdeadln,
*          lt_item_data        TYPE STANDARD TABLE OF bapiobdlvitemcon,
*          ls_item_data        TYPE bapiobdlvitemcon,
*          lt_item_control     TYPE STANDARD TABLE OF bapiobdlvitemctrlcon WITH HEADER LINE,
          lt_item_control   TYPE TABLE OF bapiobdlvitemctrlchg,
          ls_item_control   TYPE bapiobdlvitemctrlchg.
*    DATA: lv_timestamp_utc TYPE tzntstmps.
    CLEAR: ls_return.
    DO 10 TIMES.
      SELECT SINGLE vbeln,wbstk FROM likpuk INTO @DATA(ls_likp) WHERE vbeln = @iv_vbeln.
      IF sy-subrc = 0.
        EXIT.
      ELSE.
        WAIT UP TO '0.5' SECONDS.
      ENDIF.
    ENDDO.
    "交货单不存在
    IF ls_likp IS INITIAL.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'E' id = 'VL' number = '002' message_v1 = iv_vbeln ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message WITH ls_return-message_v1.
      APPEND ls_return TO rv_return.
      RETURN.
    ENDIF.
    "交货已过账
    IF ls_likp-wbstk IS NOT INITIAL.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'E' id = 'VL' number = '111' ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message .
      APPEND ls_return TO rv_return.
      RETURN.
    ENDIF.

    SELECT vbeln,posnr FROM lips INTO TABLE @DATA(lt_lips) WHERE vbeln = @iv_vbeln.
    LOOP AT lt_lips INTO DATA(ls_lips).
      CLEAR: ls_item_control .
      ls_item_control-deliv_numb = ls_lips-vbeln.
      ls_item_control-deliv_item = ls_lips-posnr.
      ls_item_control-del_item   = 'X'. "删除dn行项目
      APPEND ls_item_control TO lt_item_control.
    ENDLOOP.

    ls_header_data-deliv_numb    = iv_vbeln.
    ls_header_control-deliv_numb = iv_vbeln.
    ls_header_control-dlv_del    = 'X'."删除整个dn

    CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
      EXPORTING
        header_data    = ls_header_data
        header_control = ls_header_control
        delivery       = iv_vbeln
      TABLES
*       item_data      = lt_item_data
        item_control   = lt_item_control
*       item_data_spl  = lt_item_spl
*       header_deadlines = lt_header_deadlines
        return         = rv_return.

    LOOP AT rv_return TRANSPORTING NO FIELDS WHERE type CA 'AEX'.
      EXIT.
    ENDLOOP.
    IF sy-subrc <> 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ENDIF.
  ENDMETHOD.


  METHOD delete_so.
    DATA: ls_return TYPE bapiret2,
          ls_headx  TYPE bapisdh1x,
          lt_item   TYPE STANDARD TABLE OF bapisditm,
          ls_item   TYPE bapisditm,
          lt_itemx  TYPE STANDARD TABLE OF  bapisditmx,
          ls_itemx  TYPE bapisditmx.
    CLEAR: ls_return.

    SELECT vbeln,posnr INTO TABLE @DATA(lt_vbap) FROM vbap WHERE vbeln = @iv_vbeln AND posnr IN @it_posnr.
    IF sy-subrc = 0.
      ls_headx-updateflag = 'U'.         "UPDATE

      LOOP AT lt_vbap INTO DATA(ls_vbap).
        ls_item-itm_number    = ls_vbap-posnr ."行项目
        APPEND ls_item TO lt_item.
        ls_itemx-itm_number   = ls_vbap-posnr ."行项目
        ls_itemx-updateflag   =  'D'.
        APPEND ls_itemx TO lt_itemx.
      ENDLOOP.
      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        EXPORTING
          salesdocument    = iv_vbeln
          order_header_inx = ls_headx
        TABLES
          return           = rv_return
          order_item_in    = lt_item
          order_item_inx   = lt_itemx.
    ELSE.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'E' id = 'VL' number = '002' message_v1 = iv_vbeln ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message WITH ls_return-message_v1.
      APPEND ls_return TO rv_return.
      RETURN.
    ENDIF.
    LOOP AT rv_return TRANSPORTING NO FIELDS WHERE type CA 'AEX'.
      EXIT.
    ENDLOOP.
    IF sy-subrc <> 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ENDIF.
  ENDMETHOD.


  METHOD reverse_dn.
    DATA: ls_return TYPE bapiret2,
          lt_mesg   TYPE STANDARD TABLE OF mesg,
          lt_vbfa   TYPE STANDARD TABLE OF vbfavb.
    DATA: lv_budat TYPE budat.
    DATA: lv_error TYPE abap_bool.
    CLEAR: ls_return.
    DO 10 TIMES.
      SELECT SINGLE vbeln,wbstk,wadat_ist FROM likpuk INTO @DATA(ls_likp) WHERE vbeln = @iv_vbeln.
      IF sy-subrc = 0.
        EXIT.
      ELSE.
        WAIT UP TO '0.5' SECONDS.
      ENDIF.
    ENDDO.
    "交货单不存在
    IF ls_likp IS INITIAL.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'E' id = 'VL' number = '002' message_v1 = iv_vbeln ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message WITH ls_return-message_v1.
      APPEND ls_return TO rv_return-return.
      RETURN.
    ENDIF.
    "交货未过账
    IF ls_likp-wbstk NA 'BC'.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'E' id = 'VL' number = '001' message_v1 = TEXT-t02 ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message WITH ls_return-message_v1 .
      APPEND ls_return TO rv_return-return.
      RETURN.
    ENDIF.

    IF iv_budat IS SUPPLIED AND iv_budat IS NOT INITIAL.
      lv_budat = iv_budat.
    ELSE.
      lv_budat = ls_likp-wadat_ist.
    ENDIF.

    CALL FUNCTION 'WS_REVERSE_GOODS_ISSUE'
      EXPORTING
        i_vbeln                   = iv_vbeln
        i_budat                   = lv_budat
*       I_COUNT                   =
*       I_MBLNR                   =
        i_tcode                   = 'VL09'
        i_vbtyp                   = 'J'
      TABLES
        t_mesg                    = lt_mesg
        t_vbfa                    = lt_vbfa
      EXCEPTIONS
        error_reverse_goods_issue = 1
        OTHERS                    = 2.

    IF sy-subrc <> 0.
      lv_error = abap_true.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'E' id = 'VL' number = '001' message_v1 = TEXT-t03 ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message WITH ls_return-message_v1 .
      APPEND ls_return TO rv_return-return.
    ENDIF.
    rv_return-return = CORRESPONDING #( BASE ( rv_return-return  )
                                        lt_mesg MAPPING type = msgty
                                                        id = arbgb
                                                        number = txtnr
                                                        message_v1 = msgv1
                                                        message_v2 = msgv2
                                                        message_v3 = msgv3
                                                        message_v4 = msgv4 ).
    LOOP AT rv_return-return TRANSPORTING NO FIELDS WHERE type CA 'AEX'.
      EXIT.
    ENDLOOP.
    IF sy-subrc <> 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.

      SELECT vbeln,mjahr FROM @lt_vbfa AS a
        WHERE vbelv = @iv_vbeln AND vbtyp_n = 'h'
        ORDER BY erdat DESCENDING, erzet DESCENDING
        INTO TABLE @DATA(lt_vbfa_h)
        UP TO 1 ROWS.
      CHECK sy-subrc = 0.
      rv_return-mblnr = lt_vbfa_h[ 1 ]-vbeln.
      rv_return-mjahr = lt_vbfa_h[ 1 ]-mjahr.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ENDIF.
  ENDMETHOD.


  METHOD close_so.
    DATA: ls_return TYPE bapiret2,
          ls_headx  TYPE bapisdh1x,
          lt_item   TYPE STANDARD TABLE OF bapisditm,
          ls_item   TYPE bapisditm,
          lt_itemx  TYPE STANDARD TABLE OF  bapisditmx,
          ls_itemx  TYPE bapisditmx.
    CLEAR: ls_return.

    SELECT vbeln,posnr INTO TABLE @DATA(lt_vbap) FROM vbap WHERE vbeln = @iv_vbeln AND posnr IN @it_posnr.
    IF sy-subrc = 0.
      ls_headx-updateflag = 'U'.         "UPDATE

      LOOP AT lt_vbap INTO DATA(ls_vbap).
        ls_item-itm_number    = ls_vbap-posnr ."行项目
        ls_item-reason_rej    = iv_abgru.
        APPEND ls_item TO lt_item.
        ls_itemx-itm_number   = ls_vbap-posnr ."行项目
        ls_itemx-reason_rej   = abap_true.
        ls_itemx-updateflag   =  'U'.
        APPEND ls_itemx TO lt_itemx.
      ENDLOOP.
      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        EXPORTING
          salesdocument    = iv_vbeln
          order_header_inx = ls_headx
        TABLES
          return           = rv_return
          order_item_in    = lt_item
          order_item_inx   = lt_itemx.
    ELSE.
      CLEAR ls_return.
      ls_return = VALUE #( type = 'E' id = 'VL' number = '002' message_v1 = iv_vbeln ).
      MESSAGE ID ls_return-id TYPE ls_return-type NUMBER ls_return-number INTO ls_return-message WITH ls_return-message_v1.
      APPEND ls_return TO rv_return.
      RETURN.
    ENDIF.
    LOOP AT rv_return TRANSPORTING NO FIELDS WHERE type CA 'AEX'.
      EXIT.
    ENDLOOP.
    IF sy-subrc <> 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ENDIF.
  ENDMETHOD.


  METHOD get_month_lastday.
    CALL FUNCTION 'BKK_GET_MONTH_LASTDAY'
      EXPORTING
        i_date = iv_begda
      IMPORTING
        e_date = ev_endda.
  ENDMETHOD.


  METHOD start_job.
    DATA: jobcount TYPE tbtcjob-jobcount.
    DATA: rv_subrc LIKE sy-subrc.
    IF variant IS NOT INITIAL.
      rv_subrc = is_variant_exists( report = report variant = variant ).
      IF rv_subrc <> 0.
        rs_return = VALUE #( jobname = jobname jobcount = jobcount return = VALUE #( type = 'E' message =  |报表{ report }的变式{ variant }不存在| ) ).
        MESSAGE rs_return-return-message TYPE 'S' DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.
    ENDIF.
    IF jobuser IS INITIAL.
      jobuser = sy-uname.
    ENDIF.
    IF jobname IS INITIAL.
      jobname = |{ report }_{ sy-datum }{ sy-uzeit }{ jobuser }|.
    ENDIF.
    jobcount = open_job( jobname ).
    IF jobcount IS INITIAL.
      rs_return = VALUE #( jobname = jobname jobcount = jobcount return = VALUE #( type = 'E' message =  |后台任务{ jobname }创建失败| ) ).
      MESSAGE rs_return-return-message TYPE 'S' DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.
    IF variant IS INITIAL."未提供变式
      SUBMIT (report) WITH SELECTION-TABLE params AND RETURN USER jobuser VIA JOB jobname NUMBER jobcount.
      rv_subrc = sy-subrc.
    ELSE."按变式启动JOB
      SUBMIT (report) USING SELECTION-SET variant WITH SELECTION-TABLE params AND RETURN USER jobuser VIA JOB jobname NUMBER jobcount.
      rv_subrc = sy-subrc.
    ENDIF.
    IF rv_subrc = 0.
      rv_subrc = close_job( jobname = jobname jobcount = jobcount start_date = start_date start_time = start_time eventid = eventid eventparm = eventparm ).
      IF rv_subrc EQ 0.
        rs_return = VALUE #( jobname = jobname jobcount = jobcount return = VALUE #( type = 'S' message =  |后台任务{ jobname }成功创建并启动| ) ).
        MESSAGE s715(db) WITH jobname.
      ENDIF.
    ELSE.
      DATA(msg) = cl_abap_submit_handling=>get_error_message( ).
      rs_return = VALUE #( jobname = jobname jobcount = jobcount
                           return = VALUE #( type = 'E' message =  |后台任务{ jobname }启动失败| number = msg-msgno
                           message_v1 = msg-msgv1
                           message_v2 = msg-msgv2
                           message_v3 = msg-msgv3
                           message_v4 = msg-msgv4 ) ).
      MESSAGE ID msg-msgid
              TYPE 'S'
              NUMBER msg-msgno
              WITH msg-msgv1 msg-msgv2 msg-msgv3 msg-msgv4
              DISPLAY LIKE msg-msgty.
    ENDIF.
  ENDMETHOD.


  METHOD submit_job.
    CALL FUNCTION 'JOB_SUBMIT'
      EXPORTING
        authcknam               = jobuser
        jobcount                = jobcount
        jobname                 = jobname
        report                  = report
        variant                 = variant
      EXCEPTIONS
        bad_priparams           = 1
        bad_xpgflags            = 2
        invalid_jobdata         = 3
        jobname_missing         = 4
        job_notex               = 5
        job_submit_failed       = 6
        lock_failed             = 7
        program_missing         = 8
        prog_abap_and_extpg_set = 9
        OTHERS                  = 10.
    rv_subrc = sy-subrc.
  ENDMETHOD.


  METHOD is_variant_exists.
    CALL FUNCTION 'RS_VARIANT_EXISTS'
      EXPORTING
        report              = report
        variant             = variant
      IMPORTING
        r_c                 = rv_subrc
      EXCEPTIONS
        not_authorized      = 1
        no_report           = 2
        report_not_existent = 3
        report_not_supplied = 4.
    rv_subrc = COND #( WHEN sy-subrc <> 0 THEN sy-subrc ELSE rv_subrc ).
  ENDMETHOD.


  METHOD print_excel.
    DATA: lo_data      TYPE REF TO zcl_excel_template_data,
          lo_excel     TYPE REF TO zcl_excel,
          lo_reader    TYPE REF TO zif_excel_reader,
          lo_worksheet TYPE REF TO zcl_excel_worksheet,
          lo_error     TYPE REF TO zcx_excel.

    TRY.
        lo_data = NEW #( it_data = it_data ).
*  CREATE reader
        CREATE OBJECT lo_reader TYPE zcl_excel_reader_xlsm.

*  LOAD template
        lo_excel = lo_reader->load_smw0( iv_w3objid ).
        lo_worksheet = lo_excel->get_active_worksheet( ).

        lo_excel->fill_template( lo_data ).
        CALL FUNCTION 'ZFUN_DISPLAY_EXCEL'
          EXPORTING
            iv_xlsm      = iv_xlsm    " 是否为XLSM格式
            iv_autoprint = iv_autoprint    " 是否自动打印
            iv_filename  = iv_filename
            io_excel     = lo_excel.
      CATCH zcx_excel INTO lo_error.
        MESSAGE lo_error->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
    ENDTRY.
  ENDMETHOD.


  METHOD get_default_variant.
    DATA: lv_repid   LIKE sy-repid.
    DATA: lv_subrc   LIKE sy-subrc.
    DATA: lv_variant TYPE rsvar-variant.
    DATA: lt_callstack TYPE abap_callstack.

    CALL FUNCTION 'SYSTEM_CALLSTACK'
      IMPORTING
        callstack = lt_callstack.

    ASSIGN lt_callstack[ 2 ] TO FIELD-SYMBOL(<fs_stack>).
    IF sy-subrc EQ 0.
      lv_repid = <fs_stack>-mainprogram.
    ENDIF.

    CHECK lv_repid IS NOT INITIAL.
    IF sy-slset IS INITIAL AND
       sy-calld IS INITIAL AND
       sy-batch IS INITIAL AND
       sy-tcode <> 'SE38'  AND
       sy-tcode <> 'SA38'.

*--- 用户默认变式
      lv_variant = |U_{ sy-uname }|.
      lv_subrc = is_variant_exists( report = lv_repid variant = lv_variant ).

      IF lv_subrc IS NOT INITIAL.
*--- 自定义默认变式/不跨Client
        lv_variant = |C_{ sy-tcode }|.
        lv_subrc = is_variant_exists( report = lv_repid variant = lv_variant ).
        IF lv_subrc IS NOT INITIAL.
*--- 系统默认变式,跨客户端,"CUS&"开头变式会产生请求
          lv_variant = |CUS&{ sy-tcode }|.
          lv_subrc = is_variant_exists( report = lv_repid variant = lv_variant ).
          IF lv_subrc IS NOT INITIAL.
            lv_variant = |SAP&{ sy-tcode }|.
            lv_subrc = is_variant_exists( report = lv_repid variant = lv_variant ).
          ENDIF.
        ENDIF.
      ENDIF.
      IF lv_subrc = 0.
        CALL FUNCTION 'RS_SUPPORT_SELECTIONS'
          EXPORTING
            report               = lv_repid
            variant              = lv_variant
          EXCEPTIONS
            variant_not_existent = 01
            variant_obsolete     = 02.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_user_param.
    DATA: lt_params TYPE ustyp_t_parameters,
          ls_param  TYPE ustyp_parameters.

    CALL FUNCTION 'SUSR_USER_PARAMETERS_GET'
      EXPORTING
        user_name           = sy-uname
      TABLES
        user_parameters     = lt_params[]
      EXCEPTIONS
        user_name_not_exist = 1
        OTHERS              = 2.

    READ TABLE lt_params INTO ls_param WITH KEY parid = iv_parid.
    rv_parva = ls_param-parva.
  ENDMETHOD.


  METHOD upload_file_to_server.
    DATA: lv_filepath TYPE rlgrap-filename.
    DATA(ls_return) = upload_file( iv_filename = iv_filename ).
    IF ls_return-subrc <> 0.
      rs_return = VALUE #( return = VALUE #( id = '00' type = 'E' number = '001' message = '文件读取错误' ) ).
      RETURN.
    ENDIF.
    DATA(ls_split_file) = split_file( iv_filename ).
    TRY .
        "将文件写入到服务器上面的文件
        lv_filepath = |{ iv_path }/{ ls_split_file-filename }|.
        OPEN DATASET lv_filepath FOR OUTPUT IN BINARY MODE.
        IF sy-subrc EQ 0.
          LOOP AT ls_return-data_tab INTO DATA(ls_tab).
            TRANSFER ls_tab TO lv_filepath.
          ENDLOOP.
          CLOSE DATASET lv_filepath.
          rs_return = VALUE #( filename = lv_filepath return = VALUE #( id = '00' type = 'S' number = '001' message = '上传成功' ) ).
        ENDIF.
      CATCH cx_sy_file_authority .
        rs_return = VALUE #( return = VALUE #( id = '00' type = 'E' number = '001' message = '保存失败,文件未授权' ) ).
      CATCH cx_sy_file_open .
        rs_return = VALUE #( return = VALUE #( id = '00' type = 'E' number = '001' message = '保存失败,文件已打开' ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD upload_file.
    CALL METHOD cl_gui_frontend_services=>gui_upload
      EXPORTING
        filename                = CONV #( iv_filename )
        filetype                = 'BIN'
      IMPORTING
        filelength              = rs_return-filelength
*       header                  = lv_header
      CHANGING
        data_tab                = rs_return-data_tab
      EXCEPTIONS
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        not_supported_by_gui    = 17
        error_no_gui            = 18
        OTHERS                  = 19.
    rs_return-subrc = sy-subrc .
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
  ENDMETHOD.


  METHOD split_file.
    CALL FUNCTION 'STPU1_EXTRACT_FILENAME'
      EXPORTING
        file_and_path = iv_filename
      IMPORTING
        file          = rs_return-filename
        pathname      = rs_return-pathname.
    SPLIT rs_return-filename AT '.' INTO TABLE DATA(lt_tab).
    IF sy-subrc = 0.
      DATA(lines) = lines( lt_tab ).
      LOOP AT lt_tab INTO DATA(ls_tab).
        IF sy-tabix = 1.
          rs_return-pure_filename = ls_tab.
        ELSEIF  sy-tabix < lines.
          rs_return-pure_filename = |{ rs_return-pure_filename }.{ ls_tab }|.
        ELSE.
          rs_return-pure_extension = ls_tab.
        ENDIF.
      ENDLOOP.
    ELSE.
      rs_return-pure_filename = rs_return-filename.
    ENDIF.
  ENDMETHOD.


  METHOD save_file_dialog.
    DATA: lv_filename     TYPE rlgrap-filename,
          lv_fname        TYPE string,
          lv_path         TYPE string,
          lv_fullpath     TYPE string,
          lv_user_action  TYPE i,
          lv_default_name TYPE string.

    lv_default_name = iv_filename.
    CALL METHOD cl_gui_frontend_services=>file_save_dialog
      EXPORTING
*       window_title         = lv_title
        default_extension    = 'xls'
        default_file_name    = lv_default_name
        file_filter          = cl_gui_frontend_services=>filetype_excel
*       initial_directory    = 'C:\'
      CHANGING
        filename             = lv_fname
        path                 = lv_path
        fullpath             = lv_fullpath
        user_action          = lv_user_action
      EXCEPTIONS
        cntl_error           = 1
        error_no_gui         = 2
        not_supported_by_gui = 3
        OTHERS               = 4.
    CHECK lv_user_action = 0.
    rv_filename = lv_fullpath.
  ENDMETHOD.


  METHOD download_file.
    CHECK iv_filename IS NOT INITIAL.
    cl_gui_frontend_services=>gui_download(
      EXPORTING
        filename                = CONV #( iv_filename )
        filetype                = 'BIN'
        confirm_overwrite       = abap_true
      IMPORTING
        filelength              = DATA(lv_length)
      CHANGING
        data_tab                = data_tab
      EXCEPTIONS
        file_write_error        = 1
        no_batch                = 2
        gui_refuse_filetransfer = 3
        invalid_type            = 4
        no_authority            = 5
        unknown_error           = 6
        header_not_allowed      = 7
        separator_not_allowed   = 8
        filesize_not_allowed    = 9
        header_too_long         = 10
        dp_error_create         = 11
        dp_error_send           = 12
        dp_error_write          = 13
        unknown_dp_error        = 14
        access_denied           = 15
        dp_out_of_memory        = 16
        disk_full               = 17
        dp_timeout              = 18
        file_not_found          = 19
        dataprovider_exception  = 20
        control_flush_error     = 21
        not_supported_by_gui    = 22
        error_no_gui            = 23
        OTHERS                  = 24
    ).
    IF sy-subrc <> 0.
      rs_return = VALUE #( id = '00' type = 'E' number = '001' message = '保存失败' ).
    ELSE.
      rs_return = VALUE #( id = '00' type = 'S' number = '001' message = '保存成功' ).
    ENDIF.

  ENDMETHOD.


  METHOD download_file_from_server.
    DATA(ls_return) = read_file( iv_filename = iv_filename_server ).
    IF ls_return-return-type = 'S'.
      rs_return = download_file( iv_filename = iv_filename_client data_tab = ls_return-data_tab ).
    ELSE.
      rs_return = ls_return-return.
    ENDIF.
  ENDMETHOD.


  METHOD read_file.
    DATA: ls_data TYPE ty_pic_tab.
    TRY.
        OPEN DATASET iv_filename FOR INPUT IN BINARY MODE.
        DO.
          READ DATASET iv_filename INTO ls_data ACTUAL LENGTH DATA(bytes).
          IF sy-subrc <> 0.
            EXIT.
          ENDIF.
          APPEND ls_data TO rs_return-data_tab.
        ENDDO.
        CLOSE DATASET iv_filename.
        rs_return = VALUE #( BASE rs_return  return = VALUE #( id = '00' type = 'S' number = '001' message = '下载成功' ) ).
      CATCH  cx_sy_file_authority.
        rs_return = VALUE #( return = VALUE #( id = '00' type = 'E' number = '001' message = '下载失败,文件未授权' ) ).
      CATCH cx_sy_file_open .
        rs_return = VALUE #( return = VALUE #( id = '00' type = 'E' number = '001' message = '下载失败,文件已打开' ) ).
      CATCH cx_sy_file_access_error.
        rs_return = VALUE #( return = VALUE #( id = '00' type = 'E' number = '001' message = '下载失败,文件读取错误' ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD create_url.
    CALL FUNCTION 'DP_CREATE_URL'
      EXPORTING
        type                 = 'IMAGE'                "#EC NOTEXT
        subtype              = iv_subtype "
*       size                 = gi_graphic_size
*       lifetime             = cndp_lifetime_transaction  "
      TABLES
        data                 = data_tab
      CHANGING
        url                  = rv_url
      EXCEPTIONS
        dp_invalid_parameter = 1
        dp_error_put_table   = 2
        dp_error_general     = 3
        OTHERS               = 4.
  ENDMETHOD.


  METHOD resize_image.
    DATA:lf_xres     TYPE i,
         lf_yres     TYPE i,
         lf_xres_new TYPE i,
         lf_yres_new TYPE i,
         lf_ratio    TYPE menge_d. "小数.

    TRY.
        rv_small = iv_original.
        DATA(lo_image) = NEW cl_fxs_image_processor( ).
        DATA(lf_handle) = lo_image->add_image( iv_original ).
        lo_image->get_info(
          EXPORTING
            iv_handle = lf_handle
          IMPORTING
            ev_xres   = lf_xres
            ev_yres   = lf_yres ).

        lf_ratio = lf_xres / lf_yres.
        IF lf_ratio > 1. "宽比高大
          lf_xres_new = nmin( val1 = lf_xres val2 = iv_max_width )."求出新的最大允许宽度
          lf_yres_new = lf_xres_new / lf_ratio.
        ELSE."高比宽大
          lf_yres_new = nmin( val1 = lf_yres val2 = iv_max_height )."求出新的最大允许高度
          lf_xres_new = lf_yres_new * lf_ratio.
        ENDIF.

        IF lf_xres_new >= lf_xres.
          lo_image->discard_image( lf_handle ).
          FREE lo_image.
          RETURN.
        ENDIF.
        lo_image->resize(
          EXPORTING
            iv_handle = lf_handle
            iv_xres   = lf_xres_new
            iv_yres   = lf_yres_new ).
        rv_small = lo_image->get_image( lf_handle ).
        lo_image->discard_image( lf_handle ).
        FREE lo_image.
      CATCH cx_fxs_image_unsupported.
      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.


  METHOD binary_to_xstring.
    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
      EXPORTING
        input_length = iv_filelength
      IMPORTING
        buffer       = rv_xstring
      TABLES
        binary_tab   = data_tab
      EXCEPTIONS
        failed       = 1
        OTHERS       = 2.
  ENDMETHOD.


  METHOD xstring_to_binary.
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = iv_xstring
*       append_to_table = space
*  IMPORTING
*       output_length   =
      TABLES
        binary_tab = data_tab.
  ENDMETHOD.


  METHOD show_picture.
    CALL FUNCTION 'ZFUN_DISPLAY_PICTURE'
      EXPORTING
        iv_filename = iv_filename
        io_picture  = io_picture.
  ENDMETHOD.


  METHOD remove_file_from_server.
    TRY.
        DELETE DATASET iv_filename .
        IF sy-subrc = 0.
          rs_return = VALUE #( id = '00' type = 'S' number = '001' message = '删除成功' ) .
        ELSE.
          rs_return = VALUE #( id = '00' type = 'S' number = '001' message = '删除失败' ) .
        ENDIF.
      CATCH  cx_sy_file_authority.
        rs_return = VALUE #( id = '00' type = 'S' number = '001' message = '删除失败,文件未授权' ) .
      CATCH cx_sy_file_open .
        rs_return = VALUE #( id = '00' type = 'S' number = '001' message = '删除失败,文件已打开' ) .
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
