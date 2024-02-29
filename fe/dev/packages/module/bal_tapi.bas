Attribute VB_Name = "bal_tapi"
'==========================================================
'=                 Bilanz-Repositorie
'==========================================================
Option Compare Database


'**********************************************************
'*            POST (ins_)
'**********************************************************
Public Function ins_new_bal(pin_prd As Integer) As Integer
On Error GoTo excepton
    Dim insSql As String
    Let insSql = "INSERT INTO " & env.gt_rpt_bal & _
                       " (prd, ad_id, beg, inc, exp, tra) " & _
                 "SELECT " & pin_prd & " AS prd, " & _
                         "ad.id          AS ad_id, " & _
                          bal_xapi.cre_strSql_begStd(pin_prd) & " AS beg, " & _
                          bal_xapi.cre_strSql_taSum(env.gc_taDsc_inc, pin_prd) & " AS inc, " & _
                          bal_xapi.cre_strSql_taSum(env.gc_taDsc_exp, pin_prd) & " AS exp, " & _
                          bal_xapi.cre_strSql_taSum(env.gc_taDsc_tra, pin_prd) & " AS tra " & _
                    "FROM cat_accounts AS ad;"

'    Debug.Print insSql
    Call CurrentDb.Execute(insSql)

    Let ins_new_bal = 201   ' Created
    Exit Function

excepton:
    Debug.Print Err.Number & " - " & Err.description
    Let ins_new_bal = 400   ' Bad
End Function


'**********************************************************
'*            GET (sel_, chk_ext_)
'**********************************************************
' Existenz prüfen
Public Function chk_ext_prd(pin_prd As Integer) As Boolean
    Let chk_ext_prd = DCount("prd", env.gt_rpt_bal, "prd = " & pin_prd) > 0
End Function

'**********************************************************
'*            DELETE (del_)
'**********************************************************
Public Function del_all_byPrd(pin_prd As Integer) As Integer
On Error GoTo exception
    Dim delSql As String
    Let delSql = "DELETE FROM " & env.gt_rpt_bal & _
                 " WHERE prd = " & pin_prd & ";"

    Call CurrentDb.Execute(delSql)
    
    Let del_all_byPrd = 200 ' Ok
    Exit Function
exception:
    Debug.Print Err.Number & " - " & Err.description
    Let del_all_byPrd = 400 ' Bad
End Function
