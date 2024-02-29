VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_cat_postgroups"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'=                 Katalog "Postgruppen"
'==========================================================
Option Compare Database
Private Const lc_item As String = "Postgruppe"

'**********************************************************
'*            Form
'**********************************************************
' form_load
Private Sub Form_Load()
    Me!cmb_cur_taid = cat_api.get_cur_taid()
    
'    ' L�schfunktion-Deaktivierung im set_userModus
'    If settings_pckg.isDev_mod Then
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
    Call cat_api.set_cur_taid(Me!cmb_cur_taid.Value)
    Me.Requery
End Sub


' btn_close
Private Sub btn_close_Click()
    ' aktuelle Transaktion leeren
    Call cat_api.set_cur_taid(0)
    
    ' Formular schlie�en
    Call frm_xapi.cls_frm(Me.name, False)
End Sub


' btn_detail
Private Sub btn_detail_Click()
    ' Aktuelle Postgruppe setzen
    Call cat_api.set_cur_pgid(Me!fld_id.Value)
    
    ' Formular Post �ffnen
    Call frm_xapi.opn_frm(env.gt_cat_pd)
End Sub


'**********************************************************
'*            Datensatzmanipulation
'**********************************************************
' btn_add
Private Sub btn_add_Click()
    ' Neue Konte-Bezeichnung erhalten
    Dim new_pgDsg As String
    Let new_pgDsg = cat_api.get_new_item(lc_item)

    ' Aktuelle Transaktion ermiteln
    Dim cur_taId As Integer
    Let cur_taId = Me.cmb_cur_taid.Value

    ' Postgruppe speichern
    MsgBox cat_xapi.create_item(lc_item, new_pgDsg, cur_taId), vbOKOnly, lc_item
    Me.Requery
End Sub

' btn_delete
Private Sub btn_delete_Click()
    ' Gel�schte Postgruppe ermitteln
    Dim cur_pgId As Integer
    Let cur_pgId = Me.fld_id
    
    ' Postgruppe l�schen
    MsgBox cat_xapi.delete_item(lc_item, cur_pgId), , lc_item
    Me.Requery
End Sub