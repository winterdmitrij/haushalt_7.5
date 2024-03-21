VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_cat_accountgroups"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'========================================================================================
'=                 Katalog "Kontengruppen" - Formular
'= Version: 7.
'========================================================================================
Option Compare Database
Private Const c_titel As String = "Kontengruppe"


'*********************************** F O R M U L A R ************************************
'*******************************************|********************************************
'*       Formular laden
'* Version: 7.
'****************************************************************************************
Private Sub Form_Load()
'    ' Löschfunktion-Deaktivierung im set_userModus
'    If is_deplMod Then
        Me!btn_delete.Enabled = True
'    Else
'        Me!btn_delete.Enabled = False
'    End If
End Sub


'********************************* N A V I G A T I O N **********************************
'*******************************************|********************************************
'*       Formular schließen
'* Version: 7.6
'****************************************************************************************
Private Sub btn_close_Click()
    Call frm_api.close_form(Me.name, False)
End Sub

'****************************************************************************************
'*       Formular "Konten" öffnen
'* Version: 7.6
'****************************************************************************************
Private Sub btn_detail_Click()
    ' Aktuelle Kontengruppe setzen
    Call cat_bapi.set_cur_agId(Me.fld_id)
    
    ' Akt. Formular schließen
    Call btn_close_Click
    
    ' Formular Konten öffnen
    Call frm_api.open_form(env.gt_cat_ad)
End Sub


'************************** D A T E N M A N I P U L A T I O N ***************************
'*******************************************|********************************************
'*       Kontengruppe hinzufügen
'* Version: 7.6
'****************************************************************************************
Private Sub btn_add_Click()
    ' Neue Kontengruppe-Bezeichnung erhalten
    Dim new_agDsg As String
    Let new_agDsg = cat_bapi.open_addDialog(c_titel)
   
    ' Kontengruppe speichern
    MsgBox catacc_bapi.create_accGrp(new_agDsg), vbOKOnly, c_titel
    Me.Requery
End Sub

'****************************************************************************************
'*       Kontengruppe löschen
'* Version: 7.6
'****************************************************************************************
Private Sub btn_delete_Click()
    ' Gelöschte Kontengruppe ermitteln
    Dim cur_agId As Integer
    Let cur_agId = Me.fld_id
    
    ' Kontengruppe löschen
    MsgBox catacc_bapi.delete_accGrp(cur_agId), , c_titel
    Me.Requery
End Sub
