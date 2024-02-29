Attribute VB_Name = "env_api"
'==========================================================
'                  Enviroments-Schnittstelle
'==========================================================
Option Compare Database
'??????????????????????????????????????????????????????????
' ToDo: Nachdenken, ob es anders gelöst werden kann
'
'??????????????????????????????????????????????????????????



'**********************************************************
'*            ID's der Env.-Konstanten
'**********************************************************
' Id vom Post "Überweisung"
Public Function get_pdId_trf() As Integer
    Let get_pdId_trf = DLookup("pd_id", env.gv_cat_pst, "pd_dsg = '" & env.gc_pstDsc_trf & "'")
End Function

' Id vom Post "Monatseinlage"
Public Function get_pdId_dep() As Integer
    Let get_pdId_dep = DLookup("pd_id", env.gv_cat_pst, "pd_dsg = '" & env.gc_pstDsc_dps & "'")
End Function

' Id vom Konto "Brieftasche"
Public Function get_adId_csh() As Integer
    Let get_adId_csh = DLookup("ad_id", env.gv_cat_acc, "ad_dsg = '" & env.gc_accDsc_cash & "'")
End Function

' Id von der Transaktion "Überweisungen"
' ToDo: Vllt. "Gewinneutral" wäre besser
Public Function get_taId_tra() As Integer
    Let get_taId_tra = DLookup("ta_id", env.gv_cat_pst, "ta_dsg = '" & env.gc_taDsc_tra & "'")
End Function


'' Das gehört zu Enviroment, da ta_dsg sind Env.-Constanten
'' Gibt ta_id bei ta_dsg
'Public Function get_taId_byDsg(pin_taDsg As String) As Integer
'    Let get_taId_byDsg = DLookup("id", env.tbl_ta, "designation = '" & pin_taDsg & "'")
'End Function
