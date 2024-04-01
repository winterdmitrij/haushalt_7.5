Attribute VB_Name = "catprd_tapi"
'========================================================================================
'=                 Katalog "Zeitraum" - Repositorie
'= Version: 7.6
'========================================================================================
Option Compare Database
Private Const c_catPrd_tblName As String = "cat_periods"


'*************************************** P O S T ****************************************
'*******************************************|********************************************
'*       Fügt das neue Zeitraum hinzu
'* Version: 7.6
'****************************************************************************************
Public Function insert_new_prd(pin_prd As Integer) As Integer
On Error GoTo exception

    Dim l_addSql As String
    Let l_addSql = "INSERT INTO " & c_catPrd_tblName & _
                   "       (period) " & _
                   "VALUES (" & pin_prd & ")"
                 
    Call CurrentDb.Execute(l_addSql)
    
    Let insert_new_prd = 200
    Exit Function

exception:
    Let insert_new_prd = 400
End Function


'**************************************** G E T *****************************************
'*******************************************|********************************************
'*       Gibt das maximale gespeicherte Zeitraum zurück
'* Version: 7.6
'****************************************************************************************
Public Function find_maxPrd() As Integer
    Let find_maxPrd = Nz(DMax("period", c_catPrd_tblName), 0)
End Function

'****************************************************************************************
'*       Prüft, ob das Zeitraum bereits in der Tabelle existiert
'* Version: 7.6
'****************************************************************************************
Public Function check_prdExist(pin_prd As Integer) As Boolean
    Let check_prdExist = DCount("period", c_catPrd_tblName, "period = " & pin_prd) > 0
End Function
