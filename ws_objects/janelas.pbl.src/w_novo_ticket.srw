$PBExportHeader$w_novo_ticket.srw
$PBExportComments$Abertura de Novo Ticket
forward
global type w_novo_ticket from w_cadastro_simples_padrao
end type
end forward

global type w_novo_ticket from w_cadastro_simples_padrao
string title = "Novo Ticket"
end type
global w_novo_ticket w_novo_ticket

on w_novo_ticket.create
call super::create
end on

on w_novo_ticket.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;//Oculta o botão de recuperar
m_cadastro.m_cad.m_recuperar.Enabled = False
m_cadastro.m_cad.m_recuperar.ToolBarItemVisible = False

//Oculta o botão de editar
m_cadastro.m_cad.m_editar.Enabled = False
m_cadastro.m_cad.m_editar.ToolBarItemVisible = False

//Oculta o botão de apagar
m_cadastro.m_cad.m_deletar.Enabled = False
m_cadastro.m_cad.m_deletar.ToolBarItemVisible = False

//Seta as transações das Dw's
dw_show.setTransObject(sqlca)

dw_show.insertRow(0)

w_principal.SetMicroHelp("Cadastro de Tickets")

//Evento para Inicializar os campos
triggerEvent('u_inicializa_campos')
end event

event u_inicializa_campos;call super::u_inicializa_campos;String vls_DataABertura

//Seta a data Atual para a Data de Registro
vls_DataABertura = String(today(), "yyyy/mm/dd hh:mm:ss.ffffff")

dw_show.setItem(1, 'aberto_em', dateTime(vls_DataAbertura))

//Seta o usuário logado como quem abriu
dw_show.setItem(1, 'id_aberto_por', vgs_id_usuario)
end event

event u_update_dados;call super::u_update_dados;integer vli_Ret, vli_Ret2, vli_Opcao

vli_Ret = dw_show.update()

IF vli_Ret = 1 Then
	
	// confirma gravação no banco
	commit;
	vli_Opcao = f_messageBox('Sucesso!','O Ticket foi aberto! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','')
	
	dw_show.Reset()
	dw_show.InsertRow(0)

ELSE
	
	//Faz o Roolback
	rollback;
	vli_Opcao = f_messageBox('Erro!','Erro ao Abrir Ticket! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','') 
		
End if

return
end event

event u_valida_dados;call super::u_valida_dados;Integer vli_Categoria, vli_Opcao
String vls_Msg, vls_Titulo

//Sem modificações
if dw_show.RowCount() = 0 Then
	f_messageBox('Atenção!','Nenhuma modificação feita!~r~rDeseja Retornar?','SIM','')
	return
End if

dw_show.AcceptText()

//Atribui Todos os campos para fazer as devidas validações
vls_Titulo = dw_show.getItemString(1,'titulo')
vli_Categoria = dw_show.getItemNumber(1,'id_categoria')
vls_Msg = dw_show.getItemString(1,'mensagem')


If isnull(vls_Titulo) or isNumber(vls_Titulo) then
	vli_Opcao = f_messageBox('Atenção!','Título inválido ou não informado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('titulo')
	return
End If

If isnull(vls_Msg) then
	vli_Opcao = f_messageBox('Atenção!','Mensagem inválida ou não informado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('mensagem')
	return
End If

If isnull(vli_Categoria) then
	vli_Opcao = f_messageBox('Atenção!','Categoria inválida ou não informado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('id_categoria')
	return
End If
		

//Chama o Evento para Fazer Update dos Dados
triggerEvent('u_update_dados')
end event

type dw_get from w_cadastro_simples_padrao`dw_get within w_novo_ticket
boolean visible = false
end type

type st_1 from w_cadastro_simples_padrao`st_1 within w_novo_ticket
string text = "Abrir Ticket"
end type

type dw_show from w_cadastro_simples_padrao`dw_show within w_novo_ticket
integer x = 1248
integer y = 612
integer width = 2949
integer height = 1184
string dataobject = "dw_14"
end type

