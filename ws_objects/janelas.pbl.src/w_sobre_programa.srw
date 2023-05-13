$PBExportHeader$w_sobre_programa.srw
$PBExportComments$Janela com informações sobre o programa
forward
global type w_sobre_programa from modal_padrao_response
end type
type st_7 from statictext within w_sobre_programa
end type
type st_1 from statictext within w_sobre_programa
end type
type st_4 from statictext within w_sobre_programa
end type
type st_6 from statictext within w_sobre_programa
end type
type st_8 from statictext within w_sobre_programa
end type
type st_10 from statictext within w_sobre_programa
end type
type st_9 from statictext within w_sobre_programa
end type
type st_5 from statictext within w_sobre_programa
end type
type st_nomeprograma from statictext within w_sobre_programa
end type
type st_3 from statictext within w_sobre_programa
end type
type p_1 from picture within w_sobre_programa
end type
type st_2 from statictext within w_sobre_programa
end type
end forward

global type w_sobre_programa from modal_padrao_response
integer width = 2629
integer height = 1948
string title = "Sobre o Sistema"
string icon = "QuestionIcon!"
st_7 st_7
st_1 st_1
st_4 st_4
st_6 st_6
st_8 st_8
st_10 st_10
st_9 st_9
st_5 st_5
st_nomeprograma st_nomeprograma
st_3 st_3
p_1 p_1
st_2 st_2
end type
global w_sobre_programa w_sobre_programa

on w_sobre_programa.create
int iCurrent
call super::create
this.st_7=create st_7
this.st_1=create st_1
this.st_4=create st_4
this.st_6=create st_6
this.st_8=create st_8
this.st_10=create st_10
this.st_9=create st_9
this.st_5=create st_5
this.st_nomeprograma=create st_nomeprograma
this.st_3=create st_3
this.p_1=create p_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_7
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_6
this.Control[iCurrent+5]=this.st_8
this.Control[iCurrent+6]=this.st_10
this.Control[iCurrent+7]=this.st_9
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.st_nomeprograma
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.p_1
this.Control[iCurrent+12]=this.st_2
end on

on w_sobre_programa.destroy
call super::destroy
destroy(this.st_7)
destroy(this.st_1)
destroy(this.st_4)
destroy(this.st_6)
destroy(this.st_8)
destroy(this.st_10)
destroy(this.st_9)
destroy(this.st_5)
destroy(this.st_nomeprograma)
destroy(this.st_3)
destroy(this.p_1)
destroy(this.st_2)
end on

event open;call super::open;st_NomePrograma.text = uog_parametros_sistema.vis_NomeSis
end event

type st_7 from statictext within w_sobre_programa
integer x = 174
integer y = 920
integer width = 2281
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Professor:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_sobre_programa
integer x = 174
integer y = 996
integer width = 2281
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rodrigo Vilela da Silva"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_sobre_programa
integer x = 169
integer y = 1084
integer width = 2281
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Apoio:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_sobre_programa
integer x = 151
integer y = 1488
integer width = 2299
integer height = 208
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Este software simula um sistema escolar, uso para fins comerciais não permitidos                     Sistema Open Source, Aberto para Modificações"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_8 from statictext within w_sobre_programa
integer x = 169
integer y = 1408
integer width = 2281
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sobre:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_10 from statictext within w_sobre_programa
integer x = 169
integer y = 1312
integer width = 2281
integer height = 76
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "ppcorrieri@gmail.com"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_9 from statictext within w_sobre_programa
integer x = 169
integer y = 1244
integer width = 2281
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Contato:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from statictext within w_sobre_programa
integer x = 169
integer y = 1156
integer width = 2281
integer height = 76
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "SENAI / ENERGISA"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_nomeprograma from statictext within w_sobre_programa
boolean visible = false
integer x = 169
integer y = 720
integer width = 2281
integer height = 124
integer textsize = -16
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_sobre_programa
integer x = 169
integer y = 828
integer width = 2281
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pedro Paulo de Oliveira Corrieri"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_1 from picture within w_sobre_programa
integer x = 169
integer y = 160
integer width = 2281
integer height = 556
string picturename = "C:\Pedro Paulo de Oliveira Corrieri\PROJETO FINAL PB\IMG\gestaoescolar.png"
boolean focusrectangle = false
end type

type st_2 from statictext within w_sobre_programa
integer x = 169
integer y = 752
integer width = 2281
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desenvolvedor:"
alignment alignment = center!
boolean focusrectangle = false
end type

