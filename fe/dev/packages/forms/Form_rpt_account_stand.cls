VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_rpt_account_stand"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Compare Database

Private Sub btn_close_Click()
    Call frm_xapi.cls_frm(Me.name, False)
End Sub

Private Sub Form_Load()
    Me.fld_year.Value = prd_api.get_cur_year()
End Sub
