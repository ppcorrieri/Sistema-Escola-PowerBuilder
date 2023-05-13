$PBExportHeader$excelolebasic.sra
$PBExportComments$Generated Application Object
forward
global type excelolebasic from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type excelolebasic from application
string appname = "excelolebasic"
end type
global excelolebasic excelolebasic

on excelolebasic.create
appname="excelolebasic"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on excelolebasic.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;open(w_main)
end event

