Attribute VB_Name = "grb_tapi"
'==========================================================
'=                 Groﬂbuch-Repositorie
'==========================================================
Option Compare Database

'**********************************************************
'*            POST (ins_)
'**********************************************************
Public Function ins_pos(pin_setGrb As typ_grb) As Integer
On Error GoTo exception
    ' Recordset
    Dim rcsGrb As Recordset
    Set rcsGrb = CurrentDb.OpenRecordset(env.gt_grb, dbOpenDynaset, dbFailOnError)
    
    With rcsGrb
        .AddNew
        
        !id = pin_setGrb.id
        !dat = pin_setGrb.dat
        !ad_id = pin_setGrb.acc
        !pd_id = pin_setGrb.pst
        !amt = pin_setGrb.amt
        !cmt = Left(pin_setGrb.cmt, 50)
        
        .Update
    End With
    
    Let ins_pos = 201
    GoTo ende
    
exception:
    Debug.Print Err.Number & " - " & Err.description
    Let ins_pos = 400
    
ende:
    If Not rcsGrb Is Nothing Then
        rcsGrb.Close
    End If
End Function


'**********************************************************
'*            DELETE (del_)
'**********************************************************
Public Function del_all_pos(pin_docId As String) As Integer
On Error GoTo exception
    ' Recordset
    Dim delSql As String
    Let delSql = "DELETE FROM " & env.gt_grb & _
                 " WHERE LEFT(id, 8) = '" & pin_docId & "';"
    
    Call CurrentDb.Execute(delSql, dbFailOnError)
    
    Let del_all_pos = 200
    Exit Function
    
exception:
    Debug.Print Err.Number & " - " & Err.description
    Let del_all_pos = 400
End Function
