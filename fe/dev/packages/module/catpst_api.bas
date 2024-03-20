Attribute VB_Name = "catpst_api"
'========================================================================================
'=                 Katalog "Posten" - Schnittstelle
'= Version: 7.5
'========================================================================================
Option Compare Database


'*********************************** D A T E N T Y P ************************************
'*******************************************|********************************************
'*       DatenTyp definieren
'* Version: 7.5
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
'* Version: 7.5
'****************************************************************************************
Public Function get_pdRow(pin_pdId As Integer) As pstDtl_rowType
    Let get_pdRow = catpst_tapi.find_pdRow_by(pin_pdId)
End Function


'********************************** E R S T E L L E N ***********************************
'*******************************************|********************************************
'*       Erstellt eine neue Postgruppe
'* Version: 7.5
'****************************************************************************************
Public Function create_pstGrp(pin_pgDsg As String, _
                              pin_taId As Integer) As String
    Dim l_req As Integer
    
    ' Prüfen
    If catpst_tapi.check_pgExist(pin_pgDsg) Then
        Let create_pstGrp = "Postgruppe '" & pin_pgDsg & "' existiert bereits."
        Exit Function
    End If
    
    ' Erstellen
    Let l_req = catpst_tapi.insert_new_pstGrp(pin_pgDsg, pin_taId)
    
    If l_req = 200 Then
        Let create_pstGrp = "Postgruppe '" & pin_pgDsg & "' wurde erfolgreich hinzugefügt!"
    Else
        Let create_pstGrp = "Postgruppe '" & pin_pgDsg & "' wurde nicht hinzugefügt!"
    End If
End Function

'****************************************************************************************
'*       Erstellt ein neuen Post
'* Version: 7.5
'****************************************************************************************
Public Function create_pstDtl(pin_pdDsg As String, _
                              pin_pgId As Integer) As String
    Dim l_req As Integer
    
    ' Prüfen
    If catpst_tapi.check_pdExist(pin_pdDsg) Then
        Let create_pstDtl = "Post '" & pin_pdDsg & "' existiert bereits."
        Exit Function
    End If
    
    ' Erstellen
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
'* Version: 7.5
'****************************************************************************************
Public Function delete_pstGrp(pin_pgId As Integer) As String
    Dim l_req As Integer
    
    ' Prüfen
    ' Anzahl der Posten, die in Documenten bzw in Grb stehen
    ' ToDo
    
    ' Prüfen, ob aktiv ist
    ' ToDo
    
    ' Löschen
    Let l_req = 400
    
    If l_req = 200 Then
        Let delete_pstGrp = "Postgruppe mit dem Id '" & pin_pgId & "' wurde erfolgreich gelöscht!"
    Else
        Let delete_pstGrp = "Postgruppe mit dem Id '" & pin_pgId & "' wurde nicht gelöscht!"
    End If
End Function

'****************************************************************************************
'*       Löscht einen Post
'* Version: 7.5
'****************************************************************************************
Public Function delete_pstDtl(pin_pdId As Integer) As String
    Dim l_req As Integer
    
    ' Prüfen
    ' Anzahl der Posten, die in Documenten bzw in Grb stehen
    ' ToDo
    
    ' Prüfen, ob aktiv ist
    ' ToDo
    
    ' Löschen
    Let l_req = 400
    
    If l_req = 200 Then
        Let delete_pstDtl = "Post mit dem Id '" & pin_pdId & "' wurde erfolgreich gelöscht!"
    Else
        Let delete_pstDtl = "Post mit dem Id '" & pin_pdId & "' wurde nicht gelöscht!"
    End If
End Function
