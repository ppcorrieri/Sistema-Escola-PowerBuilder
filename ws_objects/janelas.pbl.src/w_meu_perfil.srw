$PBExportHeader$w_meu_perfil.srw
$PBExportComments$Tela para manutenção do perfil do usuário
forward
global type w_meu_perfil from window
end type
type dw_get from datawindow within w_meu_perfil
end type
type st_1 from statictext within w_meu_perfil
end type
type dw_show from datawindow within w_meu_perfil
end type
end forward

global type w_meu_perfil from window
integer width = 5495
integer height = 2616
boolean titlebar = true
string title = "Meu Perfil"
string menuname = "m_cadastro"
windowstate windowstate = maximized!
long backcolor = 67108864
string icon = "none"
boolean clientedge = true
boolean center = true
windowdockstate windowdockstate = windowdockstatefloating!
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
global w_meu_perfil w_meu_perfil

type variables
Integer vii_Opcao
Integer vis_id_usuario
uo_usuario uoi_usuario


boolean vlb_Click = TRUE
end variables

forward prototypes
public function integer wf_obtem_id_ultimo_usuario ()
public function boolean wf_calcularidade (date p_idade)
end prototypes

event u_inserir_linha();dw_show.insertRow(0)

//Evento para Inicializar os campos
triggerEvent('u_inicializa_campos')
end event

event u_update_dados();integer vli_Ret, vli_Opcao

dw_show.AcceptText()

vli_Ret = dw_show.update()

IF vli_Ret = 1 Then
	// confirma gravação no banco
	commit;
	vli_Opcao = f_messageBox('Sucesso!!','Os Dados foram Atualizados com sucesso! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','')
ELSE
	//Faz o Roolback
	rollback;
	vli_Opcao = f_messageBox('Erro!','Erro ao Atualizar os Dados! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','') 
		
End if

return
end event

event u_retrieve_dados();//Faz o Retrieve
dw_show.retrieve(vgs_id_usuario)

dw_show.object.usuarios_email.protect = 1
dw_show.object.usuarios_email.Background.Color = rgb(220,220,220)

dw_show.object.usuarios_cpf.protect = 1
dw_show.object.usuarios_cpf.Background.Color = rgb(220,220,220)

w_principal.SetMicroHelp("Meu Perfil")

end event

event u_excluir_linha();dw_show.deleteRow(dw_show.getRow())
end event

event u_valida_dados();Integer vli_Opcao, vli_NumLinhas
String vls_NomeUsuario, vls_Cpf_Usuario, vls_Email_Usuario, vls_Senha
Date vldt_Nascimento
Boolean vlb_EmailValido

//Sem modificações
if dw_show.modifiedcount( ) = 0 Then
	f_messageBox('Atenção!','Nenhuma modificação feita!~r~rDeseja Retornar?','SIM','')
	return
End if

dw_show.AcceptText()

//Atribui Todos os campos para fazer as devidas validações
vls_NomeUsuario = dw_show.getItemString(1,'usuarios_nome')
vls_Cpf_Usuario = dw_show.getItemString(1,'usuarios_cpf')
vldt_Nascimento = dw_show.getItemDate(1,'usuarios_dta_nascimento')
vls_Email_Usuario = dw_show.getItemString(1,'usuarios_email')
vls_Senha = dw_show.getItemString(1,'usuarios_senha')

If isnull(vls_NomeUsuario) then
	vli_Opcao = f_messageBox('Atenção!','Nome inválido ou não informado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('usuarios_nome')
	return
End If
		
If isnull(vls_Cpf_Usuario) then
	vli_Opcao = f_messageBox('Atenção!','CPF inválido ou não informado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('usuarios_cpf')
	return
End If
	
If not isnull(vls_Email_Usuario) then
	vlb_EmailValido = uoi_usuario.of_valida_email(vls_Email_Usuario)
	
	if not vlb_EmailValido then
		vli_Opcao = f_messageBox('Atenção!','Email inválido ou não informado!~r~rDeseja Retornar?','SIM','')  
		if vli_Opcao = 1 then dw_show.setColumn('usuarios_email')
		return
	End if
End If
	
If isnull(vls_Senha) then
	vli_Opcao = f_messageBox('Atenção!','Senha inválida ou não informada!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('usuarios_senha')
	return
End If
	
If isnull(vldt_Nascimento) then
	vli_Opcao = f_messageBox('Atenção!','Data de Nascimento inválida ou não informada!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('usuarios_dta_nascimento')
	return
Else
	if vldt_Nascimento > Today() Then
		vli_Opcao = f_messageBox('Atenção!','Data de Nascimento não pode ser maior que a Data de hoje!~r~rDeseja Retornar?','SIM','')
		return
	Else
		if wf_calcularIdade(vldt_Nascimento) = False Then
			vli_Opcao = f_messageBox('Atenção!','Idade mínima para realizar os cursos é de 15 anos!~r~rDeseja Retornar?','SIM','')
			return
		End if	
	End if
End if

//Chama o Evendo para Fazer Update dos Dados
triggerEvent('u_update_dados')
end event

event u_abandonar_cadastro();dw_show.AcceptText()

//Verifica se a DW foi Modificada
if (dw_show.ModifiedCount() > 0) Then
	vii_Opcao = f_messageBox('Atenção!','Deseja Abandonar O Cadastro Atual?','SIM','NÃO')
	//Chama o Retrieve para carregar os dados novamente
	if vii_Opcao = 1 then triggerEvent('u_retrieve_dados')
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

public function boolean wf_calcularidade (date p_idade);integer vli_AnosBissextos[], vli_AnoNasc, vli_Anos365, vli_Anos366, vli_Dias, vli_IdadePermitida
integer i, vli_i, count = 0
uo_parametros_sistema uol_parametros_sistema
uol_parametros_sistema = create uo_parametros_sistema

vli_AnoNasc = Year(p_idade)

vli_AnosBissextos = {1972, 1976, 1980, 1984, 1988, 1992, 1996, 2000, 2004, 2008, 2012, 2016, 2020, 2024, 2028, 2032}

//Verifica se o ano atual é bissexto
for i = 1 to UpperBound(vli_AnosBissextos[])
	if (vli_AnoNasc = vli_AnosBissextos[i]) then
		count ++
		vli_i = i
	end if
next

for i = 1 to UpperBound(vli_AnosBissextos[])
	if (vli_AnosBissextos[i] > vli_AnoNasc) then
		if (Year(Today()) > vli_AnoNasc) and (vli_AnosBissextos[i] < Year(Today()))  then
			count++
		end if
	end if
next

uol_parametros_sistema.of_recupera_parametro(1)

vli_IdadePermitida = uol_parametros_sistema.vis_IdadeMinCur

// Quantidade de anos normais com 365
vli_Anos365 = vli_IdadePermitida - count

// Quantidade de anos normais com 366
vli_Anos366 = vli_IdadePermitida - vli_Anos365

//Dias entre data de hoje e nascimento
vli_Dias = int(daysAfter(p_idade,Today()))

if vli_Dias >= (365 * vli_Anos365) + (366 * vli_Anos366) -1 then
	return True
else
	return False
end if

end function

on w_meu_perfil.create
if this.MenuName = "m_cadastro" then this.MenuID = create m_cadastro
this.dw_get=create dw_get
this.st_1=create st_1
this.dw_show=create dw_show
this.Control[]={this.dw_get,&
this.st_1,&
this.dw_show}
end on

on w_meu_perfil.destroy
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

m_cadastro.m_cad.m_editar.Enabled = False
m_cadastro.m_cad.m_editar.ToolBarItemVisible = False

m_cadastro.m_cad.m_deletar.Enabled = False
m_cadastro.m_cad.m_deletar.ToolBarItemVisible = False

dw_show.setTransObject(SQLCA)

//Cria os objetos necessários
uoi_usuario = create uo_usuario

this.triggerevent('u_retrieve_dados')



end event

event close;destroy uoi_usuario
end event

type dw_get from datawindow within w_meu_perfil
boolean visible = false
integer x = 18
integer width = 6002
integer height = 304
integer taborder = 10
string title = "none"
boolean livescroll = true
borderstyle borderstyle = styleshadowbox!
end type

type st_1 from statictext within w_meu_perfil
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
string text = "Meu Perfil"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_show from datawindow within w_meu_perfil
integer x = 1184
integer y = 472
integer width = 3104
integer height = 1128
integer taborder = 10
string title = "none"
string dataobject = "dw_11"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = styleshadowbox!
end type

event clicked;choose case dwo.name
	case 'b_mostrar_senha'
		
		if(vlb_Click) Then
			this.object.usuarios_senha.Edit.Password = "no"
			this.object.usuarios_senha.Format = ""
			this.object.b_mostrar_senha.Text = "🔒"
			vlb_Click = FALSE
		else
			this.object.usuarios_senha.Edit.Password = "yes"
			this.object.usuarios_senha.Format = "●●●●●●"
			this.object.b_mostrar_senha.Text = "👁"
			vlb_Click = TRUE
		end if
	
end choose
end event

