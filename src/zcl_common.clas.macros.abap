*"* use this source file for any macro definitions you need
*"* in the implementation part of the class
DEFINE all_fields.
  &1 1  &2.
  &1 2  &2.
  &1 3  &2.
  &1 4  &2.
  &1 5  &2.
  &1 6  &2.
  &1 7  &2.
  &1 8  &2.
  &1 9  &2.
  &1 10 &2.
  &1 11 &2.
  &1 12 &2.
  &1 13 &2.
  &1 14 &2.
  &1 15 &2.
  &1 16 &2.
  &1 17 &2.
  &1 18 &2.
  &1 19 &2.
  &1 20 &2.
END-OF-DEFINITION.

DEFINE assign_value.
  WHEN &1.
    ASSIGN COMPONENT <wa_key_comp>-name OF STRUCTURE &2 TO <wa_value&1>.
END-OF-DEFINITION.

DEFINE init_value.
  WHEN &1.
     IF sy-subrc = 0.
        lv_fname&1 = <wa_key_comp>-name.
     ENDIF.
     ASSIGN &2 TO <wa_value&1>.
END-OF-DEFINITION.

DEFINE read_table.
  LOOP AT lt_keys_components ASSIGNING <wa_key_comp>.
    CASE sy-tabix.
        all_fields assign_value &1.
    ENDCASE.
  ENDLOOP.
  READ TABLE &2 ASSIGNING &3 WITH KEY
   (lv_fname1) = <wa_value1>
   (lv_fname2) = <wa_value2>
   (lv_fname3) = <wa_value3>
   (lv_fname4) = <wa_value4>
   (lv_fname5) = <wa_value5>
   (lv_fname6) = <wa_value6>
   (lv_fname7) = <wa_value7>
   (lv_fname8) = <wa_value8>
   (lv_fname9) = <wa_value9>
   (lv_fname10) = <wa_value10>
   (lv_fname11) = <wa_value11>
   (lv_fname12) = <wa_value12>
   (lv_fname13) = <wa_value13>
   (lv_fname14) = <wa_value14>
   (lv_fname15) = <wa_value15>
   (lv_fname16) = <wa_value16>
   (lv_fname17) = <wa_value17>
   (lv_fname18) = <wa_value18>
   (lv_fname19) = <wa_value19>
   (lv_fname20) = <wa_value20>
  BINARY SEARCH.
END-OF-DEFINITION.

DEFINE add_data.
  read_table &1 ct_data <wa_line>.
  LOOP AT ct_data ASSIGNING <wa_line> FROM sy-tabix.
      CLEAR lv_exit_flag.
      LOOP AT lt_keys_components ASSIGNING <wa_key_comp>.
        ASSIGN COMPONENT <wa_key_comp>-name OF STRUCTURE <wa_line> TO <wa_value1>.
        ASSIGN COMPONENT <wa_key_comp>-name OF STRUCTURE &1 TO <wa_value2>.
        IF <wa_value1> <> <wa_value2>.
          lv_exit_flag = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.
      IF lv_exit_flag = abap_true.
        EXIT.
      ENDIF.
      APPEND INITIAL LINE TO <table> ASSIGNING <line>.
      GET REFERENCE OF <wa_line> INTO <line>.
    ENDLOOP.
END-OF-DEFINITION.

DEFINE add_data_and_sub.
  add_data &1.
  APPEND INITIAL LINE TO <new_table_sub> ASSIGNING <new_line_sub>.
  <new_line_sub> = CORRESPONDING #( &1 ).
  ASSIGN COMPONENT 'GROUP_COUNT' OF STRUCTURE <new_line_sub> TO <wa_value2>.
  <wa_value2> = <wa_value>.
  ASSIGN COMPONENT 'ITEMS' OF STRUCTURE <new_line_sub> TO <wa_value2>.
  <wa_value2> = <table>.
  REFRESH <table>.
END-OF-DEFINITION.

DEFINE add_group.
  APPEND INITIAL LINE TO <new_table> ASSIGNING <new_line>.
  lv_id += 1.
  ASSIGN COMPONENT 'GROUP_ID' OF STRUCTURE <new_line> TO <wa_value2>.
  <wa_value2> = lv_id.
  ASSIGN COMPONENT 'GROUP_COUNT' OF STRUCTURE <new_line> TO <wa_value2>.
  <wa_value2> = lv_count.
  ASSIGN COMPONENT 'ITEMS' OF STRUCTURE <new_line> TO <wa_value2>.
  <wa_value2> = &1.
  REFRESH &1.
  CLEAR lv_count.
END-OF-DEFINITION.
