FUNCTION zfun_get_date_rec.
*"----------------------------------------------------------------------
*"*"本地接口：
*"  IMPORTING
*"     VALUE(IV_MODE) TYPE  CHAR1 OPTIONAL
*"  CHANGING
*"     REFERENCE(CS_DATA)
*"----------------------------------------------------------------------
  FIELD-SYMBOLS:<fs_ernam>,<fs_erdat>,<fs_erzet>,<fs_aenam>,<fs_aedat>,<fs_aezet>.
  ASSIGN COMPONENT 'ERNAM' OF STRUCTURE cs_data TO <fs_ernam>.
  ASSIGN COMPONENT 'ERDAT' OF STRUCTURE cs_data TO <fs_erdat>.
  ASSIGN COMPONENT 'ERZET' OF STRUCTURE cs_data TO <fs_erzet>.
  ASSIGN COMPONENT 'AENAM' OF STRUCTURE cs_data TO <fs_aenam>.
  ASSIGN COMPONENT 'AEDAT' OF STRUCTURE cs_data TO <fs_aedat>.
  ASSIGN COMPONENT 'AEZET' OF STRUCTURE cs_data TO <fs_aezet>.
  CASE iv_mode.
    WHEN 'I'.
      IF <fs_ernam> IS ASSIGNED.
        <fs_ernam> = sy-uname.
      ENDIF.
      IF <fs_erdat> IS ASSIGNED.
        <fs_erdat> = sy-datum.
      ENDIF.
      IF <fs_erzet> IS ASSIGNED.
        <fs_erzet> = sy-uzeit.
      ENDIF.
      IF <fs_aenam> IS ASSIGNED.
        CLEAR <fs_aenam>.
      ENDIF.
      IF <fs_aedat> IS ASSIGNED.
        CLEAR <fs_aedat>.
      ENDIF.
      IF <fs_aezet> IS ASSIGNED.
        CLEAR <fs_aezet>.
      ENDIF.
    WHEN 'M'.
      IF <fs_aenam> IS ASSIGNED.
        <fs_aenam> = sy-uname.
      ENDIF.
      IF <fs_aedat> IS ASSIGNED.
        <fs_aedat> = sy-datum.
      ENDIF.
      IF <fs_aezet> IS ASSIGNED.
        <fs_aezet> = sy-uzeit.
      ENDIF.
    WHEN OTHERS.
      IF <fs_ernam> IS ASSIGNED AND <fs_ernam> IS INITIAL.
        <fs_ernam> = sy-uname.
        IF <fs_erdat> IS ASSIGNED.
          <fs_erdat> = sy-datum.
        ENDIF.
        IF <fs_erzet> IS ASSIGNED.
          <fs_erzet> = sy-uzeit.
        ENDIF.
      ELSE.
        IF <fs_aenam> IS ASSIGNED.
          <fs_aenam> = sy-uname.
        ENDIF.
        IF <fs_aedat> IS ASSIGNED.
          <fs_aedat> = sy-datum.
        ENDIF.
        IF <fs_aezet> IS ASSIGNED.
          <fs_aezet> = sy-uzeit.
        ENDIF.
      ENDIF.
  ENDCASE.

ENDFUNCTION.
