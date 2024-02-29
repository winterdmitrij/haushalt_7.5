Attribute VB_Name = "pos_pckg"
'==========================================================
'                  Positions-Package
'==========================================================
Option Compare Database

'**********************************************************
'*                 Variabken und Konatanten
'**********************************************************
Private g_dbl_arr() As Double   ' Betrag-Array aus Zeichenkette
Private g_cur_idx As Integer    ' Aktuelles Index des Betrag-Arrays


'**********************************************************
'*            Summe der Ausgaben berechnen
'**********************************************************
Public Function get_sum_amt(pin_amtDtl As String) As Double
    ' Das aktuelle Index bekommt ein 0
    Let g_cur_idx = 0
        
    ' Die erwartete Länge des Arrays ermitteln
    Dim l_arr_lng As Integer
    Let l_arr_lng = get_arr_lng(pin_amtDtl)
    
    ' Array leeren und die neue Länge zuweisen
    ReDim g_dbl_arr(l_arr_lng)

    ' Array mit anerkanten Beitragen füllen
    Call fil_dbl_arr(pin_amtDtl)

    ' Summe des Arrays berechnen und zurückgeben
    Let get_sum_amt = clc_arr_sum()
End Function


'**********************************************************
'*                 Hilfsfunktionen
'**********************************************************
' Gibt die erwartete Länge des Arrays zurück (Anzahl von + und -)
Private Function get_arr_lng(pin_strArr As String) As Integer
    ' Variablen
    Dim l_idx As Integer    ' aktueller Index der Zeichenkette
    Dim l_chr As String     ' aktuelles Zeichen der Zeichenkette
    Dim l_cnt As Integer    ' Anzahl der erwarteten Elementen
    Let l_cnt = 0
    
    ' Zeichenkette durchgehen und +/- zählen
    For l_idx = 1 To Len(pin_strArr)
        ' Aktuelles Zeichen ermitteln
        Let l_chr = Mid(pin_strArr, l_idx, 1)
        
        ' Für jeden Vorzeichen Länge vergrößern
        If l_chr = "+" Or l_chr = "-" Then
            Let l_cnt = l_cnt + 1
        End If
    Next l_idx
    
    ' Ergebnis zurückgeben
    Let get_arr_lng = l_cnt + 1
End Function


' Befüllt Zahlen-Array mit Werten
Private Sub fil_dbl_arr(pin_strArr As String)
    'Variablen
    Dim l_cur_chr As String     ' aktuelles Zeichen der Zeichenkette
    Dim l_cur_num As String     ' aktuelle Zahl des Arrays als String
    Dim l_cur_idx As Integer    ' aktuelle Position in der Zeichenkette
    Dim l_err_msg As String     ' Fehler-Beschreibung
    Let l_err_msg = ""
    
    ' Zeichenkette durchgehen
    For l_cur_idx = 1 To Len(pin_strArr)
        ' aktuelles Zeichen ermitteln
        Let l_cur_chr = Mid(pin_strArr, l_cur_idx, 1)

        ' Prüfen aktuelle Zeichen
        If IsNumeric(l_cur_chr) Then
            Let l_cur_num = l_cur_num & l_cur_chr
        Else
            Select Case l_cur_chr
                Case ",", "."
                    Let l_cur_num = l_cur_num & ","
                Case "+", "-"
                    If Len(l_cur_num) > 1 Then
                        ' annerkannte Zahl in Array speichern
                        Call add_dbl_toArr(CDbl(l_cur_num))
                    ElseIf Len(l_cur_num) = 1 Then
                        ' Fehler beschreiben
                        Let l_err_msg = l_err_msg + "- Mindestens 2 Vorzeichen stehen nebeneinander" & vbNewLine
                    End If
                    
                    ' neue Zahl anfangen
                    Let l_cur_num = l_cur_chr
                Case Else
                    ' Fehler hochzellen
                    Let l_err_msg = l_err_msg + "- Zeichenkette enthält falsche Zeichen" & vbNewLine
            End Select
        End If
    Next l_cur_idx

    ' Wenn Rest eine Zahl ist, speichern ins Array
    If IsNumeric(l_cur_num) Then
        Call add_dbl_toArr(CDbl(l_cur_num))
    End If
    
    ' Wenn in der Zeichenkette unnötige Zeichen getroffen wurden, gibt Info aus
    If Len(l_err_msg) > 0 Then
        MsgBox "Fehler bei Betragberechnung: " & vbNewLine & l_err_msg, vbExclamation, "Betragberechnung"
    End If
End Sub


' Speichert den neuerkannten Betrag ins Array
Private Sub add_dbl_toArr(pin_dbl As Double)
    ' den Index vergrößern
    Let g_cur_idx = g_cur_idx + 1
    
    ' den Betrag ins Array speichern
    Let g_dbl_arr(g_cur_idx) = pin_dbl
End Sub


' Berechnet die Summe von allen Elementen des Arrays
Private Function clc_arr_sum() As Double
    ' aktueller Index des Arrays
    Dim l_idx As Integer
    
    ' Summe der Elementen des Arrays
    Dim l_sum As Double
    Let l_sum = 0
    
    ' Array durchgehen und die Elemente summieren
    For l_idx = 1 To UBound(g_dbl_arr)
        Let l_sum = l_sum + g_dbl_arr(l_idx)
    Next l_idx
    
    ' Ergebnis zurückgeben
    Let clc_arr_sum = l_sum
End Function




