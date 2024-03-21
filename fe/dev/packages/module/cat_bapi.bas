Attribute VB_Name = "cat_bapi"
'========================================================================================
'=                 Kataloge - Schnittstelle
'= Version:
'========================================================================================
Option Compare Database
Private cur_taId As Integer
Private cur_pgId As Integer

Private cur_agId As Integer


'************************************ G E T T E R S *************************************
'*******************************************|********************************************
'*       Gibt die aktuelle Transaktion zurueck
'* Version: 7.6
'****************************************************************************************
Public Function get_cur_taId() As Integer
    If cur_taId = 0 Then
        Call set_cur_taId(1)
    End If

    Let get_cur_taId = cur_taId
End Function

'****************************************************************************************
'*       Gibt die aktuelle Postgruppe zurueck
'* Version: 7.6
'****************************************************************************************
Public Function get_cur_pgId() As Integer
    If cur_pgId = 0 Then
        Call set_cur_pgId(cat_tapi.select_min_pgId_by_taId(get_cur_taId()))
    End If

    Let get_cur_pgId = cur_pgId
End Function

'****************************************************************************************
'*       Gibt die aktuelle Kontengruppe zurueck
'* Version: 7.6
'****************************************************************************************
Public Function get_cur_agId() As Integer
    If cur_agId = 0 Then
        Call set_cur_agId(1)
    End If

    Let get_cur_agId = cur_agId
End Function


'************************************ S E T T E R S *************************************
'*******************************************|********************************************
'*       Setzt die aktuelle Transaktion
'* Version: 7.6
'****************************************************************************************
Public Sub set_cur_taId(pin_taId As Integer)
    Let cur_taId = pin_taId
End Sub

'****************************************************************************************
'*       Setzt die aktuelle Postgruppe
'* Version: 7.
'* ToDo: set_cur...(TAPI.select_min_pgId_by_taId())
'****************************************************************************************
Public Sub set_cur_pgId(pin_pgId As Integer)
    Let cur_pgId = pin_pgId
End Sub

'****************************************************************************************
'*       Setzt die aktuelle Kontengruppe
'* Version: 7.6
'****************************************************************************************
Public Sub set_cur_agId(pin_agId As Integer)
    Let cur_agId = pin_agId
End Sub


'***************************** E I N G A B E - D I A L O G ******************************
'*******************************************|********************************************
'*       Öffnet ein Dialog zur Bezeichnung-Eingabe
'* Version: 7.
'* ToDo: Gehört es nicht zum frm_api?
'* ToDo: Problem mit Cancel
'****************************************************************************************
Public Function open_addDialog(pin_dsg As String) As String
    Dim l_head As String
    Let l_head = pin_item & " hinzufügen"

    Dim l_msg As String
    Let l_msg = "Neue " & pin_dsg & "-Bezeichnung eingeben."

    Dim l_newDsg As String
    Let l_newDsg = InputBox(l_msg & vbNewLine & "Maximum 30 und minimum 4 Zeichen.", l_head)

    If l_newDsg = "" Then
        Exit Function
    End If
    
    Let l_newDsg = Trim(l_newDsg)
    
    If Len(l_newDsg) < 4 Or _
       Len(l_newDsg) > 30 Then
        MsgBox "Die Länge der Bezeichnung ist falsch. Eingabe wiederholen.", , l_head
        Let open_addDialog = open_addDialog(pin_dsg)
        Exit Function
    End If
    
    Let open_addDialog = l_newDsg
End Function
