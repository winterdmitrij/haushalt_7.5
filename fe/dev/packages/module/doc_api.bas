Attribute VB_Name = "doc_api"
'==========================================================
'=                 Documents-Schnittstelle
'==========================================================
Option Compare Database


'**********************************************************
'*            Variablen
'**********************************************************
Private cur_docId As String
Private cur_docType As String
Private cur_docTabl As String
Private cur_docView As String
Private cur_rlsView As String
Private cur_docForm As String
Private def_accId As Integer


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

' Tabellenname für akt. Dokument
Public Function get_cur_docTabl() As String
    Let get_cur_docTabl = cur_docTabl
End Function

' Ansichtname für akt. Dokument
Public Function get_cur_docView() As String
    Let get_cur_docView = cur_docView
End Function

' Freigabe-Ansicht für akt. Dokument
Public Function get_cur_rlsView() As String
    Let get_cur_rlsView = cur_rlsView
End Function

' Formular für akt. Dokument
Public Function get_cur_docForm() As String
    Let get_cur_docForm = cur_docForm
End Function

' default Konto
Public Function get_def_accId() As Integer
    Let get_def_accId = def_accId
End Function
'**********************************************************
'*           Setters
'**********************************************************
' Aktuellen Dokument setzen
Public Sub set_cur_docId(pin_docId As String)
    Let cur_docId = pin_docId
    Call init_cur_variables
End Sub

' Variablen initialisieren
Private Sub init_cur_variables()
    Let cur_docType = Nz(Mid(cur_docId, 6, 3), "")
    Let cur_docTabl = Nz(DLookup("doc_tabl", env.gt_infDoc, "doc_type = '" & cur_docType & "'"), "")
    Let cur_docView = Nz(DLookup("doc_view", env.gt_infDoc, "doc_type = '" & cur_docType & "'"), "")
    Let cur_rlsView = Nz(DLookup("rls_view", env.gt_infDoc, "doc_type = '" & cur_docType & "'"), "")
    Let cur_docForm = Nz(DLookup("doc_form", env.gt_infDoc, "doc_type = '" & cur_docType & "'"), "")
    Let def_accId = Nz(DLookup("def_acc", env.gt_infDoc, "doc_type = '" & cur_docType & "'"), 0)
End Sub
