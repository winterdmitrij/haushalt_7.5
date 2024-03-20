Attribute VB_Name = "catpst_bapi"
'========================================================================================
'=                 Katalog "Posten" - Schnittstelle
'= Version: 7.6
'========================================================================================
Option Compare Database


'*********************************** D A T E N T Y P ************************************
'*******************************************|********************************************
'*       DatenTyp definieren
'* Version: 7.6
'****************************************************************************************
Type pstDtl_rowType
    rank As String
    ta_id As Integer
    ta_dsg As String
    pg_id As Integer
    pg_dsg As String
    pg_act As Integer
    pd_id As Integer
    pd_dsg As String
    pd_act As Integer
    pd_trf As Integer
    pd_csh As Integer
End Type


'************************************* G E T T E R **************************************
'*******************************************|********************************************
'*       Gibt den ganze Post-Informazion bzgl. Post-Id in form des Records
'* Version: 7.6
'****************************************************************************************
Public Function get_pdRow(pin_pdId As Integer) As pstDtl_rowType
    Let get_pdRow = catpst_tapi.read_pdRow_by_pdId(pin_pdId)
End Function


'********************************** E R S T E L L E N ***********************************
'*******************************************|********************************************
'*       Erstellt eine neue Postgruppe
'* Version: 7.6
'****************************************************************************************
Public Function create_pstGrp(pin_pgDsg As String, _
                              pin_taId As Integer) As String
    Dim l_req As Integer
    
check:
    If catpst_tapi.check_pgExist(pin_pgDsg) Then
        Let create_pstGrp = "Postgruppe '" & pin_pgDsg & "' existiert bereits."
        Exit Function
    End If
    
create:
    Let l_req = catpst_tapi.insert_new_pstGrp(pin_pgDsg, pin_taId)
    
    If l_req = 200 Then
        Let create_pstGrp = "Postgruppe '" & pin_pgDsg & "' wurde erfolgreich hinzugefügt!"
    Else
        Let create_pstGrp = "Postgruppe '" & pin_pgDsg & "' wurde nicht hinzugefügt!"
    End If
End Function

'****************************************************************************************
'*       Erstellt ein neuen Post
'* Version: 7.6
'****************************************************************************************
Public Function create_pstDtl(pin_pdDsg As String, _
                              pin_pgId As Integer) As String
    Dim l_req As Integer
    
check:
    If catpst_tapi.check_pdExist(pin_pdDsg) Then
        Let create_pstDtl = "Post '" & pin_pdDsg & "' existiert bereits."
        Exit Function
    End If
    
create:
    Let l_req = catpst_tapi.insert_new_pstDtl(pin_pdDsg, pin_pgId)
    
    If l_req = 200 Then
        Let create_pstDtl = "Post '" & pin_pdDsg & "' wurde erfolgreich hinzugefügt!"
    Else
        Let create_pstDtl = "Post '" & pin_pdDsg & "' wurde nicht hinzugefügt!"
    End If
End Function


'************************************ L Ö S C H E N *************************************
'*******************************************|********************************************
'*       Löscht eine Postgruppe
'* Version: 7.6
'* ToDo: Check-Funktionen auslagern
'****************************************************************************************
Public Function delete_pstGrp(pin_pgId As Integer) As String
    Dim l_req As Integer
    Dim l_msg As String
    Let l_msg = "Die Postgruppe mit dem Id: " & pin_pgId
    
check:
    ' ToDo: *
    ' Anzahl der von der Postgruppe abhängigen Posten
    If catpst_tapi.select_cntPstDtl_by_pgId(pin_pgId) > 0 Then
        Let delete_pstGrp = l_msg & " darf nicht gelöscht werden!" & vbNewLine & _
                            "Es gibt die von der Postgruppe abhängige Posten."
        
        Exit Function
    End If
    
    ' Prüfen, ob die Postgruppe aktiv ist
    If catpst_tapi.check_pgActiv(pin_pgId) Then
        Let delete_pstGrp = l_msg & " darf nicht gelöscht werden!" & vbNewLine & _
                            "Die Postgruppe ist aktiv."
        Exit Function
    End If
    
delete:
    Let l_req = catpst_tapi.delete_pstGrp_by_pgId(pin_pgId)
    
    If l_req = 200 Then
        Let delete_pstGrp = l_msg & " wurde erfolgreich gelöscht!"
    Else
        Let delete_pstGrp = l_msg & " wurde nicht gelöscht!"
    End If
End Function

'****************************************************************************************
'*       Löscht einen Post
'* Version: 7.6
'* ToDo: Check-Funktionen auslagern
'****************************************************************************************
Public Function delete_pstDtl(pin_pdId As Integer) As String
    Dim l_req As Integer
    Dim l_msg As String
    Let l_msg = "Der Post mit dem Id: " & pin_pdId
    
check:
    ' ToDo: *
    ' Anzahl der Posten, die in Documenten bereits benutzt wurde
    If doc_api.get_pstDtl_inUse(pin_pdId) Then
        Let delete_pstDtl = l_msg & " darf nicht gelöscht werden!" & vbNewLine & _
                            "Es wurde der Post in Dokumenten benutzt."
        
        Exit Function
    End If
    
    ' Prüfen, ob der Post aktiv ist
    If catpst_tapi.check_pdActiv(pin_pdId) Then
        Let delete_pstDtl = l_msg & " darf nicht gelöscht werden!" & vbNewLine & _
                            "Der Post ist aktiv."
        Exit Function
    End If
    
delete:
    Let l_req = catpst_tapi.delete_pstDtl_by_pdId(pin_pdId)
    
    If l_req = 200 Then
        Let delete_pstDtl = l_msg & " wurde erfolgreich gelöscht!"
    Else
        Let delete_pstDtl = l_msg & " wurde nicht gelöscht!"
    End If
End Function
