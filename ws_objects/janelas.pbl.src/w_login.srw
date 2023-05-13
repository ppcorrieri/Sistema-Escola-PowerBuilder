$PBExportHeader$w_login.srw
$PBExportComments$Tela Inicial de Login
forward
global type w_login from window
end type
type st_3 from statictext within w_login
end type
type shl_1 from statichyperlink within w_login
end type
type st_2 from statictext within w_login
end type
type st_1 from statictext within w_login
end type
type st_senha from singlelineedit within w_login
end type
type st_login from singlelineedit within w_login
end type
type b_login from commandbutton within w_login
end type
type p_1 from picture within w_login
end type
end forward

global type w_login from window
integer width = 2053
integer height = 1716
boolean titlebar = true
string title = "Login"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 67108864
string icon = "C:\Users\Pedro Paulo\Documents\PROJETO FINAL PB\IMG\icon.ico"
boolean center = true
st_3 st_3
shl_1 shl_1
st_2 st_2
st_1 st_1
st_senha st_senha
st_login st_login
b_login b_login
p_1 p_1
end type
global w_login w_login

type variables
uo_usuario uoi_usuario

end variables

on w_login.create
this.st_3=create st_3
this.shl_1=create shl_1
this.st_2=create st_2
this.st_1=create st_1
this.st_senha=create st_senha
this.st_login=create st_login
this.b_login=create b_login
this.p_1=create p_1
this.Control[]={this.st_3,&
this.shl_1,&
this.st_2,&
this.st_1,&
this.st_senha,&
this.st_login,&
this.b_login,&
this.p_1}
end on

on w_login.destroy
destroy(this.st_3)
destroy(this.shl_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.st_senha)
destroy(this.st_login)
destroy(this.b_login)
destroy(this.p_1)
end on

event key;//Verifica se o Usuário fez a submissão pelo Enter

IF key = KeyEnter! THEN
	b_login.PostEvent(Clicked!)
End If
end event

event open;// Cria os Objetos Necessários
uoi_usuario = create uo_usuario
end event

event close;//Destrói os Objetos inicializados
destroy uoi_usuario

end event

type st_3 from statictext within w_login
integer y = 576
integer width = 2043
integer height = 144
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
boolean italic = true
long textcolor = 26830387
long backcolor = 553648127
string text = "Login"
alignment alignment = center!
boolean focusrectangle = false
end type

type shl_1 from statichyperlink within w_login
integer x = 1253
integer y = 1320
integer width = 457
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 15780518
long backcolor = 553648127
string text = "Esqueci a Senha"
boolean focusrectangle = false
end type

event clicked;open(w_recuperar_acesso)
end event

type st_2 from statictext within w_login
integer x = 361
integer y = 944
integer width = 457
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 26830387
long backcolor = 67108864
string text = "Senha"
boolean focusrectangle = false
end type

type st_1 from statictext within w_login
integer x = 366
integer y = 744
integer width = 457
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 26830387
long backcolor = 67108864
string text = "Email"
boolean focusrectangle = false
end type

type st_senha from singlelineedit within w_login
integer x = 361
integer y = 1012
integer width = 1349
integer height = 124
integer taborder = 20
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type st_login from singlelineedit within w_login
integer x = 361
integer y = 816
integer width = 1349
integer height = 120
integer taborder = 10
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type b_login from commandbutton within w_login
integer x = 361
integer y = 1168
integer width = 1349
integer height = 136
integer taborder = 30
string dragicon = "AppIcon!"
boolean dragauto = true
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string text = "ENTRAR"
boolean default = true
end type

event clicked;String vls_Email, vls_Senha
Boolean vlb_Logado = False

//Recebe os dados preenchidos nas labels
vls_Email = st_login.Text
vls_Senha = st_senha.Text

//Verifica se existe os dados no banco
vlb_Logado = uoi_usuario.wf_verifica_usuario_logado(vls_Email, vls_Senha)

//Verifica se o usuário está logado e faz o devido redirecionamento
if vlb_Logado then
	//Abre a Janela Principal
	open(w_principal)
	
	//Fecha a Janela Atual
	close(w_login)
End if


end event

type p_1 from picture within w_login
integer y = 56
integer width = 2043
integer height = 492
integer taborder = 60
string picturename = "C:\Pedro Paulo de Oliveira Corrieri\PROJETO FINAL PB\IMG\gestaoescolar.png"
boolean focusrectangle = false
end type

