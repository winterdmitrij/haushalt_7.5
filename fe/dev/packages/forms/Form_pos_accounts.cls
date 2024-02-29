VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_pos_accounts"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'             Formular Konto hinzuf�gen
'==========================================================
Option Compare Database


'**********************************************************
'*                 Schaltfl�che
'**********************************************************
' btn_close
Private Sub btn_close_Click()
    Call pos_xapi.cls_posFrm(Me.name)
End Sub


' btn_add_pos
Private Sub btn_add_acc_Click()
    
    Call pos_xapi.cre_accPos(Me.name, Me.fld_adId.Value)

'    ' Position in Dokument hinzuf�gen
'    Call tapi_positions.add_accPos(Me.fld_kdId.Value)
'
'    ' Die Form schlie�en
'    Call frm_xapi.cls_frm(Me.name)
'
'    ' Akt. Dokument �ffnen
'    Call frm_xapi.opn_frm(doc_api.get_cur_docFrm, _
'                            "dkmid = '" & doc_api.get_cur_docId & "'")
End Sub

'==========================================================
' Zweck: Position in einen Dokument hinzuf�gen (+!)
'==========================================================
Private Sub btnAddPos_Click()
    ' Konten-Id aus dem Form ermitteln
    Dim accDtlId As String
    Let accDtlId = Me.fldKntDtlId.Value

    ' Position in Dokument hinzuf�gen
    Call mdlTra.addAccPos(mdlDocMng.getCurDocId(), accDtlId)

    ' Schli�en den Formular und �ffnen das aktuelle GV-Dokument
    Call mdlFrmMng.clsFrmAddAcc
End Sub
