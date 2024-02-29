Attribute VB_Name = "doc_tapi"
'==========================================================
'=                 Documents-Repositorie
'==========================================================
Option Compare Database


'**********************************************************
'*            POST (ins_)
'**********************************************************
Public Function ins_new_doc(pin_docId As String) As Integer
On Error GoTo exception
rcs:
    Dim rcsDoc As Recordset
    Set rcsDoc = CurrentDb.OpenRecordset(doc_api.get_cur_docTabl(), dbOpenDynaset, dbFailOnError)

    With rcsDoc
        .AddNew

        !id = pin_docId
        !dat = prd_api.get_date()

        .Update
    End With
    
    Let ins_new_doc = 201 ' Createt
    GoTo ende
    
exception:
    Let ins_new_doc = 400 ' Bad request

ende:
    If Not rcsDoc Is Nothing Then
        rcsDoc.Close
    End If
End Function


'**********************************************************
'*            GET (sel_, check_docExist[_byId])
'**********************************************************
' Dokument exixtiert
Public Function check_docExist(pin_docId As String) As Boolean
    Let check_docExist = DCount("id", doc_api.get_cur_docTabl, "id = '" & pin_docId & "'") > 0
End Function

' Dokument freigegeben
Public Function chk_rls_doc(pin_docId As String) As Boolean
    Let chk_rls_doc = DLookup("rls", doc_api.get_cur_docTabl, "id = '" & pin_docId & "'")
End Function

' Anzahl positionen
Public Function sel_cnt_pos(pin_docId As String) As Integer
    Let sel_cnt_pos = DCount("pos_id", doc_api.get_cur_docView, "doc_id = '" & pin_docId & "'")
End Function


' Endestand berechnen (sum_)
' ToDo: Sollte im View die Spalte doc_id hinzufügen, LEFT(...) -> doc_id = ''
Public Function sum_bnkAmt(pin_docId As String) As Double
    Let sum_bnkAmt = DSum("amt", _
                          env.gv_grb, _
                          "ad_id = " & doc_api.get_def_accId() & " AND " & _
                          "(prd <= " & prd_api.get_cur_prd() & " OR " & _
                          "doc_id = '" & pin_docId & "')")
End Function

' Monats Ausgaben
' ToDos: Brauche ich pin_docId?
Public Function sum_exp(pin_docId As String) As Double
    Const lc_traDcs As String = "Ausgaben"

    Let sum_exp = DSum("amt", _
                       env.gv_grb, _
                       "ta_dsg = '" & lc_traDcs & "' AND " & _
                       "prd = " & prd_api.get_cur_prd())
End Function

' Monats Einkommen
Public Function sum_inc(pin_docId As String) As Double
    Const lc_traDcs As String = "Einkommen"

    Let sum_inc = DSum("amt", _
                       env.gv_grb, _
                       "ta_dsg = '" & lc_traDcs & "' AND " & _
                       "prd = " & prd_api.get_cur_prd())
End Function


' Monats Transaktionen
Public Function sum_dps(pin_docId As String) As Double
    Const lc_traDcs As String = "Überweisungen"

    Let sum_dps = DSum("amt", _
                       env.gv_grb, _
                       "ta_dsg = '" & lc_traDcs & "' AND " & _
                       "prd = " & prd_api.get_cur_prd())
End Function



'**********************************************************
'*            PUT (upd_)
'**********************************************************
' Setzt Freigabe-Flag
Public Function upd_rls(pin_docId As String, pin_rls As Boolean) As Integer
On Error GoTo exception
sql:
    Dim updSql As String
    Let updSql = "UPDATE " & doc_api.get_cur_docTabl() & _
                   " SET rls = " & IIf(pin_rls, 1, 0) & _
                 " WHERE id = '" & pin_docId & "';"
    
    Call CurrentDb.Execute(updSql, dbFailOnError)
    
    Let upd_rls = 200   ' OK
    Exit Function
exception:
    Debug.Print Err.Number & " - " & Err.description
    Let upd_rls = 400   ' Bad
End Function

' Setzt Dokument-Betrag
Public Function upd_amt(pin_docId As String, pin_amt As Double) As Integer
On Error GoTo exception
sql:
    Dim updSql As String
    Let updSql = "UPDATE " & doc_api.get_cur_docTabl() & _
                   " SET amt = " & Replace(pin_amt, ",", ".") & _
                 " WHERE id = '" & pin_docId & "';"
    
    Call CurrentDb.Execute(updSql, dbFailOnError)

    Let upd_amt = 200   'Ok
    Exit Function
exception:
    Debug.Print Err.Number & " - " & Err.description
    Let upd_amt = 400   ' Bad
End Function
