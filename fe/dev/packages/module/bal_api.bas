Attribute VB_Name = "bal_api"
'========================================================================================
'=                 Bilanz-Schnittstelle
'= Version: 7.5
'========================================================================================
Option Compare Database
' Tabellenkonstanten
Private Const c_bal_tblName As String = "rpt_balance"       ' Bilanz-Tabelle
Private Const c_grb_viewName As String = "grb_operations_v" ' Großbuch-View
' ToDo: Private Transaktion-Konstenten: Einkommen, Ausgaben, Überweisungen


'****************************************************************************************
'*       DatenTyp definieren
'* Version: 7.5
'****************************************************************************************
Type balRow
    prd As Integer
    ad_id As Integer
    beg As Double
    inc As Double
    exp As Double
    trf As Double
End Type


' ToDo: Möglichkeit hinzufügen, für den ganzen Jahr berechnen
'************************************* B I L A N Z **************************************
'*******************************************|********************************************
'*       Bilanz für das übergebenen Zeitraum berechnen
'* Version:
'****************************************************************************************
Public Sub recalculate_bal_by_prd(pin_prd As Integer)
    Dim l_req As Integer
    Dim l_msg As String
    Dim l_idx As Integer
    Dim l_balRow As balRow

check:
    ' Prüfen, ob das Zeitraum bereits drin ist
    If bal_tapi.check_prdExist(pin_prd, c_bal_tblName) Then
        ' Alles für das Zeitraum löschen
        Let l_req = bal_tapi.delete_bal_by_prd(pin_prd, c_bal_tblName)

        If l_req = 400 Then
            Let l_msg = "Fehler beim Bilanz-DELETE für Zeitraum: " & pin_prd
            GoTo ende
        End If
    End If

insert:
    ' Liste der Konten erhalten
    Dim arr_acc() As catAccRow
    Let arr_acc = catacc_api.get_listOfAccouns()
    
    ' Die Liste kontenweise durchgehen
    For l_idx = 0 To UBound(arr_acc)
        ' Bilanz-Zeile erstellen
        Let l_balRow = get_balRow_by_prd(pin_prd, arr_acc(l_idx).ad_id)
        
        ' Bilanz-Zeile in die Tabelle speichern
        Let l_req = bal_tapi.insert_balRow(l_balRow, c_bal_tblName)
    
        If l_req = 400 Then
            Let l_msg = "Fehler beim Bilanz-INSERT für Zeitraum: " & pin_prd
            GoTo ende
        End If
    Next l_idx
     
    Let l_msg = "Bilanz für den Zeitraum: " & cur_prd & " ist berechnet!"
ende:
    MsgBox l_msg
End Sub


'******************************* B I L A N Z - Z E I L E ********************************
'*******************************************|********************************************
'*       Eine Bilaz-Variable befüllen
'* Version:
'****************************************************************************************
Private Function get_balRow_by_prd(pin_prd As Integer, _
                                   pin_adId As Integer) As balRow
    Dim l_balRow As balRow
    
    Let l_balRow.prd = pin_prd
    Let l_balRow.ad_id = pin_adId
    Let l_balRow.beg = get_accBeg(pin_prd, pin_adId)
    Let l_balRow.inc = get_accInc(pin_prd, pin_adId)
    Let l_balRow.exp = get_accExp(pin_prd, pin_adId)
    Let l_balRow.trf = get_accTrf(pin_prd, pin_adId)
    
    Let get_balRow_by_prd = l_balRow
End Function



'******************************* B E T R A G S S U M M E ********************************
'*******************************************|********************************************
'*       Den Anfangsstand des Kontos berechnen
'* Version: 7.5
'****************************************************************************************
Private Function get_accBeg(pin_prd As Integer, _
                            pin_adId As Integer) As Double
    Dim l_cond As String
    Let l_cond = "ad_id = " & pin_adId & _
                 " AND prd < " & pin_prd
    
    Let get_accBeg = get_amtSum_by_cond(l_cond)
End Function

'****************************************************************************************
'*       Die laufende Einkommen des Kontos berechnen
'* Version: 7.5
'****************************************************************************************
Private Function get_accInc(pin_prd As Integer, _
                            pin_adId As Integer) As Double
    Dim l_cond As String
    Let l_cond = "ad_id = " & pin_adId & _
                 " AND prd = " & pin_prd & _
                 " AND ta_dsg = 'Einkommen'"
    
    Let get_accInc = get_amtSum_by_cond(l_cond)
End Function

'****************************************************************************************
'*       Die laufende Ausgaben des Kontos berechnen
'* Version: 7.5
'****************************************************************************************
Private Function get_accExp(pin_prd As Integer, _
                            pin_adId As Integer) As Double
    Dim l_cond As String
    Let l_cond = "ad_id = " & pin_adId & _
                 " AND prd = " & pin_prd & _
                 " AND ta_dsg = 'Ausgaben'"
    
    Let get_accExp = get_amtSum_by_cond(l_cond)
End Function

'****************************************************************************************
'*       Den laufenden Geldverkehr des Kontos berechnen
'* Version: 7.5
'****************************************************************************************
Private Function get_accTrf(pin_prd As Integer, _
                            pin_adId As Integer) As Double
    Dim l_cond As String
    Let l_cond = "ad_id = " & pin_adId & _
                 " AND prd = " & pin_prd & _
                 " AND ta_dsg = 'Überweisungen'"
    
    Let get_accTrf = get_amtSum_by_cond(l_cond)
End Function


'****************************************************************************************
'*       Die Betragssumme des Kontos bzgl. Bedingungen berechnen
'* Version: 7.5
'****************************************************************************************
Private Function get_amtSum_by_cond(pin_cond As String) As Double
    Let get_amtSum_by_cond = bal_tapi.calculate_amtSum_by_cond(c_grb_viewName, _
                                                               pin_cond)
End Function
