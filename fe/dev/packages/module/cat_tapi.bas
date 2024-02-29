Attribute VB_Name = "cat_tapi"
'==========================================================
'=                 CRUD's für catalogs-Tabellen
'==========================================================
Option Compare Database

' ToDo:
'    - Fehler durch Messeger ersetzen

'**********************************************************
'*            CRUD's
'**********************************************************
' add - create
' get - read
' upd - update
' del - delete
'---------------------------------------------------------
'-       add
'----------------------------------------------------------
Public Function add_new_itm(pin_itm As String, pin_dsg As String, Optional pin_prtId As Integer) As Integer
On Error GoTo exception
    Dim addSql As String
    Let addSql = "INSERT INTO " & get_tbl(pin_itm) & _
                 "       (designation" & IIf(pin_prtId > 0, ", " & get_prt(pin_itm), "") & ") " & _
                 "VALUES ('" & pin_dsg & IIf(pin_prtId > 0, "', " & pin_prtId, "'") & ")"

    Call CurrentDb.Execute(addSql)

    Let add_new_itm = 200 ' Succefull
    Exit Function
    
exception:
    Let add_new_itm = 400 ' Failed
End Function


'---------------------------------------------------------
'-       get
'----------------------------------------------------------


' Wenn < 1, Item existiert nicht
Public Function get_itmCnt_byDsg(pin_itm As String, pin_itmDsg As String) As Integer
    Let get_itmCnt_byDsg = DCount("id", get_tbl(pin_itm), "designation = '" & pin_itmDsg & "'")
End Function

' Wenn > 0, Item hat Abhängigkeiten
Public Function get_cldCnt_byId(pin_itm As String, pin_itmId As Integer) As Integer
    ' Prüfen, ob Item überhaupt Child-Items hat
    If Not get_cldExt_byItm(pin_itm) Then
        Let get_cldCnt_byId = 0
        Exit Function
    End If
    
    ' Wenn Abhängigkeiten möglich sind, Anzahl davon berechnen
    Let get_cldCnt_byId = DCount("id", _
                                 get_tbl(get_cld_itm(pin_itm)), _
                                 get_prt(get_cld_itm(pin_itm)) & " = " & pin_itmId)
End Function

' Hat der Item einen Eltern-Item
Public Function get_prtExt_byItm(pin_itm As String) As Boolean
    Let get_prtExt_byItm = get_prt(pin_itm) <> ""
End Function

' Hat der Item einen Kind-Item
Public Function get_cldExt_byItm(pin_itm As String) As Boolean
    Let get_cldExt_byItm = get_cld_itm(pin_itm) <> ""
End Function

' Hat der Item einen Rang
Public Function get_rnkExt_byId(pin_itm As String, pin_itmId As Integer) As Boolean
    Let get_rnkExt_byId = Nz(DLookup("rank", get_tbl(pin_itm), "id = " & pin_itmId), "") <> ""
End Function

' Ist Item Aktiv
Public Function get_itmAct_byId(pin_itm As String, pin_itmId As Integer) As Boolean
    Let get_itmAct_byId = DLookup("active", get_tbl(pin_itm), "id = " & pin_itmId)
End Function


'---------------------------------------------------------
'-       del
'----------------------------------------------------------
' del
Public Function del_itm_byId(pin_itm As String, pin_itmId As Integer) As Integer
On Error GoTo exception
    
    Dim delSql As String
    Let delSql = "DELETE FROM " & get_tbl(pin_itm) & _
                 " WHERE id = " & pin_itmId

    Call CurrentDb.Execute(delSql)

    Let del_itm_byId = 200  ' Succefull
    Exit Function
    
exception:
    Let del_itm_byId = 400  ' Failed
End Function

'---------------------------------------------------------
'-       Hilfsfunktionen mit der Tabelle cat_infos
'----------------------------------------------------------
Private Function get_tbl(pin_itm As String) As String
    Let get_tbl = DLookup("itm_tabl", env.gt_infCat, "itm_name = '" & pin_itm & "'")
End Function

Private Function get_prt(pin_itm As String) As String
    Let get_prt = Nz(DLookup("prt_item", env.gt_infCat, "itm_name = '" & pin_itm & "'"), "")
End Function

Private Function get_cld_itm(pin_itm As String) As String
    Let get_cld_itm = Nz(DLookup("cld_item", env.gt_infCat, "itm_name = '" & pin_itm & "'"), "")
End Function
