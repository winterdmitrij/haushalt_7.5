Attribute VB_Name = "prd_tapi"
'========================================================================================
'=                 Zeitraum-Repositorie
'= Version: 7.5
'========================================================================================
Option Compare Database


'*************************************** P O S T ****************************************
'*******************************************|********************************************
'*       Trägt das neue Zeitraum ein
'* Version: 7.5
'****************************************************************************************
Public Function create_newPrd(pin_prd As Integer, _
                              pin_tabName As String) As Integer
On Error GoTo exception

    Dim l_addSql As String
    Let l_addSql = "INSERT INTO " & pin_tabName & " (period) " & _
                   "VALUES (" & pin_prd & ")"
                 
    Call CurrentDb.Execute(l_addSql)
    
    Let create_newPrd = 200
    Exit Function

exception:
    Let create_newPrd = 400
End Function


'**************************************** G E T *****************************************
'*******************************************|********************************************
'*       Trägt den neuen Dokument in der aktuellen Dok-Tabelle ein
'* Version: 7.5
'****************************************************************************************
Public Function find_maxPrd(pin_tabName As String) As Integer
    Let find_maxPrd = Nz(DMax("period", pin_tabName), 0)
End Function

'****************************************************************************************
'*       Prüft, ob das Zeitraum bereits in der Tabelle existiert
'* Version: 7.5
'****************************************************************************************
Public Function check_prdExist(pin_prd As Integer, _
                               pin_tabName) As Boolean
    Let check_prdExist = DCount("period", pin_tabName, "period = " & pin_prd) > 0
End Function


'**********************************************************
'*            PUT (upd_)
'**********************************************************


'**********************************************************
'*            DELETE (del_)
'**********************************************************
