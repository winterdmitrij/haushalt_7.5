Attribute VB_Name = "tab_api"
Option Compare Database


' Gibt Array aus Tabellennamen zurück
Function get_listOfTables() As String()
    Dim curTbl As AccessObject
    
    Dim dbs As Object
    Set dbs = Application.CurrentData
    
    Dim tblList As String
    Let tblList = ""
    
    For Each curTbl In dbs.AllTables
        If Left(curTbl.name, 4) <> "MSys" Then
            Let tblList = tblList & curTbl.name & ","
        End If
    Next curTbl
    
    Let get_listOfTables = Split(tblList, ",")
End Function

' Gibt Array aus Spaltennamen der Tabelle zurück
Function get_listOfColumns(pin_tblName As String) As String()
    Dim strColList As String
    
    Dim db As DAO.Database
    Set db = CurrentDb()
    
    Dim tdf As DAO.TableDef
    Set tdf = db.TableDefs(pin_tblName)
    
    Dim curFld As DAO.Field
    For Each curFld In tdf.Fields
        Let strColList = strColList & curFld.name & ","
    Next
    
    Set tdf = Nothing
    Set db = Nothing

    Let get_listOfColumns = Split(strColList, ",")
End Function



' TODO: Recordset To Array (https://access-im-unternehmen.de/Mit_Arrays_arbeiten/)
Public Function get_tableValuesAsArray(pin_tableName) As String()
    Dim arr_tableValues() As String
    Dim l_rowValue As String
    Dim l_curValue As String
     
    ' Recordset
    Dim rcs_table As Recordset
    Set rcs_table = CurrentDb.OpenRecordset(pin_tableName, dbOpenDynaset)
     
    Dim l_cntRow As Integer
    Let l_cntRow = rcs_table.RecordCount
     
    Dim l_cntCol As Integer
    Let l_cntCol = rcs_table.Fields.Count
    
    If l_cntRow < 1 Then
'        Let get_tableValuesAsArray = ""
        GoTo ende
    End If
    
    ReDim get_tableValuesAsArray(l_cntCol)
    
    ' Zeilenweise durchgehen
    Do While Not rcs_table.EOF
        Let l_rowValue = ""
        
        ' Spaltenweise durchgehen
        For idxCol = 0 To l_cntCol - 1
            ' TODO: Werte überprüfen: "String", "Datum", -2.34
            Let l_curValue = get_formattedString(Nz(rcs_table.Fields(idxCol).Value, ""), _
                                                 rcs_table.Fields(idxCol).Type)
            
            ' Werte zum Zeichenkette binden
            Let l_rowValue = l_rowValue & l_curValue & ", "
        Next idxCol
        
        ' Array erweitern und füllen
        ReDim Preserve arr_tableValues(rcs_table.AbsolutePosition)
        arr_tableValues(rcs_table.AbsolutePosition) = Left(l_rowValue, Len(l_rowValue) - 2)
        
        ' Nächste Zeile
        rcs_table.MoveNext
    Loop
     
    Let get_tableValuesAsArray = arr_tableValues
    GoTo ende

fehler:
    Debug.Print "Fehler: " & Err.description
    
ende:
    If Not rcs_table Is Nothing Then
        rcs_table.Close
    End If
End Function

' Formatiert den übergebenen Text
Private Function get_formattedString(pin_unformattedString As String, _
                                     pin_type As String) As String
    Dim l_formStr As String
' 4 = dbLong, 10 = dbText, 8 = dbDate, 20 = dbDecimal
    
    Select Case pin_type
    Case dbLong
        Let get_formattedString = CStr(pin_unformattedString)
    Case dbDecimal
        Let get_formattedString = CStr(Replace(pin_unformattedString, ",", "."))
    Case dbDate
        Let get_formattedString = "'" & pin_unformattedString & "'"
    Case Else
        If IsNumeric(pin_unformattedString) Then
            Let get_formattedString = CStr(pin_unformattedString)
        Else
            Let get_formattedString = "'" & pin_unformattedString & "'"
        End If
    End Select
End Function
