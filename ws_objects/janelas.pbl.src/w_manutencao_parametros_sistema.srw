$PBExportHeader$w_manutencao_parametros_sistema.srw
$PBExportComments$Tela para manutenção de parâmetros do Sistema
forward
global type w_manutencao_parametros_sistema from window
end type
type dw_get from datawindow within w_manutencao_parametros_sistema
end type
type st_1 from statictext within w_manutencao_parametros_sistema
end type
type dw_show from datawindow within w_manutencao_parametros_sistema
end type
end forward

global type w_manutencao_parametros_sistema from window
integer width = 5477
integer height = 2600
boolean titlebar = true
string title = "Parâmetros do Sistema"
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
dw_get dw_get
st_1 st_1
dw_show dw_show
end type
global w_manutencao_parametros_sistema w_manutencao_parametros_sistema

type variables
Integer vii_Opcao
end variables

forward prototypes
public function integer wf_obtem_id_ultimo_usuario ()
end prototypes

event u_inserir_linha();dw_show.insertRow(0)

//Evento para Inicializar os campos
triggerEvent('u_inicializa_campos')
end event

event u_update_dados();integer vli_Ret, vli_Opcao

vli_Ret = dw_show.update()

IF vli_Ret = 1 Then
	// confirma gravação no banco
	commit;
	vli_Opcao = f_messageBox('Sucesso!!','Cadastro Realizado Com Sucesso! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','')
ELSE
	//Faz o Roolback
	rollback;
	vli_Opcao = f_messageBox('Erro!','Erro ao Cadastrar Curso! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','') 
		
End if

return
end event

event u_retrieve_dados();//Faz o Retrieve
dw_show.retrieve(1)
end event

event u_excluir_linha();dw_show.deleteRow(dw_show.getRow())
end event

event u_valida_dados();Integer vli_IdadeMinima, vli_Opcao
String vls_NomeSistema

dw_show.AcceptText()

//Sem modificações
if dw_show.modifiedcount( ) = 0 Then
	f_messageBox('Atenção!','Nenhuma modificação feita!~r~rDeseja Retornar?','SIM','')
	return
End if

//Atribui Todos os campos para fazer as devidas validações
vls_NomeSistema = dw_show.getItemString(1,'nome_sistema')
vli_IdadeMinima = dw_show.getItemNumber(1,'idade_minima_curso')

If isnull(vls_NomeSistema) then
	vli_Opcao = f_messageBox('Atenção!','Nome inválido ou não informado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('nome_sistema')
	return
End If
		
If isnull(vli_IdadeMinima) then
	vli_Opcao = f_messageBox('Atenção!','Idade inválida ou não informada!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('idade_minima_curso')
	return
End If

//Chama o Evento para Fazer Update dos Dados
triggerEvent('u_update_dados')
end event

event u_abandonar_cadastro();//Verifica se a DW foi Modificada
if (dw_show.ModifiedCount() > 0) Then
	vii_Opcao = f_messageBox('Atenção!','Deseja Abandonar O Cadastro Atual?','SIM','NÃO')  
	if vii_Opcao = 1 then triggerEvent('u_reset_dw')
	if vii_Opcao = 2 then return
	
Else
	vii_Opcao = f_messageBox('Atenção!','Nenhum dado foi modificado~r~rDeseja Retornar?','SIM','')  
	if vii_Opcao = 1 then return
End if
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

on w_manutencao_parametros_sistema.create
if this.MenuName = "m_cadastro" then this.MenuID = create m_cadastro
this.dw_get=create dw_get
this.st_1=create st_1
this.dw_show=create dw_show
this.Control[]={this.dw_get,&
this.st_1,&
this.dw_show}
end on

on w_manutencao_parametros_sistema.destroy
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

m_cadastro.m_cad.m_recuperar.Enabled = False
m_cadastro.m_cad.m_recuperar.ToolBarItemVisible = False

//Oculta o botão de editar
m_cadastro.m_cad.m_editar.Enabled = False
m_cadastro.m_cad.m_editar.ToolBarItemVisible = False

//Oculta o botão de apagar
m_cadastro.m_cad.m_deletar.Enabled = False
m_cadastro.m_cad.m_deletar.ToolBarItemVisible = False

w_principal.SetMicroHelp("Manutenção de Parâmetros do Sistema")

dw_show.setTransObject(SQLCA)
this.triggerevent('u_retrieve_dados')



end event

type dw_get from datawindow within w_manutencao_parametros_sistema
boolean visible = false
integer x = 18
integer width = 6002
integer height = 304
integer taborder = 10
string title = "none"
boolean livescroll = true
borderstyle borderstyle = styleshadowbox!
end type

type st_1 from statictext within w_manutencao_parametros_sistema
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
string text = "Parâmetros do Sistema"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_show from datawindow within w_manutencao_parametros_sistema
integer x = 1129
integer y = 756
integer width = 3154
integer height = 1064
integer taborder = 10
string title = "none"
string dataobject = "dw_parametros_sistema"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = styleshadowbox!
end type

event clicked;string docpath, docname[], vls_imagem, vls_filtro
integer i, vli_cnt, vli_rtn

choose case dwo.name
	case 'b_upload'
		vli_rtn = GetFileOpenName("Selecionar Arquivo", docpath, docname[], "*.jpg;*.jpeg;*.png",+ "Graphic Files (*.bmp;*.gif;*.jpg;*.jpeg),*.bmp;*.gif;*.jpg;*.jpeg", "C:\Program Files\Appeon", 18)

//mle_selected.text = ""
IF vli_rtn < 1 THEN return
vli_cnt = Upperbound(docname)

// if only one file is picked, docpath contains the 
// path and file name
if vli_cnt = 1 then
   vls_imagem = string(docpath)
    //sle_imagem.text=is_imagem
else

// if multiple files are picked, docpath contains the 
// path only - concatenate docpath and docname
   for i=1 to vli_cnt
      vls_imagem += string(docpath) &
         + "" +(string(docname[i]))+"~r~n"
   next
end if

dw_show.setitem(1,"assinatura_diretor",vls_imagem)

end choose
end event

