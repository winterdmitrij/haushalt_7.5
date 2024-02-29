Attribute VB_Name = "pos_api"
'==========================================================
'=                 Positions-Schnittstelle
'==========================================================
Option Compare Database


'**********************************************************
'*            Variablen
'**********************************************************
Private cur_docId As String
Private cur_docType As String
Private cur_docName As String
Private cur_posTabl As String
Private cur_posForm As String


'**********************************************************
'*            Getters
'**********************************************************
' Aktueller Dokument-Id
Public Function get_cur_docId() As String
    Let get_cur_docId = Nz(cur_docId, "")
End Function

' Aktuelles Dokumententyp
Public Function get_cur_docType() As String
    Let get_cur_docType = cur_docType
End Function

' Aktuelles Dokumentenname
Public Function get_cur_docName() As String
    Let get_cur_docName = cur_docName
End Function

' Tabellenname für akt. Dokument
Public Function get_cur_posTabl() As String
    Let get_cur_posTabl = cur_posTabl
End Function

' Formular für akt. Dokument
Public Function get_cur_posForm() As String
    Let get_cur_posForm = cur_posForm
End Function

' Gibt Dokument-Id bei Positions-Id
Public Function get_docId_byPos(pin_posId As String) As String
    Let get_docId_byPos = Left(pin_posId, 8)
End Function


'**********************************************************
'*            Setters
'**********************************************************
' Aktueller Dokument setzen
Public Sub set_cur_docId(pin_docId As String)
    Let cur_docId = pin_docId
    Call init_cur_variables
End Sub

' Variablen initialisieren
Private Sub init_cur_variables()
    Let cur_docType = Nz(Mid(cur_docId, 6, 3), "")
    Let cur_posName = Nz(DLookup("doc_name", env.gt_infDoc, "doc_type = '" & cur_docType & "'"), "")
    Let cur_posTabl = Nz(DLookup("pos_tabl", env.gt_infDoc, "doc_type = '" & cur_docType & "'"), "")
    Let cur_posForm = Nz(DLookup("pos_form", env.gt_infDoc, "doc_type = '" & cur_docType & "'"), "")
End Sub
