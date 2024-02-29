Attribute VB_Name = "frm_xapi"
'==========================================================
'               Schnittstelle für Formulare
'==========================================================
Option Compare Database


'**********************************************************
'*            Öffnen und Schließen der Form
'**********************************************************
' Öffnet den Formular mit/ohne Bedingungen (Condition)
Public Sub opn_frm(pin_frmNam As String, Optional pin_con As String = "")
    DoCmd.OpenForm pin_frmNam, , , pin_con
End Sub

' Schließt den Formular mit/ohne Speicherung
Public Sub cls_frm(pin_frmNam As String, Optional pin_sav As Boolean = True)
    If Not pin_sav Then
        DoCmd.Close acForm, pin_frmNam, acSaveNo
    Else
        DoCmd.Close acForm, pin_frmNam, acSaveYes
    End If
End Sub
