VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_frm_catalogs"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'=                 Formular Kataloge
'==========================================================
Option Compare Database


'**********************************************************
'*            Posten
'**********************************************************
' Transaktionen
Private Sub btn_transactions_Click()
    Call frm_xapi.opn_frm(env.gt_cat_ta)
End Sub

' Postgruppen
Private Sub btn_postgroups_Click()
    Call frm_xapi.opn_frm(env.gt_cat_pg)
End Sub

' Posten
Private Sub btn_posts_Click()
    Call frm_xapi.opn_frm(env.gt_cat_pd)
End Sub


'**********************************************************
'*            Konten
'**********************************************************
' Kontengruppen
Private Sub btn_accountgroups_Click()
    Call frm_xapi.opn_frm(env.gt_cat_ag)
End Sub

' Konten
Private Sub btn_accounts_Click()
    Call frm_xapi.opn_frm(env.gt_cat_ad)
End Sub


'**********************************************************
'*            Infos
'**********************************************************
Private Sub btn_docInf_Click()

End Sub

Private Sub btn_catInf_Click()

End Sub

Private Sub btn_prd_Click()
    Call prd_xapi.cre_prd
End Sub


'**********************************************************
'*            Navigation
'**********************************************************
Private Sub btn_close_Click()
    Call frm_xapi.cls_frm(Me.name)
End Sub
