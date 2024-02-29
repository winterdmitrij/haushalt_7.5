VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_frm_settings"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'=            Formular: Einstellungen
'==========================================================
Option Compare Database

'*********************************************************
'*                 BackUp's
'*********************************************************
' Erstellt einen Datenbank-Copy
Private Sub btn_beBackUp_Click()
    Call bup_api.save_database
    Call frm_xapi.cls_frm(Me.name)
End Sub

' Erstellt einen Anwendung-Copy
Private Sub btn_feBackUp_Click()
    Call bup_api.save_application
    Call frm_xapi.cls_frm(Me.name)
End Sub


'*********************************************************
'*                 Modi
'*********************************************************
' Setzt Benutzermodus
Private Sub btn_userMod_Click()
    Call settings_pckg.set_userMod
    Call frm_xapi.cls_frm(Me.name)
End Sub

' Setzt den Entwicklermodus
Private Sub btn_deplMod_Click()
    Call settings_pckg.set_deplMod
    Call frm_xapi.cls_frm(Me.name)
End Sub


'*********************************************************
'*                 Form
'*********************************************************
Private Sub btn_close_Click()
    Call frm_xapi.cls_frm(Me.name)
End Sub
