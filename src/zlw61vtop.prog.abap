TABLES: matvp,
        tmvf,
        mt61d,
        am61r,
        wmdvs,
        t001w,
        mtcom,
        mtcor,
        t006,
        t006a,
        wmdve.

* Eingabetabelle für Verfügbarkeitsprüfung
DATA:    BEGIN OF mdvps OCCURS 10.
           INCLUDE STRUCTURE mdvs.
DATA:    END OF mdvps.
*DATA:    BEGIN OF WMDVSX OCCURS 10.
*           INCLUDE STRUCTURE BAPIWMDVS.
*DATA:    END OF WMDVSX.

* Ausgabetabelle für Verfügbarkeitsprüfung
DATA:    BEGIN OF mdvex OCCURS 10.
           INCLUDE STRUCTURE mdve.
DATA:    END OF mdvex.
*DATA:    BEGIN OF WMDVEX OCCURS 10.
*           INCLUDE STRUCTURE BAPIWMDVE.
*DATA:    END OF WMDVEX.
* Korrektur für Verfügbarkeitsprüfung
DATA:    BEGIN OF mdvpk OCCURS 10.
           INCLUDE STRUCTURE mdvp.
DATA:    END OF mdvpk.

DATA:    fabkl LIKE matvp-mtvfp.
DATA: w_wzter LIKE cm61m-wzter,
      w_wkmng LIKE cm61v-wkbst,
      w_atpmn LIKE cm61v-atpbt,
      w_sumag LIKE cm61v-sumag,
      w_sumzg LIKE cm61v-sumzg,
      w_sumba LIKE cm61v-sumba,
      subrc   LIKE sy-subrc.

DATA: BEGIN OF dummy OCCURS 1,
        dummy,
      END OF dummy.
DATA  cum_atp LIKE bapicm61v-atpbt.
*--> Erweiterungen zu 3.1
DATA maxmng LIKE mdvs-mng01 VALUE '9999999999'.
*--> User exit für Selektion Werk und Prüfregel
DATA: customer_check_rule LIKE bapit441v-prreg,
      customer_plant      LIKE bapimatvp-werks,
      customer_trtyp      LIKE bapicm61v-trtyp.
DATA: BEGIN OF message,
        subrc LIKE sy-subrc,
        msgid LIKE sy-msgid,
        msgty LIKE sy-msgty,
        msgno LIKE sy-msgno,
        msgv1 LIKE sy-msgv1,
        msgv2 LIKE sy-msgv2,
        msgv3 LIKE sy-msgv3,
        msgv4 LIKE sy-msgv4.
DATA: END   OF message.


DATA: BEGIN OF t_mara OCCURS 10,
        bdcnt              TYPE xline,
        matnr              TYPE matnr40,
        meins              TYPE meins,
        unit               TYPE meinh,
        umren              TYPE umren,
        umrez              TYPE umrez,
        dec_for_rounding   TYPE andec,
        dec_for_rounding_x TYPE bapiupdate,
        andec              TYPE andec,
      END OF t_mara.
