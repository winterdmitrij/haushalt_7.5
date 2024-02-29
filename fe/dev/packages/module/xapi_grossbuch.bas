Attribute VB_Name = "xapi_grossbuch"
''==========================================================
''                  Schnittstelle Grossbuch
'' Bearbeitung der Daten zum Speicern in die Tabelle
''==========================================================
'Option Compare Database
'
''**********************************************************
''*                 Variablen und Konstanten
''**********************************************************
'' Posten
'Private l_pstId_ubw As Integer      ' Id vom Post "Überweisung"
'Private l_pstId_cur As Integer      ' Id vom akt. Post
'' Konten
'Private l_accId_brt As Integer      ' Id vom Konto "Brieftasche"
'Private l_accId_def As Integer      ' Id vom Konto, das für das akt. Dokumententyp gilt
'Private l_accId_cur As Integer      ' Id vom Konto, das für den akt. Post gilt
'Private l_accId_tre As Integer      ' Id vom Konto "Tresor"
'Private l_accId_res As Integer      ' Id vom Konto "Reserven"
'' Transaktionen
'Private l_traDsc_cur As String      ' Bezeichnung von der akt. Transaktion
'' Datensatz
'Private l_grbRec As t_grossbuch     ' Datensatz, für speicherung in die Tabelle "Großbuch"
'' Betrag
'Private l_amt As Currency           ' akt. Betrag
'
''**********************************************************
''*                 Hilfsfunktionen
''**********************************************************
'' Variablen initialisieren
'Private Sub init_var()
'    ' Das dient, um richtigen Id zu bekommen, unabhängig von akt. Datenbank
'    Let l_pstId_ubw = DLookup("pdid", env.vw_posts, "pdbez = '" & env.gc_pstDsc_trf & "'")
'    Let l_accId_brt = DLookup("kdid", env.gv_cat_accounts, "kdbez = '" & env.g_accDsc_brt & "'")
'    Let l_accId_tre = DLookup("kdid", env.gv_cat_accounts, "kdbez = '" & env.gc_accDsc_safe & "'")
'    Let l_accId_res = DLookup("kdid", env.gv_cat_accounts, "kdbez = '" & env.gc_accDsc_rsrv & "'")
'End Sub
'
'
''' Prüfen, ob Datensatz schon in der Tabelle gespeichert ist
''' !!! Nie benutzt
''Private Function chk_pos(pin_posid As String) As Boolean
''    Let chk_pos = DCount("id", env.gt_grbRec, "id = '" & pin_posid & "'") > 0
''End Function
'
'
''**********************************************************
''*                 Freigabefunktionen
''**********************************************************
'' Position bearbeiten +++
'Public Sub rls_document(pin_position As t_grossbuch)
'    ' Variablen initialisieren
'    Call init_var
'
'    ' akt. Transaktion ermitteln
'    Let l_traDsc_cur = Nz(DLookup("tabez", "v_posten", "pdid = " & pin_position.pst), env.g_traDsc_tra)
'
'    ' Datum
'    Let l_grbRec.date = pin_position.date
'
'    ' Transaktion analysieren und bearbeiten
'    If l_traDsc_cur <> env.g_traDsc_tra Then
'        ' Einkommen/Ausgaben
'        Call rls_inc_ext(pin_position)
'    Else
'        ' Transaktionen
'        Call rls_tra(pin_position)
'    End If
'End Sub
'
'' Einkommen/Ausgaben +++
'Private Sub rls_inc_ext(pin_pos As t_grossbuch)
'    ' def. Konto-Id ermitteln
'    Let l_accId_def = DLookup("kdid", env.gt_infDoc, "bez = '" & Mid(pin_pos.id, 6, 2) & "'")
'
'    ' akt. Konto-Id
'    Let l_accId_cur = Nz(DLookup("kdid", env.tbl_accPst, "pdid = " & pin_pos.pst), l_accId_def)
'
'step1:
'    ' 1. Dokument: Operetionen mit akt. Konto, +Betrag und Kommentar aus Dokument
'    Let l_grbRec.id = pin_pos.id & "d"
'    Let l_grbRec.acc = l_accId_cur
'    Let l_grbRec.pst = pin_pos.pst
'    Let l_grbRec.amt = pin_pos.amt
'    Let l_grbRec.cmt = pin_pos.cmt
'
'    Call tapi_grossbuch.add_position(l_grbRec)
'
'step2:
'    ' Wenn def. Konto nicht akt. Konto ist, und kein "Brieftasche" ist
'    If l_accId_cur <> l_accId_def And _
'       l_accId_def <> l_accId_brt Then
'
'        ' 2. Aktiv: Transaktion mit Standardkonto und +Betrag
'        Let l_grbRec.id = pin_pos.id & "a"
'        Let l_grbRec.acc = l_accId_def
'        Let l_grbRec.pst = l_pstId_ubw
'        Let l_grbRec.amt = pin_pos.amt
'        Let l_grbRec.cmt = IIf(l_grbRec.amt > 0, "Von ", "Für ") & _
'                           DLookup("pgbez", env.vw_posts, "pdid = " & pin_pos.pst)
'
'        Call tapi_grossbuch.add_position(l_grbRec)
'
'        ' 3. Passiv: Transaktion mit Brieftasche und -Betrag
'        Let l_grbRec.id = pin_pos.id & "p"
'        Let l_grbRec.acc = l_accId_brt
'        Let l_grbRec.pst = l_pstId_ubw
'        Let l_grbRec.amt = -pin_pos.amt
'        Let l_grbRec.cmt = IIf(l_grbRec.amt > 0, "Von ", "Für ") & _
'                           DLookup("pgbez", env.vw_posts, "pdid = " & pin_pos.pst)
'
'        Call tapi_grossbuch.add_position(l_grbRec)
'    End If
'End Sub
'
'
'' Transaktion +++
'Private Sub rls_tra(pin_pos As t_grossbuch)
'' Wenn Tresor dann p - Reserven
'' Ansonsten        p - accId_def
'
'    ' def. Konto
'    If pin_pos.acc = l_accId_tre Then   ' Wenn es um "Tresor" geht
'        Let l_accId_def = l_accId_res
'    Else                                ' Wenn es um andere Konten geht
'        Let l_accId_def = DLookup("kdid", env.gt_infDoc, "bez = '" & Mid(pin_pos.id, 6, 2) & "'")
'    End If
'
'    ' akt. Konto
'    If pin_pos.acc > 0 Then             ' Wenn vom Transaktion-Dokument
'        Let l_accId_cur = pin_pos.acc
'        Let l_amt = -pin_pos.amt
'    Else                                ' Wenn vom Kontoauszug-Dokument
'        Let l_accId_cur = Nz(DLookup("kdid", env.tbl_accPst, "pdid = " & pin_pos.pst), l_accId_def)
'        Let l_amt = pin_pos.amt
'    End If
'
'    ' akt Post
'    If pin_pos.pst > o Then
'        Let l_pstId_cur = pin_pos.pst
'    Else
'        Let l_pstId_cur = l_pstId_ubw
'    End If
'
'    ' Post und Kommentar sind gleich für Aktiv und Passiv
'    Let l_grbRec.pst = l_pstId_cur
'    Let l_grbRec.cmt = pin_pos.cmt
'
'    ' 1. Aktiv: Transaktion mit akt. Konto und +Betrag
'    Let l_grbRec.id = pin_pos.id & "a"
'    Let l_grbRec.acc = l_accId_def
'    Let l_grbRec.amt = l_amt
'
'    Call tapi_grossbuch.add_position(l_grbRec)
'
'    ' 2. Passiv: Transaktion mit def. Konto und -Betrag
'    Let l_grbRec.id = pin_pos.id & "p"
'    Let l_grbRec.acc = l_accId_cur
'    Let l_grbRec.amt = -l_amt
'
'    Call tapi_grossbuch.add_position(l_grbRec)
'End Sub
'
'
'
