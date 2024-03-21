VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_cat_accounts"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'========================================================================================
'=                 Katalog "Konten" - Formular
'= Version: 7.
'========================================================================================
Option Compare Database
Private Const c_titel As String = "Konto"


'*********************************** F O R M U L A R ************************************
'*******************************************|********************************************
'*       Formular laden
'* Version: 7.
'****************************************************************************************
Private Sub Form_Load()
    Me.cmb_cur_agId = cat_bapi.get_cur_agId()
    
'    ' Löschfunktion-Deaktivierung im set_userModus
'    If is_deplMod Then
        Me!btn_delete.Enabled = True
'    Else
'        Me!btn_delete.Enabled = False
'    End If
    
    Me.Requery
End Sub


'********************************* N A V I G A T I O N **********************************
'*******************************************|********************************************
'*       Kontengruppe wechseln
'* Version: 7.6
'****************************************************************************************
Private Sub cmb_cur_agId_AfterUpdate()
    Call cat_bapi.set_cur_agId(Me.cmb_cur_agId.Value)
    Me.Requery
End Sub

'****************************************************************************************
'*       Formular schließen
'* Version: 7.6
'****************************************************************************************
Private Sub btn_close_Click()
    Call cat_bapi.set_cur_agId(0)
    Call frm_api.close_form(Me.name, False)
End Sub


'************************** D A T E N M A N I P U L A T I O N ***************************
'*******************************************|********************************************
'*       Konto hinzufügen
'* Version: 7.6
'****************************************************************************************
Private Sub btn_add_Click()
    ' Neue Konto-Bezeichnung erhalten
    Dim new_adDsg As String
    Let new_adDsg = cat_bapi.open_addDialog(c_titel)

    ' Aktuelle Kontenruppe ermiteln
    Dim cur_agId As Integer
    Let cur_agId = Me.cmb_cur_agId.Value

    ' Konto speichern
    MsgBox catacc_bapi.create_accDtl(new_adDsg, cur_agId), vbOKOnly, c_titel
    Me.Requery
End Sub

'****************************************************************************************
'*       Konto löschen
'* Version: 7.6
'****************************************************************************************
Private Sub btn_delete_Click()
    ' Gelöschtes Konto ermitteln
    Dim cur_adId As Integer
    Let cur_adId = Me!fld_id.Value

    ' Post löschen
    MsgBox catacc_bapi.delete_accDtl(cur_adId), , c_titel
    Me.Requery
End Sub
