Attribute VB_Name = "z_mdlKtInfo"
''**********************************************************
''*        MODUL: KontenInformation                        *
''* BESCHREIBUNG: Sammelt ganze Information über allen     *
''*               Kontos in der Tabelle tbl_Ki             *
''*    BEMERKUNG: ktin - KontoInfo-DS                      *
''**********************************************************
'Option Compare Database
'Const tblName = "tbl_ktin"
'
''============== Info ermitteln ============================
''-------- KontenId ----------------------------------------
'Private Function getKid(pin_kt As String) As String
'    Dim sql As String
'    Let sql = "SELECT kdid " & _
'              "FROM htbl_kd " & _
'              "WHERE bezeichnung = '" & pin_kt & "';"
'
'    Dim rcsKt As Recordset
'    Set rcsKt = CurrentDb.OpenRecordset(sql)
'
'    If rcsKt.RecordCount > 0 Then
'        getKid = Nz(rcsKt!kdid, "")
'    Else
'        getKid = ""
'    End If
'
'    rcsKt.Close
'End Function
'
''-------- Kontengruppe ------------------------------------
'Private Function getKg(pin_kt As String) As String
'    Dim sql As String
'    Let sql = "SELECT kgid " & _
'              "FROM htbl_kd " & _
'              "WHERE bezeichnung = '" & pin_kt & "';"
'
'    Dim rcsKt As Recordset
'    Set rcsKt = CurrentDb.OpenRecordset(sql)
'
'    If rcsKt.RecordCount > 0 Then
'        getKg = Nz(rcsKt!kgid, "")
'    Else
'        getKg = ""
'    End If
'
'    rcsKt.Close
'End Function
'
''-------- Vorstand ----------------------------------------
'Private Function getVs(pin_kt As String, pin_jahr As Integer, pin_mon As Integer) As Currency
'    Dim sql As String
'    Let sql = "SELECT SUM(saldo) AS vorstand " & _
'              "FROM qry_MonatsKontoSaldo " & _
'              "WHERE konto = '" & pin_kt & "' " & _
'              "AND (jahr < " & pin_jahr
'
'    If pin_mon = 1 Then
'        Let sql = sql & _
'                  ");"
'    Else
'        Let sql = sql & _
'                  " OR (jahr = " & pin_jahr & " " & _
'                  "AND monat < " & pin_mon & "));"
'    End If
'
'    Dim rcsKt As Recordset
'    Set rcsKt = CurrentDb.OpenRecordset(sql)
'
'    If rcsKt.RecordCount > 0 Then
'        getVs = Nz(rcsKt!vorstand, 0)
'    Else
'        getVs = 0
'    End If
'
'    rcsKt.Close
'End Function
'
''-------- Einkommen ---------------------------------------
'Private Function getEk(pin_kt As String, pin_jahr As Integer, pin_mon As Integer) As Currency
'    Dim sql As String
'    Let sql = "SELECT SUM(betrag) AS ek " & _
'              "FROM tbl_grossbuch " & _
'              "WHERE konto = '" & pin_kt & "' " & _
'              "AND (transaktion = 'Einkommen' " & _
'              "OR (transaktion = 'Gewinneutral' " & _
'              "AND betrag > 0)) " & _
'              "AND (MONTH(datum) = " & pin_mon & " " & _
'              "AND YEAR(datum) = " & pin_jahr & ");"
'
'    Dim rcsEk As Recordset
'    Set rcsEk = CurrentDb.OpenRecordset(sql)
'
'    If rcsEk.RecordCount > 0 Then
'        getEk = Nz(rcsEk!ek, 0)
'    Else
'        getEk = 0
'    End If
'
'    rcsEk.Close
'End Function
'
''-------- Ausgaben ----------------------------------------
'Private Function getAg(pin_kt As String, pin_jahr As Integer, pin_mon As Integer) As Currency
'    Dim sql As String
'    Let sql = "SELECT SUM(betrag) AS ag " & _
'              "FROM tbl_grossbuch " & _
'              "WHERE konto = '" & pin_kt & "' " & _
'              "AND (transaktion = 'Ausgaben' " & _
'              "OR (transaktion = 'Gewinneutral' " & _
'              "AND betrag < 0)) " & _
'              "AND (MONTH(datum) = " & pin_mon & " " & _
'              "AND YEAR(datum) = " & pin_jahr & ");"
'
'    Dim rcsAg As Recordset
'    Set rcsAg = CurrentDb.OpenRecordset(sql)
'
'    If rcsAg.RecordCount > 0 Then
'        getAg = Nz(rcsAg!ag, 0)
'    Else
'        getAg = 0
'    End If
'
'    rcsAg.Close
'End Function
'
'
''============== Bericht generieren ========================
'Sub generateReport(pin_jahr As Integer, pin_monat As Integer)
'    Dim sql As String
'    Let sql = "SELECT * FROM tbl_ktin " & _
'              "WHERE jahr = " & pin_jahr & _
'              " AND monat = " & pin_monat & ";"
'
'    Dim rcsKonten As Recordset
'    Set rcsKonten = CurrentDb.OpenRecordset("qry_konteninformation")
'    rcsKonten.MoveLast
'    Dim x As Integer
'    Let x = rcsKonten.RecordCount
'
'    Dim rcsKtin As Recordset
'    Set rcsKtin = CurrentDb.OpenRecordset(sql, dbOpenDynaset)
'
'    If rcsKtin.RecordCount < rcsKonten.RecordCount Then
'        rcsKtin.Close
'
'        Do Until rcsKonten.BOF
'            Call addKtIn(rcsKonten!konto, pin_jahr, pin_monat)
'
'            rcsKonten.MovePrevious
'        Loop
'    End If
'
'    rcsKonten.Close
'End Sub
'
''============== Bericht leeren ============================
'Sub clearReport(pin_jahr As Integer, pin_monat As Integer)
'    Dim sql As String
'    Let sql = "DELETE * FROM tbl_ktin " & _
'              "WHERE jahr = " & pin_jahr & _
'              " AND monat = " & pin_monat & ";"
'
'    CurrentDb.Execute sql
'End Sub
'
'
''============== CRUD ======================================
'' DS hinzufügen
'' Übergabeparameter: kt - kontenName?
'Sub addKtIn(pin_kt As String, _
'            pin_jahr As Integer, _
'            pin_mon As Integer)
'    Dim kg As String    ' Kontengruppe
'    Dim vs As Currency  ' Vorstand
'    Dim ek As Currency  ' Einkommen
'    Dim ag As Currency  ' Ausgaben
'    Dim sd As Currency  ' Saldo
'    Dim ns As Currency  ' Nachstand
'
'    ' KontenId ermitteln
'    Dim kid As String   ' KontenId
'    Let kid = getKid(pin_kt)
'    If kid = "" Then
'        Debug.Print pin_kt & " exsistiert nicht!"
'        Exit Sub
'    End If
'
'    ' ID: Jahr + Monat + KdId = 2201urlb
'    Dim ktinId As String
'    Let ktinId = Right(pin_jahr, 2) & Format(pin_mon, "00") & kid
'
'    ' Prüfen, ob DS noch nicht existiert
'    If chkKtIn(ktinId) = 0 Then
'        ' Hinzufügen
'        Dim rcsKtin As Recordset
'        Set rcsKtin = CurrentDb.OpenRecordset(tblName, dbOpenDynaset)
'
'        ' Werte ermitteln
'        Let kg = getKg(pin_kt)
'        Let vs = getVs(pin_kt, pin_jahr, pin_mon)
'        Let ek = getEk(pin_kt, pin_jahr, pin_mon)
'        Let ag = getAg(pin_kt, pin_jahr, pin_mon)
'        Let sd = ek + ag
'        Let ns = vs + sd
'
'        With rcsKtin
'            .AddNew
'
'            ' Spalten
'            !id = ktinId
'            !jahr = pin_jahr
'            !monat = pin_mon
'            !kontengruppe = kg
'            !konto = pin_kt
'            !vorstand = vs
'            !einkommen = ek
'            !ausgaben = ag
'            !Saldo = sd
'            !nachstand = ns
'
'            .Update
'            .Close
'        End With
'    ElseIf chkKtIn(ktinId) = 1 Then
'        ' Ändern
'    Else
'        ' Informieren
'    End If
'
'End Sub
'
'' DS löschen
'Sub delKtInfo(pin_ki As String)
'
'End Sub
'
'' DS ändern
'
'' DS prüfen
'' ToDo: !!!!
'Private Function chkKtIn(pin_ktinId As String) As Integer
'
'    Dim rcsKtin As Recordset
'    Set rcsKtin = CurrentDb.OpenRecordset(tblName, dbOpenDynaset)
'
'    rcsKtin.FindFirst ("id = '" & pin_ktinId & "'")
'
'    If rcsKtin.NoMatch Then
'        ' 0 - Exsistiert nicht
'        chkKtIn = 0
'    Else
'        ' 1 - Exsistiert, aber nicht gleich ist
'        chkKtIn = 1
'        ' 2 - Exsistiert und gleich ist
'    End If
'
'    rcsKtin.Close
'End Function
'
'' DS ausgeben
