Attribute VB_Name = "doc_pckg"
''==========================================================
''=                 Documents-Package
''==========================================================
'Option Compare Database
'
'' ToDo:
''    - Dokumenten-Bearbeitung optimieren
''    - Step22: vllt add_...
''    - vllt. ein View (zB: release_v) erstellen
'
''**********************************************************
''*            Dokument freigeben
''**********************************************************
'Public Sub rls_doc(pin_docId As String)
'On Error GoTo exception
'    Dim l_step As Integer
'    Dim l_position As t_grossbuch
'
'step1:
'    Let l_step = 1
'    ' Dokument als aktuell setzen
'    Call doc_api.set_cur_docId(pin_docId)
'
'    ' Wenn akt. Dokument freigegeben ist, beenden
'    If doc_api.released_cur_doc() Then
'        Exit Sub
'    End If
'
'    ' Wenn akt. Dokument leer ist, direct zum Schritt 3
'    If doc_api.empty_cur_doc Then
'        GoTo step3
'    End If
'
'    ' Workspace
'    Dim wks As Workspace
'    Set wks = DBEngine.Workspaces(0)
'
'    ' SQL
'    Dim strSql As String
'    Let strSql = "SELECT * " & _
'                 "  FROM " & doc_api.get_cur_docView & _
'                 " WHERE dkmid = '" & doc_api.get_cur_docId & "'"
'
'    ' Recordset
'    Dim rcsDoc As Recordset
'    Set rcsDoc = CurrentDb.OpenRecordset(strSql, dbOpenSnapshot, dbFailOnError)
'
'
''------------------------- Transaktion starten --------------------------'
'step2:
'    wks.BeginTrans
'
'    Let l_step = 20
'    Do Until rcsDoc.EOF
'        With rcsDoc
'            Let l_step = 21
'
'            ' Position-Datensatz erstellen
'            Let l_position.id = !posId
'            Let l_position.amt = !posbtg
'            Let l_position.cmt = Nz(!kmt, "")
'
'            Select Case doc_api.get_cur_docType
'                Case "Sk"
'                    Let l_position.date = !posDtm
'                    Let l_position.pst = !pdid
'                Case "Ag", "Ek"
'                    Let l_position.date = !dkmDtm
'                    Let l_position.pst = !pdid
'                Case "Ta"
'                    Let l_position.date = !dkmDtm
'                    Let l_position.acc = !kdid
'                Case Else
'                    Debug.Print "Dokument existiert nicht"
'            End Select
'
'            Let l_step = 22
'            ' zu tapi_grossbuch schicken
'            Call xapi_grossbuch.rls_document(l_position)
'
'            ' Nächsten Recordset-Element
'            .MoveNext
'        End With
'    Loop
'
'    Let l_step = 29
'    ' Transaktion kommieten
'    wks.CommitTrans
''------------------------- Transaktion commieten --------------------------'
'
'step3:
'On Error GoTo exception2
'
'    Let l_step = 31
'    ' Freigabe-Flag setzen
'    Call doc_tapi.set_rls(pin_docId, True)
'
'    Let l_step = 32
'    ' Dokumentbetrag berechnen und füllen
'    Call doc_tapi.set_amt(pin_docId, doc_api.get_docAmt())
'
'    GoTo ende
'
'exception:
'    If Not wks Is Nothing Then
'        wks.Rollback
'    End If
'    Debug.Print "Freigabe des Dokuments: " & cur_docId & " wurde zurückgerollt!"
'
'exception2:
'    Debug.Print "Fehler: " & Err.description & ", in Schritt: " & l_step
'
'ende:
'    If Not rcsDoc Is Nothing Then
'        rcsDoc.Close
'    End If
'    If Not wks Is Nothing Then
'        wks.Close
'    End If
'End Sub
'
'
''**********************************************************
''*            Dokument stornieren
''**********************************************************
'Public Sub cnc_doc(pin_docId As String)
'On Error GoTo exception
'    Dim l_step As Integer
'
'step1:
'    Let l_step = 10
'    ' Übergebennen Dokument als aktuellen setzen
'    Call doc_api.set_cur_docId(pin_docId)
'
'    ' Prüfen, ob akt Dokument nicht freigegeben ist
'    If Not doc_api.released_cur_doc() Then
'        Exit Sub
'    End If
'
'    ' Workspace
'    Dim wks As Workspace
'    Set wks = DBEngine.Workspaces(0)
'
'step2:
''----------------------------------------
'' Transaktion starten
'    wks.BeginTrans
'
'    l_step = 20
'    ' Löschen Dokument aus der Tabelle tblGrb
'    Call tapi_grossbuch.del_doc(pin_docId)
'
'' Transaktion kommieten
'    wks.CommitTrans
''-------------------------------------------------
'
'step3:
'On Error GoTo exception2
'    l_step = 31
'    ' Freigabe-Flag absetzen
'    Call set_rls(pin_docId, False)
'
'    l_step = 32
'    ' Stand/Summe leeren
'    Call doc_tapi.set_amt(pin_docId, 0)
'
'    GoTo ende
'
'exception:
'    If Not wks Is Nothing Then
'        wks.Rollback
'    End If
'    Debug.Print "Stornierung des Dokuments: " & pin_docId & " wurde zurückgerollt!"
'
'exception2:
'    Debug.Print "Fehler: " & Err.description & ", in Schritt: " & l_step
'
'ende:
'    If Not wks Is Nothing Then
'        wks.Close
'    End If
'End Sub
'
