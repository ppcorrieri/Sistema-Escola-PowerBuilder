$PBExportHeader$w_cadastro_turmas.srw
$PBExportComments$Janela Para Cadastro de Turmas, Relação com Instrutor e Curso
forward
global type w_cadastro_turmas from w_cadastro_simples_padrao
end type
type dw_dia_horario_aula from datawindow within w_cadastro_turmas
end type
type dw_selecao_dias_aula from datawindow within w_cadastro_turmas
end type
end forward

global type w_cadastro_turmas from w_cadastro_simples_padrao
string title = "Cadastro de Turmas"
dw_dia_horario_aula dw_dia_horario_aula
dw_selecao_dias_aula dw_selecao_dias_aula
end type
global w_cadastro_turmas w_cadastro_turmas

type variables
integer vii_Opcao
Integer vis_QtdCheck = 0
integer vis_Linha
Integer vis_QtdCheck2
Integer viiCountDias = 0
integer vii_DiaSelec, vii_HorarioSelec

string visDiasSemana[]

uo_turmas	uoi_turmas
end variables

on w_cadastro_turmas.create
int iCurrent
call super::create
this.dw_dia_horario_aula=create dw_dia_horario_aula
this.dw_selecao_dias_aula=create dw_selecao_dias_aula
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_dia_horario_aula
this.Control[iCurrent+2]=this.dw_selecao_dias_aula
end on

on w_cadastro_turmas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_dia_horario_aula)
destroy(this.dw_selecao_dias_aula)
end on

event u_update_dados;call super::u_update_dados;Integer i
Boolean vlbRet
String vls_NomeTurma, vls_HorarioRepetido
Date vld_DataInicio, vldDataFim
Integer vli_CargaH, vliCodInstrutor, vliCodCurso, vls_Id_ProximaTurma

vls_NomeTurma = dw_show.getItemString(1, 'nome_turma')
vliCodInstrutor = dw_show.getItemNumber(1, 'instrutores_id')
vliCodCurso = dw_show.getItemNumber(1, 'cursos_id')
vld_DataInicio = dw_show.getItemDate(1, 'data_inicio')
vldDataFim = dw_show.getItemDate(1, 'data_final')
vli_CargaH = dw_show.getItemNumber(1, 'carga_horaria')

viiCountDias = dw_selecao_dias_aula.RowCount()

for i = 1 to viiCountDias
	if dw_selecao_dias_aula.getItemString(i, 'selecao') = 'S' Then
		
		//Obtem o dia Selecionado (1 é Segunda, 6 é Sábado)
		vii_DiaSelec = dw_selecao_dias_aula.getItemNumber(i, 'id_dia_semana')
		vii_HorarioSelec = dw_dia_horario_aula.getItemNumber(1, 'id_horario')
		
		//Verifica se já existe uma turma cadastrada para esse dia / horário
		vls_HorarioRepetido = uoi_turmas.of_verifica_disponibilidade_horario(vii_DiaSelec, vii_HorarioSelec)
		
		if vls_HorarioRepetido <> '' Then
			f_messageBox('Erro!','Já existe uma turma cadastrada no horário de: '+ vls_HorarioRepetido +'~r~rDeseja Retornar?','SIM','')
			Return
		ElseIf vls_HorarioRepetido = '-1' Then
			f_messageBox('Erro!!','Erro de Comunicação com o Banco ~r'+ SQLCA.SQLErrText +'.~r~rDeseja Retornar?','SIM','')
			Return
		End if
		
		//Rotina Abaixo para inserir no banco
		uoi_turmas.of_ultima_turma( )
		vls_Id_ProximaTurma = uoi_turmas.vli_ultimoidturma + 1
		
		vlbRet = uoi_turmas.of_insere(vls_NomeTurma, vliCodInstrutor, vliCodCurso,&
												vld_DataInicio, vldDataFim, vli_CargaH, vii_DiaSelec, vii_HorarioSelec, vls_Id_ProximaTurma)
		IF vlbRet = TRUE THEN
			COMMIT USING SQLCA;
			f_messageBox('Sucesso!!','Turma Cadastrada Com Sucesso!~r~rDeseja Retornar?','SIM','')
		ELSE
			ROLLBACK USING SQLCA;
			f_messageBox('Erro!!','Erro ao Cadastrar Turma~rTente novamente!~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','')
		END IF
	End if
next
end event

event u_valida_dados;call super::u_valida_dados;Integer vli_Opcao, vli_NumLinhas, vli_Id_Instrutor, vli_Carga_Horaria, vli_Curso_Id, vli_Horario
String vls_NomeTurma, vlsDias
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
vlsDias = dw_dia_horario_aula.getItemString(1, 'dia_semana')
vli_Horario = dw_dia_horario_aula.getItemNumber(1, 'id_horario')

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

If isnull(vlsDias) then
	vli_Opcao = f_messageBox('Atenção!','Selecione o(s) dia(s) do Curso!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_dia_horario_aula.setColumn('dia_semana')
	return
End if

If isnull(vli_Horario) then
	vli_Opcao = f_messageBox('Atenção!','Selecione o horário do Curso!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_dia_horario_aula.setColumn('id_horario')
	return
End if

//Chama o Evendo para Fazer Update dos Dados
triggerEvent('u_update_dados')
end event

event open;call super::open;DataWindowChild	vldwc, vldwc2
uoi_turmas = create uo_turmas

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

dw_dia_horario_aula.setTransObject(SQLCA)
dw_show.insertRow(0)

//Retriva com todos os Instrutores
dw_show.GetChild("instrutores_id", vldwc)
vldwc.setTransObject(SQLCA)
vldwc.Retrieve(0)

dw_dia_horario_aula.GetChild("id_horario", vldwc2)
vldwc2.setTransObject(SQLCA)
vldwc2.Retrieve(0)
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

event close;call super::close;if isvalid(uoi_turmas) Then destroy uoi_turmas
end event

type dw_get from w_cadastro_simples_padrao`dw_get within w_cadastro_turmas
boolean visible = false
end type

type st_1 from w_cadastro_simples_padrao`st_1 within w_cadastro_turmas
string text = "Cadastro de Turmas"
end type

type dw_show from w_cadastro_simples_padrao`dw_show within w_cadastro_turmas
integer y = 652
integer height = 828
string dataobject = "dw_07"
end type

type dw_dia_horario_aula from datawindow within w_cadastro_turmas
integer x = 1010
integer y = 1464
integer width = 3365
integer height = 468
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "dw_selecao_dias_horarios_aula_turma"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;CHOOSE CASE dwo.name
	//Click no Botão de +
	CASE 'b_selecao'
		if(dw_selecao_dias_aula.visible = TRUE) Then
			dw_selecao_dias_aula.visible = FALSE
		Else
			dw_selecao_dias_aula.visible = TRUE
			dw_selecao_dias_aula.setFocus()
		End If
	CASE ELSE
		dw_selecao_dias_aula.visible = FALSE
END CHOOSE
end event

type dw_selecao_dias_aula from datawindow within w_cadastro_turmas
boolean visible = false
integer x = 1454
integer y = 1680
integer width = 1047
integer height = 440
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "dddw_turmas_dias_de_aula"
boolean vscrollbar = true
boolean livescroll = true
end type

event constructor;this.setTransObject(SQLCA)
this.retrieve()
end event

event itemchanged;Integer i, vil_Linha
String vlsDiaSemana
boolean vlb_Check = false

CHOOSE CASE dwo.name
	//Click no Botão de +
	CASE 'selecao'
		if data = 'S' Then
			vis_QtdCheck++
			vlsDiaSemana = this.getItemString(row,'dia_semana')
			vlb_Check = true
		Else
			vis_QtdCheck2 = 0
			vis_QtdCheck --
			for i = 1 to this.rowCount()
				if this.getItemString(i,'selecao') = 'S' and i <> row Then
					vis_QtdCheck2++
					vil_Linha = i
				End If
			next
			
			If vis_QtdCheck2 > 1 Then
				dw_dia_horario_aula.setItem(1, 'dia_semana', '[AGRUPADOS]')
			ElseIf vis_QtdCheck2 = 1 Then
				dw_dia_horario_aula.setItem(1, 'dia_semana', this.getItemString(vil_Linha,'dia_semana'))
			Else
				dw_dia_horario_aula.setItem(1, 'dia_semana', '')
			End if
		End If
		
		if vlb_Check then
			If vis_QtdCheck > 1 Then
				dw_dia_horario_aula.setItem(1, 'dia_semana', '[AGRUPADOS]')
			
			ElseIf vis_QtdCheck = 1 Then
				dw_dia_horario_aula.setItem(1, 'dia_semana', vlsDiaSemana)
				
			Else
				dw_dia_horario_aula.setItem(1, 'dia_semana', '')
			End if
		end if
END CHOOSE
end event

