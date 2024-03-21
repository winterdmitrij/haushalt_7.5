VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_cat_transactions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'========================================================================================
'=                 Katalog "Transaktionen" - Formular
'= Version: 7.6
'========================================================================================
Option Compare Database

'********************************* N A V I G A T I O N **********************************
'*******************************************|********************************************
'*       Formular schließen
'* Version: 7.6
'****************************************************************************************
Private Sub btn_close_Click()
    Call frm_api.close_form(Me.name, False)
End Sub

'****************************************************************************************
'*       Formular "Postgruppe" öffnen
'* Version: 7.6
'****************************************************************************************
Private Sub btn_detail_Click()
    ' Aktuelle Transaktion setzen
    Call cat_bapi.set_cur_taId(Me.fld_id)
    
    ' Akt. Formular schließen
    Call btn_close_Click
    
    ' Formular Postgruppen öffnen
    Call frm_api.open_form(env.gt_cat_pg)
End Sub
