VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_cat_accountgroups"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'                  Katalog "Kontengruppen"
'==========================================================
Option Compare Database
Private Const lc_item As String = "Kontengruppe"

'**********************************************************
'*            Form
'**********************************************************
Private Sub Form_Load()
'    ' L�schfunktion-Deaktivierung im set_userModus
'    If is_deplMod Then
        Me!btn_delete.Enabled = True
'    Else
'        Me!btn_delete.Enabled = False
'    End If
End Sub


'**********************************************************
'*            Navigation
'**********************************************************
' btn_close
Private Sub btn_close_Click()
    Call frm_xapi.cls_frm(Me.name, False)
End Sub

' btn_detail
Private Sub btn_detail_Click()
    ' Aktuelle Kontengruppe setzen
    Call cat_api.set_cur_agId(Me.fld_id)
    
    ' Formular Konten �ffnen
    Call frm_xapi.opn_frm(env.gt_cat_ad)
End Sub


'**********************************************************
'*            Datensatzmanipulation
'**********************************************************
' btn_add
Private Sub btn_add_Click()
    ' Neue Kontengruppe-Bezeichnung erhalten
    Dim new_agDsg As String
    Let new_agDsg = cat_api.get_new_item(lc_item)
   
    ' Kontengruppe speichern
    MsgBox cat_xapi.create_item(lc_item, new_agDsg), vbOKOnly, lc_item
    Me.Requery
End Sub


' btn_delete
Private Sub btn_delete_Click()
    ' Gel�schte Kontengruppe ermitteln
    Dim cur_agId As Integer
    Let cur_agId = Me.fld_id
    
    ' Kontengruppe l�schen
    MsgBox cat_xapi.delete_item(lc_item, cur_agId), , lc_item
    Me.Requery
End Sub