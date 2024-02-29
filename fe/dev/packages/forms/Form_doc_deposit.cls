VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_doc_deposit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'             Formular Transaktionen
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
        ' Nur "Stornieren" enabled
        Me.btn_cancel.Enabled = True
        Me.btn_add.Enabled = False
        Me.btn_release.Enabled = False
        Me.btn_delete.Enabled = False
        Me.fld_posAmt.Enabled = False
        Me.fld_posCmt.Enabled = False
    Else
        ' Nur "Stornieren" disabled
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
    Call frm_xapi.cls_frm(Me.name, True)
End Sub


'**********************************************************
'*            Positionen
'**********************************************************
' btn_add
Private Sub btn_add_Click()
    Call pos_xapi.opn_posFrm_byDoc(Me.fld_cur_docId.Value, "")
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


''================= Schaltflächen-Erreignisse ==============
''==========================================================
'' Zweck: Navigation zum Start-Formular
''==========================================================
'Private Sub btnHome_Click()
'    ' Formular schließen mit Speichern
'    Call mdlFrmMng.clsFrm(Me.name, True)
''    ' Start-Formular öffnen
''    DoCmd.OpenForm "frm_Start"
'End Sub
'
'
''==========================================================
''==========================================================
'' Zweck: Manipulationen mit Position
''==========================================================
'' Position hinzufügen (+)
'' ToDo: Tabelle tabMntGvk(datum, kg, kd, btg, adJarBeg)
''----------------------------------------------------------
'Private Sub btnAdd_Click()
'    ' Dokument-Id ermitteln
'    Dim docId As String
'    Let docId = Me.fldDkmId.Value
'
'    ' Dokument-Id als aktuelles setzen
'    Call mdlDocMng.setCurDocId(docId)
'
'    ' Form schließen mit speicherung
'    Call mdlFrmMng.clsFrm(Me.name)
'
'    ' Öffnen der Form: "frmAddAcc"
'    Call mdlFrmMng.opnFrmAddAcc(docId) 'opnFrmAddPos(docId, "trsAktId = 'gn'")
'End Sub
'
''----------------------------------------------------------
'' Position löschen (-)
''----------------------------------------------------------
'Private Sub btnDel_Click()
'    ' Position löschen
'    Call mdlPosMng.delPosFrmDoc(Nz(Me.fldPosId.Value, ""))
'    ' Refresch
'    Me.Requery
'End Sub
'
'
''==========================================================
''==========================================================
'' Zweck: Manipulationen mit Dokument
''==========================================================
'' Dokument freigeben
''----------------------------------------------------------
'Private Sub btnFreigeben_Click()
'    ' Dokument freigeben
'    Call mdlTra.rlsTra(Me.fldDkmId.Value)
'    ' Form neu laden
'    Call Form_Load
'End Sub
'
''----------------------------------------------------------
'' Dokument stornieren
''----------------------------------------------------------
'Private Sub btnStornieren_Click()
'    ' Dokument stornieren
'    Call mdlDocMng.cncDoc(Me.fldDkmId.Value)
'    ' Form neu laden
'    Call Form_Load
'End Sub

