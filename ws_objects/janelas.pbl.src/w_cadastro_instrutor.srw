$PBExportHeader$w_cadastro_instrutor.srw
$PBExportComments$Janela para Cadastro de Instrutores
forward
global type w_cadastro_instrutor from w_cadastro_simples_padrao
end type
type dw_instrutor from datawindow within w_cadastro_instrutor
end type
end forward

global type w_cadastro_instrutor from w_cadastro_simples_padrao
string title = "Cadastro de Instrutores"
dw_instrutor dw_instrutor
end type
global w_cadastro_instrutor w_cadastro_instrutor

type variables
//=======================================================================================
//  Data     Responsável     Modificação
//  -------- --------------- ------------------------------------------------------------
//  18/05/01 Ramon, RSO      Mudança do pointer para AMPULHETA ao iniciar qualquer
//                           processamento disparado pelo usuário.
//  15/03/05 Thiago, TCP     Inclusão do processo de Gravação do Log
//=======================================================================================

Integer vis_id_usuario, vii_Opcao
uo_usuario uoi_usuario
end variables

event open;call super::open;//Oculta o botão de recuperar
m_cadastro.m_cad.m_recuperar.Enabled = False
m_cadastro.m_cad.m_recuperar.ToolBarItemVisible = False

//Oculta o botão de editar
m_cadastro.m_cad.m_editar.Enabled = False
m_cadastro.m_cad.m_editar.ToolBarItemVisible = False

//Oculta o botão de apagar
m_cadastro.m_cad.m_deletar.Enabled = False
m_cadastro.m_cad.m_deletar.ToolBarItemVisible = False

// Cria os Objetos Necessários
uoi_usuario = create uo_usuario

//Seta as transações das Dw's
dw_show.setTransObject(sqlca)
dw_instrutor.setTransObject(sqlca)

//Obtem o último ID de usuário cadastrado
vis_id_usuario = wf_obtem_id_ultimo_usuario()

dw_show.insertRow(0)
dw_instrutor.insertRow(0)

w_principal.SetMicroHelp("Cadastro de Instrutores")

//Evento para Inicializar os campos
triggerEvent('u_inicializa_campos')

end event

on w_cadastro_instrutor.create
int iCurrent
call super::create
this.dw_instrutor=create dw_instrutor
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_instrutor
end on

on w_cadastro_instrutor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_instrutor)
end on

event close;call super::close;//Destrói os Objetos inicializados
destroy uoi_usuario

end event

event u_abandonar_cadastro;call super::u_abandonar_cadastro;//Verifica se a DW foi Modificada
if (dw_show.ModifiedCount() > 0) Then
	vii_Opcao = f_messageBox('Atenção!','Deseja Abandonar O Cadastro Atual?','SIM','NÃO')  
	if vii_Opcao = 1 then triggerEvent('u_reset_dw')
	if vii_Opcao = 2 then return
	
Else
	vii_Opcao = f_messageBox('Atenção!','Nenhum dado foi modificado~r~rDeseja Retornar?','SIM','')  
	if vii_Opcao = 1 then return
End if
end event

event u_update_dados;call super::u_update_dados;integer vli_Ret, vli_Ret2, vli_Opcao

vli_Ret = dw_show.update()
vli_Ret2 = dw_instrutor.update()

IF vli_Ret = 1 and vli_Ret2 = 1 Then
	
	// confirma gravação no banco
	commit;
	vli_Opcao = f_messageBox('Sucesso!!','Cadastro Realizado Com Sucesso! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','')
	
	dw_show.Reset()
	dw_instrutor.Reset()
	
	//Chama Evento Open
	//Através dele irá gerar próximo ID inicializando os campos invisíveis
	triggerevent('open')

ELSE
	
	//Faz o Roolback
	rollback;
	vli_Opcao = f_messageBox('Erro!','Erro ao Cadastrar Instrutor! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','') 
		
End if

return
end event

event u_valida_dados;call super::u_valida_dados;Integer vli_Opcao, vli_NumLinhas
String vls_NomeUsuario, vls_Cpf_Usuario, vls_Email_Usuario, vls_Senha
Date vldt_Nascimento
Boolean vlb_EmailValido

//Sem modificações
if dw_show.RowCount() = 0 Then
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
	
If not isnull(vlb_EmailValido) then
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

End if

//Chama o Evento para Fazer Update dos Dados
triggerEvent('u_update_dados')
end event

event u_inicializa_campos;call super::u_inicializa_campos;String vls_DataRegistro

//Seta a data Atual para a Data de Registro
vls_DataRegistro = String(Today(), "dd/mm/yyyy")
dw_show.setItem(1, 'usuarios_dta_registro', date(vls_DataRegistro))

//Seta o próximo ID
dw_show.setItem(1, 'usuarios_id_usuario', vis_id_usuario+1)

//Seta o próximo ID
dw_instrutor.setItem(1, 'instrutor_id_usuario', vis_id_usuario+1)

//Seta o tipo de usuário 'I' -> Instrutor
dw_show.setItem(1, 'usuarios_tipo_usuario', 'I')
dw_instrutor.setItem(1, 'instrutor_tipo_usuario', 'I')
end event

event u_excluir_linha;call super::u_excluir_linha;dw_instrutor.deleteRow(dw_show.getRow())
end event

type dw_get from w_cadastro_simples_padrao`dw_get within w_cadastro_instrutor
boolean visible = false
end type

type st_1 from w_cadastro_simples_padrao`st_1 within w_cadastro_instrutor
string text = "Cadastro de Instrutor"
end type

type dw_show from w_cadastro_simples_padrao`dw_show within w_cadastro_instrutor
integer x = 1207
integer y = 516
integer width = 3159
string dataobject = "dw_01"
end type

type dw_instrutor from datawindow within w_cadastro_instrutor
integer x = 2747
integer y = 1288
integer width = 1367
integer height = 264
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "dw_05"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = styleshadowbox!
end type

event itemchanged;this.Accepttext( )

end event

