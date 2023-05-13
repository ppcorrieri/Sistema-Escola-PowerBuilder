$PBExportHeader$pbnismtp.sra
$PBExportComments$Generated Application Object
forward
global type pbnismtp from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type pbnismtp from application
string appname = "pbnismtp"
end type
global pbnismtp pbnismtp

on pbnismtp.create
appname="pbnismtp"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on pbnismtp.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

