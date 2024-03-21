Attribute VB_Name = "catacc_bapi"
'========================================================================================
'=                 Katalog "Konten" - Schnittstelle
'= Version:
'========================================================================================
Option Compare Database
Private Const c_catAcc_viewName As String = "cat_accounts_v"


'*********************************** D A T E N T Y P ************************************
'*******************************************|********************************************
'*       DatenTyp definieren
'* Version: 7.6
'****************************************************************************************
Type accDtl_rowType
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

'************************************ G E T T E R S *************************************
'*******************************************|********************************************
'*       Gibt den ganze Konto-Informazion zurück bzgl. Konto-Id in form des Records
'* Version: 7.6
'****************************************************************************************
Public Function get_adRow(pin_adId As Integer) As accDtl_rowType
    Let get_adRow = catacc_tapi.read_adRow_by_adId(pin_adId)
End Function

'****************************************************************************************
'*       Gibt eine volle Liste der Konten zurück
'* Version: 7.5
'* ToDo: Vllt. durch Tapi read_allAccounds?
'****************************************************************************************
Public Function get_listOfAccouns() As accDtl_rowType()
On Error GoTo exception
    Dim arr_lstAcc() As accDtl_rowType
    
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


'********************************** E R S T E L L E N ***********************************
'*******************************************|********************************************
'*       Erstellt eine neue Kontengruppe
'* Version: 7.6
'****************************************************************************************
Public Function create_accGrp(pin_agDsg As String) As String
    Dim l_req As Integer
    Dim l_msg As String
    Let l_msg = "Die Kontengruppe mit der Bezeichnung: '" & pin_agDsg & "'"
    
check:
    If pin_agDsg = "" Then
        Exit Function
    End If

    If catacc_tapi.check_agExist(pin_agDsg) Then
        Let create_accGrp = l_msg & " existiert bereits!"
        Exit Function
    End If

create:
    Let l_req = catacc_tapi.insert_new_accGrp(pin_agDsg)

    If l_req = 200 Then
        Let create_accGrp = l_msg & " wurde erfolgreich hinzugefögt!"
    Else
        Let create_accGrp = l_msg & " wurde nicht hinzugefögt!"
    End If
End Function

'****************************************************************************************
'*       Erstellt ein neues Konto
'* Version: 7.6
'****************************************************************************************
Public Function create_accDtl(pin_adDsg As String, _
                              pin_agId As Integer) As String
    Dim l_req As Integer
    Dim l_msg As String
    Let l_msg = "Das Konto mit der Bezeichnung: '" & pin_adDsg & "'"
    
check:
    If pin_adDsg = "" Then
        Exit Function
    End If
    
    If catacc_tapi.check_adExist(pin_adDsg) Then
        Let create_accDtl = l_msg & " existiert bereits!"
        Exit Function
    End If

create:
    Let l_req = catacc_tapi.insert_new_accDtl(pin_adDsg, pin_agId)

    If l_req = 200 Then
        Let create_accDtl = l_msg & " wurde erfolgreich hinzugefögt!"
    Else
        Let create_accDtl = l_msg & " wurde nicht hinzugefögt!"
    End If
End Function


'************************************ L Ö S C H E N *************************************
'*******************************************|********************************************
'*       Löscht eine Kontengruppe
'* Version: 7.6
'* ToDo: Check-Funktionen auslagern
'****************************************************************************************
Public Function delete_accGrp(pin_agId As Integer) As String
    Dim l_req As Integer
    Dim l_msg As String
    Let l_msg = "Die Kontengruppe mit dem Id: " & pin_agId

check:
    ' ToDo: *
    ' Anzahl der von der Kontengruppe abhöngigen Konten
    If catacc_tapi.select_cntAccDtl_by_agId(pin_agId) > 0 Then
        Let delete_accGrp = l_msg & " darf nicht gelöscht werden!" & vbNewLine & _
                            "Es gibt die von der Kontengruppe abhöngige Konten."
        Exit Function
    End If

    ' Prüfen, ob die Kontengruppe aktiv ist
    If catacc_tapi.check_agActiv(pin_agId) Then
        Let delete_accGrp = l_msg & " darf nicht gelöscht werden!" & vbNewLine & _
                            "Die Kontengruppe ist aktiv."
        Exit Function
    End If

delete:
    Let l_req = catacc_tapi.delete_accGrp_by_agId(pin_agId)

    If l_req = 200 Then
        Let delete_accGrp = l_msg & " wurde erfolgreich gelöscht!"
    Else
        Let delete_accGrp = l_msg & " wurde nicht gelöscht!"
    End If
End Function

'****************************************************************************************
'*       Löscht einen Konten
'* Version: 7.6
'* ToDo: Check-Funktionen auslagern
'****************************************************************************************
Public Function delete_accDtl(pin_adId As Integer) As String
    Dim l_req As Integer
    Dim l_msg As String
    Let l_msg = "Das Konto mit dem Id: " & pin_adId

check:
    ' ToDo: *
    ' Anzahl der Kontenen, die in Documenten bereits benutzt wurde
    If doc_api.get_accDtl_inUse(pin_adId) Then
        Let delete_accDtl = l_msg & " darf nicht gelöscht werden!" & vbNewLine & _
                            "Es wurde das Konto in Dokumenten benutzt."
        Exit Function
    End If

    ' Pröfen, ob der Konten aktiv ist
    If catacc_tapi.check_adActiv(pin_adId) Then
        Let delete_accDtl = l_msg & " darf nicht gelöscht werden!" & vbNewLine & _
                            "Das Konto ist aktiv."
        Exit Function
    End If

delete:
    Let l_req = catacc_tapi.delete_accDtl_by_adId(pin_adId)

    If l_req = 200 Then
        Let delete_accDtl = l_msg & " wurde erfolgreich gelöscht!"
    Else
        Let delete_accDtl = l_msg & " wurde nicht gelöscht!"
    End If
End Function
