*"* use this source file for your ABAP unit test classes

CLASS lc_test_runtime DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.


  PRIVATE SECTION.
    TYPES: BEGIN OF ty_data,
             id    TYPE i,
             group TYPE i,
             value TYPE i,
           END OF ty_data.


    METHODS:
      test_simple_std_without_key          FOR TESTING,
      test_std_without_key                 FOR TESTING,
      test_std_with_key                    FOR TESTING,
      test_std_without_key_order           FOR TESTING,
      test_simple_sort_with_key            FOR TESTING,
      init_data
        CHANGING ct_data TYPE INDEX TABLE.


ENDCLASS.

CLASS lc_test_runtime IMPLEMENTATION.

  METHOD test_simple_std_without_key.
    TYPES: BEGIN OF ty_data,
             id    TYPE i,
             group TYPE i,
             value TYPE i,
           END OF ty_data.
    TYPES: tty_ref TYPE STANDARD TABLE OF REF TO ty_data WITH DEFAULT KEY.
    TYPES:BEGIN OF ty_group,
            group_id    TYPE i,
            group_count TYPE i,
            items       TYPE tty_ref,
          END OF ty_group.
    TYPES: tty_group TYPE STANDARD TABLE OF ty_group.

    DATA: lt_data TYPE STANDARD TABLE OF ty_data,
          ls_data TYPE ty_data.
    DATA: lt_group TYPE STANDARD TABLE OF ty_group,
          ls_group TYPE ty_group.

    DATA: lv_count TYPE i.
    DATA lt_keys TYPE lvc_t_fnam.
    DATA lr_data TYPE REF TO data.
    FIELD-SYMBOLS <fs_group> TYPE tty_group.

    lt_keys = VALUE #( ( 'GROUP' ) ).

    init_data( CHANGING ct_data = lt_data ).

    zcl_common=>split_group_simple( EXPORTING  iv_size        = 10
                                               iv_keep_order  = abap_false
                                               it_keys        = lt_keys
                                    CHANGING   ct_data        = lt_data
                                               cr_data        = lr_data
                                    EXCEPTIONS keys_not_found = 1 ).
    cl_abap_unit_assert=>assert_equals( act   = sy-subrc
                                        exp   = 0
                                        level = 0 ).
    ASSIGN lr_data->* TO <fs_group>.
    lv_count = REDUCE #( INIT i = 0 FOR wa_group IN <fs_group> NEXT i += wa_group-group_count ).
    cl_abap_unit_assert=>assert_equals( act   = lv_count
                                        exp   = 100
                                        level = 0 ).

  ENDMETHOD.

  METHOD test_std_without_key.
    TYPES: tty_ref TYPE STANDARD TABLE OF REF TO ty_data WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_sub_item,
             group       TYPE i,
             group_count TYPE i,
             items       TYPE tty_ref,
           END OF ty_sub_item.
    TYPES: tty_sub_item TYPE STANDARD TABLE OF ty_sub_item WITH DEFAULT KEY.
    TYPES:BEGIN OF ty_group,
            group_id    TYPE i,
            group_count TYPE i,
            items       TYPE tty_sub_item,
          END OF ty_group.
    TYPES: tty_group TYPE STANDARD TABLE OF ty_group.

    DATA: lt_data TYPE STANDARD TABLE OF ty_data,
          ls_data TYPE ty_data.
    DATA: lt_group TYPE STANDARD TABLE OF ty_group,
          ls_group TYPE ty_group.

    DATA: lv_count TYPE i.
    DATA lt_keys TYPE lvc_t_fnam.
    DATA lr_data TYPE REF TO data.
    FIELD-SYMBOLS <fs_group> TYPE tty_group.

    lt_keys = VALUE #( ( 'GROUP' ) ).

    init_data( CHANGING ct_data = lt_data ).

    zcl_common=>split_group( EXPORTING  iv_size        = 10
                                        iv_keep_order  = abap_false
                                        it_keys        = lt_keys
                             CHANGING   ct_data        = lt_data
                                        cr_data        = lr_data
                             EXCEPTIONS keys_not_found = 1 ).
    cl_abap_unit_assert=>assert_equals( act   = sy-subrc
                                        exp   = 0
                                        level = 0 ).
    ASSIGN lr_data->* TO <fs_group>.
    lv_count = REDUCE #( INIT i = 0 FOR wa_group IN <fs_group> NEXT i += wa_group-group_count ).
    cl_abap_unit_assert=>assert_equals( act   = lv_count
                                        exp   = 100
                                        level = 0 ).

  ENDMETHOD.

  METHOD test_std_with_key.
    TYPES: tty_ref TYPE STANDARD TABLE OF REF TO ty_data WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_sub_item,
             group       TYPE i,
             group_count TYPE i,
             items       TYPE tty_ref,
           END OF ty_sub_item.
    TYPES: tty_sub_item TYPE STANDARD TABLE OF ty_sub_item WITH DEFAULT KEY.
    TYPES:BEGIN OF ty_group,
            group_id    TYPE i,
            group_count TYPE i,
            items       TYPE tty_sub_item,
          END OF ty_group.
    TYPES: tty_group TYPE STANDARD TABLE OF ty_group.

    DATA: lt_data TYPE STANDARD TABLE OF ty_data WITH NON-UNIQUE KEY primary_key COMPONENTS group,
          ls_data TYPE ty_data.
    DATA: lt_group TYPE STANDARD TABLE OF ty_group,
          ls_group TYPE ty_group.

    DATA: lv_count TYPE i.
    DATA lr_data TYPE REF TO data.
    FIELD-SYMBOLS <fs_group> TYPE tty_group.

    init_data( CHANGING ct_data = lt_data ).



    zcl_common=>split_group( EXPORTING  iv_size        = 10
                                        iv_keep_order  = abap_false
                             CHANGING   ct_data        = lt_data
                                        cr_data        = lr_data
                             EXCEPTIONS keys_not_found = 1 ).

    cl_abap_unit_assert=>assert_equals( act   = sy-subrc
                                        exp   = 0
                                        level = 0 ).
    ASSIGN lr_data->* TO <fs_group>.
    lv_count = REDUCE #( INIT i = 0 FOR wa_group IN <fs_group> NEXT i += wa_group-group_count ).
    cl_abap_unit_assert=>assert_equals( act   = lv_count
                                        exp   = 100
                                        level = 0 ).

  ENDMETHOD.

  METHOD test_std_without_key_order.
    TYPES: tty_ref TYPE STANDARD TABLE OF REF TO ty_data WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_sub_item,
             group       TYPE i,
             group_count TYPE i,
             items       TYPE tty_ref,
           END OF ty_sub_item.
    TYPES: tty_sub_item TYPE STANDARD TABLE OF ty_sub_item WITH DEFAULT KEY.
    TYPES:BEGIN OF ty_group,
            group_id    TYPE i,
            group_count TYPE i,
            items       TYPE tty_sub_item,
          END OF ty_group.
    TYPES: tty_group TYPE STANDARD TABLE OF ty_group.

    DATA: lt_data TYPE STANDARD TABLE OF ty_data,
          ls_data TYPE ty_data.
    DATA: lt_group TYPE STANDARD TABLE OF ty_group,
          ls_group TYPE ty_group.

    DATA: lv_count TYPE i.
    DATA lt_keys TYPE lvc_t_fnam.
    DATA lr_data TYPE REF TO data.
    FIELD-SYMBOLS <fs_group> TYPE tty_group.

    lt_keys = VALUE #( ( 'GROUP' ) ).

    init_data( CHANGING ct_data = lt_data ).

    zcl_common=>split_group( EXPORTING  iv_size        = 10
                                        iv_keep_order  = abap_true
                                        it_keys        = lt_keys
                             CHANGING   ct_data        = lt_data
                                        cr_data        = lr_data
                             EXCEPTIONS keys_not_found = 1 ).
    cl_abap_unit_assert=>assert_equals( act   = sy-subrc
                                        exp   = 0
                                        level = 0 ).
    ASSIGN lr_data->* TO <fs_group>.
    LOOP AT <fs_group> INTO ls_group.
      IF sy-tabix = 1.
        cl_abap_unit_assert=>assert_equals( act   = ls_group-items[ 1 ]-group
                                            exp   = 1
                                            level = 0 ).
      ENDIF.
      lv_count += ls_group-group_count.
    ENDLOOP.
    cl_abap_unit_assert=>assert_equals( act   = lv_count
                                        exp   = 100
                                        level = 0 ).

  ENDMETHOD.

  METHOD test_simple_sort_with_key.
    TYPES: BEGIN OF ty_data,
             id    TYPE i,
             group TYPE i,
             value TYPE i,
           END OF ty_data.
    TYPES: tty_ref TYPE STANDARD TABLE OF REF TO ty_data WITH DEFAULT KEY.
    TYPES:BEGIN OF ty_group,
            group_id    TYPE i,
            group_count TYPE i,
            items       TYPE tty_ref,
          END OF ty_group.
    TYPES: tty_group TYPE STANDARD TABLE OF ty_group.

    DATA: lt_data TYPE SORTED TABLE OF ty_data WITH NON-UNIQUE KEY group,
          ls_data TYPE ty_data.
    DATA: lt_group TYPE STANDARD TABLE OF ty_group,
          ls_group TYPE ty_group.

    DATA: lv_count TYPE i.
    DATA lt_keys TYPE lvc_t_fnam.
    DATA lr_data TYPE REF TO data.
    FIELD-SYMBOLS <fs_group> TYPE tty_group.

    init_data( CHANGING ct_data = lt_data ).

    zcl_common=>split_group_simple( EXPORTING  iv_size        = 10
                                               iv_keep_order  = abap_false
                                    CHANGING   ct_data        = lt_data
                                               cr_data        = lr_data
                                    EXCEPTIONS keys_not_found = 1 ).
    cl_abap_unit_assert=>assert_equals( act   = sy-subrc
                                        exp   = 0
                                        level = 0 ).
    ASSIGN lr_data->* TO <fs_group>.
    lv_count = REDUCE #( INIT i = 0 FOR wa_group IN <fs_group> NEXT i += wa_group-group_count ).
    cl_abap_unit_assert=>assert_equals( act   = lv_count
                                        exp   = 100
                                        level = 0 ).

  ENDMETHOD.

  METHOD init_data.
    DATA ls_data TYPE ty_data.
    DATA(lo_random) = cl_abap_random_int=>create( min = 1 max = 20 ).
    DATA(lo_random1) = cl_abap_random_int=>create( min = 1 max = 100 ).
    DO 100 TIMES.
      ls_data = VALUE #( id = sy-index
      group = lo_random->get_next( )
      value = lo_random1->get_next( ) ).
      INSERT ls_data INTO TABLE ct_data.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
