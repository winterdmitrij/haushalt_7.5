Attribute VB_Name = "tapi_positions"
'==========================================================
'               Schnittstelle für Positionen
'==========================================================
Option Compare Database
Private cur_posTbl As String
Private cur_docId As String
Private cur_docTyp As String

'**********************************************************
'*                 Hilfsfunktionen
'**********************************************************
' Initialisiere Variablen
Private Sub init_var()
    Let cur_docId = doc_api.get_cur_docId()
    Let cur_docTyp = doc_api.get_cur_docTyp()
    Let cur_posTbl = DLookup("postab", gt_infDoc, "bez = '" & cur_docTyp & "'")
End Sub

' Neuen Position-Id ermitteln
Private Function get_new_posId() As String
    ' Max Position-Id ermitteln, oder Test-Id
    Dim max_posId As String
    Let max_posId = Nz(DMax("id", cur_posTbl, "dkmid = '" & cur_docId & "'"), "2112-Ts.00")
    
    Dim max_posNum As Integer
    Let max_posNum = Mid(max_posId, 9, 2)
    
    Let get_new_posId = cur_docId & "." & Format(max_posNum + 1, "00")
End Function


'**********************************************************
'*                 Manipulationen mit Positionen
'**********************************************************
' Post-Position hinzufügen
Public Sub add_pstPos(pin_pstId As Integer)
    ' Variablen
    Call init_var

    ' Rekordset
    Dim rcs_pos As Recordset
    Set rcs_pos = CurrentDb.OpenRecordset(cur_posTbl, dbOpenDynaset)
    
    ' Neuen Datensatz hinzufügen und füllen
    With rcs_pos
        .AddNew

        !id = get_new_posId
        !pdid = pin_pstId
        !dkmId = cur_docId
        
        .Update
        .Close
    End With
End Sub

' Konto-Position hinzufügen !!!
Public Sub add_accPos(pin_accId As Integer)
    ' Variablen
    Call init_var

    ' Rekordset
    Dim rcs_pos As Recordset
    Set rcs_pos = CurrentDb.OpenRecordset(cur_posTbl, dbOpenDynaset)
    
    ' Neuen Datensatz hinzufügen und füllen
    With rcs_pos
        .AddNew

        !id = get_new_posId
        !kdid = pin_accId
        !dkmId = cur_docId
        
        .Update
        .Close
    End With
End Sub

' Position löschen
Public Sub del_pos(pin_posId As String)
    ' Variablen
    Call init_var
    
    ' SQL
    Dim strSql As String
    Let strSql = "DELETE " & _
                 "  FROM " & cur_posTbl & _
                 " WHERE id = '" & pin_posId & "'"
    
    Call CurrentDb.Execute(strSql)
End Sub
