*&---------------------------------------------------------------------*
*& Report zdemo_tcurr
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdemo_tcurr.

TABLES:tcurr.
SELECTION-SCREEN BEGIN OF BLOCK bk1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_gdatu FOR sy-datum."tcurr-gdatu."汇率有效起始日期
  SELECT-OPTIONS: s_fcurr FOR tcurr-fcurr."从货币
  SELECT-OPTIONS: s_tcurr FOR tcurr-tcurr."最终货币
SELECTION-SCREEN END OF BLOCK bk1.

INITIALIZATION.
  s_gdatu-sign = 'I'.
  s_gdatu-option = 'BT'.
  s_gdatu-low = |{ sy-datum+0(4) }0101|.
  s_gdatu-high = |{ sy-datum+0(4) }1231|.
  APPEND s_gdatu.

END-OF-SELECTION.
  DATA: lt_dba_sellist TYPE tt_vimsellist.
  zcl_common=>view_rangetab_to_sellist( EXPORTING fieldname = 'GDATU' rangetab = s_gdatu[] CHANGING sellist = lt_dba_sellist ).
  zcl_common=>view_rangetab_to_sellist( EXPORTING fieldname = 'FCURR' rangetab = s_fcurr[] CHANGING sellist = lt_dba_sellist ).
  zcl_common=>view_rangetab_to_sellist( EXPORTING fieldname = 'TCURR' rangetab = s_tcurr[] CHANGING sellist = lt_dba_sellist ).
  zcl_common=>view_maintenance( action = 'U' view_name = 'V_TCURR' dba_sellist = lt_dba_sellist ).
