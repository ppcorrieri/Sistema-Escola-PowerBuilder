$PBExportHeader$w_cadastro_curso.srw
$PBExportComments$Janela para Cadastro de Cursos
forward
global type w_cadastro_curso from w_cadastro_simples_padrao
end type
end forward

global type w_cadastro_curso from w_cadastro_simples_padrao
string title = "Cadastro de Cursos"
end type
global w_cadastro_curso w_cadastro_curso

type variables
Integer vii_Opcao
end variables

on w_cadastro_curso.create
call super::create
end on

on w_cadastro_curso.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event u_valida_dados;call super::u_valida_dados;Integer vli_Opcao, vli_NumLinhas, vli_CargaHoraria
String vls_NomeCurso, vls_RequisitoCurso
Decimal vldc_Preco

//Sem modificações
if dw_show.RowCount() = 0 Then
	f_messageBox('Atenção!','Nenhuma modificação feita!~r~rDeseja Retornar?','SIM','')
	return
End if

dw_show.AcceptText()

//Atribui Todos os campos para fazer as devidas validações
vls_NomeCurso = dw_show.getItemString(1,'nome')
vls_RequisitoCurso = dw_show.getItemString(1,'requisito')
vli_CargaHoraria = dw_show.getItemNumber(1,'carga_horaria')
vldc_Preco = dw_show.getItemDecimal(1,'preco')

If isnull(vls_NomeCurso) then
	vli_Opcao = f_messageBox('Atenção!','Nome inválido ou não informado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('nome')
	return
End If
		
If isnull(vls_RequisitoCurso) then
	vli_Opcao = f_messageBox('Atenção!','Requisito inválido ou não informado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('requisito')
	return
End If
	
If isnull(vli_CargaHoraria) then
	vli_Opcao = f_messageBox('Atenção!','Carga Horária inválida ou não informada!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('carga_horaria')
	return
End If
	
If isnull(vldc_Preco) then
	vli_Opcao = f_messageBox('Atenção!','Preço inválido ou não informado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('preco')
	return
End If

//Chama o Evendo para Fazer Update dos Dados
triggerEvent('u_update_dados')
end event

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

event open;call super::open;//Oculta o botão de recuperar
m_cadastro.m_cad.m_recuperar.Enabled = False
m_cadastro.m_cad.m_recuperar.ToolBarItemVisible = False

//Oculta o botão de editar
m_cadastro.m_cad.m_editar.Enabled = False
m_cadastro.m_cad.m_editar.ToolBarItemVisible = False

//Oculta o botão de apagar
m_cadastro.m_cad.m_deletar.Enabled = False
m_cadastro.m_cad.m_deletar.ToolBarItemVisible = False

w_principal.SetMicroHelp("Cadastro de Cursos")

dw_show.setTransObject(SQLCA)
dw_show.insertRow(0)
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

type dw_get from w_cadastro_simples_padrao`dw_get within w_cadastro_curso
boolean visible = false
end type

type st_1 from w_cadastro_simples_padrao`st_1 within w_cadastro_curso
string text = "Cadastro de Cursos"
end type

type dw_show from w_cadastro_simples_padrao`dw_show within w_cadastro_curso
integer x = 1047
integer y = 712
integer taborder = 20
string dataobject = "dw_06"
end type

