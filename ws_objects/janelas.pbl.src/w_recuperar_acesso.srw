$PBExportHeader$w_recuperar_acesso.srw
$PBExportComments$Janela para recuperação de acesso
forward
global type w_recuperar_acesso from modal_padrao_response
end type
type uo_email from u_tabpg_smtp within w_recuperar_acesso
end type
type st_2 from statictext within w_recuperar_acesso
end type
type st_1 from statictext within w_recuperar_acesso
end type
type b_recuperar from commandbutton within w_recuperar_acesso
end type
type p_1 from picture within w_recuperar_acesso
end type
type st_email from singlelineedit within w_recuperar_acesso
end type
type n_cpp_smtp_1 from n_cpp_smtp within w_recuperar_acesso
end type
end forward

global type w_recuperar_acesso from modal_padrao_response
integer width = 2053
integer height = 1716
string title = "Recuperação de Conta"
string icon = "C:\Users\Pedro Paulo\Documents\PROJETO FINAL PB\IMG\icon.ico"
uo_email uo_email
st_2 st_2
st_1 st_1
b_recuperar b_recuperar
p_1 p_1
st_email st_email
n_cpp_smtp_1 n_cpp_smtp_1
end type
global w_recuperar_acesso w_recuperar_acesso

type variables

end variables

on w_recuperar_acesso.create
int iCurrent
call super::create
this.uo_email=create uo_email
this.st_2=create st_2
this.st_1=create st_1
this.b_recuperar=create b_recuperar
this.p_1=create p_1
this.st_email=create st_email
this.n_cpp_smtp_1=create n_cpp_smtp_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_email
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.b_recuperar
this.Control[iCurrent+5]=this.p_1
this.Control[iCurrent+6]=this.st_email
end on

on w_recuperar_acesso.destroy
call super::destroy
destroy(this.uo_email)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.b_recuperar)
destroy(this.p_1)
destroy(this.st_email)
destroy(this.n_cpp_smtp_1)
end on

event key;call super::key;//Verifica se o Usuário fez a submissão pelo Enter

IF key = KeyEnter! THEN
	b_recuperar.PostEvent(Clicked!)
End If
end event

type uo_email from u_tabpg_smtp within w_recuperar_acesso
boolean visible = false
integer x = 2336
integer y = 52
integer taborder = 90
end type

on uo_email.destroy
call u_tabpg_smtp::destroy
end on

type st_2 from statictext within w_recuperar_acesso
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
long textcolor = 33554432
long backcolor = 67108864
string text = "Recuperação"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_recuperar_acesso
integer x = 361
integer y = 844
integer width = 457
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Email"
boolean focusrectangle = false
end type

type b_recuperar from commandbutton within w_recuperar_acesso
accessiblerole accessiblerole = progressbarrole!
integer x = 361
integer y = 1072
integer width = 1349
integer height = 136
integer taborder = 20
string dragicon = "AppIcon!"
boolean dragauto = true
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string text = "ENVIAR"
boolean default = true
end type

event clicked;String vls_Email, vls_Senha
uo_usuario uol_usuario

// Cria os Objetos Necessários
uol_usuario = create uo_usuario

vls_Email = st_email.Text
vls_Senha = uol_usuario.of_recupera_senha(vls_Email)

// Se recuperou a Senha, então chama o evento para enviar o email
if vls_Senha <> '' Then
	
	//Ajusta o objeto de envio de email
	uo_email.sle_recip_email.text = vls_Email
	uo_email.mle_body.text = '<body marginheight="0" topmargin="0" marginwidth="0" style="margin: 0px; background-color: #f2f3f8;" leftmargin="0">     <!--100% body table-->     <table cellspacing="0" border="0" cellpadding="0" width="100%" bgcolor="#f2f3f8"         style="@import url(https://fonts.googleapis.com/css?family=Rubik:300,400,500,700|Open+Sans:300,400,600,700); font-family: "Open Sans", sans-serif;">         <tr>             <td>                 <table style="background-color: #f2f3f8; max-width:670px;  margin:0 auto;" width="100%" border="0"                     align="center" cellpadding="0" cellspacing="0">                     <tr>                         <td style="height:80px;">&nbsp;</td>                     </tr>                     <tr>                         <td style="text-align:center;">                         </td>                     </tr>                     <tr>                         <td style="height:20px;">&nbsp;</td>                     </tr>                     <tr>                         <td>                             <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0"                                 style="max-width:670px;background:#fff; border-radius:3px; text-align:center;-webkit-box-shadow:0 6px 18px 0 rgba(0,0,0,.06);-moz-box-shadow:0 6px 18px 0 rgba(0,0,0,.06);box-shadow:0 6px 18px 0 rgba(0,0,0,.06);">                                 <tr>                                     <td style="height:40px;">&nbsp;</td>                                 </tr>                                 <tr>                                     <td style="padding:0 35px;">                                         <h1 style="color:#1e1e2d; font-weight:500; margin:0;font-size:32px;font-family:"Rubik",sans-serif;">Atenção!</h1><br><br> <h3>Você solicitou a recuperação de senha. <br>Favor desconsiderar esse email caso não tenha solicitado</h3>                                         <span                                             style="display:inline-block; vertical-align:middle; margin:29px 0 26px; border-bottom:1px solid #cecece; width:100px;"></span>                                         <p style="color:#455056; font-size:17px;line-height:24px; margin:0;">                                             A sua senha é:                                       <h5>'+ vls_Senha +'</h5>                                         </p>                                         <a href="javascript:void(0);"                                             style="background:#20e277;text-decoration:none !important; font-weight:500; margin-top:35px; color:#fff;text-transform:uppercase; font-size:14px;padding:10px 24px;display:inline-block;border-radius:50px;">Saiba mais</a>                                     </td>                                 </tr>                                 <tr>                                     <td style="height:40px;">&nbsp;</td>                                 </tr>                             </table>                         </td>                     <tr>                         <td style="height:20px;">&nbsp;</td>                     </tr>                     <tr>                         <td style="text-align:center;">                             <p style="font-size:14px; color:rgba(69, 80, 86, 0.7411764705882353); line-height:18px; margin:0 0 0;">&copy; <strong>Sistema Escola Online 2023</strong></p>                         </td>                     </tr>                     <tr>                         <td style="height:80px;">&nbsp;</td>                     </tr>                 </table>             </td>         </tr>     </table>     <!--/100% body table--> </body>'																		
	uo_email.cb_send.event clicked( )
Else
	MessageBox("Atenção!", "O Email está incorreto, nenhum usuário encontrado", StopSign!)
End if


destroy uol_usuario


end event

type p_1 from picture within w_recuperar_acesso
integer y = 56
integer width = 2039
integer height = 492
string picturename = "C:\Users\Pedro Paulo\Documents\PROJETO FINAL PB\IMG\gestaoescolar.png"
boolean focusrectangle = false
end type

type st_email from singlelineedit within w_recuperar_acesso
integer x = 361
integer y = 920
integer width = 1349
integer height = 120
integer taborder = 10
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type n_cpp_smtp_1 from n_cpp_smtp within w_recuperar_acesso descriptor "pb_nvo" = "true" 
end type

on n_cpp_smtp_1.create
call super::create
end on

on n_cpp_smtp_1.destroy
call super::destroy
end on

