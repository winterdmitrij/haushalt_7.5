Attribute VB_Name = "catpst_tapi"
'========================================================================================
'=                 Katalog "Posten" - Repositorie
'= Version: 7.6
'========================================================================================
Option Compare Database
Private Const c_pstGrp_tabName As String = "cat_postgroups"
Private Const c_pstDtl_tabName As String = "cat_posts"
Private Const c_catPst_viewName As String = "cat_posts_v"


'*************************************** P O S T ****************************************
'*******************************************|********************************************
'*       Insertet ein neuen Eintrag in die Postgruppen-Tabelle
'* Version: 7.6
'****************************************************************************************
Public Function insert_new_pstGrp(pin_pgDsg As String, _
                                  pin_taId As Integer) As Integer
On Error GoTo exception
    Dim addSql As String
    Let addSql = "INSERT INTO " & c_pstGrp_tabName & _
                 "       (designation, ta_id) " & _
                 "VALUES ('" & pin_pgDsg & "', " & pin_taId & ")"

    Call CurrentDb.Execute(addSql)

    Let insert_new_pstGrp = 200 ' Succefull
    Exit Function
    
exception:
    Debug.Print Err.description
    Let insert_new_pstGrp = 400 ' Failed
End Function

'****************************************************************************************
'*       Insertet ein neuen Eintrag in die Posten-Tabelle
'* Version: 7.6
'****************************************************************************************
Public Function insert_new_pstDtl(pin_pdDsg As String, _
                                  pin_pgId As Integer) As Integer
On Error GoTo exception
    Dim addSql As String
    Let addSql = "INSERT INTO " & c_pstDtl_tabName & _
                 "       (designation, pg_id) " & _
                 "VALUES ('" & pin_pdDsg & "', " & pin_pgId & ")"

    Call CurrentDb.Execute(addSql)

    Let insert_new_pstDtl = 200 ' Succefull
    Exit Function
    
exception:
    Debug.Print Err.description
    Let insert_new_pstDtl = 400 ' Failed
End Function


'**************************************** G E T *****************************************
'*******************************************|********************************************
'*       Gibt die ganze Zeile bzgl. Post-Id zurück
'* Version: 7.6
'****************************************************************************************
Public Function read_pdRow_by_pdId(pin_pdId As Integer) As pstDtl_rowType
On Error GoTo exception
    Dim r_pstDtl As pstDtl_rowType
    
    ' Recordset erhalten
    Dim rcs_pst As Recordset
    Set rcs_pst = CurrentDb.OpenRecordset(c_catPst_viewName, dbOpenDynaset)
    
    ' Suchen und prüfung, ob was gefunden wurde
    Call rcs_pst.FindFirst("pd_id=" & pin_pdId)
    If rcs_pst.NoMatch Then
        Debug.Print "Post mit dem ID: " & pin_pdId & " existiert nicht!"
        GoTo ende
    End If
    
    ' Recordset durchgehen
    With rcs_pst

        Let r_pstDtl.rank = !rank
        Let r_pstDtl.ta_id = !ta_id
        Let r_pstDtl.ta_dsg = !ta_dsg
        Let r_pstDtl.pg_id = !pg_id
        Let r_pstDtl.pg_dsg = !pg_dsg
        Let r_pstDtl.pg_act = !pg_act
        Let r_pstDtl.pd_id = !pd_id
        Let r_pstDtl.pd_dsg = !pd_dsg
        Let r_pstDtl.pd_act = !pd_act
        Let r_pstDtl.pd_csh = !pd_csh
        Let r_pstDtl.pd_trf = !pd_trf
            
    End With
    
    ' Ergebnis zurückgeben
    Let read_pdRow_by_pdId = r_pstDtl
    GoTo ende

exception:
    Debug.Print Err.description
ende:
    If Not rcs_pst Is Nothing Then
        rcs_pst.Close
    End If
End Function

'****************************************************************************************
'*       Prüft, ob die Postgruppe mit der Bezeichnung exixtiert
'* Version: 7.6
'****************************************************************************************
Public Function check_pgExist(pin_pgDsg As String) As Boolean
    Let check_pgExist = (DCount("id", c_pstGrp_tabName, "designation = '" & pin_pgDsg & "'") > 0)
End Function

'****************************************************************************************
'*       Prüft, ob den Post mit der Bezeichnung exixtiert
'* Version: 7.6
'****************************************************************************************
Public Function check_pdExist(pin_pdDsg As String) As Boolean
    Let check_pdExist = (DCount("id", c_pstDtl_tabName, "designation = '" & pin_pdDsg & "'") > 0)
End Function

'****************************************************************************************
'*       Prüft, ob die Postgruppe mit dem Id aktiv ist
'* Version: 7.6
'****************************************************************************************
Public Function check_pgActiv(pin_pgId As Integer) As Boolean
    Let check_pgActiv = DLookup("active", c_pstGrp_tabName, "id=" & pin_pgId)
End Function

'****************************************************************************************
'*       Prüft, ob den Post mit dem Id aktiv ist
'* Version: 7.6
'****************************************************************************************
Public Function check_pdActiv(pin_pdId As Integer) As Boolean
    Let check_pdActiv = DLookup("active", c_pstDtl_tabName, "id=" & pin_pdId)
End Function

'****************************************************************************************
'*       Gibt die Posten-Anzahl zurück, die zu den Postgruppe-Id gehören
'* Version: 7.6
'****************************************************************************************
Public Function select_cntPstDtl_by_pgId(pin_pgId As Integer) As Integer
    Let select_cntPstDtl_by_pgId = DCount("id", c_pstDtl_tabName, "pg_id=" & pin_pgId)
End Function


'************************************* D E L E T E **************************************
'*******************************************|********************************************
'*       Löscht die Postgruppe
'* Version: 7.6
'****************************************************************************************
Public Function delete_pstGrp_by_pgId(pin_pgId As Integer) As Integer
On Error GoTo exception
    
    Dim delSql As String
    Let delSql = "DELETE FROM " & c_pstGrp_tabName & _
                 " WHERE id = " & pin_pgId

    Call CurrentDb.Execute(delSql)

    Let delete_pstGrp_by_pgId = 200  ' Succefull
    Exit Function
    
exception:
    Let delete_pstGrp_by_pgId = 400  ' Failed
End Function

'****************************************************************************************
'*       Löscht den Post
'* Version: 7.6
'****************************************************************************************
Public Function delete_pstDtl_by_pdId(pin_pdId As Integer) As Integer
On Error GoTo exception
    
    Dim delSql As String
    Let delSql = "DELETE FROM " & c_pstDtl_tabName & _
                 " WHERE id = " & pin_pdId

    Call CurrentDb.Execute(delSql)

    Let delete_pstDtl_by_pdId = 200  ' Succefull
    Exit Function
    
exception:
    Let delete_pstDtl_by_pdId = 400  ' Failed
End Function
