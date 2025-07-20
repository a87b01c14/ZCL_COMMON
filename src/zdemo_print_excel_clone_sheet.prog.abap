*&---------------------------------------------------------------------*
*& Report ZTEST_PRINT_EXCEL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdemo_print_excel_clone_sheet.
TYPES: BEGIN OF ty_item,
         xh            TYPE i,
         dispatch_no   TYPE char10,
         dispatch_date TYPE d,
         aufnr         TYPE aufnr,
         zzxtno        TYPE char10,
         psmng         TYPE menge_d,
         dz            TYPE menge_d,
         zz            TYPE menge_d,
         matnr         TYPE matnr,
         maktx         TYPE maktx,
         psmng1        TYPE menge_d,
         bdmng         TYPE menge_d,
       END OF ty_item.
TYPES: BEGIN OF ty_item1,
         xh1    TYPE i,
         idnrk  TYPE idnrk,
         maktx1 TYPE maktx,
         bdmng1 TYPE menge_d,
         meins  TYPE meins,
       END OF ty_item1.
TYPES: tt_item TYPE STANDARD TABLE OF ty_item WITH DEFAULT KEY.
TYPES: tt_item1 TYPE STANDARD TABLE OF ty_item1 WITH DEFAULT KEY.
TYPES: BEGIN OF ty_print_sheet,
         ernam TYPE ernam,
         item  TYPE tt_item,
         item1 TYPE tt_item1,
       END OF ty_print_sheet.
DATA: gs_print_sheet1 TYPE ty_print_sheet.
DATA: gs_print_sheet2 TYPE ty_print_sheet.
DATA: gs_print_sheet3 TYPE ty_print_sheet.
DATA: gt_template TYPE zcl_excel_template_data=>tt_template_data_sheets.

START-OF-SELECTION.
  gs_print_sheet1 = VALUE #( ernam = sy-uname
                             item = VALUE #( ( xh  = 1
                                        dispatch_no = '1000000000'
                                        dispatch_date = sy-datum
                                        aufnr = '001000000000'
                                        zzxtno = 'ABC'
                                        psmng  = 1
                                        dz  = '0.1'
                                        zz  = '10'
                                        matnr = 'MAT001'
                                        maktx = '测试物料1'
                                        psmng1 = '100'
                                        bdmng = '200'      )
                                      ( xh  = 2
                                        dispatch_no = '1000000001'
                                        dispatch_date = sy-datum
                                        aufnr = '001000000000'
                                        zzxtno = 'ABC'
                                        psmng  = 1
                                        dz  = '0.1'
                                        zz  = '10'
                                        matnr = 'MAT002'
                                        maktx = '测试物料2'
                                        psmng1 = '100'
                                        bdmng = '200'      )
                                      ( xh  = 3
                                        dispatch_no = '1000000002'
                                        dispatch_date = sy-datum
                                        aufnr = '001000000000'
                                        zzxtno = 'ABC'
                                        psmng  = 1
                                        dz  = '0.1'
                                        zz  = '10'
                                        matnr = 'MAT003'
                                        maktx = '测试物料3'
                                        psmng1 = '100'
                                        bdmng = '200'      ) )
                             item1 = VALUE #( ( xh1 = 1
                                        idnrk = 'MAT00101'
                                        maktx1 = '子件1'
                                        bdmng1 = '10'
                                        meins = 'PCS'
                                        )
                                        ( xh1 = 2
                                        idnrk = 'MAT00102'
                                        maktx1 = '子件2'
                                        bdmng1 = '20'
                                        meins = 'PCS'
                                        )
                                        ( xh1 = 3
                                        idnrk = 'MAT00103'
                                        maktx1 = '子件3'
                                        bdmng1 = '30'
                                        meins = 'PCS'
                                        ) ) ).

  APPEND VALUE #( sheet = 'Sheet1' rename = '001000000000' data = REF #( gs_print_sheet1 ) ) TO gt_template.

  gs_print_sheet2 = VALUE #( ernam = 'COPY'
                             item = VALUE #( ( xh  = 1
                                        dispatch_no = '2000000000'
                                        dispatch_date = sy-datum
                                        aufnr = '002000000000'
                                        zzxtno = 'ABC'
                                        psmng  = 1
                                        dz  = '0.1'
                                        zz  = '10'
                                        matnr = 'MAT001'
                                        maktx = '测试物料1'
                                        psmng1 = '100'
                                        bdmng = '200'      )
                                      ( xh  = 2
                                        dispatch_no = '2000000001'
                                        dispatch_date = sy-datum
                                        aufnr = '002000000000'
                                        zzxtno = 'ABC'
                                        psmng  = 1
                                        dz  = '0.1'
                                        zz  = '10'
                                        matnr = 'MAT002'
                                        maktx = '测试物料2'
                                        psmng1 = '100'
                                        bdmng = '200'      ) )
                             item1 = VALUE #( ( xh1 = 1
                                        idnrk = 'MAT00101'
                                        maktx1 = '子件1'
                                        bdmng1 = '10'
                                        meins = 'PCS'
                                        )
                                        ( xh1 = 2
                                        idnrk = 'MAT00102'
                                        maktx1 = '子件2'
                                        bdmng1 = '20'
                                        meins = 'PCS'
                                        )
                                        ( xh1 = 3
                                        idnrk = 'MAT00103'
                                        maktx1 = '子件3'
                                        bdmng1 = '30'
                                        meins = 'PCS'
                                        ) ) ).
  APPEND VALUE #( sheet = 'Sheet1' clone = abap_true rename = '002000000000' data = REF #( gs_print_sheet2 ) ) TO gt_template.

  gs_print_sheet3 = VALUE #( ernam = 'COPY'
                             item = VALUE #( ( xh  = 1
                                        dispatch_no = '3000000000'
                                        dispatch_date = sy-datum
                                        aufnr = '003000000000'
                                        zzxtno = 'ABC'
                                        psmng  = 1
                                        dz  = '0.1'
                                        zz  = '10'
                                        matnr = 'MAT001'
                                        maktx = '测试物料1'
                                        psmng1 = '100'
                                        bdmng = '200'      )
                                      ( xh  = 2
                                        dispatch_no = '3000000001'
                                        dispatch_date = sy-datum
                                        aufnr = '003000000000'
                                        zzxtno = 'ABC'
                                        psmng  = 1
                                        dz  = '0.1'
                                        zz  = '10'
                                        matnr = 'MAT002'
                                        maktx = '测试物料2'
                                        psmng1 = '100'
                                        bdmng = '200'      ) )
                             item1 = VALUE #( ( xh1 = 1
                                        idnrk = 'MAT00101'
                                        maktx1 = '子件1'
                                        bdmng1 = '10'
                                        meins = 'PCS'
                                        )
                                        ( xh1 = 2
                                        idnrk = 'MAT00102'
                                        maktx1 = '子件2'
                                        bdmng1 = '20'
                                        meins = 'PCS'
                                        )
                                        ( xh1 = 3
                                        idnrk = 'MAT00103'
                                        maktx1 = '子件3'
                                        bdmng1 = '30'
                                        meins = 'PCS'
                                        ) ) ).
  APPEND VALUE #( sheet = 'Sheet1' clone = abap_true rename = '003000000000' data = REF #( gs_print_sheet3 ) ) TO gt_template.
  zcl_common=>print_excel( iv_w3objid = 'ZDEMO_PRINT_EXCEL' it_data = gt_template  iv_xlsm = abap_true iv_autoprint = abap_false iv_autosave = abap_true  ).
