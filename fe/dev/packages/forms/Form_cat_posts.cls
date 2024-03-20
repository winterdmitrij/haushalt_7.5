VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_cat_posts"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'=                 Katalog: "Posten"
'==========================================================
Option Compare Database
Private Const lc_item As String = "Post"

'**********************************************************
'*            Formular
'**********************************************************
' form_load
Private Sub Form_Load()
    ' Listenfeld Transaktion
    Me!cmb_cur_taid = cat_api.get_cur_taid()
        
    ' Neue Liste für Postgruppe-Listenfeld erhalten
    Me!cmb_cur_pgid.Requery
    ' Aktuelle Postengruppe auswählen
    Me!cmb_cur_pgid = cat_api.get_cur_pgid()
    
'    ' Löschfunktion-Deaktivierung im set_userModus
'    If is_deplMod Then
        Me!btn_delete.Enabled = True
'    Else
'        Me!btn_delete.Enabled = False
'    End If

    Me.Requery
End Sub


'**********************************************************
'*            Navigation
'**********************************************************
' Transaktion wechseln
Private Sub cmb_cur_taid_AfterUpdate()
    ' Aktuelle Transaktion setzen
    Call cat_api.set_cur_taid(Me!cmb_cur_taid.Value)
    
    ' Neue Liste für Postgruppe-Listenfeld erhalten
    Me!cmb_cur_pgid.Requery
    ' Ersten Element auswählen
    Me!cmb_cur_pgid = Me!cmb_cur_pgid.ItemData(0)
    
    Me.Requery
End Sub

' Postgruppe wechseln
Private Sub cmb_cur_pgid_AfterUpdate()
    Call cat_api.set_cur_pgid(Me!cmb_cur_pgid.Value)
    Me.Requery
End Sub


' btn_close
Private Sub btn_close_Click()
    ' aktuelle Postgruppe leeren
    Call cat_api.set_cur_pgid(0)
    
    ' Formular schließen
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
    Let new_pdDsg = cat_api.get_new_item(lc_item)

    ' Aktuelle Postgruppe ermitteln
    Dim cur_pgId As Integer
    Let cur_pgId = Me.cmb_cur_pgid.Value

    ' Post speichern
    MsgBox catpst_bapi.create_pstDtl(new_pdDsg, cur_pgId), vbOKOnly, lc_item
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
    MsgBox catpst_bapi.delete_pstDtl(cur_pdId), , lc_item
    Me.Requery
End Sub

