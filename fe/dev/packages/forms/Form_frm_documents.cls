VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_frm_documents"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'========================================================================================
'=                 Formular Dokumente
'========================================================================================
Option Compare Database


' ToDo:
'    - View automatisch �ffnen (vllt. in Tabelle inf_documents hinzuf�gen)
'**********************************************************
'*            Formular
'**********************************************************
' Form laden
Private Sub Form_Load()
    Me.cmb_cur_prd.Value = prd_api.get_cur_prd()
End Sub

' Zeitraum ge�ndert
Private Sub cmb_cur_prd_AfterUpdate()
    Call prd_api.set_cur_prd(Me.cmb_cur_prd.Value)
    Me.Requery
End Sub

' Form schlie�en
Private Sub btn_close_Click()
    Call frm_xapi.cls_frm(Me.name, False)
End Sub


'************************************* T A S T E N **************************************
'****************************************************************************************
'*       Dokumente erstellen
'* Version: 7,5
'****************************************************************************************
Private Sub btn_createDocs_Click()
    ' Aktuelles Zeitraum ablesen
    Dim l_curPrd As Integer
    Let l_curPrd = Me.cmb_cur_prd.Value
    
    ' Dokumente erstellen
    Call doc_xapi.create_docs(l_curPrd)
    
    Me.Requery
End Sub

'****************************************************************************************
'*       Schlie�en
'****************************************************************************************
Private Sub btn_close_Click()
    Call frm_xapi.cls_frm(Me.name, False)
End Sub


'**** Sp�ter �ndern
' Sparkasse Sk Spk
Private Sub btn_sparkasse_Click()
    Call doc_xapi.opn_docFrm_byType(pin_docType:="Spk", _
                                    pin_prd:=Me.cmb_cur_prd.Value)
End Sub

' Ausgaben Ex Exp
Private Sub btn_expenditures_Click()
    Call doc_xapi.opn_docFrm_byType(pin_docType:="Exp", _
                                    pin_prd:=Me.cmb_cur_prd.Value)
End Sub

' Einkommen Ic Inc
Private Sub btn_incomes_Click()
    Call doc_xapi.opn_docFrm_byType(pin_docType:="Inc", _
                                    pin_prd:=Me.cmb_cur_prd.Value)
End Sub

' Einlagen Dp Dps
Private Sub btn_deposits_Click()
    Call doc_xapi.opn_docFrm_byType(pin_docType:="Dps", _
                                    pin_prd:=Me.cmb_cur_prd.Value)
End Sub

' Verm�gens-Form �ffnen
Private Sub btn_assets_Click()
    ' ToDo: Verm�gens-Form �ffnen
End Sub


'**********************************************************
'*            Bericht-Schaltfl�chen
'**********************************************************
' Taste Rls/Cnc (+/-)
Private Sub btn_rls_cnc_Click()
    If Me.fld_rls = "ja" Then
        Call grb_xapi.cnc_doc(Me.fld_docId.Value)
    Else
        Call grb_xapi.rls_doc(Me.fld_docId.Value)
    End If
    Me.Requery
End Sub

' Release-View
Private Sub btn_rls_Click()
    ' Dokument als aktuell setzen
    Call doc_api.set_cur_docId(Me.fld_docId.Value)
    
    ' View �ffnen
    'DoCmd.OpenView (doc_api.get_cur_rlsView())
    DoCmd.OpenQuery (doc_api.get_cur_rlsView())
    Debug.Print doc_api.get_cur_rlsView()
End Sub
