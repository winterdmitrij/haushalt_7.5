VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_rpt_accountdetail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'=                 Bericht Konto-Detail
'==========================================================
Option Compare Database

' ToDo:
'    - btn_close:  - bild ändern zum Haus
'    - wäre nicht schlecht, sortieren, um Gesamt am Ende war

' btn_close
Private Sub btn_close_Click()
    Call frm_xapi.cls_frm(Me.name, False)
End Sub
