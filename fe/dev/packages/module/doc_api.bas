Attribute VB_Name = "doc_api"
'========================================================================================
'=                 Document-Schnittstelle
'= Version: 7.5
'========================================================================================
Option Compare Database


'********************************** E R S T E L L E N ***********************************
'*******************************************|********************************************
'*       Alle relevante Dokumente erstellen
'* Version: 7.5
'****************************************************************************************
Public Sub create_docs(pin_prd As Integer)
    Dim l_curDocId As String
    Dim l_curInfDoc As docInf
    Dim l_idx As Integer
    
    ' Aktuelle Monat ermitteln
    Dim l_curMonth As Integer
    Let l_curMonth = curprd_api.get_curMonth()
    
    ' List von Dokumenten, die für den Monat relevant sind, ermitteln
    Dim l_listOfDocTypes() As String    ' Array des Types von Dokumenten
    Let l_listOfDocTypes = docinfo_api.get_listOfDocs(l_curMonth)
    
    ' Array durchgehen und Dokumente, die nicht vorhanden, erstellen
    For l_idx = 0 To UBound(l_listOfDocTypes)
        ' Dokument-Id ermitteln
        Let l_curDocId = generate_docId(l_listOfDocTypes(l_idx), pin_prd)
        
        ' Dokument erstellen, wenn es notwendig ist
        Call create_doc_ifNotExist(l_curDocId)
    Next l_idx
End Sub


'****************************************************************************************
'*       Erstellt Dokument, wenn er bereits nicht existiert
'* Version: 7.5
'****************************************************************************************
Private Sub create_doc_ifNotExist(pin_docId As String)
    ' Dokument-Id als aktuell setzen
    Call curdoc_api.set_curDocId(pin_docId)
    
    ' Dokumentexistenz prüfen
    If Not curdoc_api.check_curDocExist Then
        ' Neuer Dokument erstellen
        Call doc_tapi.create_newDoc(pin_docId, _
                                    prd_api.get_curPrd(), _
                                    curdoc_api.get_curDocInf().doc_tabl)
    End If
End Sub

'****************************************************************************************
'*       Generiert den Dokument-Id bzg des Dokumententyps und des aktuellen Zeitraums
'* Version: 7.5
'****************************************************************************************
Private Function generate_docId(pin_docType As String, _
                                pin_curPrd As Integer) As String
    Let generate_docId = pin_curPrd & "-" & pin_docType
End Function

'****************************************************************************************
'*       Gibt den Dokument-Type bzg des Dokument-Id zurück
'* Version: 7.5
'****************************************************************************************
Public Function get_docType_by_docId(pin_docId As String) As String
    Let get_docType_by_docId = Right(pin_docId, 3)
End Function


'****************************** P O S T E N / K O N T E N *******************************
'*******************************************|********************************************
'*       Gibt die Post-Anzahl zurück, der bereits in Dokumenten benutzt wurde
'* Version: 7.5
'****************************************************************************************
Public Function get_posCount_withPost(pin_pdId As Integer) As Integer
    Let get_posCount_withPost = select_cntPositions_by_pdId(pin_pdId)
End Function


'*********************************** F R E I G A B E ************************************
'*******************************************|********************************************
'*            Dokument freigeben (rls_)
'****************************************************************************************
Public Sub release_doc(pin_docId As String)
On Error GoTo exception
    ' Gehen dafon aus, dass das Dokument bereita als aktuell gesetzt
    Dim l_msq As String
    Dim l_req As Integer
    Dim l_grbRow As grbRow
    Dim l_docAmt As Double
    
    Dim l_curDocInf As docInf
    Let l_curDocInf = curdoc_api.get_curDocInf()
    
chk_doc:
    ' Prüfen, ob das Dokument bereits freigegeben ist
    If doc_tapi.check_docReleased(pin_docId, _
                                  l_curDocInf.doc_tabl) Then
        Debug.Print "Dokument mit Id: " & pin_docId & " ist bereits freigegeben."
        Exit Sub
    End If
    
    ' Prüfen, ob das Dokument nicht leer ist
    If doc_tapi.calculate_posCount(pin_docId, _
                                   l_curDocInf.doc_view) = 0 Then
        GoTo upd_doc
    End If
    
cre_rcs:
    ' Workspace
    Dim wks As Workspace
    Set wks = DBEngine.Workspaces(0)
    
    ' Recordset
    Dim rcsDoc As Recordset
    Set rcsDoc = CurrentDb.OpenRecordset(l_curDocInf.rls_view, dbOpenDynaset, dbFailOnError)
    
    ' Prüfen, ob das Recordset nicht leer ist
    If rcsDoc.RecordCount = 0 Then
        GoTo upd_doc
    End If

beg_trs:
    '------------------------- Transaktion starten --------------------------'
    wks.BeginTrans
    
    Do Until rcsDoc.EOF
        With rcsDoc
            ' neue Grb-Zeile erstellen
            Let l_grbRow.id = !id
            Let l_grbRow.dat = !dat
            Let l_grbRow.acc = !ad_id
            Let l_grbRow.pst = !pd_id
            Let l_grbRow.amt = !amt
            Let l_grbRow.cmt = Nz(!cmt, "")
        
            ' Zeile in Grosbuch speichern
            Let l_req = grb_api.write_newGrbRow(l_grbRow)
            
            ' Request analysieren
            If l_req = 400 Then
                Let l_msg = "Feheler beim INSERT von : " & !id
                GoTo exception
            Else
                ' Nächsten Recordset-Element
                .MoveNext
            End If
        End With
    Loop

cmt_trs:
    '------------------------- Transaktion commieten --------------------------'
    wks.CommitTrans

upd_doc:
    ' Freigabe-Flag setzen
    Let l_req = doc_tapi.update_docRls(pin_docId, _
                                       l_curDocInf.doc_tabl, _
                                       True)

    If l_req = 400 Then
        Debug.Print "Fehler beim Freigabeflag-Update"
    End If

    ' Betrag berechnen und setzen
    Let l_docAmt = doc_api.get_docAmt_by_docId(pin_docId)
    Let l_req = doc_tapi.update_docAmt(pin_docId, _
                                       l_curDocInf.doc_tabl, _
                                       l_docAmt)
    
    If l_req = 400 Then
        Debug.Print "Fehler beim Betrag-Update"
    End If
    
    GoTo ende
exception:
    MsgBox l_msg
    Debug.Print Err.Number & " - " & Err.description
    
    ' Rollback
    If Not wks Is Nothing Then
        wks.Rollback
        Debug.Print "Freigabe des Dokuments: " & pin_docId & " wurde zurückgerollt!"
    End If
ende:
    If Not rcsDoc Is Nothing Then
        rcsDoc.Close
    End If
    If Not wks Is Nothing Then
        wks.Close
    End If
End Sub


'****************************************************************************************
'*            Dokument stornieren (cnc_)
'****************************************************************************************
Public Sub cancele_doc(pin_docId As String)
On Error GoTo exception
    Dim l_req As Integer
    Dim l_msg As String
    
chk_doc:
    ' Prüfen, ob das Dokument bereits storniert ist
    If Not doc_tapi.check_docReleased(pin_docId, _
                                      curdoc_api.get_curDocInf().doc_tabl) Then
        Debug.Print "Dokument mit Id: " & pin_docId & " ist bereits storniert."
        Exit Sub
    End If

    ' Workspace
    Dim wks As Workspace
    Set wks = DBEngine.Workspaces(0)

beg_trs:
    '------------------------- Transaktion starten --------------------------'
    wks.BeginTrans

    ' Löschen alle Einträge des Dokuments aus der Grossbuch-Tabelle
    Let req = grb_api.delete_allGrbRows_by_docId(pin_docId)

    If req = 400 Then
        Let l_msg = "Feheler beim DELETE vom Dokument: " & pin_docId
        GoTo exception
    End If
    
cmt_trs:
    '------------------------- Transaktion commieten --------------------------'
    wks.CommitTrans

upd_doc:
    ' Freigabe-Flag absetzen
    Let l_req = doc_tapi.update_docRls(pin_docId, _
                                       curdoc_api.get_curDocInf().doc_tabl, _
                                       False)

    If l_req = 400 Then
        Debug.Print "Fehler beim Freigabeflag-Update"
    End If

    ' Betrag leeren
    Let l_req = doc_tapi.update_docAmt(pin_docId, _
                                       curdoc_api.get_curDocInf().doc_tabl, _
                                       0)
    
    If l_req = 400 Then
        Debug.Print "Fehler beim Betrag-Update"
    End If
    
    GoTo ende

exception:
    MsgBox l_msg
    Debug.Print Err.Number & " - " & Err.description
    
    ' Rollback
    If Not wks Is Nothing Then
        wks.Rollback
        Debug.Print "Stornierung des Dokuments: " & pin_docId & " wurde zurückgerollt!"
    End If

ende:
    If Not wks Is Nothing Then
        wks.Close
    End If
End Sub



'************************************* B E T R A G **************************************
'*******************************************|********************************************
'*       Dokumentenbetrags berechnen (clc_)
'**********************************************************
' Gibt den Betrag
Public Function get_docAmt_by_docId(pin_docId As String) As Double
    ' Bedingung
    Dim l_cond As String
    
    ' Dokumenten-Type ermitteln
    Dim l_docType As String
    Let l_docType = doc_api.get_docType_by_docId(pin_docId)
    
    Select Case l_docType
        ' ToDo: prd_api überprüfen, Else und "Spk" können vllt zusammen sein
        Case "Spk"
            Let l_cond = "ad_id = " & curdoc_api.get_curDocInf().def_acc & " AND " & _
                         "(prd <= " & curprd_api.get_curPrd() & " OR " & _
                         "doc_id = '" & pin_docId & "')"
        Case "Exp", "Inc"
            Let l_cond = "ta_dsg = '" & curdoc_api.get_curDocInf().doc_name & "' AND " & _
                         "prd = " & curprd_api.get_curPrd()
        Case "Dps"
            ' ToDo: 'Überweisungen' ist hard gecodet Und falsch berechnet
            Let l_cond = "ta_dsg = 'Überweisungen' AND " & _
                         "prd = " & curprd_api.get_curPrd()
        Case Else
            Let l_cond = "ad_id = " & curdoc_api.get_curDocInf().def_acc & " AND " & _
                         "(prd <= " & curprd_api.get_curPrd() & " OR " & _
                         "doc_id = '" & pin_docId & "')"
    End Select
    
    ' ToDo: env.gv_grb muss in grb_api oder grb_dfs als Konstante sein
    Let get_docAmt_by_docId = doc_tapi.calculate_docAmount(pin_docId, env.gv_grb, l_cond)
End Function

