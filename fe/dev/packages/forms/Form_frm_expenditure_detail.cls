VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_frm_expenditure_detail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'                  Formular "Detailierte Ausgaben"
'==========================================================
Option Compare Database


' btn_close
Private Sub btn_close_Click()
    Call frm_xapi.cls_frm(Me.name)
    
    ' Akt. Dokument öffnen
    Call doc_xapi.opn_docFrm_byId(pos_api.get_cur_docId)
End Sub

Private Sub btn_calculate_Click()
    ' Detailierten Betrag auslesen
    Dim l_amt_dtl As String
    Let l_amt_dtl = Nz(Trim(Me.fld_amtDtl.Value), "")
    
    If Len(l_amt_dtl) = 0 Then
        Exit Sub
    End If
    
    ' Betrag berechnen und den Feld füllen
    Me.fld_posAmt.Value = pos_pckg.get_sum_amt(l_amt_dtl)
End Sub


