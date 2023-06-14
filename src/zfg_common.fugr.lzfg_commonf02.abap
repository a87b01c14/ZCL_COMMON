*----------------------------------------------------------------------*
***INCLUDE LZFG_COMMONF02.
*----------------------------------------------------------------------*
***INCLUDE L2027F01 .
*----------------------------------------------------------------------*
* 13.04.2006 RHU ML buffer refresh                           Note 934326
*&---------------------------------------------------------------------*
*&      Form  CONVERT_ETAB_2_ITAB
*&---------------------------------------------------------------------*
* Konvertierung der externen Tabelle MATERIAL_PRICE_LIST in die
* interne geschachtelte Tabelle MAT_PRICE.
* (Die interne Darstellung für den Aufruf von PRICES_CHANGE enthält
*  eine geschachtelte Tabelle, diese faßt alle CURTP-Zeilen zu EINEM
*  Bewertungssegment zusammen.)
*----------------------------------------------------------------------*
*      -->P_BUKRS           Buchungkreis
*      -->P_BWKEY_IS_BUKRS  Bewertungskreis = Buchungkreis ?
*      -->P_POPER           Periode
*      -->P_BDATJ           Geschäftsjahr
*      <->P_ETAB            Externe Tabelle des BAPIs
*      <--P_ITAB            Interne Tabelle für Aufruf "PRICES_CHANGE"
*      <->P_RETURN_TAB      Externe Fehlertabelle des BAPIs
*      <--p_error         Erfolgsmeldung
*                            initial = Erfolg
*                            'X'     = Fehler
* OBSOLET :
*         1 = Fehlerhaftes Sonderbestandskennzeichen
*         2 = Fehlerhafte externe PSP-Elementenummer
*         3 = Ungültiger ISO-Währungscode
*         4 = Ungültiger ISO-Mengeneinheitencode
*         5 = Konvertierung des Währungsbetrages nicht ausführbar
*         6 = Externer Währungsbetrag zu groß, daher keine Konvertierung
*         7 = Anzahl der Dezimalstellen übersteigt maximale Anzahl
*         8 = Keine Berechtigung zur Preisänderung im Bewertungskreis
*         9 = Keine Berechtigung für einen W&B-Typ
*         A = Währung ist nicht die für diesen CURTP erwartete
*----------------------------------------------------------------------*
FORM convert_etab_2_itab USING  p_bukrs  LIKE bapi2027_pc_hd-comp_code
                                p_bwkey_is_bukrs TYPE c
                                p_poper  TYPE poper
                                p_bdatj  TYPE bkpf-gjahr
                       CHANGING p_etab   TYPE ckmpr_bapi2027_pc_list
                                p_itab   TYPE ckmpr_mat_price
                                p_return_tab TYPE ckmpr_bapireturn1_tab
                                p_error  TYPE c.

  DATA:
*       Zeile der externen Tabelle
    eline         LIKE LINE OF p_etab,
*       Zeile der internen Tabelle
    iline         LIKE LINE OF p_itab,
*       Zeile der Fehlertabelle
    p_return_line LIKE LINE OF p_return_tab,
*       Material-Bewertungs-Segment (externe Darstellung)
    eseg          TYPE ckmpr_f_bapi2027_pc_bewseg,
    eseg_old      LIKE eseg,
*       Domänenkonvertierung
    bwkey         LIKE mbew-bwkey,
    cvtyp         LIKE tcval-cvtyp,
*       Hilfstabelle zur Umschlüsselung PSP-Element (extern / intern)
    psp_ext_int   TYPE psp_ext_int,
    psp           LIKE LINE OF psp_ext_int,
*       Interner Returnparameter
    i_error       TYPE c,
*       Mengeneinheit, Währung, S-Preis, V-Preis pro Zeile
    waers         TYPE  waers,
    ext_meinh     TYPE  meinh,
    s_price       TYPE  stprs,
    v_price       TYPE  ck_pvprs_1,
*       Interne Preise (bezogen auf Basismengeneinheit und Preiseinheit)
    int_s_price   TYPE  stprs,
    int_v_price   TYPE  ck_pvprs_1,
*       Struktur T001K
    f_t001k       LIKE  t001k,
*       Interner BAPIRETURN zum Abfangen von Exceptions
    i_bapireturn  TYPE bapireturn,
*       Flag für Berechtigung
    authority     TYPE c,
*       Message-Parameter
    cl            LIKE  sy-msgid,
    number        LIKE  sy-msgno,
    par1          LIKE  sy-msgv1,
    par2          LIKE  sy-msgv2,
    par3          LIKE  sy-msgv3.

  FIELD-SYMBOLS:
*       Feldsymbol für die interne Tabelle
    <iline>    LIKE LINE OF p_itab,
    <iline_cr> LIKE cki_pae_cr.

  CLEAR p_error.

*-----------------------------------------------------------------------
* Loop über die externe Tabelle, um alle betroffenen Bewertungssegmente
* in der internen Tabelle zu sammeln
  REFRESH: p_itab,
           psp_ext_int.
  CLEAR: eseg,
         eseg_old.
  LOOP AT p_etab INTO eline.

*   Zugehörigkeit Bewertungskreis zu Buchungskreis prüfen, falls
*   Bewertungskreis = Werk
    IF ( p_bwkey_is_bukrs IS INITIAL ).
      CLEAR f_t001k.
      bwkey = eline-plant.
      CALL FUNCTION 'T001K_SINGLE_READ'
        EXPORTING
*         KZRFB         = ' '
*         MAXTZ         = 0
          bwkey         = bwkey
        IMPORTING
          wt001k        = f_t001k
        EXCEPTIONS
          not_found     = 1
          wrong_call    = 2
          error_message = 3      "Alle Fehler abfangen
          OTHERS        = 4.
      IF sy-subrc <> 0.
*       Fehlermeldung aus T001k_SINGLE_READ an BAPI durchreichen
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
            bapireturn = p_return_line.
        APPEND p_return_line TO p_return_tab.
        p_error = 'X'.
      ELSE.
        IF ( p_bukrs <> f_t001k-bukrs ).
*         Fehler: Werk existiert nicht im Buchungskreis
          par1 = eline-plant.
          par2 = p_bukrs.
          CALL FUNCTION 'BALW_BAPIRETURN_GET1'
            EXPORTING
              type       = 'E'
              cl         = 'CKPRCH'
              number     = 013
              par1       = par1
              par2       = par2
            IMPORTING
              bapireturn = p_return_line.
          APPEND p_return_line TO p_return_tab.
          p_error = 'X'.
          CONTINUE.                    "LOOP AT p_etab
        ENDIF.
      ENDIF.
    ENDIF.

    MOVE-CORRESPONDING eline TO eseg.
*   Jedes NEUE Bewertungssegment in der internen Tabelle sammeln
    IF ( eseg <> eseg_old ).
      eseg_old = eseg.
*     Externe Darstellung des Segmentes in die interne konvertieren
      PERFORM convert_eseg_2_iseg USING eseg
                                        p_bukrs
                                        p_bwkey_is_bukrs
                               CHANGING iline
                                        psp_ext_int
                                        p_return_tab[]
                                        i_error.
      IF ( NOT i_error IS INITIAL ).
*       Exceptions abfangen -> p_error setzen
*       (P_RETURN_TAB wird in der FORM gefüllt)
        p_error = 'X'.
      ELSE.
*       Die interne Struktur enthält Periode/Geschäftsjahr pro Zeile
        iline-pp-poper = p_poper.
        iline-pp-bdatj = p_bdatj.
*       Geschachtelte CURTP-Tabelle löschen
        REFRESH iline-cr.
*       Interne Tabelle um die aktuelle Zeile ergänzen
        APPEND iline TO p_itab.

      ENDIF.                           "i_error IS INITIAL
    ENDIF.                             "eseg <> eseg_old

  ENDLOOP.                             "p_etab

* Bei Fehler: FORM verlassen
  CHECK ( p_error IS INITIAL ).

*-----------------------------------------------------------------------
* Die interne Tabelle enthält nun je betroffenem Bewertungssegment eine
* Zeile. Nun wird PRICES_PROPOSE gerufen, um die geschachtelten
* CR-Zeilen zu ergänzen (CURTP und WAERS), die jeweilige Preiseinheit
* aus dem Materialstamm zu lesen und die Einzelbestände auf un-/bewertet
* zu überprüfen
  CALL FUNCTION 'PRICES_PROPOSE'
    EXPORTING
      actual_bdatj  = p_bdatj
      actual_poper  = p_poper
      bukrs         = p_bukrs
*     SUBS_DBT      =
*    IMPORTING
*     PRICES_PROPOSED =
    TABLES
      t_matpr       = p_itab
    EXCEPTIONS
      data_error    = 1
      error_message = 2        "Alle Fehler abfangen
      OTHERS        = 3.
  IF ( NOT sy-subrc IS INITIAL ).
*   Fehlermeldung aus PRICES_PROPOSE an BAPI durchreichen
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
        bapireturn = p_return_line.
    APPEND p_return_line TO p_return_tab.
    p_error = 'X'.
  ENDIF.

* Bei Fehler: FORM verlassen
  CHECK ( p_error IS INITIAL ).

*-----------------------------------------------------------------------
* Loop über die interne Tabelle, um die geschachtelte Tabelle der
* verschiedenen W&B-Typen aus der externen Tabelle zu füllen
  LOOP AT p_itab ASSIGNING <iline>.

*   Initialisieren der geschachtelten CURTP-Tabelle
    LOOP        AT <iline>-cr
         ASSIGNING <iline_cr>.
*     Sicherstellen, daß keine Preise aus PRICES_PROPOSE
*     freigegeben werden:
      CLEAR <iline_cr>-newpeinh.
      CLEAR <iline_cr>-newsalkv.
      CLEAR <iline_cr>-salkv.
      CLEAR <iline_cr>-zuumb.
      CLEAR <iline_cr>-zuabw.
      CLEAR <iline_cr>-erzkalk.
      CLEAR <iline_cr>-zukbew.
      CLEAR <iline_cr>-lfdkalk.
*     Default: es wird kein Preis geändert, der nicht in der externen
*     Tabelle explizit gesetzt wird:
      CLEAR <iline_cr>-newstprs.
      CLEAR <iline_cr>-stprs.
      CLEAR <iline_cr>-newpvprs.
      CLEAR <iline_cr>-pvprs.
      CLEAR <iline_cr>-newsalk3.
      CLEAR <iline_cr>-salk3.
      CLEAR <iline_cr>-manpae_s.
      CLEAR <iline_cr>-manpae_v.
    ENDLOOP.

*   Berechtigung zur Preisänderung in diesem Bewertungskreis prüfen
    IF ( NOT <iline>-pp-bwkey IS INITIAL ).
      AUTHORITY-CHECK OBJECT 'K_MLPR_VA'
               ID 'BWKEY' FIELD <iline>-pp-bwkey
               ID 'ACTVT' FIELD '16'.
      IF ( sy-subrc <> 0 ).
        par1 = <iline>-pp-bwkey.
        IF 1 = 0.                                           "note788185
          MESSAGE e039(ckprch) WITH par1.                   "note788185
* Keine Berechtigung, in Bewertungskreis & Preise zu ändern "note788185
        ENDIF.                                              "note788185
        CALL FUNCTION 'BALW_BAPIRETURN_GET1'
          EXPORTING
            type       = 'E'
            cl         = 'CKPRCH'
            number     = 039
            par1       = par1
          IMPORTING
            bapireturn = p_return_line.
        APPEND p_return_line TO p_return_tab.
        p_error = 'X'.
*       => Nächstes Bewertungssegment
        CONTINUE.                      "ENDLOOP P_ITAB
      ENDIF.
    ENDIF.

*   Zurückkonvertieren PSP-Element (intern -> extern) mittels der
*   zuvor aufgebauten Hilfstabelle (=> steht dann in PSP-EXT)
    READ TABLE     psp_ext_int
          INTO     psp
          WITH KEY int = <iline>-pp-pspnr.

*   Loop über alle W&B-Typen (CURTPs) - - - - - - - - - - - - - - - - -
    LOOP AT <iline>-cr
         ASSIGNING <iline_cr>.

*     Externe BAPI-Tabelle lesen (je CURTP)
      CLEAR eline.
      IF ( NOT p_bwkey_is_bukrs IS INITIAL ).
*       Falls der Bewertungskreis auf Buchungskreisebene eingestellt
*       ist, und die externe Tabelle Bewertungssegmente enthält, die
*       sich nur im Werk unterscheiden, wird der ERSTE dieser Einträge
*       gelesen, da sich hier mehrere Zeilen auf ein Segment beziehen.
*       (! In der Doku entsprechend beschreiben !)
        READ TABLE     p_etab
              INTO     eline
              WITH KEY material    = <iline>-pp-matnr
                       val_type    = <iline>-pp-bwtar
                       sales_ord   = <iline>-pp-vbeln
                       s_ord_item  = <iline>-pp-posnr
                       wbs_element = psp-ext
                       curr_type   = <iline_cr>-curtp.
      ELSE.
*       Ansonsten wird die Zeile mit spezifiziertem Werk gesucht
        READ TABLE     p_etab
              INTO     eline
              WITH KEY plant       = <iline>-pp-bwkey
                       material    = <iline>-pp-matnr
                       val_type    = <iline>-pp-bwtar
                       sales_ord   = <iline>-pp-vbeln
                       s_ord_item  = <iline>-pp-posnr
                       wbs_element = psp-ext
                       curr_type   = <iline_cr>-curtp.
      ENDIF.

*     Falls kein Eintrag gefunden wird, kann dies nur daran liegen,
*     daß zum erwarteten CURTP keine Zeile vorhanden ist.
*     Die implementierte Logik ist, dann den Preis in dieser CURTP
*     nicht zu ändern.
*     (! In der Doku entsprechend beschreiben !)
*     Es wurde aber oben bereits in der entsprechenden Zeile in der
*     internen Tabelle vermerkt, daß hier keine Preisänderung ge-
*     wünscht ist. => Do nothing & nächste CURTP-Zeile
      IF ( sy-subrc <> 0 ).
        CONTINUE.                      "LOOP AT <iline>-cr
*     Falls ein Eintrag in der externen Tabelle gefunden wurde, wird
*     die entsprechende Zeile in die interne Darstellung konvertiert.
      ELSE.
*       Falls eine S- oder V-Preisänderung für diesen CURTP gewünscht
        IF (    ( NOT eline-change_std_price IS INITIAL )
             OR ( NOT eline-change_mov_price IS INITIAL ) ).
*         Berechtigung prüfen für diesen Bewertungstyp
*         (Schlüssel: KOKRS,VALUTYP,ACTVT - geht aber auch mit BWKEY und
*          CURTP => wird im FuBau umgewandelt)
          CLEAR authority.
          cvtyp = <iline_cr>-curtp.
          CALL FUNCTION 'TP_VALUATION_AUTHORITY'
            EXPORTING
              i_bwkey                        = <iline>-pp-bwkey
              i_cvtyp                        = cvtyp
              i_actvt                        = '02'
            IMPORTING
              e_xauth                        = authority
            EXCEPTIONS
              kokrs_finding_error            = 1
              valutyp_finding_error          = 2
              insufficient_input_for_kokrs   = 3
              insufficient_input_for_valutyp = 4
              activity_not_allowed           = 5
              error_message                  = 6               "Alle F. abfangen
              OTHERS                         = 7.
          IF sy-subrc <> 0.
*           Fehlermeldung aus TP_VALUATION_AUTH... an BAPI durchreichen
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
                bapireturn = p_return_line.
            APPEND p_return_line TO p_return_tab.
            p_error = 'X'.
          ELSE.
            IF ( authority IS INITIAL ). "= NOT ALLOWED
*           Falls Berechtigung für diesen CURTP fehlt, so wird wieder
*           keine Preisänderung erzeugt und eine entsprechende Fehler-
*           meldung ausgegeben.
              par1 = <iline_cr>-curtp.
              CALL FUNCTION 'BALW_BAPIRETURN_GET1'
                EXPORTING
                  type       = 'E'
                  cl         = 'CKPRCH'
                  number     = 043
                  par1       = par1
                IMPORTING
                  bapireturn = p_return_line.
              APPEND p_return_line TO p_return_tab.
              p_error = 'X'.
              CONTINUE.                "ENDLOOP AT <iline>-cr
            ENDIF.                     "NOT ALLOWED
          ENDIF.                       "SY-SUBRC <> 0
        ENDIF.                         "Preisänderung gewünscht


*   Beginn der Konvertierung der CURTP-Zeile in die interne Darstellung

        IF ( NOT eline-currency IS INITIAL ).
*         SAP-Währungscode von extern übernehmen
          waers = eline-currency.
        ELSE.
*         Falls nicht mitgegeben, aus dem ISO-Code ermitteln
          CALL FUNCTION 'CURRENCY_CODE_ISO_TO_SAP'
            EXPORTING
              iso_code      = eline-iso_code
            IMPORTING
              sap_code      = waers
*             UNIQUE        =
            EXCEPTIONS
              not_found     = 1
              error_message = 2  "Alle Fehler abfangen
              OTHERS        = 3.
          IF sy-subrc <> 0.
*           Fehlermeldung aus CURRENCY_CODE_ISO_... an BAPI durchreichen
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
                bapireturn = p_return_line.
            APPEND p_return_line TO p_return_tab.
            p_error = 'X'.
          ENDIF.
        ENDIF.

*       Externe Währung mit der für diesen CURTP erwarteten vergleichen
        IF ( waers <> <iline_cr>-waers ).
*         Fehler: Externe Währung &1 entspricht nicht der für den
*                 Währungs-/Bewertungstyp &2 erwartet Währung &3,
          par1 = waers.
          par2 = <iline_cr>-curtp.
          par3 = <iline_cr>-waers.
          CALL FUNCTION 'BALW_BAPIRETURN_GET1'
            EXPORTING
              type       = 'E'
              cl         = 'CKPRCH'
              number     = 042
              par1       = par1
              par2       = par2
              par3       = par3
            IMPORTING
              bapireturn = p_return_line.
          APPEND p_return_line TO p_return_tab.
          p_error = 'X'.
          CONTINUE.                    "LOOP AT <iline>-cr
        ENDIF.

*       Standardpreis aus externer Darstellung in interne konvertieren
        CLEAR i_bapireturn.
        CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_INTERNAL'
          EXPORTING
            currency             = waers
            amount_external      = eline-std_price
            max_number_of_digits = 11
          IMPORTING
            amount_internal      = s_price
            return               = i_bapireturn
          EXCEPTIONS
            error_message        = 1  "Alle Fehler abfangen
            OTHERS               = 2.
*       Fehlermeldung aus BAPI_CURRENCY_... an BAPI durchreichen
*       (implizit: über EXCEPTION ERROR_MESSAGE)
        IF ( NOT sy-subrc IS INITIAL ).
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
              bapireturn = p_return_line.
          APPEND p_return_line TO p_return_tab.
          p_error = 'X'.
        ELSE.
*         (explizit: über RETURN-Parameter)
          IF ( NOT i_bapireturn-code IS INITIAL ).
*           Konvertierung BAPIRETURN-CODE -> SY-MSGID, SY-MSGNO
*           [Klappt nur bei 2-stelliger Message-ID]
            cl     = i_bapireturn-code.
            number = i_bapireturn-code+2(3).
            CALL FUNCTION 'BALW_BAPIRETURN_GET1'
              EXPORTING
                type       = i_bapireturn-type
                cl         = cl
                number     = number
                par1       = i_bapireturn-message_v1
                par2       = i_bapireturn-message_v2
                par3       = i_bapireturn-message_v3
                par4       = i_bapireturn-message_v4
              IMPORTING
                bapireturn = p_return_line.
            APPEND p_return_line TO p_return_tab.
            p_error = 'X'.
          ENDIF.
        ENDIF.

*       Verrechnungspreis aus externer Darstellung in interne konvert.
        CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_INTERNAL'
          EXPORTING
            currency             = waers
            amount_external      = eline-moving_pr
            max_number_of_digits = 11
          IMPORTING
            amount_internal      = v_price
            return               = i_bapireturn
          EXCEPTIONS
            error_message        = 1  "Alle Fehler abfangen
            OTHERS               = 2.
*       Fehlermeldung aus BAPI_CURRENCY_... an BAPI durchreichen
*       (implizit: über EXCEPTION ERROR_MESSAGE)
        IF ( NOT sy-subrc IS INITIAL ).
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
              bapireturn = p_return_line.
          APPEND p_return_line TO p_return_tab.
          p_error = 'X'.
        ELSE.
*         (explizit: über RETURN-Parameter)
          IF ( NOT i_bapireturn-code IS INITIAL ).
*           Konvertierung BAPIRETURN-CODE -> SY-MSGID, SY-MSGNO
*           [ Klappt nur bei 2-stelliger Message-ID,
*             ist hier aber ok, da immer MSGID = 'S&' ]
            cl     = i_bapireturn-code.
            number = i_bapireturn-code+2(3).
            CALL FUNCTION 'BALW_BAPIRETURN_GET1'
              EXPORTING
                type       = i_bapireturn-type
                cl         = cl
                number     = number
                par1       = i_bapireturn-message_v1
                par2       = i_bapireturn-message_v2
                par3       = i_bapireturn-message_v3
                par4       = i_bapireturn-message_v4
              IMPORTING
                bapireturn = p_return_line.
            APPEND p_return_line TO p_return_tab.
            p_error = 'X'.
          ENDIF.
        ENDIF.

*       SAP-Mengeneinheit von extern übernehmen
        IF ( NOT eline-quantity_unit IS INITIAL ).
          ext_meinh = eline-quantity_unit.
*       Falls nicht mitgegeben, aus der ISO-Mengeneinheit ermitteln.
        ELSE.
          CALL FUNCTION 'UNIT_OF_MEASURE_ISO_TO_SAP'
            EXPORTING
              iso_code      = eline-isocode_unit
            IMPORTING
              sap_code      = ext_meinh
*             UNIQUE        =
            EXCEPTIONS
              not_found     = 1
              error_message = 2  "Alle Fehler abfangen
              OTHERS        = 3.
          IF sy-subrc <> 0.
*           Fehlermeldung aus UNIT_OF_MEASURE_... an BAPI durchreichen
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
                bapireturn = p_return_line.
            APPEND p_return_line TO p_return_tab.
            p_error = 'X'.
          ENDIF.
        ENDIF.

*       Preise bezogen auf die Materialstamm-Preiseinheit und die
*       Materialstamm-Basismengeneinheit aus externem Preis, externer
*       Preiseinheit und externer Preismengeneinheit berechnen.
        PERFORM convert_price USING <iline>-pp-matnr
                                    s_price
                                    v_price
                                    eline-price_unit
                                    ext_meinh
                                    <iline_cr>-peinh
                           CHANGING int_s_price
                                    int_v_price
                                    p_return_tab[]
                                    i_error.
        IF ( NOT i_error IS INITIAL ).
*         Fehler: Preisumrechnung (extern -> intern) nicht möglich
          CALL FUNCTION 'BALW_BAPIRETURN_GET1'
            EXPORTING
              type       = 'E'
              cl         = 'CKPRCH'
              number     = 041
            IMPORTING
              bapireturn = p_return_line.
          APPEND p_return_line TO p_return_tab.
          p_error = 'X'.
        ELSE.
*         Preis-Felder in der CURTP-Zeile füllen
          <iline_cr>-newstprs = int_s_price.
          <iline_cr>-newpvprs = int_v_price.
          <iline_cr>-manpae_s = eline-change_std_price.
          <iline_cr>-manpae_v = eline-change_mov_price.
        ENDIF.
      ENDIF.                             "Eintrag in ext. Tabelle gefunden

    ENDLOOP.  "CURTP - - - - - - - - - - - - - - - - - - - - - - - - -
  ENDLOOP.                             "P_ITAB

ENDFORM.                               " CONVERT_ETAB_2_ITAB

*&---------------------------------------------------------------------*
*&      Form  CONVERT_ESEG_2_ISEG
*&---------------------------------------------------------------------*
*       Konvertierung der externen Darstellung des Material-Bewertungs-
*       Segmentes in die interne Darstellung
*----------------------------------------------------------------------*
*      -->P_ESEG            Externe Darstellung des Bewertungssegments
*      -->P_BUKRS           Buchungskreis
*      -->P_BWKEY_IS_BUKRS  Bewertungs auf Buchungskreisebene (= 'X')
*      <--P_ILINE           Interne Darstellung (Bew.Seg & CURTP-Zeilen)
*      <->P_PSP_EXT_INT     Hilfstabelle: Konvertierung PSP ext.<->int.
*      <->P_RETURN_TAB      BAPI-Fehlertabelle
*      <--P_ERROR           Erfolgsmeldung
*                             initial = fehlerfrei
*                             'X'     = Fehler
*----------------------------------------------------------------------*
FORM convert_eseg_2_iseg
                 USING p_eseg           TYPE ckmpr_f_bapi2027_pc_bewseg
                       p_bukrs          LIKE bapi2027_pc_hd-comp_code
                       p_bwkey_is_bukrs TYPE c
              CHANGING p_iline          TYPE ckmpr_f_mat_price
                       p_psp_ext_int    TYPE psp_ext_int
                       p_return_tab     TYPE ckmpr_bapireturn1_tab
                       p_error          TYPE c.

  DATA:
*       Zeile der Fehlertabelle
    p_return_line    LIKE LINE OF p_return_tab,
*       Zeile der PSP-Konvertierungstabelle
    line_psp_ext_int LIKE LINE OF p_psp_ext_int,
*       Hilfsstrukturen
    f_vbap           LIKE vbap,
    f_prps           LIKE prps.

  CLEAR:
         p_error,
         p_iline,
         p_iline-pp.
  REFRESH:
         p_iline-cr.

* Bewertungskreis setzen (Buchungskreis oder Werk)
  IF ( NOT p_bwkey_is_bukrs IS INITIAL ).
    p_iline-pp-bwkey = p_bukrs.
  ELSE.
    p_iline-pp-bwkey = p_eseg-plant.
  ENDIF.

* Materialnummer
  p_iline-pp-matnr = p_eseg-material.

* Bewertungsart
  p_iline-pp-bwtar = p_eseg-val_type.

* Initialisiere Einzelbestandsfelder
  CLEAR p_iline-pp-sobkz.
  CLEAR p_iline-pp-vbeln.
  CLEAR p_iline-pp-posnr.
  CLEAR p_iline-pp-pspnr.

* Kundeneinzelbestand
  IF (     ( NOT p_eseg-sales_ord   IS INITIAL )
       AND ( NOT p_eseg-s_ord_item  IS INITIAL )
       AND (     p_eseg-wbs_element IS INITIAL ) ).
*   Gibt es diesen Vertriebsbeleg/Position
    CALL FUNCTION 'SD_VBAP_SELECT'
      EXPORTING
        i_document_number = p_iline-pp-vbeln
        i_item_number     = p_iline-pp-posnr
      IMPORTING
        e_vbap            = f_vbap
      EXCEPTIONS
        item_not_found    = 1
        error_message     = 2    "Alle Fehler abfangen
        OTHERS            = 3.
    IF sy-subrc <> 0.
*     Fehler: Vertriebs-Belegposition existiert nicht
*     (Fehlermeldung aus SD_VBAP_SELECT an BAPI durchreichen)
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
          bapireturn = p_return_line.
      APPEND p_return_line TO p_return_tab.
      p_error = 'X'.
    ELSE.
      p_iline-pp-vbeln = p_eseg-sales_ord.
      p_iline-pp-posnr = p_eseg-s_ord_item.
      p_iline-pp-sobkz = 'E'.
    ENDIF.
  ENDIF.

*  Projekteinzelbestand
  IF (     (     p_eseg-sales_ord   IS INITIAL )
       AND (     p_eseg-s_ord_item  IS INITIAL )
       AND ( NOT p_eseg-wbs_element IS INITIAL ) ).
*   Projektstrukturplanelement von extern (Domäne PS_POSID) auf
*   intern (Domäne PS_POSNR) konvertieren...
    CALL FUNCTION 'CJDW_PRPS_SELECT_SINGLE'
      EXPORTING
*       OBJNR             = ' '
        posid             = p_eseg-wbs_element
*       POSNR             = ' '
      IMPORTING
        e_prps            = f_prps
*       E_VSPRPS          =
      EXCEPTIONS
        missing_parameter = 1
        not_found         = 2
        error_message     = 3    "Alle Fehler abfangen
        OTHERS            = 4.
    IF sy-subrc <> 0.
*     Fehlerhafte externe PSP-Elementenummer
*     (Fehlermeldung aus CJDW_PRPS_SELECT_SINGLE an BAPI durchreichen)
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
          bapireturn = p_return_line.
      APPEND p_return_line TO p_return_tab.
      p_error = 'X'.
    ELSE.
*     Extern -> intern Konvertierung übertragen
      p_iline-pp-pspnr = f_prps-pspnr.
      p_iline-pp-sobkz = 'Q'.
*     Es wird eine Hilfstabelle gefüllt, um sicherzustellen, daß
*     später die Rück-Konvertierung das identische Ergebnis bringt
*     und nicht die externe Darstellung "editiert".
      CLEAR line_psp_ext_int.
      line_psp_ext_int-ext = p_eseg-wbs_element.
      line_psp_ext_int-ext = p_iline-pp-pspnr.
      APPEND line_psp_ext_int TO p_psp_ext_int.
    ENDIF.
  ENDIF.


** Sonderbestand wird NICHT auf BEWERTET/UNBEWERTET überprüft,
** PRICES_PROPOSE bestimmt nachher, ob der Sonderbestand bewertet
** geführt wird. (Markus Kuppe 19.3.99)
*
*  DATA:
**       Hilfsvariablen für Sonderbestand
*        line_psp_ext_int LIKE LINE OF p_psp_ext_int,
*        wrong_sobkz      TYPE c,
*        f_vbap           LIKE vbap,
*        f_t459a          LIKE t459a,
*        f_t459k          LIKE t459k,
*        f_prps           LIKE prps.
*
** Prüfen, ob die Kombinationen zum Sonderbestand von außen "passen"
*  wrong_sobkz = 'X'.
** Fall 1) Kein Sonderbestand
*  IF (     ( p_eseg-sales_ord   IS INITIAL )
*       AND ( p_eseg-s_ord_item  IS INITIAL )
*       AND ( p_eseg-wbs_element IS INITIAL ) ).
*    CLEAR wrong_sobkz.
*    CLEAR p_iline-pp-sobkz.
*    CLEAR p_iline-pp-vbeln.
*    CLEAR p_iline-pp-posnr.
*    CLEAR p_iline-pp-pspnr.
*  ENDIF.
** Fall 2) Kundeneinzelbestand
*  IF (     ( NOT p_eseg-sales_ord   IS INITIAL )
*       AND ( NOT p_eseg-s_ord_item  IS INITIAL )
*       AND (     p_eseg-wbs_element IS INITIAL ) ).
*    CLEAR wrong_sobkz.
**   Hat die Position einen bewerteten KDE-Bestand ?
*    CALL FUNCTION 'SD_VBAP_SELECT'
*         EXPORTING
*              i_document_number = p_iline-pp-vbeln
*              i_item_number     = p_iline-pp-posnr
*         IMPORTING
*              e_vbap            = f_vbap
*         EXCEPTIONS
*              item_not_found    = 1
*              OTHERS            = 2.
*    IF sy-subrc <> 0.
**     Fehler: Vertriebs-Belegposition existiert nicht
*      CLEAR p_iline-pp-sobkz.
*      p_error = 3.
*    ELSE.
*      p_iline-pp-vbeln = p_eseg-sales_ord.
*      p_iline-pp-posnr = p_eseg-s_ord_item.
*      CLEAR f_t459a.
*      SELECT SINGLE *
*               FROM t459a
*               INTO f_t459a
*              WHERE bedae = f_vbap-bedae. "Bedarfsart
*      CLEAR f_t459k.
*      SELECT SINGLE *
*               FROM t459k
*               INTO f_t459k
*              WHERE bedar = f_t459a-bedar. "Bedarfsklasse
*      IF NOT f_t459k-kzbws IS INITIAL.
**       Kundeneinzelbestand ist bewertet
*        p_iline-pp-sobkz = 'E'.
*      ELSE.
**       Kundeneinzelbestand ist unbewertet
*        CLEAR p_iline-pp-sobkz.
*      ENDIF.
*    ENDIF.
*  ENDIF.                               "Kundeneinzelbestand
** Fall 3) Projekteinzelbestand
*  IF (     (     p_eseg-sales_ord   IS INITIAL )
*       AND (     p_eseg-s_ord_item  IS INITIAL )
*       AND ( NOT p_eseg-wbs_element IS INITIAL ) ).
*    CLEAR wrong_sobkz.
*
**   Projektstrukturplanelement von extern (Domäne PS_POSID) auf
**   intern (Domäne PS_POSNR) konvertieren...
**   ...und prüfen, ob der Einzelbestand bewertet geführt wird
*    CALL FUNCTION 'CJDW_PRPS_SELECT_SINGLE'
*         EXPORTING
**             OBJNR             = ' '
*              posid             = p_eseg-wbs_element
**             POSNR             = ' '
*         IMPORTING
*              e_prps            = f_prps
**             E_VSPRPS          =
*         EXCEPTIONS
*              missing_parameter = 1
*              not_found         = 2
*              OTHERS            = 3.
*    IF sy-subrc <> 0.
**     Fehlerhafte externe PSP-Elementenummer
*      CLEAR p_iline-pp-sobkz.
*      CLEAR p_iline-pp-pspnr.
*      p_error = 2.
*    ELSE.
**     Extern -> intern Konvertierung übertragen
*      p_iline-pp-pspnr = f_prps-pspnr.
**     Es wird eine Hilfstabelle gefüllt, um sicherzustellen, daß
**     später die Rück-Konvertierung das identische Ergebnis bringt
**     und nicht die externe Darstellung "editiert".
*      CLEAR line_psp_ext_int.
*      line_psp_ext_int-ext = p_eseg-wbs_element.
*      line_psp_ext_int-ext = p_iline-pp-pspnr.
*      APPEND line_psp_ext_int TO p_psp_ext_int.
**     Bewertet ?
*      IF NOT f_prps-kzbws IS INITIAL.
**       Projekteinzelbestand ist bewertet
*        p_iline-pp-sobkz = 'Q'.
*      ELSE.
**       Projekteinzelbestand ist unbewertet
*        CLEAR p_iline-pp-sobkz.
*      ENDIF.
*    ENDIF.
*  ENDIF.                               "Projekteinzelbestand
*
** Wurde einer der obigen Fälle erkannt, so ist WRONG_SOBKZ initial
*  IF ( NOT wrong_sobkz IS INITIAL ).
**   Fehler bei Angaben zu Sonderbestand
*    p_error = 1.
*  ENDIF.

ENDFORM.                               " CONVERT_ESEG_2_ISEG
*&---------------------------------------------------------------------*
*&      Form  convert_price
*&---------------------------------------------------------------------*
*       Preis bezogen auf die Materialstamm-Preiseinheit und die
*       Materialstamm-Basismengeneinheit aus externem Preis, externer
*       Preiseinheit und externer Preismengeneinheit berechnen.
*----------------------------------------------------------------------*
*    -->P_MATNR        Material
*    -->P_EXT_S_PRICE  Externer Standardpreis
*    -->P_EXT_V_PRICE  Externer Verrechnungspreis
*    -->P_EXT_PEINH    Externe Preiseinheit
*    -->P_EXT_MEINH    Externe Preismengeneinheit
*    -->P_INT_PEINH    Interne Preiseinheit aus dem Materialstamm
*    <--P_INT_S_PRICE  Interner Standardpreis
*    <--P_INT_V_PRICE  Interner Verrechnungspreis
*    <->P_RETURN_TAB   Fehlertabelle für BAPI
*    <--p_error        Erfolgsmeldung
*                         initial = Erfolg
*                         'X'     = Fehler
*----------------------------------------------------------------------*
FORM convert_price USING    p_matnr        LIKE  mara-matnr
                            p_ext_s_price  TYPE  stprs
                            p_ext_v_price  TYPE  ck_pvprs_1
                            p_ext_peinh    LIKE  mbew-peinh
                            p_ext_meinh    LIKE  mara-meins
                            p_int_peinh    LIKE  mbew-peinh
                   CHANGING p_int_s_price  LIKE  mbew-stprs
                            p_int_v_price  LIKE  mbew-verpr
                            p_return_tab   TYPE  ckmpr_bapireturn1_tab
                            p_error        TYPE  c.

  DATA:
*    Zeile der Fehlertabelle
    p_return_line LIKE LINE OF p_return_tab,
*    Hilfsgröße: Bezugsmenge in Basismengeneinheit
    quantity      LIKE  mbew-peinh.


  CLEAR p_error.
  CLEAR p_return_line.
  CLEAR p_int_s_price.
  CLEAR p_int_v_price.

* Bemerkung: Falls P_EXT_MEINH = Basisimengeneinheit passiert im
* folgenden FB nur OUTPUT = INPUT => keine Rundungsprobleme
*
* Hilfsmenge: X = Externe Preiseinheit mit externer Preismengeneinheit
*                 umgerechnet in Basismengeneinheit des Materials
*     (d.h. der externe Preis bezieht sich auf X Basismengeneinheiten)
  CLEAR quantity.
  CALL FUNCTION 'MATERIAL_UNIT_CONVERSION'
    EXPORTING
      input                = p_ext_peinh
      kzmeinh              = 'X' "-> umrechnen in MARA-MEINS
      matnr                = p_matnr
      meinh                = p_ext_meinh
    IMPORTING
      output               = quantity
    EXCEPTIONS
      conversion_not_found = 1
      input_invalid        = 2
      material_not_found   = 3
      meinh_not_found      = 4
      meins_missing        = 5
      no_meinh             = 6
      output_invalid       = 7
      overflow             = 8
      error_message        = 9   "Alle Fehler abfangen
      OTHERS               = 10.
  IF ( sy-subrc <> 0 ).
*   Fehlermeldung aus MATERIAL_UNIT_CONV... an BAPI durchreichen
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
        bapireturn = p_return_line.
    APPEND p_return_line TO p_return_tab.
    p_error = 'X'.
  ENDIF.

  IF ( quantity = 0 ).
*   Fehler bei Preisumrechnung (extern -> intern)
*   MESSAGE wird außerhalb der Form ausgegeben
    p_error = 'X'.
  ENDIF.

* Falls bereits Fehler festgestellt => FORM verlassen
  CHECK ( p_error IS INITIAL ).

* Falls die Bezugsmenge = Materialstamm-Preiseinheit => kopieren
  IF ( quantity = p_int_peinh ).
    p_int_s_price = p_ext_s_price.
    p_int_v_price = p_ext_v_price.
* Sonst: Preis = Externer Preis * Mat.Stamm-Preiseinheit / Hilfsmenge
* (Bemerkung: QUANTITY = 0 kann nicht mehr sein, siehe CHECK...)
  ELSE.
    p_int_s_price = p_ext_s_price * ( p_int_peinh / quantity ).
    p_int_v_price = p_ext_v_price * ( p_int_peinh / quantity ).
  ENDIF.

ENDFORM.                               " convert_price
*&---------------------------------------------------------------------*
*&      Form  PRICES_CHANGE_AND_POST
*&---------------------------------------------------------------------*
*       Ruft die Routinen PRICES_CHANGE und PRICES_POST mit der Tabelle
*       MAT_PRICE auf. Ggf. werden Fehler in die externe BAPI-Tabelle
*       MATERIAL_PRICE_LIST übertragen.
*----------------------------------------------------------------------*
*      -->P_BUKRS       Buchungskreis
*      -->P_BDATJ       Geschäftsjahr
*      -->P_POPER       Periode
*      -->P_BUDAT       Buchungsdatum
*      <->P_INT_TAB     Interne Tabelle für PRICES_CHANGE
*      <--P_KJAHR       ML-Beleg-Speicherungsjahr
*      <--P_BELNR       ML-Belegnummer
*      <->P_RETURN_TAB  Externe Fehler-Tabelle
*      <--P_ERROR       Ergebnis
*                         initial = Erfolg
*                         'X '    = Fehler
*----------------------------------------------------------------------*
FORM prices_change_and_post
                    USING    p_bukrs      LIKE bapi2027_pc_hd-comp_code
                             p_bdatj      TYPE bkpf-gjahr
                             p_poper      TYPE ckmlpp-poper
                             p_budat      LIKE bapi2027_pc_hd-pstng_date
                    CHANGING p_int_tab    TYPE ckmpr_mat_price
                             p_kjahr     LIKE bapi2027_pc_ex-ml_doc_year
                             p_belnr      LIKE bapi2027_pc_ex-ml_doc_num
                             p_return_tab TYPE ckmpr_bapireturn1_tab
                             p_error      TYPE c.

  DATA:
*      Zeile der externen Fehlertabelle
       p_return_line LIKE LINE OF p_return_tab.


  CLEAR p_error.


* Material-Ledger-Puffer zurücksetzen
  CALL FUNCTION 'CKML_BUFFER_REFRESH_ALL'
    EXPORTING
      i_called_by   = 'PRCH-B'
    EXCEPTIONS
      error_message = 1.
  IF sy-subrc <> 0.
*   Fehler in p_return_tab übertragen
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
        bapireturn = p_return_line.
    APPEND p_return_line TO p_return_tab.
    p_error = 'X'.
  ENDIF.

* Bei Fehler: FORM verlassen
  CHECK p_error IS INITIAL.

* Preisverbuchung auf Fehlerfreiheit überprüfen
  CALL FUNCTION 'PRICES_CHANGE'
    EXPORTING
      actual_bdatj   = p_bdatj
      actual_poper   = p_poper
      bukrs          = p_bukrs
      ignore_kalkl   = 'X'
*     SUBS_DBT       =            "Preisänderung (nicht Belastung)
      budat          = p_budat
    TABLES
      t_matpr        = p_int_tab
    EXCEPTIONS
      invalid_period = 1
      error_message  = 2         "Alle Fehler abfangen
      OTHERS         = 3.
  IF sy-subrc <> 0.
*   Fehler in p_return_tab übertragen
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
        bapireturn = p_return_line.
    APPEND p_return_line TO p_return_tab.
    p_error = 'X'.
  ENDIF.

* Bei Fehler: FORM verlassen
  CHECK p_error IS INITIAL.

* Falls bei PRICES_CHANGE irgendein Fehler auftritt, wird PRICES_POST
* NICHT aufgerufen. D.h. bei Fehler zu einem einzigen Satz wird über-
* haupt nichts verbucht, und der BAPI kann mit ALLEN Sätzen erneut
* aufgerufen werden - nicht nur mit den korrigierten Sätzen.
* Wo der Fehler aufgetreten ist, steht im Fehlerprotokoll.
  CALL FUNCTION 'PRICES_POST'
    EXPORTING
*     I_BKTXT       =
      bukrs         = p_bukrs
*     LIS_UPDATE    = 'X'
*     SUBS_DBT      =
*     I_AWREF       =
*     I_AWORG       =
*     I_AWTYP       =
*     I_AWSYS       =
*     NO_MESSAGE    =
    IMPORTING
      o_belnr       = p_belnr
      o_kjahr       = p_kjahr
    TABLES
      t_matpr       = p_int_tab
    EXCEPTIONS
      error_message = 1           "Alle Fehler abfangen
      OTHERS        = 2.
  IF sy-subrc <> 0.
*   Fehler aus "PRICES_POST" in p_return_tab übertragen
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
        bapireturn = p_return_line.
    APPEND p_return_line TO p_return_tab.
    p_error = 'X'.
  ENDIF.                               "SY-SUBRC

ENDFORM.                               " PRICES_CHANGE_AND_POST
