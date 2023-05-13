$PBExportHeader$w_visualizar_impressao.srw
$PBExportComments$Janela para visualização de impressão
forward
global type w_visualizar_impressao from window
end type
type cb_close from commandbutton within w_visualizar_impressao
end type
type dw_print from datawindow within w_visualizar_impressao
end type
end forward

global type w_visualizar_impressao from window
integer width = 2080
integer height = 2732
windowtype windowtype = popup!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_close cb_close
dw_print dw_print
end type
global w_visualizar_impressao w_visualizar_impressao

on w_visualizar_impressao.create
this.cb_close=create cb_close
this.dw_print=create dw_print
this.Control[]={this.cb_close,&
this.dw_print}
end on

on w_visualizar_impressao.destroy
destroy(this.cb_close)
destroy(this.dw_print)
end on

event open;dw_print.setTransObject(SQLCA)

dw_print.Modify("DataWindow.Zoom=60")

f_gera_matricula(dw_print)
end event

type cb_close from commandbutton within w_visualizar_impressao
integer x = 814
integer y = 2556
integer width = 457
integer height = 120
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string text = "Fechar"
end type

event clicked;close(w_visualizar_impressao)
end event

type dw_print from datawindow within w_visualizar_impressao
integer width = 2080
integer height = 3192
integer taborder = 10
string title = "none"
string dataobject = "dw_declaracao_matricula"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

