$PBExportHeader$w_home.srw
$PBExportComments$Janela de Boas Vindas
forward
global type w_home from window
end type
type st_1 from statictext within w_home
end type
type cb_close from commandbutton within w_home
end type
type p_1 from picture within w_home
end type
type st_hora from statictext within w_home
end type
type st_data from statictext within w_home
end type
type st_inicial from statictext within w_home
end type
type r_1 from rectangle within w_home
end type
end forward

global type w_home from window
integer width = 4050
integer height = 1932
windowtype windowtype = response!
long backcolor = 67108864
boolean center = true
windowanimationstyle closeanimation = fadeanimation!
integer animationtime = 500
st_1 st_1
cb_close cb_close
p_1 p_1
st_hora st_hora
st_data st_data
st_inicial st_inicial
r_1 r_1
end type
global w_home w_home

on w_home.create
this.st_1=create st_1
this.cb_close=create cb_close
this.p_1=create p_1
this.st_hora=create st_hora
this.st_data=create st_data
this.st_inicial=create st_inicial
this.r_1=create r_1
this.Control[]={this.st_1,&
this.cb_close,&
this.p_1,&
this.st_hora,&
this.st_data,&
this.st_inicial,&
this.r_1}
end on

on w_home.destroy
destroy(this.st_1)
destroy(this.cb_close)
destroy(this.p_1)
destroy(this.st_hora)
destroy(this.st_data)
destroy(this.st_inicial)
destroy(this.r_1)
end on

event open;st_inicial.text = vgs_Nome


st_data.text=string(today())
st_hora.text=string(now(), "hh:mm")
timer(0.3)

end event

event timer;st_hora.text=string(now(), "hh:mm")
end event

type st_1 from statictext within w_home
integer x = 9
integer y = 792
integer width = 4050
integer height = 164
boolean bringtotop = true
integer textsize = -22
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI Light"
long textcolor = 26830387
long backcolor = 553648127
string text = "Bem Vindo,"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_home
integer x = 1545
integer y = 1648
integer width = 955
integer height = 200
integer taborder = 10
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string text = "FECHAR"
boolean default = true
end type

event clicked;close(w_home)
end event

type p_1 from picture within w_home
integer x = 978
integer y = 212
integer width = 2039
integer height = 492
string picturename = "C:\Pedro Paulo de Oliveira Corrieri\PROJETO FINAL PB\IMG\gestaoescolar.png"
boolean focusrectangle = false
end type

type st_hora from statictext within w_home
integer x = 1847
integer y = 1484
integer width = 384
integer height = 96
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI Light"
long textcolor = 26830387
long backcolor = 553648127
string text = "none"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_data from statictext within w_home
integer x = 1847
integer y = 1568
integer width = 384
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI Light"
long textcolor = 26830387
long backcolor = 553648127
string text = "none"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_inicial from statictext within w_home
integer y = 988
integer width = 4050
integer height = 164
boolean bringtotop = true
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI Light"
long textcolor = 26830387
long backcolor = 553648127
string text = "none"
alignment alignment = center!
boolean focusrectangle = false
end type

type r_1 from rectangle within w_home
long linecolor = 33554431
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 26830387
integer y = 1752
integer width = 4101
integer height = 180
end type

