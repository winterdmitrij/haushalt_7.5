VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_doc_expenditure"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'             Formular Ausgaben
'==========================================================
Option Compare Database

' ToDo:
'    - Formularname ändern: doc_expenditure
'    - form_requerry erstellen
'    - btn_change löschen
'    - btn_close:  - bild ändern
'    - btn_detail: - bild ändern
'                  - deaktvieren bei Freigabe
'    - Postspalte: - Breite anpassen


'**********************************************************
'*                 Formular
'**********************************************************
' Form laden
Private Sub Form_Load()
    If Me.chk_rls.Value Then
        Me.btn_cancel.Enabled = True
        Me.btn_add.Enabled = False
        Me.btn_release.Enabled = False
        Me.btn_delete.Enabled = False
        Me.fld_posAmt.Enabled = False
        Me.fld_posCmt.Enabled = False
    Else
        Me.btn_cancel.Enabled = False
        Me.btn_add.Enabled = True
        Me.btn_release.Enabled = True
        Me.btn_delete.Enabled = True
        Me.fld_posAmt.Enabled = True
        Me.fld_posCmt.Enabled = True
    End If
End Sub


'**********************************************************
'*            Navigation
'**********************************************************
' btn_close
Private Sub btn_close_Click()
    Call doc_xapi.cls_docFrm(Me.name)
End Sub



'**********************************************************
'*            Positionen
'**********************************************************
' btn_add
Private Sub btn_add_Click()
    Call pos_xapi.opn_posFrm_byDoc(Me.fld_cur_docId.Value, "pd_csh = true AND ta_dsg = '" & env.gc_taDsc_exp & "'")
End Sub

' btn_delete
Private Sub btn_delete_Click()
    ' Position löschen
    Call pos_xapi.delete_pos(Nz(Me.fld_posid.Value, ""))

    ' Refresch
    Me.Requery
End Sub

' btn_detail
Private Sub btn_detail_Click()
    If Nz(Me.fld_posid.Value, "") <> "" Then
        ' Detail-Form öffnen
        Call pos_xapi.opn_dtlFrm_Exp(Me.fld_posid.Value)
              
        
'        ' Position-Id ermitteln
'        Dim l_posId As String
'        Let l_posId = Me.fld_posid.Value
'
'        ' Dokument-Id als aktuelles setzen
'        Call doc_api.set_cur_docId(Me.fld_cur_dkmid.Value)
'
'        ' Dokument schließen
'        Call frm_xapi.cls_frm(Me.name, True)
'
'        ' Ausgabe-Positionen
'        Call frm_xapi.opn_frm(env.frm_dtlExt, "posId = '" & l_posId & "'")
    End If
End Sub


'**********************************************************
'*            Dokument
'**********************************************************
' btn_release
Private Sub btn_release_Click()
    ' Dokument freigeben
    Call grb_xapi.rls_doc(Me.fld_cur_docId.Value)
    
    ' Form neu laden
    Me.Requery
    Call Form_Load
End Sub

' btn_cancel
Private Sub btn_cancel_Click()
    ' Dokument stornieren
    Call grb_xapi.cnc_doc(Me.fld_cur_docId.Value)
    
    ' Form neu laden
    Me.Requery
    Call Form_Load
End Sub

