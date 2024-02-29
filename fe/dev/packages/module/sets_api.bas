Attribute VB_Name = "sets_api"
'==========================================================
'=                 Einstellungen-Package
'==========================================================
Option Compare Database
Private dev_mod As Boolean

''****************************************************************************************
''*       Speicherung einer Kopie von der Anwendung in \backups\application\ - Verzeichnis
''* Version: 7,5
''****************************************************************************************
'' Anwendung (FE)
'Sub save_application()
'    ' Aktuälles Datum
'    Dim l_curData As String
'    Let l_curData = Format(Now, "yymmddHHMM")
'
'    ' Name des Backups: ProjektsName_Datum.accbd
'    Dim l_newFileName As String
'    Let l_newFileName = Left(CurrentProject.name, Len(CurrentProject.name) - 6) & _
'                        "_" & l_curData & _
'                        Right(CurrentProject.name, 6)
'
'    ' Volle Name der Quell-Datei
'    Dim l_srcFileFullName As String
'    Let l_srcFileFullName = CurrentProject.FullName
'
'    ' Volle Name des Backups
'' ToDo: "\backups\application\" als Konstante anlegen
'    Dim l_trgFileFullName As String
'    Let l_trgFileFullName = CurrentProject.Path & _
'                            "\backups\application\" & _
'                            l_newFileName
'
'    ' Datei kopieren
'    Call copy_file(l_srcFileFullName, l_trgFileFullName)
'
'    ' Rückmeldung im FE
'    MsgBox "Anwendung wurde gesichert." & chr(13) & _
'           "Es wurde eine Kopie erstellt: " & l_trgFileFullName, _
'           vbInformation, "Frontend Backup"
'
'    ' Rückmeldung im BE
'    Debug.Print "Quelle: " & l_srcFileFullName & chr(13) & _
'                "Ziel:   " & l_trgFileFullName
'End Sub
'
'' Macht eine Datei-Kopie
'' ToDo: muss in File-Modul
'Private Sub copy_file(pin_srcFileFullName As String, _
'                      pin_trgFileFullName As String)
'On Error GoTo fehler
'    ' FileSystemObject
'    Dim fso As Object
'    Set fso = CreateObject("Scripting.FileSystemObject")
'
'    ' Datei kopieren
'    Call fso.copyFile(pin_srcFileFullName, pin_trgFileFullName, True)
'
'    GoTo ende
'
'fehler:
'    Debug.Print "Fehler: " & Err.description
'
'ende:
'    If Not fso Is Nothing Then
'        Set fso = Nothing
'    End If
'End Sub


'****************************************************************************************
'' Datenbank (BE) - Brauchen wir nicht mehr
'Sub sav_backEnd()
'    Call backup.save_database
'End Sub


'**********************************************************
'*            Modi
'**********************************************************
Public Function isDev_mod() As Boolean
    Let isDev_mod = dev_mod
End Function


' Setzt den Benutzermodus
Sub set_userMod()
    ' Menüleiste ausblenden
    DoCmd.ShowToolbar "Ribbon", acToolbarNo
    ' Navigationsleiste ausblenden
    Call show_navMenu(False)
    Let dev_mod = False
End Sub

' Setzt den Entwicklermodus
Sub set_deplMod()
    ' Menüleiste einblenden
    DoCmd.ShowToolbar "Ribbon", acToolbarYes
    ' Navigationsleiste einblenden
    Call show_navMenu(True)
    Let dev_mod = True
End Sub

' Navigationsleiste aus-/einblenden
Private Sub show_navMenu(pin_show As Boolean)
    DoCmd.SelectObject acTable, vbNullString, True
    If pin_show = False Then
        RunCommand acCmdWindowHide
    End If
End Sub
