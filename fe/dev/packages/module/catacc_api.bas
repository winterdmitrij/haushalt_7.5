Attribute VB_Name = "catacc_api"
'========================================================================================
'=                 Konten-Kataloge-Schnittstelle
'= Version: 7.5
'========================================================================================
Option Compare Database
Private Const c_catAcc_viewName As String = "cat_accounts_v"


'****************************************************************************************
'*       DatenTyp definieren
'* Version: 7.5
'****************************************************************************************
Type catAccRow
    rank As String
    ag_id As Integer
    ag_dsg As String
    ag_shw As Integer
    ag_act As Integer
    ad_id As Integer
    ad_dsg As String
    ad_shw As Integer
    ad_act As Integer
    ad_sav As Integer
End Type


'*******************************************|********************************************
'*       Gibt eine volle Liste der Konen zurück
'* Version: 7.5
'****************************************************************************************
Public Function get_listOfAccouns() As catAccRow()
On Error GoTo exception
    Dim arr_lstAcc() As catAccRow
    
    Dim l_idx As Integer
    Let l_idx = -1
    
    ' Recordset erhalten
    Dim rcs_acc As Recordset
    Set rcs_acc = CurrentDb.OpenRecordset(c_catAcc_viewName, dbOpenDynaset)
    
    ' Recordset durchgehen
    With rcs_acc
        Do While Not .EOF
            ' Array dynamisch erweitern
            Let l_idx = l_idx + 1
            ReDim Preserve arr_lstAcc(l_idx)
            
            ' Array befüllen
            Let arr_lstAcc(l_idx).rank = !rank
            Let arr_lstAcc(l_idx).ag_id = !ag_id
            Let arr_lstAcc(l_idx).ag_dsg = !ag_dsg
            Let arr_lstAcc(l_idx).ag_shw = !ag_shw
            Let arr_lstAcc(l_idx).ag_act = !ag_act
            Let arr_lstAcc(l_idx).ad_id = !ad_id
            Let arr_lstAcc(l_idx).ad_dsg = !ad_dsg
            Let arr_lstAcc(l_idx).ad_shw = !ad_shw
            Let arr_lstAcc(l_idx).ad_act = !ad_act
            Let arr_lstAcc(l_idx).ad_sav = !ad_sav
            
            .MoveNext
        Loop
    End With
    
    ' Ergebnis zurückgeben
    Let get_listOfAccouns = arr_lstAcc
    GoTo ende

exception:
    Debug.Print Err.description
ende:
    If Not rcs_acc Is Nothing Then
        rcs_acc.Close
    End If
End Function
