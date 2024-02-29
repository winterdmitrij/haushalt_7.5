Attribute VB_Name = "env"
'==========================================================
'                  Enviroments-Konstanten
'==========================================================
Option Compare Database
' Agenda
' g - Global
' -c - Constante
' -t - Table
' -v - View
' -f - Form


'**********************************************************
'*            Konstanten
'**********************************************************
' Arten von Transaktionen
Public Const gc_taDsc_inc As String = "Einkommen"       ' incomes      = Einkommen
Public Const gc_taDsc_exp As String = "Ausgaben"        ' expenditures = Ausgaben
Public Const gc_taDsc_tra As String = "Überweisungen"   ' transfers    = Überweisungen


' Posten, die oft gebraucht sind
Public Const gc_pstDsc_trf As String = "Überweisungen"  ' Transfer(trf)
Public Const gc_pstDsc_dps As String = "Monatseinlagen" ' Deposits(dps)


' Konten, die oft gebraucht sind
Public Const gc_accDsc_cash As String = "Brieftasche"   ' Cash
Public Const gc_accDsc_safe As String = "Tresor"        ' Safe
Public Const gc_accDsc_rsrv As String = "Reserven"      ' Reserve


'**********************************************************
'*            Tabellennamen und Ansichten
'**********************************************************
' Kataloge
Public Const gt_cat_prd As String = "cat_periods"
Public Const gt_cat_ta As String = "cat_transactions"
Public Const gt_cat_pg As String = "cat_postgroups"
Public Const gt_cat_pd As String = "cat_posts"
Public Const gt_cat_ag As String = "cat_accountgroups"
Public Const gt_cat_ad As String = "cat_accounts"

Public Const gv_cat_pst As String = "cat_posts_v"
Public Const gv_cat_acc As String = "cat_accounts_v"

' Infotabellen
Public Const gt_infCat As String = "inf_catalogs"
Public Const gt_infDoc As String = "inf_documents"

' Haupttabelle
Public Const gt_grb As String = "grb_operations"
Public Const gv_grb As String = "grb_operations_v"

' Berichtstabelle
Public Const gt_rpt_bal As String = "rpt_balance"
Public Const gv_rpt_bal As String = "rpt_balance_v"
Public Const gt_rpt_acc As String = "rpt_accountdetail"     ' vllt. soll Tabelle rpt_account heißen


'**********************************************************
'*            Formennamen
'**********************************************************
' Hauptmenü-Elemente
Public Const gf_frm_doc As String = "frm_documents"
Public Const gf_frm_rpt As String = "frm_reports"
Public Const gf_frm_cat As String = "frm_catalogs"
Public Const gf_frm_set As String = "frm_settings"

' Ausgaben-Detail
Public Const gf_frm_expDtl As String = "frm_expenditure_detail"

' Berichten
Public Const gf_rpt_bal As String = "rpt_account_stand"
