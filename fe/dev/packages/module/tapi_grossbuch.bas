Attribute VB_Name = "tapi_grossbuch"
'==========================================================
'                  Grossbuch-Verwaltung
' Operationen mit der Tabelle
'==========================================================
Option Compare Database


' Datensatz in die Tabelle Gro�buch speichern
' ToDo: Betragsformatierung !!!
Public Sub add_position(pin_grb As t_grossbuch)
'    ' Rekordset
'    Dim rcs_grb As Recordset
'    Set rcs_grb = CurrentDb.OpenRecordset(env.gt_grb, dbOpenDynaset, dbFailOnError)
'
'    ' Neuen Datensatz hinzuf�gen und f�llen
'    With rcs_grb
'        .AddNew
'
'        !id = pin_grb.id
'        !dtm = Format(pin_grb.date, "yyyy-mm-dd")
'        !kdid = pin_grb.acc
'        !pdid = pin_grb.pst
'        ' ToDo: Betragsformatierung
'        !btg = CDbl(Replace(CStr(Format(pin_grb.amt, "#,##0.00")), ",", ".")) / 100
'        !kmt = Nz(pin_grb.cmt, "")
'
'        .Update
'        .Close
'    End With
End Sub


' Alle Dokument-Datens�tze aus der Tabelle l�schen
Public Sub del_doc(pin_docId As String)
'    'SQL
'    Dim strSql As String
'    Let strSql = "DELETE " & _
'                 "FROM " & env.gt_grb & " " & _
'                 "WHERE Left(id, 7) = '" & pin_docId & "';"
'
'    ' SQL ausf�hren
'    Call CurrentDb.Execute(strSql)
End Sub
