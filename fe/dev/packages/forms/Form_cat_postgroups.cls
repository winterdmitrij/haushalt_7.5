VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_cat_postgroups"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'========================================================================================
'=                 Katalog "Postgruppen" - Formular
'= Version: 7.
'========================================================================================
Option Compare Database
Private Const c_titel As String = "Postgruppe"


'*********************************** F O R M U L A R ************************************
'*******************************************|********************************************
'*       Formular laden
'* Version: 7.
'****************************************************************************************
Private Sub Form_Load()
    Me!cmb_cur_taid = cat_bapi.get_cur_taId()
    
'    ' Löschfunktion-Deaktivierung im set_userModus
'    If settings_pckg.isDev_mod Then
        Me!btn_delete.Enabled = True
'    Else
'        Me!btn_delete.Enabled = False
'    End If
    
    Me.Requery
End Sub


'********************************* N A V I G A T I O N **********************************
'*******************************************|********************************************
'*       Transaktion wechseln
'* Version: 7.6
'****************************************************************************************
Private Sub cmb_cur_taid_AfterUpdate()
    ' Neue Transaktion als aktuell setzen
    Call cat_bapi.set_cur_taId(Me!cmb_cur_taid.Value)
    Me.Requery
End Sub

'****************************************************************************************
'*       Formular schließen
'* Version: 7.6
'****************************************************************************************
Private Sub btn_close_Click()
    Call cat_bapi.set_cur_taId(0)
    Call frm_api.close_form(Me.name, False)
End Sub

'****************************************************************************************
'*       Formular Post öffnen
'* Version: 7.6
'****************************************************************************************
Private Sub btn_detail_Click()
    ' Aktuelle Postgruppe setzen
    Call cat_bapi.set_cur_pgId(Me!fld_id.Value)
    
    ' Akt. Formular schließen
    Call frm_api.close_form(Me.name, False)
    
    ' Formular Post öffnen
    Call frm_api.open_form(env.gt_cat_pd)
End Sub


'************************** D A T E N M A N I P U L A T I O N ***************************
'*******************************************|********************************************
'*       Postgruppe hinzufügen
'* Version: 7.6
'****************************************************************************************
Private Sub btn_add_Click()
    ' Neue Konte-Bezeichnung erhalten
    Dim l_new_pgDsg As String
    Let l_new_pgDsg = Nz(cat_bapi.open_addDialog(c_titel), "")

    ' Aktuelle Transaktion ermitteln
    Dim l_cur_taId As Integer
    Let l_cur_taId = Me.cmb_cur_taid.Value

    ' Postgruppe speichern
    MsgBox catpst_bapi.create_pstGrp(l_new_pgDsg, l_cur_taId), vbOKOnly, c_titel
    Me.Requery
End Sub

'****************************************************************************************
'*       Postgruppe löschen
'* Version: 7.6
'****************************************************************************************
Private Sub btn_delete_Click()
    ' Gelöschte Postgruppe ermitteln
    Dim cur_pgId As Integer
    Let cur_pgId = Me.fld_id
    
    ' Postgruppe löschen
    MsgBox catpst_bapi.delete_pstGrp(cur_pgId), , c_titel
    Me.Requery
End Sub
