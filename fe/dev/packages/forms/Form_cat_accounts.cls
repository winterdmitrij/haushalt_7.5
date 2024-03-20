VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_cat_accounts"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'                  Katalog "Konten"
'==========================================================
Option Compare Database
Private Const lc_item As String = "Konto"

'**********************************************************
'*       Form laden und Kontengruppe wechseln
'**********************************************************
' Form laden
Private Sub Form_Load()
    Me.cmb_cur_agId = cat_api.get_cur_agId()
    
'    ' Löschfunktion-Deaktivierung im set_userModus
'    If is_deplMod Then
        Me!btn_delete.Enabled = True
'    Else
'        Me!btn_delete.Enabled = False
'    End If
    
    Me.Requery
End Sub

' Listenfeld "Kontengruppe" wechseln
Private Sub cmb_cur_agId_AfterUpdate()
    Call cat_api.set_cur_agId(Me.cmb_cur_agId.Value)
    Me.Requery
End Sub


'**********************************************************
'*            Navigation
'**********************************************************
' btn_close
Private Sub btn_close_Click()
    Call frm_api.close_form(Me.name, False)
End Sub


'**********************************************************
'*            Konto
'**********************************************************
' hinzufügen
Private Sub btn_add_Click()
    ' Neue Konto-Bezeichnung erhalten
    Dim new_adDsg As String
    Let new_adDsg = cat_api.get_new_item(lc_item)

    ' Aktuelle Kontenruppe ermiteln
    Dim cur_agId As Integer
    Let cur_agId = Me.cmb_cur_agId.Value

    ' Konto speichern
'    MsgBox cat_xapi.create_item(lc_item, new_adDsg, cur_agId), vbOKOnly, lc_item
    MsgBox catacc_bapi.create_accDtl(new_adDsg, cur_agId), vbOKOnly, lc_item
    Me.Requery
End Sub

' löschen
Private Sub btn_delete_Click()
    ' Gelöschtes Konto ermitteln
    Dim cur_adId As Integer
    Let cur_adId = Me!fld_id.Value

    ' Post löschen
'    MsgBox cat_xapi.delete_item(lc_item, cur_adId), , lc_item
    MsgBox catacc_bapi.delete_accDtl(cur_adId), , lc_item
    Me.Requery
End Sub
