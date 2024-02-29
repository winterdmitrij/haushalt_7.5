Attribute VB_Name = "z_mdlKS"
'Option Compare Database
'Const tmpTblName = "tmp_Kontenstand"
'
''=============== Temporäte Tabelle füllen ==================
'Sub createTmpTbl(pin_jahr As Integer)
'    Dim curKg As String
'    Let curKg = ""
'    Dim curArt As String
'    Dim curName As String
'    Dim zellerKg As Integer
'    Let zellerKg = 0
'    Dim zellerKd As Integer
'    Let zellerKd = 0
'
'    Dim rcsKi As Recordset
'    Set rcsKi = CurrentDb.OpenRecordset("qry_konteninformation")
'
'    ' Tabelle leeren
'    Call leereTabelle(tmpTblName)
'
'    Dim rcsKs As Recordset
'    Set rcsKs = CurrentDb.OpenRecordset(tmpTblName, dbOpenDynaset)
'
'    ' Alle Konten durchgehen
'    Do Until rcsKi.EOF
'        If rcsKi!kontengruppe = curKg Then
'            zellerKd = zellerKd + 1
'            curArt = "konto"
'            curName = rcsKi!konto
'        Else
'            zellerKg = zellerKg + 1
'            zellerKd = 0
'            curArt = "kontengruppe"
'            curKg = rcsKi!kontengruppe
'            curName = rcsKi!kontengruppe
'        End If
'        With rcsKs
'            .AddNew
'
'            !id = zellerKg * 10 + zellerKd
'            !kName = curName
'            !art = curArt
'            ' Jetz Jahr = 2022 hartprogrammiert
'            !vorjahr = getVorjahrwert(curArt, curName, pin_jahr)
'            !stornoJan = getMonatsSaldo(curArt, curName, 1, pin_jahr)
'            !standJan = getMonatsendeStand(curArt, curName, 1, pin_jahr)
'            !stornoFeb = getMonatsSaldo(curArt, curName, 2, pin_jahr)
'            !standFeb = getMonatsendeStand(curArt, curName, 2, pin_jahr)
'            !stornoMrz = getMonatsSaldo(curArt, curName, 3, pin_jahr)
'            !standMrz = getMonatsendeStand(curArt, curName, 3, pin_jahr)
'            !stornoApr = getMonatsSaldo(curArt, curName, 4, pin_jahr)
'            !standApr = getMonatsendeStand(curArt, curName, 4, pin_jahr)
'            !stornoMai = getMonatsSaldo(curArt, curName, 5, pin_jahr)
'            !standMai = getMonatsendeStand(curArt, curName, 5, pin_jahr)
'            !stornoJun = getMonatsSaldo(curArt, curName, 6, pin_jahr)
'            !standJun = getMonatsendeStand(curArt, curName, 6, pin_jahr)
'            !stornoJul = getMonatsSaldo(curArt, curName, 7, pin_jahr)
'            !standJul = getMonatsendeStand(curArt, curName, 7, pin_jahr)
'            !stornoAug = getMonatsSaldo(curArt, curName, 8, pin_jahr)
'            !standAug = getMonatsendeStand(curArt, curName, 8, pin_jahr)
'            !stornoSep = getMonatsSaldo(curArt, curName, 9, pin_jahr)
'            !standSep = getMonatsendeStand(curArt, curName, 9, pin_jahr)
'            !stornoOkt = getMonatsSaldo(curArt, curName, 10, pin_jahr)
'            !standOkt = getMonatsendeStand(curArt, curName, 10, pin_jahr)
'            !stornoNov = getMonatsSaldo(curArt, curName, 11, pin_jahr)
'            !standNov = getMonatsendeStand(curArt, curName, 11, pin_jahr)
'            !stornoDez = getMonatsSaldo(curArt, curName, 12, pin_jahr)
'            !standDez = getMonatsendeStand(curArt, curName, 12, pin_jahr)
'            .Update
'        End With
'        If curArt = "konto" Then
'            rcsKi.MoveNext
'        End If
'    Loop
'
'    rcsKi.Close
'    rcsKs.Close
'End Sub
'
''========== Tabelle füllen ================================
''------------------- Vorjahrwert bekommen -----------------
'Private Function getVorjahrwert(pin_art As String, _
'                                pin_wert As String, _
'                                pin_jahr As Integer) As Currency
'    Dim sql As String
'    Let sql = "SELECT SUM(saldo) AS vorjahrstand " & _
'              "FROM qry_MonatsKontoSaldo " & _
'              "WHERE " & pin_art & " = '" & pin_wert & "' " & _
'              "AND jahr < " & pin_jahr & ";"
'
'    Dim rcsVj As Recordset
'    Set rcsVj = CurrentDb.OpenRecordset(sql)
'
'    If Not rcsVj.NoMatch Then
'        getVorjahrwert = Nz(rcsVj!vorjahrstand, 0)
'    Else
'        getVorjahrwert = 0
'    End If
'
'    rcsVj.Close
'End Function
'
''------------------ MonatsSaldo ermitteln ---------------------
'Private Function getMonatsSaldo(pin_art As String, _
'                                pin_wert As String, _
'                                pin_monat As Integer, _
'                                pin_jahr As Integer) As Currency
'    Dim sql As String
'    Let sql = "SELECT SUM(saldo) AS monatssaldo " & _
'              "FROM qry_MonatsKontoSaldo " & _
'              "WHERE " & pin_art & " = '" & pin_wert & "' " & _
'              "AND jahr = " & pin_jahr & " " & _
'              "AND monat = " & pin_monat & ";"
'
'    Dim rcsSaldo As Recordset
'    Set rcsSaldo = CurrentDb.OpenRecordset(sql)
'
'    If Not rcsSaldo.NoMatch Then
'        getMonatsSaldo = Nz(rcsSaldo!monatssaldo, 0)
'    Else
'        getMonatsSaldo = 0
'    End If
'
'    rcsSaldo.Close
'End Function
'
''----------------- MonatendeKontoStand ermitteln -----------------
'Private Function getMonatsendeStand(pin_art As String, _
'                                    pin_wert As String, _
'                                    pin_monat As Integer, _
'                                    pin_jahr As Integer) As Currency
'    Dim sql As String
'    Let sql = "SELECT SUM(saldo) AS monatsendestand " & _
'              "FROM qry_MonatsKontoSaldo " & _
'              "WHERE " & pin_art & " = '" & pin_wert & "' " & _
'              "AND (jahr < " & pin_jahr & " " & _
'              "OR (monat <= " & pin_monat & " " & _
'              "AND jahr = " & pin_jahr & "));"
'
'    Dim rcsStand As Recordset
'    Set rcsStand = CurrentDb.OpenRecordset(sql)
'
'    If Not rcsStand.NoMatch Then
'        getMonatsendeStand = Nz(rcsStand!monatsendestand, 0)
'    Else
'        getMonatsendeStand = 0
'    End If
'
'    rcsStand.Close
'End Function
'
'
''========== Tabelle leeren ================================
'Private Sub leereTabelle(pin_tblName As String)
'    Dim sql As String
'    Let sql = "DELETE FROM " & pin_tblName & ";"
'
'    CurrentDb.Execute sql
'End Sub
