Attribute VB_Name = "cat_api"
'==========================================================
'=                 Kataloge-Schnittstelle
'==========================================================
Option Compare Database


'**********************************************************
'*            Variablen, Getters und Setters
'**********************************************************
Private cur_taId As Integer
Private cur_pgId As Integer

Private cur_agId As Integer


' Aktuelle Transaktion
Public Function get_cur_taid() As Integer
    If cur_taId = 0 Then
        Call set_cur_taid(1)
    End If
    
    Let get_cur_taid = cur_taId
End Function
Public Sub set_cur_taid(pin_taId As Integer)
    Let cur_taId = pin_taId
End Sub


' Aktuelle Postgruppe
Public Function get_cur_pgid() As Integer
    If cur_pgId = 0 Then
        Call set_cur_pgid(DLookup("id", env.gt_cat_pg, "rank = 'a' AND ta_id = " & get_cur_taid()))
    End If
    
    Let get_cur_pgid = cur_pgId
End Function
Public Sub set_cur_pgid(pin_pgId As Integer)
    Let cur_pgId = pin_pgId
End Sub


' Aktuelle Kontengruppe
Public Function get_cur_agId() As Integer
    If cur_agId = 0 Then
        Call set_cur_agId(1)
    End If

    Let get_cur_agId = cur_agId
End Function
Public Sub set_cur_agId(pin_agId As Integer)
    Let cur_agId = pin_agId
End Sub



'**********************************************************
'*            Neues Katalog-Item Dialog
'**********************************************************
Public Function get_new_item(pin_item As String) As String
    Dim head As String
    Let head = pin_item & " hinzuf¸gen"
    
    Dim txt As String
    Let txt = "Neue " & pin_item & "-Bezeichnung eingeben."
    
    
    Dim new_item As String    ' Post Group Designation
    Let new_item = InputBox(txt & vbNewLine & "Maximum 30 und minimum 4 Zeichen.", head, "")

    Let new_item = Trim(new_item)

    ' L‰nge der Eingabe pr¸fen
    If Len(new_item) = 0 Then
        Let get_new_item = ""
        Exit Function
    End If

    If Len(new_item) > 30 Then
        MsgBox "Die L‰nge der Bezeichnung ist zu groﬂ. Eingabe wiederholen.", , head
        Let get_new_item = get_new_item(pin_item)
        Exit Function
    End If
    
    Let get_new_item = new_item
End Function
