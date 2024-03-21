Attribute VB_Name = "catacc_tapi"
'========================================================================================
'=                 Katalog "Konten" - Repositorie
'= Version:
'========================================================================================
Option Compare Database
Private Const c_accGrp_tabName As String = "cat_accountgroups"
Private Const c_accDtl_tabName As String = "cat_accounts"
Private Const c_catAcc_viewName As String = "cat_accounts_v"


'*************************************** P O S T ****************************************
'*******************************************|********************************************
'*       Insertet ein neuen Eintrag in die Kontengruppen-Tabelle
'* Version: 7.6
'****************************************************************************************
Public Function insert_new_accGrp(pin_agDsg As String) As Integer
On Error GoTo exception
    
    Dim addSql As String
    Let addSql = "INSERT INTO " & c_accGrp_tabName & _
                 "       (designation) " & _
                 "VALUES ('" & pin_agDsg & "')"

    Call CurrentDb.Execute(addSql)

    Let insert_new_accGrp = 200 ' Succefull
    Exit Function

exception:
    Debug.Print Err.description
    Let insert_new_accGrp = 400 ' Failed
End Function

'****************************************************************************************
'*       Insertet ein neuen Eintrag in die Konten-Tabelle
'* Version: 7.6
'****************************************************************************************
Public Function insert_new_accDtl(pin_adDsg As String, _
                                  pin_agId As Integer) As Integer
On Error GoTo exception
    
    Dim addSql As String
    Let addSql = "INSERT INTO " & c_accDtl_tabName & _
                 "       (designation, ag_id) " & _
                 "VALUES ('" & pin_adDsg & "', " & pin_agId & ")"

    Call CurrentDb.Execute(addSql)

    Let insert_new_accDtl = 200 ' Succefull
    Exit Function

exception:
    Debug.Print Err.description
    Let insert_new_accDtl = 400 ' Failed
End Function


'**************************************** G E T *****************************************
'*******************************************|********************************************
'*       Gibt die ganze Zeile bzgl. Konto-Id zurück
'* Version: 7.6
'****************************************************************************************
Public Function read_adRow_by_adId(pin_adId As Integer) As accDtl_rowType
On Error GoTo exception
    
    Dim r_accDtl As accDtl_rowType

    ' Recordset erhalten
    Dim rcs_acc As Recordset
    Set rcs_acc = CurrentDb.OpenRecordset(c_catAcc_viewName, dbOpenDynaset)
    
    ' Suchen und prüfung, ob was gefunden wurde
    Call rcs_acc.FindFirst("ad_id=" & pin_adId)

    If rcs_acc.NoMatch Then
        Debug.Print "Konto mit dem ID: " & pin_adId & " existiert nicht!"
        GoTo ende
    End If

    ' Recordset durchgehen
    With rcs_acc

        Let r_accDtl.rank = !rank
        Let r_accDtl.ag_id = !ag_id
        Let r_accDtl.ag_dsg = !ag_dsg
        Let r_accDtl.ag_shw = !ag_shw
        Let r_accDtl.ag_act = !ag_act
        Let r_accDtl.ad_id = !ad_id
        Let r_accDtl.ad_dsg = !ad_dsg
        Let r_accDtl.ad_shw = !ad_shw
        Let r_accDtl.ad_act = !ad_act
        Let r_accDtl.ad_sav = !ad_sav

    End With

    ' Ergebnis zurückgeben
    Let read_adRow_by_adId = r_accDtl
    GoTo ende

exception:
    Debug.Print Err.description
ende:
    If Not rcs_acc Is Nothing Then
        rcs_acc.Close
    End If
End Function

'****************************************************************************************
'*       Prüft, ob die Kontengruppe mit der Bezeichnung exixtiert
'* Version: 7.6
'****************************************************************************************
Public Function check_agExist(pin_agDsg As String) As Boolean
    Let check_agExist = (DCount("ag_id", c_catAcc_viewName, "ag_dsg='" & pin_agDsg & "'") > 0)
End Function

'****************************************************************************************
'*       Prüft, ob das Konto mit der Bezeichnung exixtiert
'* Version: 7.6
'****************************************************************************************
Public Function check_adExist(pin_adDsg As String) As Boolean
    Let check_adExist = (DCount("ad_id", c_catAcc_viewName, "ad_dsg='" & pin_adDsg & "'") > 0)
End Function

'****************************************************************************************
'*       Prüft, ob die Kontengruppe mit dem Id aktiv ist
'* Version: 7.6
'****************************************************************************************
Public Function check_agActiv(pin_agId As Integer) As Boolean
    Let check_agActiv = DLookup("active", c_accGrp_tabName, "id=" & pin_agId)
End Function

'****************************************************************************************
'*       Prüft, ob das Konto mit dem Id aktiv ist
'* Version: 7.6
'****************************************************************************************
Public Function check_adActiv(pin_adId As Integer) As Boolean
    Let check_adActiv = DLookup("active", c_accDtl_tabName, "id=" & pin_adId)
End Function

'****************************************************************************************
'*       Gibt die Konten-Anzahl zurück, die zu den Kontengruppe-Id gehören
'* Version: 7.6
'****************************************************************************************
Public Function select_cntAccDtl_by_agId(pin_agId As Integer) As Integer
    Let select_cntAccDtl_by_agId = DCount("id", c_accDtl_tabName, "ag_id=" & pin_agId)
End Function


'************************************* D E L E T E **************************************
'*******************************************|********************************************
'*       Löscht die Kontengruppe
'* Version: 7.6
'****************************************************************************************
Public Function delete_accGrp_by_agId(pin_agId As Integer) As Integer
On Error GoTo exception

    Dim delSql As String
    Let delSql = "DELETE FROM " & c_accGrp_tabName & _
                 " WHERE id = " & pin_agId

    Call CurrentDb.Execute(delSql)

    Let delete_accGrp_by_agId = 200  ' Succefull
    Exit Function

exception:
    Let delete_accGrp_by_agId = 400  ' Failed
End Function

'****************************************************************************************
'*       Löscht das Konto
'* Version: 7.6
'****************************************************************************************
Public Function delete_accDtl_by_adId(pin_adId As Integer) As Integer
On Error GoTo exception

    Dim delSql As String
    Let delSql = "DELETE FROM " & c_accDtl_tabName & _
                 " WHERE id = " & pin_adId

    Call CurrentDb.Execute(delSql)

    Let delete_accDtl_by_adId = 200  ' Succefull
    Exit Function

exception:
    Let delete_accDtl_by_adId = 400  ' Failed
End Function
