Attribute VB_Name = "curdoc_api"
'========================================================================================
'=                 Aktueller Document-Schnittstelle
'= Version: 7.5
'========================================================================================
Option Compare Database

Private g_curDocId As String
Private g_curDocInf As docInf

'************************************ G E T T E R S *************************************
'*******************************************|********************************************
'*       Gibt aktuellen Dokument-Id zurück
'****************************************************************************************
Public Function get_curDocId()              ' ToDo: Fall mit Nullen Id berücksichtigen
    Let get_curDocId = g_curDocId
End Function

'****************************************************************************************
'*       Gibt aktuellen Dokument-Information zurück
'****************************************************************************************
Public Function get_curDocInf() As docInf
    Let get_curDocInf = g_curDocInf
End Function


'************************************ S E T T E R S *************************************
'*******************************************|********************************************
'*       Setzt aktuellen Dokument-Id
'****************************************************************************************
Public Sub set_curDocId(pin_docId As String)
    Let g_curDocId = pin_docId
    
    ' aktuelle Dokument-Information setzen
    Call set_curDocInf
End Sub

'****************************************************************************************
'*       Setzt aktuelle Dokument-Information
'****************************************************************************************
Private Sub set_curDocInf()
    Let g_curDocInf = docinfo_api.get_docInf_by_docId(g_curDocId)
End Sub


'**************************** H I L F S F U N K T I O N E N *****************************
'*******************************************|********************************************
'*       Gibt DokumentenType bzg. Dokumenten-Id zurück
'****************************************************************************************
Private Function get_docType_by_docId(pin_docId As String) As String
    Let get_DocType_by_id = Nz(Mid(pin_docId, 6, 3), "")
End Function

'****************************************************************************************
'*       Prüft, ob den aktuellen Dokument bereits existtiert
'****************************************************************************************
Public Function check_curDocExist() As Boolean
    Let check_curDocExist = DCount("id", g_curDocInf.doc_tabl, "id = '" & g_curDocId & "'") > 0
End Function
