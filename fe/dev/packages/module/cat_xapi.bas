Attribute VB_Name = "cat_xapi"
'==========================================================
'=                 Kataloge-Controller
'==========================================================
Option Compare Database

'**********************************************************
'*            Erstellen einen neuen Item
'**********************************************************
Public Function create_item(pin_itm As String, pin_itmDsg As String, Optional pin_prtId As Integer) As String
    ' Bezeichnung pr�fen
    If Len(pin_itmDsg) <= 3 Then
        Let create_item = pin_itm & "-Bezeichnung ist zu kurz!"
        Exit Function
    End If
    
    ' Existenz des Items mit der gleichen Bezeichnung pr�fen
    If cat_tapi.get_itmCnt_byDsg(pin_itm, pin_itmDsg) > 0 Then
        Let create_item = pin_itm & " '" & pin_itmDsg & "' schon existiert!"
        Exit Function
    End If
    
    ' Volst�ndigkeit von �bergegebenen Daten pr�fen
    If pin_prtId < 1 And _
       cat_tapi.get_prtExt_byItm(pin_itm) Then
        Let create_item = "Es muss noch ElternItem-Id �bergeben werden!"
        Exit Function
    End If
    
    ' Antwort pr�fen
    Dim req As Integer
    Let req = cat_tapi.add_new_itm(pin_itm, pin_itmDsg, pin_prtId)
    
    If req = 200 Then
        Let create_item = pin_itm & " '" & pin_itmDsg & "' wurde erfolgreich hinzugef�gt!"
    Else
        Let create_item = pin_itm & " '" & pin_itmDsg & "' wurde nicht hinzugef�gt!"
    End If
End Function


'**********************************************************
'*            L�schen einen existierenden unaktiven Item
'**********************************************************
Public Function delete_item(pin_itm As String, pin_itmId As Integer) As String
    Dim msg As String
    Let msg = pin_itm & " mit ID: " & pin_itmId
    
    Dim errMsg As String
    Let errMsg = msg
    
' Anforderungen pr�fen
    ' Abh�ngigkeit pr�fen(wenn es notwendig)
    If cat_tapi.get_cldCnt_byId(pin_itm, pin_itmId) > 0 Then
        Let errMsg = errMsg & _
                     vbNewLine & "- hat noch abh�ngige Elemente"
    End If
    
    ' Rang pr�fen
    If cat_tapi.get_rnkExt_byId(pin_itm, pin_itmId) Then
        Let errMsg = errMsg & _
                     vbNewLine & "- hat noch den Rang"
    End If
        
    ' Aktivit�t pr�fen
    If cat_tapi.get_itmAct_byId(pin_itm, pin_itmId) Then
        Let errMsg = errMsg & _
                     vbNewLine & "- ist noch aktiv"
    End If
    
    If Len(errMsg) > Len(msg) Then
        Let delete_item = errMsg
        Exit Function
    End If

    ' Request pr�fen
    Dim req As Integer
    Let req = cat_tapi.del_itm_byId(pin_itm, pin_itmId)
    
    If req = 200 Then
        Let delete_item = msg & " wurde erfolgreich gel�scht."
    Else
        Let delete_item = "Fehler beim L�schen von " & msg
    End If
End Function




'
''----------------------------------------------------------------------------------------------------------
''**********************************************************
''*                 Posten
''**********************************************************
'' Erstellen
'Public Function create_pd(pin_pdDsg As String, pin_pgId As Integer) As String
'    ' Existenz des Posts pr�fen
'    If cat_tapi.get_pdCnt_byDsg(pin_pdDsg) > 0 Then
'        Let create_pd = "Post '" & pin_pdDsg & "' schon existiert."
'        Exit Function
'    End If
'
'    ' Postgruppe-Objekt
'    Dim cre_pd As pd_type
'    Let cre_pd.dsg = pin_pdDsg
'    Let cre_pd.pgid = pin_pgId
'
'    If cat_tapi.add_new_pd(cre_pd) <> 200 Then
'        Let create_pd = "Fehler passirte beim Einf�gen des Posts"
'        Exit Function
'    End If
'
'    Let create_pd = "Post '" & pin_pdDsg & "' wurde hinzugef�gt."
'End Function
'
'' L�schen
'Public Function delete_pd(pin_pdId As Integer) As String
'    Dim msg As String
'    Let msg = "Post mit ID: " & pin_pdId
'
'    ' L�schen darf nur die Postgruppen, die unaktiv sind und keinen Rang haben
'    If DLookup("active", env.tbl_pd, "id = " & pin_pdId) > 0 Or _
'       DLookup("rank", env.tbl_pd, "id = " & pin_pdId) <> "" Then
'        Let delete_pd = msg & " darf nicht gel�scht werden, da" & _
'                        vbNewLine & "- die den Rang hat, oder" & _
'                        vbNewLine & "- noch aktiv ist."
'        Exit Function
'    End If
'
'
'    If cat_tapi.del_pd_byId(pin_pdId) <> 200 Then
'        Let delete_pd = "Fehler passirte beim L�schen des Posts"
'        Exit Function
'    End If
'
'    Let delete_pd = msg & " wurde gel�scht."
'End Function
'
'
''**********************************************************
''*            Postengruppe
''**********************************************************
'' Erstellen
'Public Function create_pg(pin_pgDsg As String, pin_taId As Integer) As String
'    ' Existenz der Postgruppe pr�fen
'    If cat_tapi.get_pgCnt_byDsg(pin_pgDsg) > 0 Then
'        Let create_pg = "Postgruppe '" & pin_pgDsg & "' schon existiert."
'        Exit Function
'    End If
'
'    ' Postgruppe-Objekt
'    Dim cre_pg As pg_type
'    Let cre_pg.dsg = pin_pgDsg
'    Let cre_pg.taid = pin_taId
'
'    If cat_tapi.add_new_pg(cre_pg) <> 200 Then
'        Let create_pg = "Fehler passirte beim Einf�gen der Postgruppe"
'        Exit Function
'    End If
'
'    Let create_pg = "Postgruppe '" & pin_pgDsg & "' wurde hinzugef�gt."
'End Function
'
'
'' L�schen
'Public Function delete_pg(pin_pgId As Integer) As String
'    Dim msg As String
'    Let msg = "Postgruppe mit ID: " & pin_pgId
'
'    ' L�schen darf nur die Postgruppen, die unaktiv sind und keinen Rang und keine Abh�ngigkeiten haben
'    If DLookup("active", env.tbl_pg, "id = " & pin_pgId) > 0 Or _
'       DLookup("rank", env.tbl_pg, "id = " & pin_pgId) <> "" Or _
'       DCount("id", env.tbl_pd, "pg_id = " & pin_pgId) > 0 Then
'        Let delete_pg = msg & " darf nicht gel�scht werden, da" & _
'                        vbNewLine & "- die den Rang hat, oder" & _
'                        vbNewLine & "- noch aktiv ist, oder" & _
'                        vbNewLine & "- noch Posten hat."
'        Exit Function
'    End If
'
'    If cat_tapi.del_pg_byId(pin_pgId) <> 200 Then
'        Let delete_pg = "Fehler passirte beim L�schen der Postgruppe"
'        Exit Function
'    End If
'
'    Let delete_pg = msg & " wurde erfolgreich gel�scht!"
'End Function
'
'
'
'
''*****************************************************************************************
''*****************************************************************************************
'
'
'
'
'
'
'
''**********************************************************
''*            Kontengruppe
''**********************************************************
'' Hinzuf�gen Kontengruppe
'Public Function add_new_accGrp(pin_accGrpDsg As String) As String
'    ' Existenz der Kontengruppe pr�fen
'    If DCount("id", tbl_kg, "bez = '" & pin_accGrpDsg & "'") > 0 Then
'        Let add_new_accGrp = "Kontengruppe '" & pin_accGrpDsg & "' schon existiert."
'        Exit Function
'    End If
'
'    ' Insert-SQL
'    Dim strSql As String
'    Let strSql = "INSERT INTO " & tbl_kg & _
'                 "       (bez) " & _
'                 "VALUES ('" & pin_accGrpDsg & "')"
'
'    ' SQL ausf�hren
'    Call CurrentDb.Execute(strSql)
'    Let add_new_accGrp = "Kontengruppe '" & pin_accGrpDsg & "' wurde hinzugef�gt."
'End Function
'
'' L�schen Kontengruppe
'Public Function del_accGrp(pin_accGrpId As Integer) As String
'    Dim accGrpDsg As String
'    Let accGrpDsg = DLookup("bez", tbl_kg, "id = " & pin_accGrpId)
'
'    ' L�schen darf nur die Kontengruppen, die keinen Rang haben und keine abh�ngige Konten
'    If DCount("kdid", v_kd, "kgid = " & pin_accGrpId) > 0 Or _
'       DLookup("rng", tbl_kg, "id = " & pin_accGrpId) <> "" Then
'        Let del_accGrp = "Kontengruppe '" & accGrpDsg & "' darf nicht gel�scht werden"
'        Exit Function
'    End If
'
'    ' Delete-SQL
'    Dim strSq As String
'    Let strSql = "DELETE FROM " & tbl_kg & _
'                 " WHERE id = " & pin_accGrpId
'
'    ' SQL ausf�hren
'    Call CurrentDb.Execute(strSql)
'    Let del_accGrp = "Kontengruppe '" & accGrpDsg & "' wurde gel�scht."
'End Function
'
'
''**********************************************************
''*                 Konten
''**********************************************************
'' Hinzuf�gen
'Public Function add_new_acc(pin_accDsg As String, pin_accGrpId As Integer) As String
'    ' Existenz des Kontos pr�fen
'    If DCount("id", tbl_kd, "bez = '" & pin_accDsg & "'") > 0 Then
'        Let add_new_acc = "Konto '" & pin_accDsg & "' schon existiert."
'        Exit Function
'    End If
'
'    ' Insert-SQL
'    Dim strSql As String
'    Let strSql = "INSERT INTO " & tbl_kd & _
'                 "       (bez, kgid) " & _
'                 "VALUES ('" & pin_accDsg & "', " & pin_accGrpId & ")"
'
'    ' SQL ausf�hren
'    Call CurrentDb.Execute(strSql)
'    Let add_new_acc = "Konto '" & pin_accDsg & "' wurde hinzugef�gt."
'End Function
'
'' L�schen
'Public Function del_acc(pin_accId As Integer) As String
'    Dim accDsg As String
'    Let accDsg = DLookup("bez", tbl_kd, "id = " & pin_accId)
'
'    ' L�schen darf nur die Kontos, die unaktiv sind und keinen Rang haben
'    If DLookup("akt", tbl_kd, "id = " & pin_accId) > 0 Or _
'       DLookup("rng", tbl_kd, "id = " & pin_accId) <> "" Then
'        Let del_acc = "Konto '" & accDsg & "' darf nicht gel�scht werden"
'        Exit Function
'    End If
'
'    ' Delete-SQL
'    Dim strSq As String
'    Let strSql = "DELETE FROM " & tbl_kd & _
'                 " WHERE id = " & pin_accId
'
'    ' SQL ausf�hren
'    Call CurrentDb.Execute(strSql)
'    Let del_acc = "Konto '" & accDsg & "' wurde gel�scht."
'End Function


