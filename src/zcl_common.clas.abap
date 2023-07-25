class ZCL_COMMON definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_billing_return,
        fkstk     TYPE likp-fkstk,
        fkivk     TYPE likp-fkivk,
        fkstk_ret TYPE likp-fkstk, "BAPI后交货开票状态
        fkivk_ret TYPE likp-fkivk, "BAPI后公司间开票状态
        return    TYPE bapiret1_t,
        errors    TYPE /syclo/sd_bapivbrkerrors_tab,
        success   TYPE bapivbrksuccess_t,
      END OF ty_billing_return .
  types:
    BEGIN OF ty_dn_return,
        vbeln  TYPE vbeln_vl,
        return TYPE bapiret2_t,
      END OF ty_dn_return .
  types:
    BEGIN OF ty_dn_post_return,
        mblnr  TYPE mblnr,
        mjahr  TYPE mjahr,
        return TYPE bapiret2_t,
      END OF ty_dn_post_return .
  types:
    tt_posnr TYPE STANDARD TABLE OF /cwm/r_posnr .

  class-methods AUTHORITY_CHECK_TCODE
    importing
      !TCODE type TCODE .
  class-methods GET_MONTH_LASTDAY
    importing
      value(IV_BEGDA) type BEGDA
    returning
      value(EV_ENDDA) type ENDDA .
  class-methods GET_FILE_NAME
    returning
      value(RV_FILE) type RLGRAP-FILENAME .
  class-methods DOWNLOAD_TEMPLATE
    importing
      !IV_OBJID type W3OBJID
      !IV_FILENAME type RLGRAP-FILENAME .
  class-methods UPLOAD_EXCEL
    importing
      !IV_FILENAME type RLGRAP-FILENAME
      !IV_SKIPPED_ROWS type I
      !IV_SKIPPED_COLS type I
      !IV_MAX_COL type I
      !IV_MAX_ROW type I
    exporting
      !ET_TABLE type STANDARD TABLE
    exceptions
      ERROR
      CONVER_ERROR .
  class-methods EXPORT_EXCEL
    importing
      !IV_FILENAME type RLGRAP-FILENAME
      !IT_TABLE type STANDARD TABLE
    raising
      ZCX_EXCEL .
  class-methods PRINT_EXCEL
    importing
      !IV_W3OBJID type W3OBJID
      !IT_DATA type ZCL_EXCEL_TEMPLATE_DATA=>TT_TEMPLATE_DATA_SHEETS
      !IV_XLSM type ABAP_BOOL default ABAP_FALSE
      !IV_AUTOPRINT type ABAP_BOOL default ABAP_FALSE
      !IV_FILENAME type STRING optional .
  class-methods GET_OJB_NUMBER
    importing
      !IV_OBJ type ZEOBJECT
      !IV_OBJKEY type ZEKEY
      !IV_MAX type ZESEQ_MAX
      !IV_COUNT type ZECOUNT
      !IV_OBJ_D type ZEOBJECT_D
      !IV_REPEAT type ZEREPEAT optional
    returning
      value(RV_SEQ) type ZESEQ .
  class-methods SHOW_PROGRESSBAR
    importing
      !IV_CURRENT type I
      !IV_TOTAL type I
      !IV_MSG type STRING optional .
  class-methods START_JOB
    importing
      value(JOBNAME) type TBTCJOB-JOBNAME optional
      value(JOBUSER) type SY-UNAME optional
      value(REPORT) type REPID
      !VARIANT type RSVAR-VARIANT optional
      !PARAMS type RSPARAMS_TT
      !START_DATE type TBTCJOB-SDLSTRTDT optional
      !START_TIME type TBTCJOB-SDLSTRTTM optional
    returning
      value(RS_RETURN) type BAPIRET2 .
  class-methods SUBMIT_JOB
    importing
      !JOBNAME type TBTCJOB-JOBNAME
      !JOBCOUNT type TBTCJOB-JOBCOUNT
      !JOBUSER type SY-UNAME
      !REPORT type REPID
      !VARIANT type RSVAR-VARIANT
    returning
      value(RV_SUBRC) type SY-SUBRC .
  class-methods OPEN_JOB
    importing
      !JOBNAME type TBTCJOB-JOBNAME
    returning
      value(JOBCOUNT) type TBTCJOB-JOBCOUNT .
  class-methods CLOSE_JOB
    importing
      !JOBNAME type TBTCJOB-JOBNAME
      !JOBCOUNT type TBTCJOB-JOBCOUNT
      !START_DATE type TBTCJOB-SDLSTRTDT optional
      !START_TIME type TBTCJOB-SDLSTRTTM optional
    returning
      value(RV_SUBRC) type SY-SUBRC .
  class-methods AM_I_IN_JOB
    exporting
      !IN_JOB type ABAP_BOOL
      !JOBCOUNT type BTCJOBCNT
      !JOBNAME type BTCJOB .
  class-methods IS_VARIANT_EXISTS
    importing
      !REPORT type SY-REPID
      !VARIANT type RSVAR-VARIANT
    returning
      value(RV_SUBRC) type SY-SUBRC .
  class-methods RV_CALL_DISPLAY_TRANSACTION
    importing
      value(BUKRS) type BUKRS default '    '
      value(GJAHR) type GJAHR default '0000'
      value(LGNUM) type VBFA-LGNUM default '   '
      value(POSNR) type VBAP-POSNR default '000000'
      value(VBELN) type VBUK-VBELN
      value(AUFNR) type VBAK-AUFNR optional
      value(VBTYP) type VBUK-VBTYP default ' '
      value(FI_APPLI) type VBFAL-APPLI default '  ' .
  class-methods DISPLAY_SD_DOC
    importing
      value(VBELN) type VBUK-VBELN .
  class-methods DISPLAY_SO
    importing
      value(VBELN) type VBUK-VBELN .
  class-methods DISPLAY_DN
    importing
      value(VBELN) type VBUK-VBELN .
  class-methods DISPLAY_IV
    importing
      !VBELN type VBUK-VBELN .
  class-methods DISPLAY_MIGO
    importing
      !VBELN type VBUK-VBELN .
  class-methods DISPLAY_PR
    importing
      !VBELN type VBUK-VBELN .
  class-methods DISPLAY_PO
    importing
      !VBELN type VBUK-VBELN .
  class-methods DISPLAY_FI
    importing
      value(BUKRS) type BUKRS default '    '
      value(GJAHR) type GJAHR default '0000'
      value(VBELN) type VBUK-VBELN .
  class-methods DISPLAY_BP
    importing
      !IV_PARTNER type BUT000-PARTNER .
  class-methods DISPLAY_CO
    importing
      !AUFNR type AUFNR .
  class-methods DISPLAY_IDOC
    importing
      !IV_DOCNUM type EDIDC-DOCNUM .
  class-methods ADD_ROLE
    importing
      !IV_USERNAME type BAPIBNAME-BAPIBNAME
      !IT_ROLES type SUID_TT_BAPIAGR
    returning
      value(RETURN) type TT_BAPIRET2 .
  class-methods SWC_CALL_METHOD
    importing
      value(OBJTYPE) type SWOTOBJID-OBJTYPE optional
      value(OBJKEY) type SWOTOBJID-OBJKEY optional
      value(OBJECT) type SWOTRTIME-OBJECT optional
      value(METHOD) type SWO_METHOD default 'DISPLAY'
    returning
      value(RETURN) type SWOTRETURN .
  class-methods CREATE_BILLING_BY_SO
    importing
      value(IV_VBELN) type VBELN
    returning
      value(RV_RETURN) type TY_BILLING_RETURN .
  class-methods CREATE_BILLING_BY_DN
    importing
      value(IV_VBELN) type VBELN
    returning
      value(RV_RETURN) type TY_BILLING_RETURN .
  class-methods CREATE_SO_DN
    importing
      value(IV_VBELN) type VBELN
    returning
      value(RV_RETURN) type TY_DN_RETURN .
  class-methods CREATE_STO_DN
    importing
      value(IV_VBELN) type VBELN
    returning
      value(RV_RETURN) type TY_DN_RETURN .
  class-methods POST_DN
    importing
      value(IV_VBELN) type LIKP-VBELN
      !IV_BUDAT type BUDAT optional
      !IV_RESLO type RESLO optional
    returning
      value(RV_RETURN) type TY_DN_POST_RETURN .
  class-methods REVERSE_DN
    importing
      value(IV_VBELN) type LIKP-VBELN
      !IV_BUDAT type BUDAT optional
    returning
      value(RV_RETURN) type TY_DN_POST_RETURN .
  class-methods DELETE_DN
    importing
      value(IV_VBELN) type LIKP-VBELN
    returning
      value(RV_RETURN) type BAPIRET2_T .
  class-methods DELETE_SO
    importing
      value(IV_VBELN) type VBAK-VBELN
      !IT_POSNR type TT_POSNR optional
    returning
      value(RV_RETURN) type BAPIRET2_T .
  class-methods CLOSE_SO
    importing
      value(IV_VBELN) type VBAK-VBELN
      !IT_POSNR type TT_POSNR optional
      value(IV_ABGRU) type VBAP-ABGRU
    returning
      value(RV_RETURN) type BAPIRET2_T .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_COMMON IMPLEMENTATION.


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
    IF start_date IS NOT INITIAL.
      CALL FUNCTION 'JOB_CLOSE'
        EXPORTING
          jobname              = jobname
          jobcount             = jobcount
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
    ELSE.
      CALL FUNCTION 'JOB_CLOSE'
        EXPORTING
          jobname              = jobname
          jobcount             = jobcount
          strtimmed            = abap_true
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
        default_extension       = cl_gui_frontend_services=>filetype_excel
        file_filter             = cl_gui_frontend_services=>filetype_excel
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
        SELECT SINGLE wbstk INTO @DATA(lv_wbstk) FROM likp WHERE vbeln = @iv_vbeln.
        IF sy-subrc = 0.
          IF lv_wbstk NE 'C'."交货单未过账成功，直接返回
            RETURN.
          ELSE.
            EXIT."退出循环
          ENDIF.
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
    IF jobuser IS INITIAL.
      jobuser = sy-uname.
    ENDIF.
    IF jobname IS INITIAL.
      jobname = |{ report }_{ sy-datum }{ sy-uzeit }{ jobuser }|.
    ENDIF.
    jobcount = open_job( jobname ).
    IF jobcount IS INITIAL.
      rs_return = VALUE #( type = 'E' message =  |后台任务{ jobname }创建失败| ).
      MESSAGE rs_return-message TYPE 'S' DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.
    IF variant IS INITIAL."未提供变式
      SUBMIT (report) WITH SELECTION-TABLE params AND RETURN USER jobuser VIA JOB jobname NUMBER jobcount.
      rv_subrc = sy-subrc.
    ELSE."按变式启动JOB
      rv_subrc = is_variant_exists( report = report variant = variant ).
      IF rv_subrc <> 0.
        rs_return = VALUE #( type = 'E' message =  |报表{ report }的变式{ variant }不存在| ).
        MESSAGE rs_return-message TYPE 'S' DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.
      SUBMIT (report) USING SELECTION-SET variant WITH SELECTION-TABLE params AND RETURN USER jobuser VIA JOB jobname NUMBER jobcount.
      rv_subrc = sy-subrc.
    ENDIF.
    IF rv_subrc = 0.
      rv_subrc = close_job( jobname = jobname jobcount = jobcount start_date = start_date start_time = start_time ).
      IF rv_subrc EQ 0.
        rs_return = VALUE #( type = 'S' message =  |后台任务{ jobname }成功创建并启动| ).
        MESSAGE s715(db) WITH jobname.
      ENDIF.
    ELSE.
      DATA(msg) = cl_abap_submit_handling=>get_error_message( ).
      rs_return = VALUE #( type = 'E' message =  |后台任务{ jobname }启动失败| number = msg-msgno
                           message_v1 = msg-msgv1
                           message_v2 = msg-msgv2
                           message_v3 = msg-msgv3
                           message_v4 = msg-msgv4 ).
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
ENDCLASS.
