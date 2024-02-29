Attribute VB_Name = "doc_xapi"
'========================================================================================
'=                 Documents-Controller
'= Version: 7,5
'========================================================================================
Option Compare Database



'***************** D O K U M E N T   E R S T E L L E N **********************************
'****************************************************************************************
'*       Alle relevante Dokumente erstellen
'****************************************************************************************
Public Sub create_docs(pin_prd As Integer)
    Dim l_curDocId As String
    Dim l_curInfDoc As docInf
    Dim l_idx As Integer
    
    ' Aktuelle Monat ermitteln
' ToDo: l_month = .get_month_by_prd(pin_prd)
    Dim l_curMonth As Integer
    Let l_curMonth = Right(pin_prd, 2)
    
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
'****************************************************************************************
Private Sub create_doc_ifNotExist(pin_docId As String)
    ' Dokument-Id als aktuell setzen
    Call curdoc_api.set_curDocId(pin_docId)
    
    ' Dokumentexistenz prüfen
    If Not curdoc_api.check_curDocExist Then
        ' Neuer Dokument erstellen
        Call doc_tapi.ins_new_doc(pin_docId)
    End If
End Sub

'****************************************************************************************
'*       Generiert den Dokument-Id bzg des Dokumententyps und des aktuellen Zeitraums
'****************************************************************************************
Private Function generate_docId(pin_docType As String, _
                                pin_curPrd As Integer) As String
    Let generate_docId = pin_curPrd & "-" & pin_docType
End Function





'***************** D O K U M E N T   Ö F F N E N **********************************
' ToDo: Soll hier sein?
'**********************************************************
'*            Dokument öffnen (opn_docFrm_)
'**********************************************************
' bei Dokumenten-Type
Public Sub opn_docFrm_byType(pin_docType As String, pin_prd As Integer)
    ' Aktuelles Zeitraum speichern
    Call prd_api.set_cur_prd(pin_prd)
    
    ' akt. Dokument-Id ermitteln
    Dim cur_docId As String
    Let cur_docId = pin_prd & "-" & pin_docType
    
    ' Form bei Dokumenten-Id öffnen
    Call opn_docFrm_byId(cur_docId)
End Sub

' bei Dokumenten-Id
Public Sub opn_docFrm_byId(pin_docId As String)
    If pin_docId = "" Then
        Exit Sub
    End If
    
    ' Dokument als aktuell merken
    Call doc_api.set_cur_docId(pin_docId)
    
    ' Existenz des Dokuments prüfen
    If Not doc_tapi.check_docExist(pin_docId) Then
        ' Request ermitteln
        Dim req As Integer
        Let req = doc_tapi.ins_new_doc(pin_docId)
        
        ' Request analysieren
        If req <> 200 Then
            MsgBox "Es wurde erfolglos versucht, einen Dokument mit dem Id: " & pin_docId & " zu erstellen!"
            Exit Sub
        End If
    End If
    
    ' Öffne Form des aktuellen Dokuments
    Call frm_xapi.opn_frm(doc_api.get_cur_docForm(), "doc_id = '" & pin_docId & "'")
End Sub


'**********************************************************
'*            Dokument schließen (cls_docFrm)
'**********************************************************
Public Sub cls_docFrm(pin_frmName As String)
    ' Aktuellen Dokument-Id leeren
    Call doc_api.set_cur_docId("")
    
    ' Form schließen
    Call frm_xapi.cls_frm(pin_frmName, True)
End Sub


'**********************************************************
'*            Dokumentenbetrags berechnen (clc_)
'**********************************************************
' Gibt den Betrag
Public Function clc_amt_byId(pin_docId As String) As Double
    Select Case doc_api.get_cur_docType()
        Case "Spk"
            Let clc_amt_byId = doc_tapi.sum_bnkAmt(pin_docId)
        Case "Exp"
            Let clc_amt_byId = doc_tapi.sum_exp(pin_docId)
        Case "Inc"
            Let clc_amt_byId = doc_tapi.sum_inc(pin_docId)
        Case Else
            Let clc_amt_byId = doc_tapi.sum_dps(pin_docId)
    End Select
End Function


'-------------------------------------------------
''**********************************************************
''*            Operationen mit akt. Dokument
''**********************************************************
'' Erstellt neuen Dokument, wenn es notwendig
'Public Sub create_cur_doc()
'    If Not exists_cur_doc() Then
'        Call doc_tapi.cre_new_doc(cur_docId)
'    End If
'End Sub

' Prüft des Eksistenz des Dokuments
'Public Function exists_cur_doc() As Boolean
'    Let exists_cur_doc = DCount("id", cur_docTabl, "id = '" & cur_docId & "'") > 0
'End Function

