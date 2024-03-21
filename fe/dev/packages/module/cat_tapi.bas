Attribute VB_Name = "cat_tapi"
'========================================================================================
'=                 Kataloge - Repositorie
'= Version:
'========================================================================================
Option Compare Database
Private Const c_pstGrp_tabName As String = "cat_postgroups"

'**************************************** G E T *****************************************
'*******************************************|********************************************
'*       Gibt die ganze Zeile bzgl. Post-Id zurück
'* Version: 7.6
'****************************************************************************************
Public Function select_min_pgId_by_taId(pin_taId As Integer) As Integer
    Let select_min_pgId_by_taId = DMin("id", c_pstGrp_tabName, "ta_id = " & get_cur_taId())
End Function
