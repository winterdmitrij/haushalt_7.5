Attribute VB_Name = "prd_xapi"
'==========================================================
'=                 Periods-Controller
'==========================================================
Option Compare Database


'**********************************************************
'*            Heutiges Zeitraum hinzufügen (cre_)
'**********************************************************
Public Sub cre_prd()
    ' Heutiges Zeitraum ermitteln
    Dim new_prd As Integer
    Let new_prd = Format(date, "YYMM")
    
    ' Existenz prüfen
    If prd_tapi.chk_ext_prd(new_prd) Then
        MsgBox "Zeitraum: " & new_prd & " existiert schon!"
        Exit Sub
    End If
    
    ' Request erhalten
    Dim req As Integer
    Let req = prd_tapi.ins_new_prd(new_prd)
    
    ' Request analysieren
    If req = 200 Then
        MsgBox "Zeitraum: " & new_prd & " wurde erfolgreich hinzugefügt!"
    Else
        MsgBox "Es wurde erfolglos versucht, das Zeitraum: " & new_prd & " hinzuzufügen!"
    End If
End Sub
