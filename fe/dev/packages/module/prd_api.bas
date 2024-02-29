Attribute VB_Name = "prd_api"
'========================================================================================
'=                 Periods-Controller
'= Version: 7.5
'========================================================================================
Option Compare Database
Private Const prd_tblName As String = "cat_periods"

'****************************************************************************************
'*       Neues Zeitraum des aktuellen Datums
'* Version: 7.5
'****************************************************************************************
Public Sub create_curPrd()
    ' Heutiges Zeitraum ermitteln
    Dim l_newPrd As Integer
    Let l_newPrd = Format(date, "YYMM")
    
    ' Existenz prüfen
    If prd_tapi.check_prdExist(l_newPrd, prd_tblName) Then
        MsgBox "Zeitraum: " & l_newPrd & " existiert bereits!"
        Exit Sub
    End If
    
    ' Request erhalten
    Dim l_req As Integer
    Let l_req = prd_tapi.create_newPrd(l_newPrd, prd_tblName)
    
    ' Request analysieren
    If l_req = 200 Then
        MsgBox "Zeitraum: " & l_newPrd & " wurde erfolgreich hinzugefügt!"
    Else
        MsgBox "Es wurde erfolglos versucht, das Zeitraum: " & l_newPrd & " hinzuzufügen!"
    End If
End Sub


'****************************************************************************************
'*       Gibt das maximalen Zeitraum aus der Tabelle "cat_periods"
'* Version: 7.5
'****************************************************************************************
Public Function get_maxPrd() As Integer
    Let get_maxPrd = prd_tapi.find_maxPrd(prd_tblName)
End Function
