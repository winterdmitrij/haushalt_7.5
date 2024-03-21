VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_cat_posts"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'========================================================================================
'=                 Katalog "Posten" - Formular
'= Version: 7.
'========================================================================================
Option Compare Database
Private Const c_titel As String = "Post"


'*********************************** F O R M U L A R ************************************
'*******************************************|********************************************
'*       Formular laden
'* Version: 7.
'****************************************************************************************
Private Sub Form_Load()
    ' Listenfeld Transaktion
    Me!cmb_cur_taid = cat_bapi.get_cur_taId()
        
    ' Neue Liste für Postgruppe-Listenfeld erhalten
    Me!cmb_cur_pgid.Requery
    ' Aktuelle Postengruppe auswählen
    Me!cmb_cur_pgid = cat_bapi.get_cur_pgId()
    
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
'*       Transaktion wechseln
'* Version: 7.6
'****************************************************************************************
Private Sub cmb_cur_taid_AfterUpdate()
    ' Aktuelle Transaktion setzen
    Call cat_bapi.set_cur_taId(Me!cmb_cur_taid.Value)
    
    ' Postgruppe-Listenfeld aktualisieren und erstes Element auswählen
    Me!cmb_cur_pgid.Requery
    Me!cmb_cur_pgid = Me!cmb_cur_pgid.ItemData(0)
    
    Me.Requery
End Sub

'****************************************************************************************
'*       Postgruppe wechseln
'* Version: 7.6
'****************************************************************************************
Private Sub cmb_cur_pgid_AfterUpdate()
    Call cat_bapi.set_cur_pgId(Me!cmb_cur_pgid.Value)
    Me.Requery
End Sub

'****************************************************************************************
'*       Formular schließen
'* Version: 7.6
'****************************************************************************************
Private Sub btn_close_Click()
    Call cat_bapi.set_cur_pgId(0)
    Call cat_bapi.set_cur_taId(0)
    
    Call frm_api.close_form(Me.name, False)
End Sub


'************************** D A T E N M A N I P U L A T I O N ***************************
'*******************************************|********************************************
'*       Post hinzufügen
'* Version: 7.6
'****************************************************************************************
Private Sub btn_add_Click()
    ' Neue Post-Bezeichnung erhalten
    Dim new_pdDsg As String
    Let new_pdDsg = cat_bapi.open_addDialog(c_titel)

    ' Aktuelle Postgruppe ermitteln
    Dim cur_pgId As Integer
    Let cur_pgId = Me.cmb_cur_pgid.Value

    ' Post speichern
    MsgBox catpst_bapi.create_pstDtl(new_pdDsg, cur_pgId), vbOKOnly, c_titel
    Me.Requery
End Sub

'****************************************************************************************
'*       Post löschen
'* Version: 7.6
'****************************************************************************************
Private Sub btn_delete_Click()
    ' Gelöschten Post ermitteln
    Dim cur_pdId As Integer
    Let cur_pdId = Me!fld_id.Value

    ' Post löschen
    MsgBox catpst_bapi.delete_pstDtl(cur_pdId), , c_titel
    Me.Requery
End Sub

