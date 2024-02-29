VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_pos_posts"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'             Formular Position hinzufügen
'==========================================================
Option Compare Database
Private cur_tabez As String

'**********************************************************
'*                 Formular
'**********************************************************
' Form laden
Private Sub Form_Load()
    ' Analyse des aktuellen Dokuments
    Dim docType As String
    Let docType = doc_api.get_cur_docType

    Debug.Print docType
    
    If docType = "Exp" Then
        'Die Taste "Ausgabe" ist angezeigt, aber ist unaktiv
        Call vsbl_btn(False, True, False)
        Call akt_btn(True, True, True)
        
    ElseIf docType = "Inc" Then
        'Die Taste "Einkommen" ist angezeigt, aber ist unaktiv
        Call vsbl_btn(True, False, False)
        Call akt_btn(True, False, False)
        
    ElseIf docType = "Dps" Then
        'Die Taste "Gewinneutral" ist angezeigt, aber ist unaktiv
        Call vsbl_btn(False, False, True)
        Call akt_btn(False, False, True)

    Else
        'Alle drei Tasten sind angezeigt und aktiv
        Call vsbl_btn(True, True, True)
        Call akt_btn(False, False, False)
    End If
End Sub

' Sichtbarkeit der Tasten (ek, ag, ta)
Private Sub vsbl_btn(pin_vsblEkm As Boolean, pin_vsblAgb As Boolean, pin_vsblTra As Boolean)
    Me.btn_agb.Visible = pin_vsblAgb
    Me.btn_ekm.Visible = pin_vsblEkm
    Me.btn_tra.Visible = pin_vsblTra
End Sub

' Aktivierung der Tasten (ek, ag, gv)
Private Sub akt_btn(pin_aktEkm As Boolean, pin_aktAgb As Boolean, pin_aktTra As Boolean)
    Me.btn_agb.Enabled = Not pin_aktAgb
    Me.btn_ekm.Enabled = Not pin_aktEkm
    Me.btn_tra.Enabled = Not pin_aktTra
End Sub


'**********************************************************
'*                 Filter
'**********************************************************
' btn_agb
Private Sub btn_agb_Click()
    Const cur_taDsg As String = "Ausgaben"
    
    Call akt_btn(False, True, False)
    
    ' Formular neu öffnen
    Call pos_xapi.opn_posFrm_byName(Me.name, "pd_trf = True AND ta_dsg = '" & cur_taDsg & "'")
End Sub

' btn_ekm
Private Sub btn_ekm_Click()
    Const cur_taDsg As String = "Einkommen"
    
    Call akt_btn(True, False, False)
    
    ' Formular neu öffnen
    Call pos_xapi.opn_posFrm_byName(Me.name, "pd_trf = True AND ta_dsg = '" & cur_taDsg & "'")
End Sub

' btn_tra
Private Sub btn_tra_Click()
    Const cur_taDsg As String = "Überweisungen"
    
    Call akt_btn(False, False, True)
    
    ' Formular neu öffnen
    Call pos_xapi.opn_posFrm_byName(Me.name, "pd_trf = True AND ta_dsg = '" & cur_taDsg & "'")
End Sub


'**********************************************************
'*                 Schaltfläche
'**********************************************************
' btn_close
Private Sub btn_close_Click()
    Call pos_xapi.cls_posFrm(Me.name)
End Sub

' btn_add_pos
Private Sub btn_add_pos_Click()
    ' ToDo:
     Call pos_xapi.cre_pstPos(Me.name, Me.fld_pdid.Value)
'    ' Position in Dokument hinzufügen
'    Call tapi_positions.add_pstPos(Me.fld_pdid.Value)
'
'    ' Die Form schließen
'    Call frm_xapi.cls_frm(Me.name)
'
'    ' Akt. Dokument öffnen
'    Call frm_xapi.opn_frm(doc_api.get_cur_docFrm, _
'                            "dkmid = '" & doc_api.get_cur_docId & "'")
End Sub
