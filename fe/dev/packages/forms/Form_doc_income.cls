VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_doc_income"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'             Formular Einkommen
'==========================================================
Option Compare Database

' ToDo:
'    - form_requerry erstellen
'    - btn_close:  - bild ändern, zB <-


'**********************************************************
'*                 Formular
'**********************************************************
' Form laden
Private Sub Form_Load()
    If Me.chk_docRls.Value Then
        Me.btn_add.Enabled = False
        Me.btn_release.Enabled = False
        Me.btn_delete.Enabled = False
        Me.btn_cancel.Enabled = True
        Me.fld_posAmt.Enabled = False
        Me.fld_posCmt.Enabled = False
    Else
        Me.btn_add.Enabled = True
        Me.btn_release.Enabled = True
        Me.btn_cancel.Enabled = False
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
    Call frm_xapi.cls_frm(Me.name, True)
End Sub


'**********************************************************
'*            Positionen
'**********************************************************
' btn_add
Private Sub btn_add_Click()
    Call pos_xapi.opn_posFrm_byDoc(Me.fld_cur_docId.Value, _
                                  "pd_csh = true AND ta_dsg = '" & env.gc_taDsc_inc & "'")
End Sub

' btn_delete
Private Sub btn_delete_Click()
    ' Position löschen
    Call pos_xapi.delete_pos(Nz(Me.fld_posid.Value, ""))

    ' Refresch
    Me.Requery
End Sub


'**********************************************************
'*            Dokument
'**********************************************************
'btn_release
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
