$PBExportHeader$w_documento_consulta_simples_padrao.srw
$PBExportComments$Janela Padrão de Consultas de Documento
forward
global type w_documento_consulta_simples_padrao from window
end type
type dw_print from datawindow within w_documento_consulta_simples_padrao
end type
type st_2 from statictext within w_documento_consulta_simples_padrao
end type
type dw_get from datawindow within w_documento_consulta_simples_padrao
end type
type dw_show from datawindow within w_documento_consulta_simples_padrao
end type
end forward

global type w_documento_consulta_simples_padrao from window
integer width = 5477
integer height = 2524
boolean titlebar = true
string title = "Untitled"
windowstate windowstate = maximized!
long backcolor = 67108864
boolean center = true
event u_reset_dddws ( )
event u_carrega_dddw ( )
event u_valida_get ( )
event u_retrieve_dados ( )
event u_abandonar_consulta ( )
event u_exportar_pdf ( )
event u_imprimir_doc ( )
dw_print dw_print
st_2 st_2
dw_get dw_get
dw_show dw_show
end type
global w_documento_consulta_simples_padrao w_documento_consulta_simples_padrao

event u_reset_dddws();// Reseta as Datawindows
dw_get.Reset()
dw_get.InsertRow(0)
dw_show.Reset()
end event

on w_documento_consulta_simples_padrao.create
this.dw_print=create dw_print
this.st_2=create st_2
this.dw_get=create dw_get
this.dw_show=create dw_show
this.Control[]={this.dw_print,&
this.st_2,&
this.dw_get,&
this.dw_show}
end on

on w_documento_consulta_simples_padrao.destroy
destroy(this.dw_print)
destroy(this.st_2)
destroy(this.dw_get)
destroy(this.dw_show)
end on

event open;//Fecha a Janela de Boas Vindas
close(w_home)

//Libera / Bloqueia os Menus
f_PermissaoAcessoMenu()
end event

type dw_print from datawindow within w_documento_consulta_simples_padrao
boolean visible = false
integer x = 270
integer y = 756
integer width = 686
integer height = 400
integer taborder = 20
string title = "none"
boolean livescroll = true
borderstyle borderstyle = StyleBox!
end type

type st_2 from statictext within w_documento_consulta_simples_padrao
integer x = 5
integer y = 356
integer width = 5472
integer height = 220
integer textsize = -24
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI Light"
long textcolor = 33554432
long backcolor = 553648127
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_get from datawindow within w_documento_consulta_simples_padrao
integer width = 6002
integer height = 304
integer taborder = 10
string title = "none"
boolean livescroll = true
borderstyle borderstyle = styleshadowbox!
end type

event constructor;this.setTransObject(SQLCA)
end event

type dw_show from datawindow within w_documento_consulta_simples_padrao
integer x = 1010
integer y = 756
integer width = 3365
integer height = 1164
integer taborder = 10
string title = "none"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;this.setTransObject(SQLCA)
end event

