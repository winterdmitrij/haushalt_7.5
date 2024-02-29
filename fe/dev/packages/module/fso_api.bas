Attribute VB_Name = "fso_api"
'========================================================================================
'=                 File System Object - API
'========================================================================================
Option Compare Database


'********************************** T E X T - F I L E ***********************************
'*******************************************|********************************************
'*       Eine neue leere Text-Datei erstellen
'* Version: 7,5
'****************************************************************************************
Sub create_newFile(pin_fileFullName As String)
On Error GoTo fehler
    ' File System Object
    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    ' Datei-Object
    Dim l_file As Object
    Set l_file = fso.CreateTextFile(pin_fileFullName, True)
    
'    ' Sreiben in die Detei einen Random Text und schlie�en
'    l_file.WriteLine ("Neue Datei erstellt.")
'    l_file.Close

    GoTo ende

fehler:
    Debug.Print "Fehler: " & Err.description

ende:
    If Not fso Is Nothing Then
        Set fso = Nothing
    End If
End Sub

'****************************************************************************************
'*       Schreibt die �bergebene Zeile in die �bergebene Datei
'*       Regimee: 2 = �berschreiben; 8 = Hinzuf�gen
'* Version: 7,5
'****************************************************************************************
Sub write_rowInFile(pin_fileFullName As String, _
                    pin_row As String, _
                    Optional pin_regim As Integer = 8)
On Error GoTo fehler
    Const ForReading = 1    ' �ffnet eine Datei NUR zum Lesen. Sie k�nnen nicht in diese Datei schreiben.
    Const ForWriting = 2    ' �ffnen Sie eine Datei NUR zum �berschreiben.
    Const ForAppending = 8  ' �ffnen einer Datei NUR zum Schreiben an ihrem Ende.
    Const TristateTrue = -1 ' �ffnet die Datei als Unicode.
    
    ' File System Object
    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    ' Datei-Object
    Dim l_file As Object
    Set l_file = fso.OpenTextFile(pin_fileFullName, pin_regim, True, TristateTrue)
    
    ' Sreiben in die Detei einen Random Text und schlie�en
    l_file.Write pin_row
    l_file.Close
 
    GoTo ende

fehler:
    Debug.Print "Fehler: " & Err.description
    
ende:
    If Not fso Is Nothing Then
        Set fso = Nothing
    End If
End Sub


'******************************** A C C E S S - F I L E *********************************
'*******************************************|********************************************
'*       Erstellt eine Kopie der �bergebenen Datei unter den �bergebenen Pfad
'* Version: 7,5
'****************************************************************************************
Sub copy_file(pin_srcFileFullName As String, _
              pin_trgFileFullName As String)
On Error GoTo fehler
    ' FileSystemObject
    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")

    ' Datei kopieren
    Call fso.copyFile(pin_srcFileFullName, pin_trgFileFullName, True)

    GoTo ende

fehler:
    Debug.Print "Fehler: " & Err.description

ende:
    If Not fso Is Nothing Then
        Set fso = Nothing
    End If
End Sub

