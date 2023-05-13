$PBExportHeader$w_cadastro_turmas.srw
$PBExportComments$Janela Para Cadastro de Turmas, Relação com Instrutor e Curso
forward
global type w_cadastro_turmas from w_cadastro_simples_padrao
end type
end forward

global type w_cadastro_turmas from w_cadastro_simples_padrao
string title = "Cadastro de Turmas"
end type
global w_cadastro_turmas w_cadastro_turmas

type variables
integer vii_Opcao
end variables

on w_cadastro_turmas.create
call super::create
end on

on w_cadastro_turmas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event u_update_dados;call super::u_update_dados;integer vli_Ret, vli_Opcao

vli_Ret = dw_show.update()

IF vli_Ret = 1 Then
	// confirma gravação no banco
	commit;
	vli_Opcao = f_messageBox('Sucesso!!','Cadastro Realizado Com Sucesso! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','')
	triggerEvent('u_reset_dw')
ELSE
	//Faz o Roolback
	rollback;
	vli_Opcao = f_messageBox('Erro!','Erro ao Cadastrar Curso! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','') 
		
End if

return
end event

event u_valida_dados;call super::u_valida_dados;Integer vli_Opcao, vli_NumLinhas, vli_Id_Instrutor, vli_Carga_Horaria, vli_Curso_Id
String vls_NomeTurma
Date vldt_DataInicio, vldt_DataFim

//Sem modificações
if dw_show.RowCount() = 0 Then
	f_messageBox('Atenção!','Nenhuma modificação feita!~r~rDeseja Retornar?','SIM','')
	return
End if

dw_show.AcceptText()

//Atribui Todos os campos para fazer as devidas validações
vls_NomeTurma = dw_show.getItemString(1,'nome_turma')
vli_Id_Instrutor = dw_show.getItemNumber(1,'instrutores_id')
vli_Curso_Id = dw_show.getItemNumber(1,'cursos_id')
vli_Carga_Horaria = dw_show.getItemNumber(1,'carga_horaria')
vldt_DataInicio = dw_show.getItemDate(1,'data_inicio')
vldt_DataFim = dw_show.getItemDate(1,'data_final')

If isnull(vls_NomeTurma) or isNumber(vls_NomeTurma) then
	vli_Opcao = f_messageBox('Atenção!','Nome da turma inválido ou não informado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('instrutores_id')
	return
End If

If isnull(vli_Id_Instrutor) then
	vli_Opcao = f_messageBox('Atenção!','Nome do instrutor não informado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('instrutores_id')
	return
End If
	
If isnull(vli_Curso_Id) then
	vli_Opcao = f_messageBox('Atenção!','Curso não informado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('cursos_id')
	return
End If

If isnull(vli_Carga_Horaria) then
	vli_Opcao = f_messageBox('Atenção!','Carga horária inválido ou não informado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('carga_horaria')
	return
End If
	
If isnull(vldt_DataInicio) then
	vli_Opcao = f_messageBox('Atenção!','Data Inicial inválida ou não informada!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('data_inicio')
	return
End If
	
If isnull(vldt_DataFim) then
	vli_Opcao = f_messageBox('Atenção!','Data Final inválida ou não informada!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('data_final')
	return

End if

//Chama o Evendo para Fazer Update dos Dados
triggerEvent('u_update_dados')
end event

event open;call super::open;DataWindowChild	vldwc

//Oculta o botão de recuperar
m_cadastro.m_cad.m_recuperar.Enabled = False
m_cadastro.m_cad.m_recuperar.ToolBarItemVisible = False

//Oculta o botão de editar
m_cadastro.m_cad.m_editar.Enabled = False
m_cadastro.m_cad.m_editar.ToolBarItemVisible = False

//Oculta o botão de apagar
m_cadastro.m_cad.m_deletar.Enabled = False
m_cadastro.m_cad.m_deletar.ToolBarItemVisible = False

w_principal.SetMicroHelp("Cadastro de Turmas")

dw_show.setTransObject(SQLCA)
dw_show.insertRow(0)

//Retriva com todos os Instrutores
dw_show.GetChild("instrutores_id", vldwc)
vldwc.setTransObject(SQLCA)
vldwc.Retrieve(0)

dw_show.GetChild("instrutores_id", vldwc)
vldwc.setTransObject(SQLCA)
vldwc.Retrieve(0)
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

type dw_get from w_cadastro_simples_padrao`dw_get within w_cadastro_turmas
boolean visible = false
end type

type st_1 from w_cadastro_simples_padrao`st_1 within w_cadastro_turmas
string text = "Cadastro de Turmas"
end type

type dw_show from w_cadastro_simples_padrao`dw_show within w_cadastro_turmas
string dataobject = "dw_07"
end type

