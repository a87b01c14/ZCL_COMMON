FUNCTION zbapi_m_reval_createpricechang.
*"----------------------------------------------------------------------
*"*"本地接口：
*"  IMPORTING
*"     REFERENCE(COMP_CODE) LIKE  BAPI2027_PC_HD-COMP_CODE
*"     REFERENCE(PSTNG_DATE) LIKE  BAPI2027_PC_HD-PSTNG_DATE
*"  EXPORTING
*"     REFERENCE(ML_DOC_YEAR) LIKE  BAPI2027_PC_EX-ML_DOC_YEAR
*"     REFERENCE(ML_DOC_NUM) LIKE  BAPI2027_PC_EX-ML_DOC_NUM
*"  TABLES
*"      MATERIAL_PRICE_LIST STRUCTURE  BAPI2027_PC_LIST
*"      RETURN STRUCTURE  BAPIRETURN1
*"----------------------------------------------------------------------

  DATA:
*       Zeile der externen Fehlertabelle
    return_line    LIKE LINE OF return,
*       Periode, Geschäftsjahr
    poper          TYPE poper,
    monat          TYPE frper,
    fisc_year      TYPE bkpf-gjahr,
*       Interface zu PRICES_CHANGE
    mat_price      TYPE ckmpr_mat_price,
*       Intern verwendeter Returnparameter
    i_error        TYPE c,
*       Flag: Bewertungskreis auf Buchungskreisebene (= 'X')
    bwkey_is_bukrs TYPE c,
*       Fehler aufgetreten -> Bearbeitung beenden
    error_flag     TYPE c.

* Initialisiere Fehlertabelle
  REFRESH return.
  CLEAR return.
  CLEAR return_line.

  CLEAR error_flag.

* Geschäftsjahr und Periode aus Buchungskreis, Buchungsdatum ermitteln
  CALL FUNCTION 'FI_PERIOD_DETERMINE'
    EXPORTING
      i_budat        = pstng_date
      i_bukrs        = comp_code
    IMPORTING
      e_gjahr        = fisc_year
      e_poper        = poper
    EXCEPTIONS
      fiscal_year    = 1
      period         = 2
      period_version = 3
      posting_period = 4
      special_period = 5
      version        = 6
      posting_date   = 7
      error_message  = 8         "Alle Fehler abfangen
      OTHERS         = 9.
  IF ( sy-subrc <> 0 ).
*   Ungültige Daten -> RETURN-Parameter füllen
    CALL FUNCTION 'BALW_BAPIRETURN_GET1'
      EXPORTING
        type       = sy-msgty
        cl         = sy-msgid
        number     = sy-msgno
        par1       = sy-msgv1
        par2       = sy-msgv2
        par3       = sy-msgv3
        par4       = sy-msgv4
      IMPORTING
        bapireturn = return_line.
    APPEND return_line TO return.
    error_flag = 'X'.
  ENDIF.

* Bebuchbarkeit der Periode prüfen
  IF ( error_flag IS INITIAL ).
    monat = poper.
    CALL FUNCTION 'FI_PERIOD_CHECK'
      EXPORTING
        i_bukrs          = comp_code
        i_gjahr          = fisc_year
        i_koart          = '+'
        i_konto          = '+'
        i_monat          = monat
      EXCEPTIONS
        error_period     = 1
        error_period_acc = 2
        error_message    = 3     "Alle Fehler abfangen
        OTHERS           = 4.
    IF ( sy-subrc <> 0 ).
*     Periode ist nicht bebuchbar -> RETURN-Parameter füllen
      CALL FUNCTION 'BALW_BAPIRETURN_GET1'
        EXPORTING
          type       = sy-msgty
          cl         = sy-msgid
          number     = sy-msgno
          par1       = sy-msgv1
          par2       = sy-msgv2
          par3       = sy-msgv3
          par4       = sy-msgv4
        IMPORTING
          bapireturn = return_line.
      APPEND return_line TO return.
      error_flag = 'X'.
    ENDIF.
  ENDIF.                               "ERROR_FLAG

* Bewertungskreis = Buchungskreis oder Werk ?
  IF ( error_flag IS INITIAL ).
    CLEAR tcurm.
    SELECT SINGLE * FROM tcurm.
    IF ( tcurm-bwkrs_cus = '3' ).
      bwkey_is_bukrs = 'X'.            "Buchungskreis
    ELSE.
      CLEAR bwkey_is_bukrs.            "Werk
    ENDIF.
  ENDIF.                               "ERROR_FLAG

* Konvertierung der externen Tabelle MATERIAL_PRICE_LIST in die
* interne geschachtelte Tabelle MAT_PRICE.
  IF ( error_flag IS INITIAL ).
    PERFORM convert_etab_2_itab USING    comp_code
                                         bwkey_is_bukrs
                                         poper
                                         fisc_year
                                CHANGING material_price_list[]
                                         mat_price[]
                                         return[]
                                         i_error.
    IF ( NOT i_error IS INITIAL ).
*     Exceptions abfangen -> ext. RETURN-Parameter wurde im FORM gefüllt
      error_flag = 'X'.
    ENDIF.
  ENDIF.                               "ERROR_FLAG

* PRICES_CHANGE und PRICES_POST rufen (mit Fehlerprotokoll)
  IF ( error_flag IS INITIAL ).
    PERFORM prices_change_and_post USING comp_code
                                         fisc_year
                                         poper
                                         pstng_date
                                CHANGING mat_price[]
                                         ml_doc_year
                                         ml_doc_num
                                         return[]
                                         i_error.
    IF ( NOT i_error IS INITIAL ).
*     Exceptions abfangen -> ext. RETURN-Parameter wurde im FORM gefüllt
      error_flag = 'X'.
    ENDIF.
  ENDIF.                               "ERROR_FLAG



  IF ( NOT error_flag IS INITIAL ).
*   "Es wurden Fehler festgestellt, und daher keine Preise verbucht.
*    Bitte beachten Sie das Fehlerprotokoll in RETURN und rufen Sie
*    das BAPI mit allen Materialien neu auf."
    CALL FUNCTION 'BALW_BAPIRETURN_GET1'
      EXPORTING
        type       = 'E'
        cl         = 'CKPRCH'
        number     = 044
      IMPORTING
        bapireturn = return_line.
    APPEND return_line TO return.
  ENDIF.

ENDFUNCTION.
