Attribute VB_Name = "pos_tapi"
'==========================================================
'=                 Positions-Repositorie
'==========================================================
Option Compare Database


'**********************************************************
'*            POST (ins_)
'**********************************************************
' neue Post-Position
Public Function ins_new_pstPos(pin_posId As String, pin_pstId As Integer) As Integer
On Error GoTo exception

    Dim insSql As String
    Let insSql = "INSERT INTO " & pos_api.get_cur_posTabl() & _
                       " (id, pd_id, doc_id) " & _
                 "VALUES ('" & pin_posId & "', " & pin_pstId & ", '" & pos_api.get_cur_docId & "')"
    
    Call CurrentDb.Execute(insSql)
    
    Let ins_new_pstPos = 200
    Exit Function
    
exception:
    Let ins_new_pstPos = 400
End Function

' neue Konto-Pisition
Public Function ins_new_accPos(pin_posId As String, get_accId As Integer) As Integer
On Error GoTo exception

    Dim insSql As String
    Let insSql = "INSERT INTO " & pos_api.get_cur_posTabl() & _
                       " (id, ad_id, doc_id) " & _
                 "VALUES ('" & pin_posId & "', " & get_accId & ", '" & pos_api.get_cur_docId & "')"

    Call CurrentDb.Execute(insSql)
    
    Let ins_new_accPos = 200
    Exit Function
    
exception:
    Let ins_new_accPos = 400
End Function


'**********************************************************
'*            GET (sel_, chk_ext_)
'**********************************************************
' Max Positions-Id
Public Function sel_max_posId(pin_docId As String) As String
    Let sel_max_posId = Nz(DMax("id", pos_api.get_cur_posTabl(), "doc_id = '" & pin_docId & "'"), _
                           pin_docId & "." & Format(0, "00"))
End Function


'**********************************************************
'*            PUT (upd_)
'**********************************************************
'


'**********************************************************
'*            DELETE (del_)
'**********************************************************
Public Function del_pos_byId(pin_posId As String) As Integer
On Error GoTo exception

    Dim delSql As String
    Let delSql = "DELETE FROM " & pos_api.get_cur_posTabl() & _
                 " WHERE id = '" & pin_posId & "';"

'    Debug.Print delSql
    Call CurrentDb.Execute(delSql)
    
    Let del_pos_byId = 200
    Exit Function
    
exception:
    Let del_pos_byId = 400
End Function
