FUNCTION zfm_sd_calculate.
*"----------------------------------------------------------------------
*"*"本地接口：
*"  IMPORTING
*"     REFERENCE(IV_P1) TYPE  P
*"     REFERENCE(IV_P2) TYPE  P
*"     REFERENCE(IV_OP) TYPE  C
*"  EXPORTING
*"     REFERENCE(RV) TYPE  P
*"----------------------------------------------------------------------

  CASE iv_op.
    WHEN '+'.
      rv = iv_p1 + iv_p2.
    WHEN '-'.
      rv = iv_p1 - iv_p2.
    WHEN '*'.
      rv = iv_p1 * iv_p2.
    WHEN '/'.
      CHECK iv_p2 <> 0.
      rv = iv_p1 / iv_p2.
  ENDCASE.

ENDFUNCTION.
