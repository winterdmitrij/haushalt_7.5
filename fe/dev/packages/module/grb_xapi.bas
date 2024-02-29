Attribute VB_Name = "grb_xapi"
'==========================================================
'=                 Großbuch-Controller
'==========================================================
Option Compare Database


'**********************************************************
'*            Dokument freigeben (rls_)
'**********************************************************
Public Sub rls_doc(pin_docId As String)
On Error GoTo exception
    Dim l_msq As String
    Dim l_req As Integer
    Dim l_setGrb As typ_grb
    Dim l_docAmt As Double

    ' für Sicherheit, Dokument als aktuellen setzen
    Call doc_api.set_cur_docId(pin_docId)
    
    
chk_doc:
    ' ist frg -> exit
    If doc_tapi.chk_rls_doc(pin_docId) Then
        Debug.Print "Dokument mit Id: " & pin_docId & " ist schon freigegeben."
        Exit Sub
    End If
    
    ' ist leer -> to upd_doc
    If doc_tapi.sel_cnt_pos(pin_docId) = 0 Then
        GoTo upd_doc
    End If
    
cre_rcs:
    ' Workspace
    Dim wks As Workspace
    Set wks = DBEngine.Workspaces(0)
    
    ' Recordset
    Dim rcsDoc As Recordset
    Set rcsDoc = CurrentDb.OpenRecordset(doc_api.get_cur_rlsView, dbOpenDynaset, dbFailOnError)
    
    ' ist Recordset leer -> to upd_doc
    If rcsDoc.RecordCount = 0 Then
        GoTo upd_doc
    End If

beg_trs:
    '------------------------- Transaktion starten --------------------------'
    wks.BeginTrans
    
    Do Until rcsDoc.EOF
        With rcsDoc
            ' Werte zuweisen
            Let l_setGrb.id = !id
            Let l_setGrb.dat = !dat
            Let l_setGrb.acc = !ad_id
            Let l_setGrb.pst = !pd_id
            Let l_setGrb.amt = !amt
            Let l_setGrb.cmt = Nz(!cmt, "")
        
            ' Position ins Grosbuch speichern
            Let l_req = grb_tapi.ins_pos(l_setGrb)

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
    Let l_req = doc_tapi.upd_rls(pin_docId, True)

    If l_req = 400 Then
        Debug.Print "Fehler beim Freigabeflag-Update"
    End If

    ' Betrag berechnen und setzen
    Let l_docAmt = doc_xapi.clc_amt_byId(pin_docId)
    Let l_req = doc_tapi.upd_amt(pin_docId, l_docAmt)
    
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


'**********************************************************
'*            Dokument stornieren (cnc_)
'**********************************************************
Public Sub cnc_doc(pin_docId As String)
On Error GoTo exception
    Dim l_req As Integer
    Dim l_msg As String
    
    ' für Sicherheit, Dokument als aktuellen setzen
    Call doc_api.set_cur_docId(pin_docId)
    
    
chk_doc:
    ' ist frg -> exit
    If Not doc_tapi.chk_rls_doc(pin_docId) Then
        Debug.Print "Dokument mit Id: " & pin_docId & " ist schon storniert."
        Exit Sub
    End If

    ' Workspace
    Dim wks As Workspace
    Set wks = DBEngine.Workspaces(0)

beg_trs:
    '------------------------- Transaktion starten --------------------------'
    wks.BeginTrans

    ' Löschen Dokument aus der Grossbuch-Tabelle
    Let req = grb_tapi.del_all_pos(pin_docId)

    If req = 400 Then
        Let l_msg = "Feheler beim DELETE vom Dokument: " & pin_docId
        GoTo exception
    End If
    
cmt_trs:
    '------------------------- Transaktion commieten --------------------------'
    wks.CommitTrans

upd_doc:
    ' Freigabe-Flag absetzen
    Let l_req = doc_tapi.upd_rls(pin_docId, False)

    If l_req = 400 Then
        Debug.Print "Fehler beim Freigabeflag-Update"
    End If

    ' Betrag leeren
    Let l_req = doc_tapi.upd_amt(pin_docId, 0)
    
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


