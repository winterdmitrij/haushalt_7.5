Attribute VB_Name = "bal_xapi"
''========================================================================================
''=                 Bilanz-API
''========================================================================================
'Option Compare Database
'' Tabellenkonstanten
'
'' Datentype balance prd, ad_id, beg, inc, exp, tra
'
'
'' ToDo: Möglichkeit hinzufügen, für den ganzen Jahr berechnen
''*******************************************|********************************************
''*            Bilanz berechnen (recalc_)
''* Version:
''****************************************************************************************
'Public Sub recalc_bal(pin_prd As Integer)
'    Dim l_req As Integer
'    Dim l_msg As String
'
'chk_bal:
'    If bal_tapi.check_prdExist(pin_prd) Then
'        ' Alles für das Zeitraum löschen
'        Let l_req = bal_tapi.del_all_byPrd(pin_prd)
'
'        If l_req = 400 Then
'            Let l_msg = "Fehler beim Bilanz-DELETE für Zeitraum: " & pin_prd
'            GoTo ende
'        End If
'    End If
'
'insert:
'    Let l_req = bal_tapi.ins_new_bal(pin_prd)
'
'    If l_req = 400 Then
'        Let l_msg = "Fehler beim Bilanz-INSERT für Zeitraum: " & pin_prd
'        GoTo ende
'    End If
'
'    Let l_msg = "Bilanz für den Zeitraum: " & cur_prd & " ist berechnet!"
'ende:
'    MsgBox l_msg
'End Sub
'
'
''**********************************************************
''*            String-Sql erstellen (cre_strSql_)
''**********************************************************
'' Beginstand
'Public Function cre_strSql_begStd(pin_prd As Integer) As String
'    Let cre_strSql_begStd = "(SELECT Nz(SUM(grb.amt), 0)" & _
'                               " FROM " & env.gt_grb & " AS grb " & _
'                              " WHERE Format(grb.dat, 'yymm') < " & pin_prd & _
'                              " AND grb.ad_id = ad.id)"
'End Function
'
'' Summe der Monats-Transaktionen gt_cat_ta
'Public Function cre_strSql_taSum(pin_taDsg As String, pin_prd As Integer) As String
'    Let cre_strSql_taSum = "(SELECT Nz(SUM(grb.amt), 0)" & _
'                             " FROM (((" & env.gt_grb & " AS grb " & _
'                             "LEFT JOIN " & env.gt_cat_pd & " AS pd ON pd.id = grb.pd_id) " & _
'                             "LEFT JOIN " & env.gt_cat_pg & " AS pg ON pg.id = pd.pg_id) " & _
'                             "LEFT JOIN " & env.gt_cat_ta & " AS ta ON ta.id = pg.ta_id)" & _
'                            " WHERE Format(grb.dat, 'yymm') = " & pin_prd & _
'                              " AND grb.ad_id = ad.id" & _
'                              " AND ta.designation = '" & pin_taDsg & "')"
'End Function
