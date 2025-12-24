FUNCTION zbapi_material_availability.
*"----------------------------------------------------------------------
*"*"全局接口：
*"  IMPORTING
*"     VALUE(IT_MATERIAL_AVAILABILITY) TYPE  ZSTMATERIAL_AVAILABILITY
*"  TABLES
*"      WMDVSX STRUCTURE  BAPIWMDVS
*"      WMDVEX STRUCTURE  BAPIWMDVE
*"      RETURN STRUCTURE  BAPIRETURN OPTIONAL
*"----------------------------------------------------------------------
  DATA lt_wmdvsx TYPE STANDARD TABLE OF bapiwmdvs.
  DATA lv_tabix LIKE sy-tabix.


  CHECK it_material_availability IS NOT INITIAL.


  DATA: lv_material_long TYPE matnr40.
  LOOP AT it_material_availability INTO DATA(ls_material_availability).
* initialize:
    CLEAR: return, message, matvp, am61r, tmvf, t_mara.
    lv_tabix = sy-tabix.
** Start - FLE MATNR BAPI Changes on input
    cl_matnr_chk_mapper=>convert_on_input(
      EXPORTING
        iv_matnr18    = ls_material_availability-material
        iv_matnr40    = ls_material_availability-material_long
        iv_guid       = ls_material_availability-material_guid
        iv_version    = ls_material_availability-material_vers
        iv_matnr_ext  = ls_material_availability-material_ext
      IMPORTING
        ev_matnr40    = lv_material_long
    ).
** End - FLE MATNR BAPI Changes on input

** Begin FLE segmentation BAPI Changes
    PERFORM sfle_req_seg USING ls_material_availability-sgt_rcat ls_material_availability-req_seg_long return.
    IF sy-subrc IS NOT INITIAL.
      APPEND return.
      CONTINUE.
    ENDIF.
** End FLE segmentation BAPI Changes

    DATA: l_atp_type(1),
          l_trtyp       LIKE bapicm61v-trtyp,
          l_wbs_elem    LIKE vbakkom-ps_psp_pnr,
          l_atpca       LIKE atpca,
          l_atpcc       LIKE atpcc,
          l_atpcs       LIKE atpcs  OCCURS 0 WITH HEADER LINE,
          l_atpmatx     LIKE atpmat OCCURS 0 WITH HEADER LINE,
          l_atpdsx      LIKE atpds  OCCURS 0 WITH HEADER LINE,
          l_t441vx      LIKE t441v    OCCURS 0 WITH HEADER LINE,
          l_atpfield    LIKE atpfield OCCURS 0 WITH HEADER LINE,
          p_atpmsgx     LIKE atpmsg   OCCURS 0 WITH HEADER LINE,
          l_return      LIKE return.
    TABLES: kna1,    "Kundenstamm
            vbap.    "Belegposition



*-->Prüfregel vorbelegen falls initial
    IF ls_material_availability-check_rule IS INITIAL.
      MOVE 'A ' TO  ls_material_availability-check_rule.
    ENDIF.
*--> Materialdaten beschaffen
    PERFORM read_mt61d USING lv_material_long ls_material_availability-plant CHANGING return.
    IF NOT return IS INITIAL.
      APPEND return.
      CONTINUE.
    ENDIF.
    MOVE matvp-mtvfp TO tmvf-mtvfp.
*--> Kundennummer prüfen
    IF NOT ls_material_availability-customer IS INITIAL.
      CALL FUNCTION 'V_KNA1_SINGLE_READ'
        EXPORTING
          pi_kunnr            = ls_material_availability-customer
          pi_cvp_behavior     = cvp_cl_read_api_deflt_behavior=>cvp_if_const_dcpld_i1~gc_single_behavior_exception
          pi_bypassing_buffer = 'X'
        IMPORTING
          pe_kna1             = kna1
        EXCEPTIONS
          no_records_found    = 1
          OTHERS              = 2.
      IF sy-subrc NE 0.
        MOVE: sy-subrc  TO message-subrc,
              'CO'      TO message-msgid,
              'E'       TO message-msgty,
              '845'     TO message-msgno.
*--> FILL RETURN PARAMETER
        PERFORM fill_output_return
                   USING
                      message
                   CHANGING
                      return.
        APPEND return.
        IF ls_material_availability-stock_ind CA 'VW'.
          EXIT.
        ENDIF.
      ENDIF.
    ENDIF.

    MOVE 'V' TO l_trtyp.
*--> Fabrikkalender beschaffen
    PERFORM read_t001 USING ls_material_availability-plant CHANGING l_return.
    IF NOT l_return IS INITIAL.
      CLEAR return.
      return-type       = l_return-type.
      return-code       = l_return-code.
      return-message    = l_return-message.
      return-message_v1 = l_return-message_v1.
      CLEAR l_return.
      EXIT.
    ENDIF.
*--> Mengeneinheit prüfen
    IF matvp-meins NE ls_material_availability-unit.        "HW 668316
      PERFORM unit_conversion CHANGING am61r ls_material_availability-unit ls_material_availability-batch l_return.
      IF NOT l_return IS INITIAL.
        CLEAR return.
        return-type       = l_return-type.
        return-code       = l_return-code.
        return-message    = l_return-message.
        APPEND return.
        CLEAR l_return.
        CONTINUE.
      ENDIF.
    ENDIF.                                                  "HW 668316
*--> Dezimalstellen ermitteln
    PERFORM read_t006 USING ls_material_availability-unit CHANGING l_return.
    IF NOT l_return IS INITIAL.
      CLEAR return.
      return-type       = l_return-type.
      return-code       = l_return-code.
      return-message    = l_return-message.
      APPEND return.
      CLEAR l_return.
      CONTINUE.
    ENDIF.
*--> Prüfen ob Material an Prüfung teilnehmen soll
    PERFORM read_tmvf USING matvp-mtvfp.

*--> Prüfen, ob Sonderbestandskennzeichen gesetzt ist
    CASE ls_material_availability-stock_ind.
      WHEN 'E'.
*--> Kundeneinzelbestand
*--> Prüfen, ob Kundenauftrag / Position vorhanden sind
        IF NOT ls_material_availability-doc_number IS INITIAL AND
           NOT ls_material_availability-itm_number IS INITIAL.
          SELECT SINGLE * FROM vbap WHERE vbeln EQ ls_material_availability-doc_number
                                    AND posnr EQ ls_material_availability-itm_number.
          IF NOT sy-subrc IS INITIAL.
            MOVE: sy-subrc      TO message-subrc,
                  'CO'          TO message-msgid,
                  'E'           TO message-msgty,
                  '317'         TO message-msgno,
                  ls_material_availability-doc_number    TO message-msgv1,
                  ls_material_availability-itm_number    TO message-msgv2.
*--> FILL RETURN PARAMETER
            PERFORM fill_output_return
                       USING
                          message
                       CHANGING
                          return.
            APPEND return.
            CONTINUE.
          ENDIF.
        ELSE.
          MOVE: sy-subrc      TO message-subrc,
                'CO'          TO message-msgid,
                'E'           TO message-msgty,
                '317'         TO message-msgno.
*--> FILL RETURN PARAMETER
          PERFORM fill_output_return
                     USING
                        message
                     CHANGING
                        return.
          APPEND return.
          CONTINUE.
        ENDIF.
      WHEN 'Q'.
*--> Projektbestand
*--> Prüfen, ob PSP-Element vorhanden sind
        IF NOT ls_material_availability-wbs_elem IS INITIAL.
          CALL FUNCTION 'CJPN_EXTERN_TO_INTERN_CONV'
            EXPORTING
              ext_num   = ls_material_availability-wbs_elem
            IMPORTING
              int_num   = l_wbs_elem
            EXCEPTIONS
              not_found = 01.
          IF NOT sy-subrc IS INITIAL.
            MOVE: sy-subrc      TO message-subrc,
                  'CO'          TO message-msgid,
                  'E'           TO message-msgty,
                  '741'         TO message-msgno,
                  ls_material_availability-wbs_elem      TO message-msgv1.
*--> FILL RETURN PARAMETER
            PERFORM fill_output_return
                       USING
                          message
                       CHANGING
                          return.
            APPEND return.
            CONTINUE.
          ENDIF.
        ELSE.
          MOVE: sy-subrc      TO message-subrc,
                'CO'          TO message-msgid,
                'E'           TO message-msgty,
                '741'         TO message-msgno.
*--> FILL RETURN PARAMETER
          PERFORM fill_output_return
                     USING
                        message
                     CHANGING
                        return.
          APPEND return.
          CONTINUE.
        ENDIF.
      WHEN 'V' OR 'W'.
*--> Leihgut- oder Konsignationsbestand
*--> Prüfen, ob Kundennummer übergeben wird
        IF ls_material_availability-customer IS INITIAL.
          MOVE: sy-subrc  TO message-subrc,
                'CO'      TO message-msgid,
                'E'       TO message-msgty,
                '845'     TO message-msgno.
*--> FILL RETURN PARAMETER
          PERFORM fill_output_return
                     USING
                        message
                     CHANGING
                        return.
          APPEND return.
          CONTINUE.
        ENDIF.
    ENDCASE.

*--> Initialisieren
    CLEAR mdvps.
    REFRESH mdvps.
    CLEAR mdvex.
    REFRESH mdvex.
    REFRESH lt_wmdvsx.
*--> Übernahme Simulationstabelle in Abhängigkeit von der Eingabe
    LOOP AT wmdvsx WHERE yline = lv_tabix.
      APPEND wmdvsx TO lt_wmdvsx.
    ENDLOOP.
    PERFORM take_input TABLES lt_wmdvsx USING am61r-umren am61r-umrez
                                                       ls_material_availability-unit.
*--> take MDVPS to L_ATPCS
    LOOP AT mdvps.
      MOVE 'VC'        TO l_atpcs-delkz.
      MOVE matvp-matnr TO l_atpcs-matnr.
      MOVE ls_material_availability-plant       TO l_atpcs-werks.
      MOVE ls_material_availability-stge_loc    TO l_atpcs-lgort.
      MOVE ls_material_availability-batch       TO l_atpcs-charg.
      MOVE ls_material_availability-check_rule  TO l_atpcs-prreg.
      MOVE 'X'         TO l_atpcs-chkflg.
      MOVE 'X'         TO l_atpcs-resmd.
      MOVE mdvps-dat00 TO l_atpcs-bdter.
      MOVE mdvps-mng01 TO l_atpcs-bdmng.
      MOVE '1'    TO l_atpcs-idxatp.
      MOVE lv_tabix    TO l_atpcs-xline.
      MOVE l_trtyp     TO l_atpcs-trtyp.
      MOVE ls_material_availability-customer     TO l_atpcs-kunnr.
      MOVE ls_material_availability-doc_number   TO l_atpcs-kdauf.
      MOVE ls_material_availability-itm_number   TO l_atpcs-kdpos.
      MOVE ls_material_availability-doc_number   TO l_atpcs-delnr.
      MOVE ls_material_availability-itm_number   TO l_atpcs-delps.
      MOVE l_wbs_elem   TO l_atpcs-pspel.
      MOVE ls_material_availability-stock_ind    TO l_atpcs-sobkz.
* Pass Requirement segment to ATP
      IF cl_ops_switch_check=>sfsw_segmentation( ) EQ abap_on.
        MOVE ls_material_availability-sgt_rcat   TO l_atpcs-sgt_rcat.
        IF ls_material_availability-req_seg_long IS NOT INITIAL.
          MOVE ls_material_availability-req_seg_long   TO l_atpcs-sgt_rcat.
        ENDIF.
      ENDIF.

      APPEND l_atpcs.
    ENDLOOP.

*--> create field catalog
    MOVE ls_material_availability-doc_number TO l_atpfield-delnr.
    MOVE ls_material_availability-itm_number TO l_atpfield-delps.

    MOVE 'MATNR' TO l_atpfield-kfdna.
    MOVE lv_material_long TO l_atpfield-value.
    APPEND l_atpfield.
    MOVE 'WERKS' TO l_atpfield-kfdna.
    MOVE ls_material_availability-plant TO l_atpfield-value.
    APPEND l_atpfield.
    MOVE 'KUNNR' TO l_atpfield-kfdna.
    MOVE ls_material_availability-customer TO l_atpfield-value.
    APPEND l_atpfield.
    MOVE 'PRREG' TO l_atpfield-kfdna.
    MOVE ls_material_availability-check_rule TO l_atpfield-value.
    APPEND l_atpfield.

*--> fill ATPCA
    MOVE 'A' TO l_atpca-rdmod.

    IF ls_material_availability-read_atp_lock_x IS INITIAL.
      MOVE 'N' TO l_atpca-xenqmd.
    ELSE.
      IF ls_material_availability-read_atp_lock IS INITIAL.
        MOVE 'N' TO l_atpca-xenqmd.
      ELSE.
        MOVE 'R' TO l_atpca-xenqmd.
      ENDIF.
    ENDIF.

    cl_atp_db_controller=>get_instance( )->initialize_buffer( ). "2855044
    MOVE '6' TO l_atpca-anwdg.

    t_mara-bdcnt = lv_tabix.
    t_mara-matnr = lv_material_long.
    t_mara-meins = matvp-meins.
    t_mara-unit = ls_material_availability-unit.
    t_mara-umren = am61r-umren.
    t_mara-umrez = am61r-umrez.
    t_mara-dec_for_rounding = ls_material_availability-dec_for_rounding.
    t_mara-dec_for_rounding_x = ls_material_availability-dec_for_rounding_x.
    t_mara-andec = t006-andec.
    APPEND t_mara.

  ENDLOOP.
  SORT t_mara BY bdcnt.
*--> call atp server
  CALL FUNCTION 'AVAILABILITY_CHECK_CONTROLLER'
    TABLES
      p_atpcsx    = l_atpcs
      p_atpdsx    = l_atpdsx
      p_atpmatx   = l_atpmatx
      p_mdvex     = mdvex
      p_t441vx    = l_t441vx
      p_atpfieldx = l_atpfield
    CHANGING
      p_atpca     = l_atpca
      p_atpcc     = l_atpcc
    EXCEPTIONS
      error       = 1.

*--> SY-SUBRC retten
  subrc = sy-subrc.
*--> Ausgabetabelle initialisieren
  CLEAR wmdvex.
  REFRESH wmdvex.
*--> Fehler in Prüfung
  IF subrc NE 0.
    CALL FUNCTION 'MESSAGE_HANDLING'
      EXPORTING
        p_fcode   = 'GET'
      TABLES
        p_atpmsgx = p_atpmsgx.
    LOOP AT p_atpmsgx WHERE msgty EQ 'E'.
      EXIT.
    ENDLOOP.
    IF sy-subrc EQ 0.
      MOVE: subrc           TO message-subrc,
            p_atpmsgx-msgid TO message-msgid,
            p_atpmsgx-msgty TO message-msgty,
            p_atpmsgx-msgno TO message-msgno,
            p_atpmsgx-msgv1 TO message-msgv1,
            p_atpmsgx-msgv2 TO message-msgv2,
            p_atpmsgx-msgv3 TO message-msgv3,
            p_atpmsgx-msgv4 TO message-msgv4.
    ELSE.
      MOVE: subrc    TO message-subrc,
          sy-msgid TO message-msgid,
          sy-msgty TO message-msgty,
          sy-msgno TO message-msgno.
    ENDIF.
*--> Fill return parameter
    PERFORM fill_output_return
                USING
                   message
                CHANGING
                   return.
    APPEND return.
    EXIT.
  ENDIF.
*--> ATP-Mengen zum gleichen Termin kumulieren.
  PERFORM cumulate_mdvex.

*--> MDVEX uebernehmen und kum. ATP-Menge zum Bedarfstermin ermitteln
*--> eventuell Mengenumrechnung.
  PERFORM take_mdvex TABLES wmdvex.

ENDFUNCTION.


*&---------------------------------------------------------------------*
*& Form SFLE_REQ_SEG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM sfle_req_seg USING sgt_rcat TYPE sgt_rcat16
                        req_seg_long TYPE sgt_rcat40
                        cs_return TYPE bapireturn.
  DATA: lv_subrc TYPE sysubrc.
  CALL METHOD cl_sgt_chk_mapper=>convert_on_input
    EXPORTING
      iv_sgt_16              = sgt_rcat
      iv_sgt_40              = req_seg_long
    IMPORTING
      ev_sgt_40              = req_seg_long
    EXCEPTIONS
      excp_sgt_ne            = 1
      excp_sgt_invalid_input = 2
      OTHERS                 = 3.
  IF sy-subrc IS NOT INITIAL.
    lv_subrc = sy-subrc.
    cl_sgt_chk_mapper=>bapi_get_last_error( IMPORTING ev_return = cs_return ).
    sy-subrc = lv_subrc.
    RETURN.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  READ_T001
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM read_t001 USING werk CHANGING p_return LIKE bapireturn.
  IF werk EQ t001w-werks
  AND NOT werk IS INITIAL.
    EXIT.
  ENDIF.
  SELECT SINGLE * FROM  t001w
                  WHERE werks EQ werk.
*--> Fehler in Prüfung
  IF sy-subrc NE 0.
    MOVE: sy-subrc TO message-subrc,
          '61'     TO message-msgid,
          'W'      TO message-msgty,
          '272'    TO message-msgno,
          werk     TO message-msgv1.
*--> Fill return parameter
    PERFORM fill_output_return
                USING
                   message
                CHANGING
                   p_return.
  ENDIF.
ENDFORM.                               " READ_T001
*&---------------------------------------------------------------------*
*&      Form  TAKE_INPUT
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM take_input TABLES wmdvsx STRUCTURE bapiwmdvs USING umren umrez
                                                  input_unit.
  IF wmdvsx[] IS INITIAL.
    APPEND wmdvsx.
  ENDIF.
  LOOP AT wmdvsx.
*--> Eingabe voll spezifiziert.
    IF NOT wmdvsx-req_date IS INITIAL.
      IF wmdvsx-req_date LT sy-datlo.
        MOVE sy-datlo TO wmdvsx-req_date.
      ENDIF.
      IF NOT wmdvsx-req_qty IS INITIAL.
        MOVE wmdvsx-req_date TO mdvps-dat00.
        MOVE wmdvsx-req_qty TO mdvps-mng01.
*--> unit conversion if necessary
        IF matvp-meins NE input_unit.
          PERFORM convert_bedme_to_basme USING mdvps-mng01 umrez umren.
*        mdvps-mng01 = mdvps-mng01 * umrez / umren.
        ENDIF.
        APPEND mdvps.
      ELSE.
*--> Nur Material und Datum: Max Menge wird genommen
        MOVE wmdvsx-req_date TO mdvps-dat00.
        MOVE maxmng TO mdvps-mng01.
*--> unit conversion not necessary
        APPEND mdvps.
      ENDIF.
    ELSE.
*--> Nur Material und Menge: heute wird genommnen
      IF NOT wmdvsx-req_qty IS INITIAL.
        MOVE sy-datlo TO mdvps-dat00.
        MOVE wmdvsx-req_qty TO mdvps-mng01.
*--> unit conversion if necessary
        IF matvp-meins NE input_unit.
          PERFORM convert_bedme_to_basme USING mdvps-mng01 umrez umren.
*        mdvps-mng01 = mdvps-mng01 * umrez / umren.
        ENDIF.
        APPEND mdvps.
      ELSE.
*--> Nur Material: heute und Max.Menge
        MOVE sy-datlo TO mdvps-dat00.
        MOVE maxmng TO mdvps-mng01.
*--> unit conversion not necessary
        APPEND mdvps.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.                               " TAKE_INPUT
*&---------------------------------------------------------------------*
*&      Form  READ_MT61D
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM read_mt61d USING material plant CHANGING p_return LIKE bapireturn.
  CLEAR matvp.
  CLEAR mt61d.
*--> Materialstamm fuer Disposition lesen
  CLEAR mtcom.
  MOVE 'MT61D'  TO mtcom-kenng.
  MOVE sy-langu TO mtcom-spras.
  MOVE material TO mtcom-matnr.
  MOVE plant    TO mtcom-werks.
  CALL FUNCTION 'MATERIAL_LESEN'
    EXPORTING
      schluessel         = mtcom
    IMPORTING
      matdaten           = mt61d
      return             = mtcor
    TABLES
      seqmat01           = dummy
    EXCEPTIONS
      material_not_found = 04
      plant_not_found    = 08
      OTHERS             = 01.
*      exceptions
*       error_message = 1.

  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING mt61d TO matvp.
  ELSE.
    MOVE: sy-subrc TO message-subrc,
          sy-msgid TO message-msgid,
          'W'      TO message-msgty,
          sy-msgno TO message-msgno,
          sy-msgv1 TO message-msgv1,
          sy-msgv2 TO message-msgv2,
          sy-msgv3 TO message-msgv3,
          sy-msgv4 TO message-msgv4.
*--> FILL RETURN PARAMETER
    PERFORM fill_output_return
                USING
                   message
                CHANGING
                   p_return.
  ENDIF.
ENDFORM.                               " READ_MT61D
*&---------------------------------------------------------------------*
*&      Form  CUMULATE_MDVEX
*&---------------------------------------------------------------------*
*       Kumuliert ATP-Mengen mit gleichem Termin                       *
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM cumulate_mdvex.

  DATA: l_dat01 TYPE dat05,
        l_bdcnt TYPE numc5,
        l_mdve  TYPE mdve,
        l_index TYPE sytabix,
        l_lines TYPE sytabix.

  DESCRIBE TABLE mdvex LINES l_lines.

  WHILE l_index < l_lines.
    l_index = l_index + 1.
    READ TABLE mdvex INDEX l_index.
    IF  mdvex-bdcnt <> l_bdcnt.
      l_bdcnt = mdvex-bdcnt.
      l_dat01 = mdvex-dat01.
      CONTINUE.
    ENDIF.
    IF  mdvex-dat01 = l_dat01.
      DELETE mdvex INDEX l_index.
      l_index = l_index - 1.
      l_lines = l_lines - 1.
      READ TABLE mdvex INDEX l_index INTO l_mdve.
      PERFORM add_menge USING l_mdve-mng02 mdvex-mng02.
      MODIFY mdvex FROM l_mdve INDEX l_index.
      CONTINUE.
    ENDIF.
    l_dat01 = mdvex-dat01.
  ENDWHILE.

ENDFORM.                    " CUMULATE_MDVEX
*&---------------------------------------------------------------------*
*&      Form  READ_TMVF
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM read_tmvf USING mtvfp.
  SELECT SINGLE * FROM tmvf
         WHERE mtvfp EQ mtvfp.
ENDFORM.                    " READ_TMVF
*&---------------------------------------------------------------------*
*&      Form  UNIT_CONVERSION
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM unit_conversion CHANGING am61r STRUCTURE am61r
                              unit LIKE rm61r-meinh
                              batch LIKE bapicm61v-charg
                              p_return.

  DATA: flp01 TYPE p.                  "dummy parameter

*--> interne Darstellung der Mengeneinheit holen falls extern
  SELECT SINGLE * FROM t006a WHERE
                       spras EQ sy-langu AND
                       mseh3 EQ unit.
  IF sy-subrc EQ 0.
    MOVE t006a-msehi TO unit.
  ELSE.
*--> handelt es sich bereits um eine interne ME?
    SELECT SINGLE * FROM t006 WHERE msehi EQ unit.
*--> Maßeinheit nicht gepflegt.
    IF sy-subrc NE 0.
      MOVE: sy-subrc  TO message-subrc,
            'BM'      TO message-msgid,
            'W'       TO message-msgty,
            '305'     TO message-msgno,
            unit      TO message-msgv1,
            sy-langu  TO message-msgv2.
      .
*--> FILL RETURN PARAMETER
      PERFORM fill_output_return
                  USING
                     message
                  CHANGING
                     p_return.
      EXIT.
    ENDIF.
  ENDIF.

*--> conversion necessary
  IF matvp-meins NE unit.
    CALL FUNCTION 'MATERIAL_UNIT_CONVERSION'
      EXPORTING
        matnr                = matvp-matnr
        meinh                = unit
        meins                = matvp-meins
        charge               = batch                       "n_834400
      IMPORTING
        output               = flp01         "dummy parameter
        umren                = am61r-umren
        umrez                = am61r-umrez
      EXCEPTIONS
        conversion_not_found = 01
        input_invalid        = 02
        material_not_found   = 03
        meinh_not_found      = 04
        meins_missing        = 05
        no_meinh             = 06
        output_invalid       = 07
        overflow             = 08.

*--> conversion error
    IF sy-subrc NE 0.
      MOVE:  sy-subrc TO message-subrc,
             sy-msgid TO message-msgid,
             'W'      TO message-msgty,
             sy-msgno TO message-msgno,
             sy-msgv1 TO message-msgv1,
             sy-msgv2 TO message-msgv2,
             sy-msgv3 TO message-msgv3,
             sy-msgv4 TO message-msgv4.
*--> Fill return parameter
      PERFORM fill_output_return
                USING
                   message
                CHANGING
                   p_return.
    ENDIF.
  ENDIF.
ENDFORM.                    " UNIT_CONVERSION
*&---------------------------------------------------------------------*
*&      Form  TAKE_MDVEX
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM take_mdvex TABLES wmdvex STRUCTURE bapiwmdve.
  CLEAR cum_atp.
  LOOP AT mdvex.
    READ TABLE t_mara WITH KEY bdcnt = mdvex-bdcnt BINARY SEARCH.
    MOVE mdvex-bdcnt TO wmdvex-bdcnt.
    MOVE mdvex-dat00 TO wmdvex-req_date.
    MOVE mdvex-mng01 TO wmdvex-req_qty.
    MOVE mdvex-dat01 TO wmdvex-com_date.
    MOVE mdvex-mng02 TO wmdvex-com_qty.
*--> unit conversion if necessary
    IF t_mara-meins NE t_mara-unit.
      PERFORM convert_basme_to_bedme USING wmdvex-req_qty
                                           t_mara-umren
                                           t_mara-umrez.
      PERFORM convert_basme_to_bedme USING wmdvex-com_qty
                                           t_mara-umren
                                           t_mara-umrez.
      IF wmdvex-com_qty GT 0 AND wmdvex-com_qty LT maxmng.
        IF t_mara-dec_for_rounding_x IS INITIAL.
          PERFORM menge_abrunden USING t_mara-andec wmdvex-com_qty.
        ELSE.
          PERFORM menge_abrunden USING t_mara-dec_for_rounding wmdvex-com_qty.
        ENDIF.
      ENDIF.
    ENDIF.
    PERFORM add_menge USING cum_atp wmdvex-com_qty.
    APPEND wmdvex.
  ENDLOOP.
ENDFORM.                    " TAKE_MDVEX
*&---------------------------------------------------------------------*
*&      Form  MENGE_ABRUNDEN
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM menge_abrunden USING andec mngxx.
*--> Anzahl Dezimalstellen pruefen und entsprechend runden
  CASE andec.
    WHEN 3.
      EXIT.
    WHEN 2.
      mngxx = mngxx / 10.
      mngxx = mngxx * 10.
    WHEN 1.
      mngxx = mngxx / 100.
      mngxx = mngxx * 100.
    WHEN 0.
      mngxx = mngxx / 1000.
      mngxx = mngxx * 1000.
  ENDCASE.
ENDFORM.                    " MENGE_ABRUNDEN
*&---------------------------------------------------------------------*
*&      Form  READ_T006
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM read_t006 USING unit CHANGING p_return.
  IF unit EQ t006-msehi AND NOT unit IS INITIAL.
    EXIT.
  ENDIF.
  SELECT SINGLE * FROM  t006
                  WHERE msehi EQ unit.
  IF sy-subrc NE 0.
    MOVE: sy-subrc  TO message-subrc,
          'BM'      TO message-msgid,
          'W'       TO message-msgty,
          '305'     TO message-msgno.
*--> FILL RETURN PARAMETER
    PERFORM fill_output_return
                USING
                   message
                CHANGING
                   p_return.
  ENDIF.
ENDFORM.                    " READ_T006
*&---------------------------------------------------------------------*
*&      Form  CONVERT_QTY_TO_BME
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM convert_bedme_to_basme USING mng01 umrez umren.
  DATA: mng01_f TYPE f,
        umren_f TYPE f,
        umrez_f TYPE f.

  mng01_f = mng01.
  umren_f = umren.
  umrez_f = umrez.

  mng01_f = mng01_f * umrez_f / umren_f.
  IF mng01_f LE maxmng.
    mng01 = mng01 * umrez / umren.
  ELSEIF mng01_f GE 0.
    MOVE maxmng TO mng01.
  ENDIF.
ENDFORM.                    " CONVERT_QTY_TO_BME
*&---------------------------------------------------------------------*
*&      Form  CONVERT_BASME_TO_BEDME
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM convert_basme_to_bedme USING mng01 umren umrez.
  DATA: mng01_f TYPE f,
        umren_f TYPE f,
        umrez_f TYPE f.

  mng01_f = mng01.
  umren_f = umren.
  umrez_f = umrez.

  mng01_f = mng01_f * umren_f / umrez_f.
  IF mng01_f LE maxmng.
    mng01 = mng01 * umren / umrez.
  ELSEIF mng01_f GE 0.
    MOVE maxmng TO mng01.
  ENDIF.

ENDFORM.                    " CONVERT_BASME_TO_BEDME
*&---------------------------------------------------------------------*
*&      Form  FILL_OUTPUT_RETURN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_MESSAGE  text                                              *
*      <--P_P_RETURN  text                                             *
*----------------------------------------------------------------------*
FORM fill_output_return USING    p_message LIKE message
                        CHANGING p_return  LIKE bapireturn.

  CLEAR p_return.

  CALL FUNCTION 'BALW_BAPIRETURN_GET'
    EXPORTING
      type       = p_message-msgty
      cl         = p_message-msgid
      number     = p_message-msgno
      par1       = p_message-msgv1
      par2       = p_message-msgv2
      par3       = p_message-msgv3
      par4       = p_message-msgv4
    IMPORTING
      bapireturn = p_return
    EXCEPTIONS
      OTHERS     = 1.





ENDFORM.                    " FILL_OUTPUT_RETURN
*&---------------------------------------------------------------------*
*&      Form  ADD_MENGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_CUM_ATP  text
*      -->P_WMDVEX_COM_QTY  text
*----------------------------------------------------------------------*
FORM add_menge USING mng01 mng02.

  DATA: flp01 TYPE f,
        flp02 TYPE f.
  flp01 = mng01.
  flp02 = mng02.
  flp01 = flp01 + flp02.
  IF  flp01 LE maxmng.
    mng01 = mng01 + mng02.
  ELSE.
    MOVE maxmng TO mng01.
  ENDIF.
ENDFORM.                    " ADD_MENGE
