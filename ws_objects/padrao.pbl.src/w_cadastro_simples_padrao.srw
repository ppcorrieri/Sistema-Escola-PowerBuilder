$PBExportHeader$w_cadastro_simples_padrao.srw
$PBExportComments$Tela para cadastro Simples com GET
forward
global type w_cadastro_simples_padrao from window
end type
type dw_get from datawindow within w_cadastro_simples_padrao
end type
type st_1 from statictext within w_cadastro_simples_padrao
end type
type dw_show from datawindow within w_cadastro_simples_padrao
end type
end forward

global type w_cadastro_simples_padrao from window
integer width = 5477
integer height = 2600
boolean titlebar = true
string title = "Cadastro de Alunos"
string menuname = "m_cadastro"
windowstate windowstate = maximized!
long backcolor = 67108864
string icon = "none"
boolean center = true
event insere_item ( long p_row )
event u_inicializa_campos ( )
event u_inserir_linha ( )
event u_update_dados ( )
event u_retrieve_dados ( )
event u_excluir_linha ( )
event u_valida_dados ( )
event u_abandonar_cadastro ( )
event u_reset_dw ( )
event u_delete_dados ( )
dw_get dw_get
st_1 st_1
dw_show dw_show
end type
global w_cadastro_simples_padrao w_cadastro_simples_padrao

type variables

end variables

forward prototypes
public function integer wf_obtem_id_ultimo_usuario ()
end prototypes

event u_inserir_linha();dw_show.insertRow(0)

//Evento para Inicializar os campos
triggerEvent('u_inicializa_campos')
end event

event u_excluir_linha();dw_show.deleteRow(dw_show.getRow())
end event

event u_reset_dw();// Reseta as Datawindows
dw_show.Reset()
dw_show.InsertRow(0)
end event

public function integer wf_obtem_id_ultimo_usuario ();Integer vli_id_usuario

SELECT max (id_usuario)
into: vli_id_usuario
from usuarios;

return vli_id_usuario
end function

on w_cadastro_simples_padrao.create
if this.MenuName = "m_cadastro" then this.MenuID = create m_cadastro
this.dw_get=create dw_get
this.st_1=create st_1
this.dw_show=create dw_show
this.Control[]={this.dw_get,&
this.st_1,&
this.dw_show}
end on

on w_cadastro_simples_padrao.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_get)
destroy(this.st_1)
destroy(this.dw_show)
end on

event open;//Fecha a Janela de Boas Vindas
close(w_home)

//Libera / Bloqueia os Menus
f_PermissaoAcessoMenu()

//Oculta os botões de Inserir / Remover Linha
m_cadastro.m_cad.m_inserir.Enabled = False
m_cadastro.m_cad.m_inserir.ToolBarItemVisible = False

m_cadastro.m_cad.m_excluir.Enabled = False
m_cadastro.m_cad.m_excluir.ToolBarItemVisible = False



end event

type dw_get from datawindow within w_cadastro_simples_padrao
integer x = 18
integer width = 6002
integer height = 304
integer taborder = 10
string title = "none"
boolean livescroll = true
borderstyle borderstyle = styleshadowbox!
end type

type st_1 from statictext within w_cadastro_simples_padrao
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

type dw_show from datawindow within w_cadastro_simples_padrao
integer x = 1010
integer y = 756
integer width = 3365
integer height = 1064
integer taborder = 10
string title = "none"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = styleshadowbox!
end type

