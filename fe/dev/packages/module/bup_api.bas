Attribute VB_Name = "bup_api"
'========================================================================================
'=                  BackUps-API
'= Version: 7,5
'========================================================================================
Option Compare Database


'************************************ B A C K U P S *************************************
'*******************************************|********************************************
'*       Speicherung einer Kopie von der Anwendung in \backups\application\ - Verzeichnis
'* Version: 7,5
'****************************************************************************************
Sub save_application()
    ' Aktuälles Datum
    Dim l_curData As String
    Let l_curData = Format(Now, "yymmddHHMM")
    
    ' Name des Backups: ProjektsName_Datum.accbd
    Dim l_newFileName As String
    Let l_newFileName = Left(CurrentProject.name, Len(CurrentProject.name) - 6) & _
                        "_" & l_curData & _
                        Right(CurrentProject.name, 6)
    
    ' Volle Name der Quell-Datei
    Dim l_srcFileFullName As String
    Let l_srcFileFullName = CurrentProject.FullName

    ' Volle Name des Backups
    Dim l_trgFileFullName As String
    Let l_trgFileFullName = CurrentProject.Path & _
                            "\backups\application\" & _
                            l_newFileName
    
    ' Datei kopieren
    Call fso_api.copy_file(l_srcFileFullName, l_trgFileFullName)
    
    ' Rückmeldung im FE
    MsgBox "Anwendung wurde gesichert." & chr(13) & _
           "Es wurde eine Kopie erstellt: " & l_trgFileFullName, _
           vbInformation, "Frontend Backup"
         
    ' Rückmeldung im BE
    Debug.Print "Quelle: " & l_srcFileFullName & chr(13) & _
                "Ziel:   " & l_trgFileFullName
End Sub

'****************************************************************************************
'*       Erstellung von INSERT INTO - Skripten für allen Tabellen der Anwendung und
'*       Speicherung deren in \backups\database\ - Verzeichnis
'* Version: 7,5
'****************************************************************************************
Public Sub save_database()
    ' Variablen
    Dim l_curTableName As String
    Dim l_fileFullName As String
    Dim l_curRowOfValues As String

    Dim arr_listOfColumns() As String
    Dim arr_listOfValues() As String
    
    ' List von Tabellennamen erhalten
    Dim arr_listOfTables() As String
    Let arr_listOfTables = tab_api.get_listOfTables
    
'---------- Liste der Tabellen durchgehen ----------
    For l_tabIdx = 0 To UBound(arr_listOfTables) - 1
        ' aktuelle Tabellenname ermitteln
        Let l_curTableName = arr_listOfTables(l_tabIdx)
        
        ' Dateiname bzg der Tabellenname generieren
        Let l_fileFullName = generate_fileFullName(l_curTableName)
        
        ' Datei erstellen, wenn die nicht vorhanden
        Call create_file_ifNotExist(l_fileFullName)

' Datei schreiben
        ' Überschreibe die Datei mit erster Zeile: INSERT INTO tbl_name
        Call fso_api.write_rowInFile(l_fileFullName, _
                                     get_firstRow(l_curTableName), _
                                     2)
        
        ' Spaltennamenlist der aktuellen Tabelle ermitteln
        Let arr_listOfColumns = tab_api.get_listOfColumns(l_curTableName)
        
        ' Füge Spaltennamenlist in die Datei hinzu: (col1, col2) VALUES
        Call fso_api.write_rowInFile(l_fileFullName, _
                                     get_secondRow(arr_listOfColumns), _
                                     8)

        ' Recordset To Array aus der aktuellen Tabelle erhalten
        Let arr_listOfValues = tab_api.get_tableValuesAsArray(l_curTableName)
        
        ' Leeres Array überspringen
        If Not (Not arr_listOfValues) Then
            ' Array mit Inhalt durchgehen
            For l_rowIdx = 0 To UBound(arr_listOfValues)
                Let l_curRowOfValues = get_valueRow(arr_listOfValues(l_rowIdx))
                
                ' Füge die neue Zeile mit den Werten in die Datei hinzu
                Call fso_api.write_rowInFile(l_fileFullName, _
                                             l_curRowOfValues, _
                                             8)
            
            Next l_rowIdx
        End If
        
        Debug.Print "Tabelle: " & l_curTableName & " gespeichert!"
    Next l_tabIdx

    Debug.Print "Prozess beendet"
End Sub


'*************************************** F I L E ****************************************
'*******************************************|********************************************
'*       Generiert volle Dateiname bzg Tabellenname zurück
'* Version: 7,5
'****************************************************************************************
Private Function generate_fileFullName(pin_tableName As String) As String
    Let generate_fileFullName = CurrentProject.Path & _
                                "\backups\database\" & _
                                pin_tableName & ".sql"
End Function

'****************************************************************************************
'*       Erstellt die Datei, wenn die nicht vorhanden ist
'* Version: 7,5
'****************************************************************************************
Private Sub create_file_ifNotExist(pin_fileFullName As String)
    ' Prüfen, ob die Datei vorhanden ist
    If Not check_fileExist(pin_fileFullName) Then
        Call fso_api.create_newFile(pin_fileFullName)
    End If
End Sub

'****************************************************************************************
'*       Prüft, ob eine Datei vorhanden ist
'* Version: 7,5
'****************************************************************************************
Private Function check_fileExist(pin_fullFileName As String) As Boolean
    Let check_fileExist = (Dir(pin_fullFileName) <> "")
End Function


'************************************* S C R I P T **************************************
'*******************************************|********************************************
'*       Gibt erste Zeile des Scripts zurück: INSERT INTO tbl_name
'* Version: 7,5
'****************************************************************************************
Private Function get_firstRow(pin_tblName As String) As String
    Let get_firstRow = "INSERT INTO " & pin_tblName
End Function

'****************************************************************************************
'*       Gibt zweite Zeile des Scripts zurück: (col1, col2) VALUES
'* Version: 7,5
'****************************************************************************************
Private Function get_secondRow(pin_arr_colList() As String) As String
    Dim str_colLost As String
    Let str_colLost = Join(pin_arr_colList, ", ")
    
    Let get_secondRow = chr(13) & chr(10) & "       (" & Left(str_colLost, Len(str_colLost) - 2) & ")" & _
                        chr(13) & chr(10) & "VALUES "
End Function

'****************************************************************************************
'*       Gibt die restliche Zeilen (mit Werten) des Skripts zurück
'* Version: 7,5
'****************************************************************************************
Private Function get_valueRow(pin_valueRow As String) As String
    Let get_valueRow = chr(13) & chr(10) & "       (" & pin_valueRow & "),"
End Function
