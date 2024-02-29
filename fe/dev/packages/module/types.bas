Attribute VB_Name = "types"
Option Compare Database

'**********************************************************
'*            Grossbuch
'**********************************************************
' Groﬂbuch-Datensatz
Public Type typ_grb
    id  As String
    dat As Date
    acc As Integer
    pst As Integer
    amt As Double
    cmt As String
End Type

'**********************************************************
'*            Posten
'**********************************************************
' transactions
Public Type ta_type
    id As Integer
    dsg As String
    rank As String
End Type

' postgroups
Public Type pg_type
    id As Integer
    dsg As String
    dsc As String
    rnk As String
    act As Boolean
    taid As Integer
End Type

' posts
Public Type pd_type
    id As Integer
    dsg As String
    dsc As String
    rnk As String
    trf As Boolean
    csh As Boolean
    act As Boolean
    pgid As Integer
End Type
