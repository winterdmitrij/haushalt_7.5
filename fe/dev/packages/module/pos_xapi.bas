Attribute VB_Name = "pos_xapi"
'==========================================================
'=                 Positions-Controller
'==========================================================
Option Compare Database


'**********************************************************
'*            Formular öffnen (opn_posFrm_, opn_dtlFrm)
'**********************************************************
' bei Dokument-Id
Public Sub opn_posFrm_byDoc(pin_docId As String, pin_cnd As String)
    ' Dokument-Id als aktuell merken
    Call pos_api.set_cur_docId(pin_docId)

    ' Form öffnen
    Call opn_posFrm_byName(pos_api.get_cur_posForm, pin_cnd)
End Sub

' bei Formname
Public Sub opn_posFrm_byName(pin_frmName As String, pin_cnd As String)
    Call frm_xapi.opn_frm(pin_frmName, pin_cnd)
End Sub

' Detail-Ausgaben-Formular
Public Sub opn_dtlFrm_Exp(pin_posId As String)
    ' Dokument-Id als aktuell merken
    Call pos_api.set_cur_docId(pos_api.get_docId_byPos(pin_posId))
    
    ' Form öffnen
    Call frm_xapi.opn_frm(env.gf_frm_expDtl, "pos_id = '" & pin_posId & "'")
End Sub

'**********************************************************
'*            Formular schließen (cls_posFrm)
'**********************************************************
Public Sub cls_posFrm(pin_frmName As String)
    ' Akt. Dokument ermitteln
    Dim cur_docId As String
    Let cur_docId = pos_api.get_cur_docId
    
    ' Positionsform schließen
    Call frm_xapi.cls_frm(pin_frmName, False)
    
    ' Akt. Position-Variablen leeren
    Call pos_api.set_cur_docId("")
    
    ' Dokumentenform öffnen
    Call doc_xapi.opn_docFrm_byId(cur_docId)
End Sub


'**********************************************************
'*            Position hinzufügen (cre_)
'**********************************************************
Public Sub cre_pstPos(pin_frmName As String, pin_pdId As Integer)
    ' Position hinzufügen
    Dim req As Integer
    Let req = pos_tapi.ins_new_pstPos(get_new_posId(), pin_pdId)
    
    ' ToDo: Request-Analyse
    If req <> 200 Then
        MsgBox "Fehler beim Hinzufügen der Position"
    End If
    
    ' Form schließen
    Call cls_posFrm(pin_frmName)
End Sub


Public Sub cre_accPos(pin_frmName As String, pin_adId As Integer)
    ' Position hinzufügen
    Dim req As Integer
    Let req = pos_tapi.ins_new_accPos(get_new_posId(), pin_adId)
    
    ' ToDo: Request-Analyse
    If req <> 200 Then
        MsgBox "Fehler beim Hinzufügen des Kontos"
    End If
    
    ' Form schließen
    Call cls_posFrm(pin_frmName)
End Sub

'**********************************************************
'*            Neuer Positions_Id ermitteln (get_)
'**********************************************************
Private Function get_new_posId() As String
    ' Akt. Dokument-Id ermitteln
    Dim cur_docId As String
    Let cur_docId = pos_api.get_cur_docId()
    
    ' Max Position-Id ermitteln
    Dim max_posId As String
    Let max_posId = pos_tapi.sel_max_posId(cur_docId)
    
    Let get_new_posId = cur_docId & "." & Format(Right(max_posId, 2) + 1, "00")
End Function


'**********************************************************
'*            Position löschen (delete_)
'**********************************************************
Public Sub delete_pos(pin_posId As String)
    If Len(pin_posId) = 0 Then
        Exit Sub
    End If
    
    ' Dokument-Id als aktuell merken
    Call pos_api.set_cur_docId(Left(pin_posId, 8))
    
    ' Position löschen
    Dim req As Integer
    Let req = pos_tapi.del_pos_byId(pin_posId)
    
    ' Request analysieren
    If req = 400 Then
        MsgBox "Fehler beim Löschen der Position: " & pin_posId
    End If
End Sub
