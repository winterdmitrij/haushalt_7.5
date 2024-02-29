VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_cat_transactions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'                  Katalog "Transaktionen"
'==========================================================
Option Compare Database

'**********************************************************
'*                 Schaltflächen
'**********************************************************
' btn_close
Private Sub btn_close_Click()
    Call frm_xapi.cls_frm(Me.name, False)
End Sub

' btn_detail
Private Sub btn_detail_Click()
    ' Aktuelle Transaktion setzen
    Call cat_api.set_cur_taid(Me.fld_id)
    
    ' Formular Postgruppen öffnen
    Call frm_xapi.opn_frm(env.gt_cat_pg)
End Sub
