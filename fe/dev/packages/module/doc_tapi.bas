Attribute VB_Name = "doc_tapi"
'========================================================================================
'=                 Documents-Repositorie
'= Version: 7.5
'========================================================================================
Option Compare Database
Private Const c_docAst_viewName As String = "doc_assets_v"
Private Const c_docBnk_viewName As String = "doc_banks_v"
Private Const c_docDep_viewName As String = "doc_deposits_v"
Private Const c_docExp_viewName As String = "doc_expenditures_v"
Private Const c_docInc_viewName As String = "doc_incomes_v"


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
'*       Prüft, ob der Post bereits benutzt wurde
'* Version: 7.5
'* ToDo: Verbessern! Vllt. eine Dok-Tabellen lieste, und durch Loop wenn l_inUse True mach weiter
'****************************************************************************************
Public Function check_pstDtl_inUse(pin_pdId As Integer) As Boolean
    Dim l_inUse As Boolean
    
    Let l_inUse = DCount("pos_id", c_docExp_viewName, "pd_id=" & pin_pdId) > 0
    
    If Not l_inUse Then
        Let l_inUse = DCount("pos_id", c_docBnk_viewName, "pd_id=" & pin_pdId) > 0
    End If
    
    If Not l_inUse Then
        Let l_inUse = DCount("pos_id", c_docInc_viewName, "pd_id=" & pin_pdId) > 0
    End If
    
    ' Bei Deposits gibt keine Posten
'    If Not l_inUse Then
'        Let l_inUse = DCount("pos_id", c_docDep_viewName, "pd_id=" & pin_pdId) > 0
'    End If
    
    If Not l_inUse Then
        Let l_inUse = DCount("pos_id", c_docAst_viewName, "pd_id=" & pin_pdId) > 0
    End If
    
    Let check_pstDtl_inUse = l_inUse
End Function


'****************************************************************************************
'*       Prüft, ob das Konto bereits benutzt wurde
'* Version: 7.5
'* ToDo: Konten sind nur im Deposits-Dokumenten, Muss noch grb-Tabelle geprüft werden
'*       zB: Sparkasse und Brieftasche geben Falsch zurück.
'****************************************************************************************
Public Function check_accDtl_inUse(pin_adId As Integer) As Boolean
    Dim l_inUse As Boolean
    Let l_inUse = DCount("pos_id", c_docDep_viewName, "ad_id=" & pin_adId) > 0
    
    Let check_accDtl_inUse = l_inUse
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
