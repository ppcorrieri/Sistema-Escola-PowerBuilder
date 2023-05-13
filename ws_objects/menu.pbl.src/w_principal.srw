$PBExportHeader$w_principal.srw
$PBExportComments$Teste de Conexãp
forward
global type w_principal from window
end type
type mdi_1 from mdiclient within w_principal
end type
end forward

global type w_principal from window
integer width = 5477
integer height = 2600
boolean titlebar = true
string menuname = "m_principal"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = mdihelp!
long backcolor = 67108864
string icon = "C:\Users\Pedro Paulo\Documents\PROJETO FINAL PB\IMG\icon.ico"
toolbaralignment toolbaralignment = alignatbottom!
boolean center = true
windowanimationstyle openanimation = fadeanimation!
windowanimationstyle closeanimation = fadeanimation!
integer animationtime = 100
windowdockoptions windowdockoptions = windowdockoptiontabbeddocumentonly!
mdi_1 mdi_1
end type
global w_principal w_principal

on w_principal.create
if this.MenuName = "m_principal" then this.MenuID = create m_principal
this.mdi_1=create mdi_1
this.Control[]={this.mdi_1}
end on

on w_principal.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
end on

event open;// Cria os Objetos Necessários
uog_usuario = create uo_usuario

uog_parametros_sistema = create uo_parametros_sistema

uog_usuario.of_verifica_acesso_usuario_logado(vgs_Email)

uog_parametros_sistema.of_recupera_parametro(1)

this.title = uog_parametros_sistema.vis_NomeSis

//Libera / Bloqueia os Menus
f_PermissaoAcessoMenu()

//Deleta todas as matrículas caso tenham ultrapassado a data de limite
f_FinalizaMatriculaAutomatica()

//Deleta todas as turmas que já tenham iniciado atividades e que não tenham matrículas relacionadas
//Existe um Prazo de 1 semana de cadastro de matrículas pra turmas novas
f_FinalizaTurmaAutomatica()

this.SetMicroHelp("Bem vindo, " +vgs_Nome)

//Abre a Janela de Boas Vindas
OpenSheet(w_home, w_principal, 1, Original!)



end event

event close;destroy uog_usuario
end event

type mdi_1 from mdiclient within w_principal
long BackColor=268435456
end type

