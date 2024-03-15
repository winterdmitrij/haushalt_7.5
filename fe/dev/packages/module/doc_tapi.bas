Attribute VB_Name = "doc_tapi"
'========================================================================================
'=                 Documents-Repositorie
'= Version: 7.5
'========================================================================================
Option Compare Database


'*************************************** P O S T ****************************************
'*******************************************|********************************************
'*       Trägt den neuen Dokument in der aktuellen Dok-Tabelle ein
'* Version: 7.5
'****************************************************************************************
Public Function create_newDoc(pin_docId As String, _
                              pin_date As Date, _
                              pin_tabName As String) As Integer
On Error GoTo exception
    ' DokumentenTabelle-Rekordset
    Dim rcs_docTab As Recordset
    Set rcs_docTab = CurrentDb.OpenRecordset(pin_tabName, _
                                             dbOpenDynaset, _
                                             dbFailOnError)
    ' Neuer Dokument eintragen
    With rcs_docTab
        .AddNew

        !id = pin_docId
        !dat = pin_date

        .Update
    End With
    
    ' Erfolgreiche Rückmeldung
    Let create_newDoc = 201 ' Createt
    GoTo ende
    
exception:
    ' Missgelungene Rückmeldung
    Let create_newDoc = 400 ' Bad request

ende:
    If Not rcs_docTab Is Nothing Then
        rcs_docTab.Close
    End If
End Function


'**************************************** G E T *****************************************
'*******************************************|********************************************
'*       Prüft den Existenz des Dokuments
'* Version: 7.5
'****************************************************************************************
Public Function check_docExist(pin_docId As String, _
                               pin_tabName As String) As Boolean
    Let check_docExist = DCount("id", pin_tabName, "id = '" & pin_docId & "'") > 0
End Function

'****************************************************************************************
'*       Prüft, ob den Dokument freigegeben ist
'* Version: 7.5
'****************************************************************************************
Public Function check_docReleased(pin_docId As String, _
                                  pin_tabName As String) As Boolean
    Let check_docReleased = DLookup("rls", pin_tabName, "id = '" & pin_docId & "'")
End Function

'****************************************************************************************
'*       Berechnet die Positionen-Anzahl des Dokuments
'* Version: 7.5
'****************************************************************************************
Public Function calculate_posCount(pin_docId As String, _
                                   pin_viewName As String) As Integer
    Let calculate_posCount = DCount("pos_id", pin_viewName, "doc_id = '" & pin_docId & "'")
End Function

'****************************************************************************************
'*       Berechnet die Endsumme des Dokuments bzg den übergebenen Bedingungen
'* Version: 7.5
'****************************************************************************************
Public Function calculate_docAmount(pin_docId As String, _
                                    pin_viewName As String, _
                                    pin_cond As String) As Double
    Let calculate_docAmount = DSum("amt", pin_viewName, pin_cond)
End Function

'****************************************************************************************
'*       Berechnet die Endsumme des Dokuments bzg den übergebenen Bedingungen
'* Version: 7.5
'****************************************************************************************
Public Function select_cntPositions_by_pdId(pin_pdId As Integer) As Integer
    ' ToDo: View, die alle Dokumente beinhaltet
    Let select_cntPositions_by_pdId = 666 'DCount("amt", pin_viewName, pin_cond)
End Function


'**************************************** P U T *****************************************
'*******************************************|********************************************
'*       Setzt bzw löscht den Freigabe-Flag des überbebenen Dokuments
'* Version: 7.5
'****************************************************************************************
Public Function update_docRls(pin_docId As String, _
                              pin_tabName As String, _
                              pin_rls As Boolean) As Integer
On Error GoTo exception
    Dim l_updSql As String
    Let l_updSql = "UPDATE " & pin_tabName & _
                   " SET rls = " & IIf(pin_rls, 1, 0) & _
                   " WHERE id = '" & pin_docId & "';"
    
    Call CurrentDb.Execute(l_updSql, dbFailOnError)
    
    Let update_docRls = 200   ' OK
    Exit Function
exception:
    Debug.Print Err.Number & " - " & Err.description
    Let update_docRls = 400   ' Bad
End Function

'****************************************************************************************
'*       Setzt den Betrag des überbebenen Dokuments
'* Version: 7.5
'****************************************************************************************
Public Function update_docAmt(pin_docId As String, _
                              pin_tabName As String, _
                              pin_amt As Double) As Integer
On Error GoTo exception
    Dim l_updSql As String
    Let l_updSql = "UPDATE " & pin_tabName & _
                   " SET amt = " & Replace(pin_amt, ",", ".") & _
                   " WHERE id = '" & pin_docId & "';"
    
    Call CurrentDb.Execute(l_updSql, dbFailOnError)

    Let update_docAmt = 200   'Ok
    Exit Function
exception:
    Debug.Print Err.Number & " - " & Err.description
    Let update_docAmt = 400   ' Bad
End Function
