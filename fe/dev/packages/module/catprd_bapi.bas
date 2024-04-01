Attribute VB_Name = "catprd_bapi"
'========================================================================================
'=                 Katalog "Zeitraum" - Schnittstelle
'= Version: 7.
'========================================================================================
Option Compare Database
Private cur_taId As Integer
Private cur_pgId As Integer

Private cur_agId As Integer


'************************************ G E T T E R S *************************************
'*******************************************|********************************************
'*       Neues Zeitraum des aktuellen Datums
'* Version: 7.
'****************************************************************************************
Public Sub create_nextPrd()
    ' Akt. Zeitraum generieren
    Dim l_curPrd As Integer
    Let l_curPrd = Format(date, "YYMM")
    
    ' Prüfen, ob akt. Zeitraum bereits existiert
    If catprd_tapi.check_prdExist(l_curPrd) Then
        MsgBox l_msg & "existiert bereits!"
        Exit Sub
    End If
    
    Call create_prd(l_curPrd)
End Sub

'****************************************************************************************
'*       Erstellt neues und alle fehlende Zeiträume
'* Version: 7.6
'****************************************************************************************
Private Sub create_prd(pin_prd As Integer)
    Dim l_msg As String
    Let l_msg = "Das Zeitraum: " & pin_prd
    
    ' Max. Zeitraum ermitteln
    Dim l_maxPrd As Integer
    Let l_maxPrd = catprd_tapi.find_maxPrd()
    
    ' Vorheriges Zeitraum ermitteln
    Dim l_prePrd As Integer
    Let l_prePrd = get_prePrd(pin_prd)
    
    ' Prüfen, ob das vorherige Zeitraum existiert
    If l_prePrd > l_maxPrd Then
        Call create_prd(l_prePrd)
    End If
        
    ' Request erhalten
    Dim l_req As Integer
    Let l_req = catprd_tapi.insert_new_prd(pin_prd)
    
    ' Request analysieren
    If l_req = 200 Then
        MsgBox l_msg & " wurde erfolgreich hinzugefügt!"
    Else
        MsgBox l_msg & " wurde wegen eines Fehlers nicht hinzuzufügen!"
    End If
End Sub

'****************************************************************************************
'*       Gibt das vorherige Zeitraum bzgl. dem übergebenen Zeitraum zurück
'* Version: 7.6
'****************************************************************************************
Private Function get_prePrd(pin_prd As Integer) As Integer
    ' Der Monat ermitteln
    Dim l_month As Integer
    Let l_month = get_month_by_prd(pin_prd)
    
    ' Das Jahr ermitteln
    Dim l_year As Integer
    Let l_year = get_year_by_prd(pin_prd)
    
    Let l_month = l_month - 1
    
    ' Den Monat prüfen
    If l_month = 0 Then
        Let l_month = 12
        Let l_year = l_year - 1
    End If
    
    Let get_prePrd = Format(DateSerial(l_year, l_month, 1), "YYMM")
End Function

'****************************************************************************************
'*       Gibt das Jahr bzgl. dem übergebenen Zeitraum zurück
'* Version: 7.6
'****************************************************************************************
Public Function get_year_by_prd(pin_prd As Integer) As Integer
    Let get_year_by_prd = Format(DateSerial(Left(pin_prd, 2), 1, 1), "YYYY")
End Function

'****************************************************************************************
'*       Gibt den Nummer des Monats bzgl. dem übergebenen Zeitraum zurück
'* Version: 7.6
'****************************************************************************************
Public Function get_month_by_prd(pin_prd As Integer) As String
    Let get_month_by_prd = Format(DateSerial(Left(pin_prd, 2), Right(pin_prd, 2), 1), "M")
End Function

'****************************************************************************************
'*       Gibt die kurze Monatsname bzgl. dem übergebenen Zeitraum zurück
'* Version: 7.6
'****************************************************************************************
Public Function get_monthName_by_prd(pin_prd As Integer) As String
    Let get_monthName_by_prd = Format(DateSerial(Left(pin_prd, 2), Right(pin_prd, 2), 1), "MMM")
End Function


'****************************************************************************************
'*       Gibt das maximalen Zeitraum aus der Tabelle "cat_periods"
'* Version: 7.5
'****************************************************************************************
Public Function get_maxPrd() As Integer
    Let get_maxPrd = catprd_tapi.find_maxPrd()
End Function
