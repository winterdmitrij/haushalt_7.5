VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_frm_start"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'========================================================================================
'=                 Start-Formular
'= Version: 7.5
'========================================================================================
Option Compare Database


'*********************************** F O R M U L A R ************************************
'*******************************************|********************************************
'*       Formular laden
'* Version: 7.5
'****************************************************************************************
Private Sub Form_Load()
    Me.cmb_period.Value = curprd_api.get_curPrd()
    
    Call frm_requery
End Sub

'****************************************************************************************
'*       Formular-Variablen aktualisieren
'****************************************************************************************
Private Sub frm_requery()
    Me.Requery
    
    ' Gesamtergebnisse berechnen
    ' ToDo: balRow-Datentype und in curbal_api
    Me.fldSumBeg.Value = DSum("beg", env.gv_rpt_bal, "prd = " & get_curPrd())
    Me.fldSumEkm.Value = DSum("inc", env.gv_rpt_bal, "prd = " & get_curPrd())
    Me.fldSumAgb.Value = DSum("exp", env.gv_rpt_bal, "prd = " & get_curPrd())
    Me.fldSumGvk.Value = DSum("tra", env.gv_rpt_bal, "prd = " & get_curPrd())
    Me.fldSumSld.Value = DSum("sld", env.gv_rpt_bal, "prd = " & get_curPrd())
    Me.fldSumEnd.Value = DSum("end", env.gv_rpt_bal, "prd = " & get_curPrd())
    ' Feld Brieftasche + AEGU
    Me.fldSumAeg.Value = DSum("end", env.gv_rpt_bal, "ag_dsg = 'AEGU' AND prd = " & get_curPrd())
    Me.fld_sumBar.Value = DSum("end", env.gv_rpt_bal, "(ag_dsg = 'AEGU' OR ad_dsg = 'Brieftasche') AND prd = " & get_curPrd())
End Sub


'******************************** K O P F B E R E I C H *********************************
'*******************************************|********************************************
'*       Zeitraum geändert
'* Version: 7.5
'****************************************************************************************
Private Sub cmb_period_AfterUpdate()
    ' Neues Zeitraum als aktuell setzen
    Call curprd_api.set_curPrd(Me.cmb_period.Value)
    
    ' Formular-Variablen aktualisieren
    Call frm_requery
End Sub

'****************************************************************************************
'*       Dokumenten-Formular öffnen
'* Version: 7.5
'****************************************************************************************
Private Sub btn_documents_Click()
    ' Zeitraum als aktuell setzen
    Call curprd_api.set_curPrd(Me.cmb_period.Value)
    
    ' Dokumenten-Formular öffnen
    Call frm_api.open_form(env.gf_frm_doc)
End Sub

'****************************************************************************************
'*       Berichts-Formular öffnen
'* Version: 7.5
'****************************************************************************************
Private Sub btn_reports_Click()
    ' Zeitraum als aktuell setzen
    Call curprd_api.set_curPrd(Me.cmb_period.Value)
    
    ' Berichts-Formular öffnen
    Call frm_api.open_form(env.gf_frm_rpt)
End Sub

'****************************************************************************************
'*       Katalogs-Formular öffnen
'* Version: 7.5
'****************************************************************************************
Private Sub btn_catalogs_Click()
    ' Katalogs-Formular öffnen
    Call frm_api.open_form(env.gf_frm_cat)
End Sub

'****************************************************************************************
'*       Einstellung-Formular öffnen
'* Version: 7.5
'****************************************************************************************
Private Sub btn_settings_Click()
    ' Einstellung-Formular öffnen
    Call frm_api.open_form(env.gf_frm_set)
End Sub

'****************************************************************************************
'*       Bilanz-Tabelle aktualisieren
'* Version: 7.5
'****************************************************************************************
Private Sub btn_update_Click()
    ' Zeitraum als aktuell setzen
    Call curprd_api.set_curPrd(Me.cmb_period.Value)
    
    ' Bilanz für das aktuelle Zeitraum aktualisieren
    Call bal_xapi.recalc_bal(Me.cmb_period.Value)

    ' Formular-Variablen aktualisieren
    Call frm_requery
End Sub



'***************************** B E R I C H T B E R E I C H ******************************
'*******************************************|********************************************
'*       Bericht-Formular öffnen
'* Version: 7.5
'****************************************************************************************
Private Sub opn_rpt(pin_taDsc As String, pin_adDsc As String)
    ' Zeitraum als aktuell setzen
    Call curprd_api.set_curPrd(Me.cmb_period.Value)

    ' Form öffnen
    Call frm_api.open_form(env.gt_rpt_acc, _
                          "ta_dsg = '" & pin_taDsc & "' AND " & _
                          "ad_dsg = '" & pin_adDsc & "' AND " & _
                          "prd = '" & Me.cmb_period.Value & "'")
End Sub

'****************************************************************************************
'*       Einkommen-Bericht-Formular öffnen
'* Version: 7.5
'****************************************************************************************
Private Sub btn_inc_Click()
    If Me.fld_inc = 0 Then
        Exit Sub
    End If
    Call opn_rpt(env.gc_taDsc_inc, Me.fld_adDsg.Value)
End Sub

'****************************************************************************************
'*       Ausgaben-Bericht-Formular öffnen
'* Version: 7.5
'****************************************************************************************
Private Sub btn_exp_Click()
    If Me.fld_exp = 0 Then
        Exit Sub
    End If
    Call opn_rpt(env.gc_taDsc_exp, Me.fld_adDsg.Value)
End Sub

'****************************************************************************************
'*       Transaktionen-Bericht-Formular öffnen
'* Version: 7.5
'****************************************************************************************
Private Sub btn_tra_Click()
    If Me.fld_tra = 0 Then
        Exit Sub
    End If
    Call opn_rpt(env.gc_taDsc_tra, Me.fld_adDsg.Value)
End Sub
