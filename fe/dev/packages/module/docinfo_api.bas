Attribute VB_Name = "docinfo_api"
'========================================================================================
'                  DokumentInformation-API
'========================================================================================
Option Compare Database
Private Const docInf_tblName As String = "inf_documents"

'****************************************************************************************
'*            DatenTyp
'* Version 7.1
'****************************************************************************************
Type docInf
    doc_type As String
    doc_name As String
    doc_tabl As String
    doc_view As String
    doc_form As String
    pos_tabl As String
    pos_form As String
    rls_view As String
    def_acc As Integer
    doc_frq As Integer
End Type

'****************************************************************************************
'*       Gibt Information des Dokuments (als Objekt) zurück
'* Version 7.1
'****************************************************************************************
' bzg Id des Dokuments
Public Function get_docInf_by_docId(pin_docId As String) As docInf
    ' Dokumententyp aus Dokumenten-Id ermitteln
    Dim l_docType As String
    Let l_docType = Right(pin_docId, 3)             ' ToDo: get_docType_by_docId
   
    Let get_docInf_by_docId = get_docInf_by_docType(l_docType)
End Function

' bzg Typ des Dokuments
Public Function get_docInf_by_docType(pin_docType As String) As docInf
    Dim l_docInf As docInf
    
    Let l_docInf.doc_name = Nz(DLookup("doc_name", docInf_tblName, "doc_type = '" & pin_docType & "'"), "")
    Let l_docInf.doc_tabl = Nz(DLookup("doc_tabl", docInf_tblName, "doc_type = '" & pin_docType & "'"), "")
    Let l_docInf.doc_view = Nz(DLookup("doc_view", docInf_tblName, "doc_type = '" & pin_docType & "'"), "")
    Let l_docInf.doc_form = Nz(DLookup("doc_form", docInf_tblName, "doc_type = '" & pin_docType & "'"), "")
    Let l_docInf.pos_tabl = Nz(DLookup("pos_tabl", docInf_tblName, "doc_type = '" & pin_docType & "'"), "")
    Let l_docInf.pos_form = Nz(DLookup("pos_form", docInf_tblName, "doc_type = '" & pin_docType & "'"), "")
    Let l_docInf.rls_view = Nz(DLookup("rls_view", docInf_tblName, "doc_type = '" & pin_docType & "'"), "")
    Let l_docInf.def_acc = Nz(DLookup("def_acc", docInf_tblName, "doc_type = '" & pin_docType & "'"), 0)
    Let l_docInf.doc_frq = Nz(DLookup("doc_frq", docInf_tblName, "doc_type = '" & pin_docType & "'"), 12)
    
    Let get_docInf_by_docType = l_docInf
End Function


'****************************************************************************************
'*       Gibt eine Liste aus DokumentenTypen zurück, die für den Monat relevant sind.
'* Version 7.1
'****************************************************************************************
' Gibt eine Liste des DokumentenTypes bzg. des aktuellen Monats zurück
Public Function get_listOfDocs(pin_monthNr As Integer) As String()
On Error GoTo fehler
    ' String Array definieren
    Dim arr_lstDocs() As String
    ReDim arr_lstDocs(0)
    
    ' Index des Arrays
    Dim l_idx As Integer
    Let l_idx = -1
    
    ' Recordset erhalten
    Dim rcs_docInf As Recordset
    Set rcs_docInf = CurrentDb.OpenRecordset(docInf_tblName, dbOpenDynaset)
    
    ' Recordset durchgehen
    With rcs_docInf
        Do While Not .EOF
            If (pin_monthNr Mod !doc_frq) = 0 Then
                ' Array dynamisch erweitern
                Let l_idx = l_idx + 1
                ReDim Preserve arr_lstDocs(l_idx)
                Let arr_lstDocs(l_idx) = !doc_type
            End If
            
            .MoveNext
        Loop
    End With
    
    ' Ausgabewert zuweisen
    Let get_listOfDocs = arr_lstDocs
    
    GoTo ende
fehler:
    Debug.Print Err.description
ende:
    If Not rcs_docInf Is Nothing Then
        rcs_docInf.Close
    End If
End Function
