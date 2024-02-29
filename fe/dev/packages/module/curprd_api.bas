Attribute VB_Name = "curprd_api"
'========================================================================================
'=                 Aktuelles Zeitraum-Schnittstelle
'= Version: 7,5
'========================================================================================
Option Compare Database

Private g_curPrd As Integer

'************************************ G E T T E R S *************************************
'*******************************************|********************************************
'*       Gibt das aktuelle Zeitraum zurück
'* Version: 7,5
'****************************************************************************************
Public Function get_curPrd() As Integer
    If g_curPrd = 0 Then
        Call set_curPrd(prd_tapi.sel_max_prd())
    End If
    Let get_curPrd = g_curPrd
End Function

'****************************************************************************************
'*       Gibt das aktuelle Jahr zurück
'* Version: 7,5
'****************************************************************************************
Public Function get_curYear() As Integer
    Let get_curYear = Format(DateSerial(Left(get_curPrd(), 2), 1, 1), "YYYY")
End Function

'****************************************************************************************
'*       Gibt den aktuellen Monatnummer zurück
'* Version: 7,5
'****************************************************************************************
Public Function get_curMonth() As Integer
    Let get_curMonth = Format(DateSerial(Left(get_curPrd(), 2), Right(get_curPrd(), 2), 1), "MM")
End Function

'****************************************************************************************
'*       Gibt Datum des letzten Tags vom aktuellen Zeitraum zurück
'* Version: 7,5
'****************************************************************************************
Public Function get_lastDayDate() As Date
    Let get_lastDayDate = DateSerial(Left(get_curPrd(), 2), Right(get_curPrd(), 2) + 1, 0)
End Function


'************************************ S E T T E R S *************************************
'*******************************************|********************************************
'*       Setzt das aktuelle Zeitraum
'* Version: 7,5
'****************************************************************************************
Public Sub set_curPrd(pin_prd As Integer)
    Let g_curPrd = pin_prd
End Sub
