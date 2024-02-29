VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_frm_reports"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'=                 Formular: Berichte
'==========================================================
Option Compare Database


'==========================================================
'             Navigation
'==========================================================
Private Sub btn_close_Click()
    Call frm_xapi.cls_frm(Me.name)
End Sub


'==========================================================
'             Berichte
'==========================================================
' Jahres Kontostand
Private Sub btn_balance_Click()
    Call frm_xapi.opn_frm(env.gf_rpt_bal)
End Sub

''==========================================================
'==========================================================
' Zweck: Monats-Berichte
' TODO: qry durch Form oder Report ersätzen
'==========================================================
'' Monatsausgaben
''----------------------------------------------------------
'Private Sub btnMntAgb_Click()
'    ' Setze das Datum als aktuelles
'    Call mdlDatMng.setCurRng
'
'    DoCmd.OpenQuery "qryMntAgb"
'End Sub
'
''----------------------------------------------------------
'' Monatseinkommen
''----------------------------------------------------------
'Private Sub btnMntEkm_Click()
'    ' Setze das Datum als aktuelles
'    Call mdlDatMng.setCurRng
'
'    DoCmd.OpenQuery "qryMntEkm"
'End Sub
'
'
''==========================================================
''==========================================================
'' Zweck: Jahres-Berichte
''==========================================================
'' Monatsausgaben
''----------------------------------------------------------
'Private Sub btnJarAgb_Click()
'    ' Form öffnen
'    Call mdlFrmMng.opnFrm("frmJarAgb", "")
'End Sub
'
'Private Sub btnJarEkm_Click()
'
'End Sub
'
'Private Sub btnJarKntStd_Click()
'
'End Sub






