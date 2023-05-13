$PBExportHeader$w_manutencao_turmas.srw
$PBExportComments$Tela para manutenção de turmas
forward
global type w_manutencao_turmas from w_cadastro_simples_padrao
end type
end forward

global type w_manutencao_turmas from w_cadastro_simples_padrao
string title = "Manutenção de Turmas"
event u_carrega_dddw ( )
event u_valida_get ( )
end type
global w_manutencao_turmas w_manutencao_turmas

type variables
Integer vii_Id_Instrutor, vii_Id_Turma, vii_Opcao, vii_Instrutor_Turma
Date vid_DataInicio

DataWindowChild	vidwc_Instrutor, vidwc_Turma
end variables
event u_carrega_dddw();//Acesso de usuários com nível máximo
if vgs_TipoAcesso = 'G' Then

	// DropDown de Instrutores
	dw_get.InsertRow(1)
	dw_get.event losefocus( )
	dw_get.GetChild("instrutor_id", vidwc_Instrutor)
	vidwc_Instrutor.setTransObject(SQLCA)
	vidwc_Instrutor.Retrieve(0)
	
elseif vgs_TipoAcesso = 'I' Then
	
	// DropDown de Instrutores
	dw_get.GetChild("instrutor_id", vidwc_Instrutor)
	dw_get.InsertRow(1)
	dw_get.event losefocus( )
	vidwc_Instrutor.setTransObject(SQLCA)
	vidwc_Instrutor.Retrieve(vgs_id_usuario)
	
End if

//dw_get.AcceptText()
end event

event u_valida_get();Integer vli_Opcao

If vgs_TipoAcesso = 'G' Then
	
	vii_Id_Instrutor = dw_get.getItemNumber(1,'instrutor_id')
	vii_Id_Turma = dw_get.getItemNumber(1,'turmas_id')

	If isnull(vii_Id_Instrutor) THEN
		vli_Opcao = f_messageBox('Atenção!','Instrutor não selecionado!~r~rDeseja Retornar?','SIM','')  
		if vli_Opcao = 1 then dw_get.setColumn('instrutor_id')
		return
	End If
	
	If isnull(vii_Id_Turma) THEN
		vli_Opcao = f_messageBox('Atenção!','Turma não selecionada!~r~rDeseja Retornar?','SIM','')  
		if vli_Opcao = 1 then dw_get.setColumn('turmas_id')
		return
	End If

ElseIf vgs_TipoAcesso = 'I' Then
	
	vii_Id_Turma = dw_get.getItemNumber(1,'turmas_id')
	If isnull(vii_Id_Turma) THEN
		vli_Opcao = f_messageBox('Atenção!','Turma não selecionada!~r~rDeseja Retornar?','SIM','')  
		if vli_Opcao = 1 then dw_get.setColumn('turmas_id')
		return
	End If
	
End If

//Chama o Evento de Recuperação dos dados
triggerEvent('u_Retrieve_Dados')
end event

on w_manutencao_turmas.create
call super::create
end on

on w_manutencao_turmas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;//Fecha a Janela de Boas Vindas
close(w_home)

//Libera / Bloqueia os Menus
f_PermissaoAcessoMenu()

dw_show.setTransObject(SQLCA)

w_principal.SetMicroHelp("Manutenção de Turmas")

//Oculta o botão de recuperar
m_cadastro.m_cad.m_recuperar.Enabled = False
m_cadastro.m_cad.m_recuperar.ToolBarItemVisible = False

// Para acesso Instrutor, carregar somente turmas atreladas a ele
// Bloqueando a drop de instrutores
if vgs_TipoAcesso = 'I' Then
	dw_get.object.instrutor_id_t.visible = false
	dw_get.object.instrutor_id.visible = false
	
	//Muda a Posição
	dw_get.object.turmas_id_t.X = 37
	dw_get.object.turmas_id_t.Y = 96
	
	dw_get.object.turmas_id.X = 347
	dw_get.object.turmas_id.Y = 96
End If

//Bloqueia o campo STATUS pois ele é usado em uma consulta específica e não é útil nesse caso
dw_get.object.status_turma_t.visible = false
dw_get.object.status_turma.visible = false

triggerEvent('u_carrega_dddw')
end event

event u_retrieve_dados;call super::u_retrieve_dados;Date vld_DataInicio

if vgs_TipoAcesso = 'G' Then
	dw_show.retrieve(vii_Id_Instrutor,vii_Id_Turma)
ElseIf vgs_TipoAcesso = 'I' Then
	dw_show.retrieve(vgs_id_usuario,vii_Id_Turma)
End IF

//Verifica se Encontrou Registros
if dw_show.rowCount() = 0 Then
	f_messageBox('Atenção!','Nenhum Registro Encontrado!~r~rDeseja Retornar?','SIM','')  
End If

// Se recuperou Registros
If (dw_show.rowCount() > 0) Then
		
	dw_show.object.status_turma.protect = 1
	vid_DataInicio = dw_show.getITemDate(1, 'data_inicio')
	
	//Curso já iniciado
	//Independente do tipo de acesso será impossível mudar o curso ou as datas de início / fim
	if (Today() > vid_DataInicio) Then
		dw_show.object.cursos_id.protect = 1
		dw_show.object.cursos_id.Background.Color = rgb(220,220,220)
		
		dw_show.object.data_inicio.protect = 1
		dw_show.object.data_inicio.Background.Color = rgb(220,220,220)
		
		dw_show.object.data_final.protect = 1
		dw_show.object.data_final.Background.Color = rgb(220,220,220)
	End If
	
	If (vgs_TipoAcesso = 'I') Then
		dw_show.object.cursos_id.protect = 1
		dw_show.object.cursos_id.Background.Color = rgb(220,220,220)
		
		dw_show.object.carga_horaria.protect = 1
		dw_show.object.carga_horaria.Background.Color = rgb(220,220,220)
	End If
End if
end event

event u_update_dados;call super::u_update_dados;integer vli_Ret, vli_Opcao

vli_Ret = dw_show.update()

IF vli_Ret = 1 Then
	// confirma gravação no banco
	commit;
	vli_Opcao = f_messageBox('Sucesso!!','Alteração Realizada Com Sucesso! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','')
ELSE
	//Faz o Roolback
	rollback;
	vli_Opcao = f_messageBox('Erro!','Erro ao Atualizar Dados! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','') 
		
End if

return
end event

event u_abandonar_cadastro;call super::u_abandonar_cadastro;if dw_show.RowCount() > 0 Then

	dw_show.AcceptText()
	
	//Verifica se a DW foi Modificada
	if (dw_show.ModifiedCount() > 0) Then
		vii_Opcao = f_messageBox('Atenção!','Deseja Abandonar a Modificação Atual?','SIM','NÃO')  
		if vii_Opcao = 1 then triggerEvent('u_retrieve_dados')
		if vii_Opcao = 2 then return
		
	Else
		vii_Opcao = f_messageBox('Atenção!','Nenhum Dado foi Modificado~r~rDeseja Retornar?','SIM','')  
		if vii_Opcao = 1 then return
	End if
	
Else
	//Click no Salvar
	f_messageBox('Atenção!','Não é possível abandonar sem antes recuperar os registros!~r~rDeseja Retornar?','SIM','')
End if
end event

event u_valida_dados;call super::u_valida_dados;string vls_NomeTurma
integer vli_CargaHoraria

if dw_show.RowCount() > 0 Then

	dw_show.AcceptText()
	
	//Sem modificações
	if dw_show.modifiedcount() = 0 Then
		f_messageBox('Atenção!','Nenhuma modificação feita!~r~rDeseja Retornar?','SIM','')
		return
	End if
	
	vls_NomeTurma = dw_show.getITemString(1, 'turmas_nome_turma')
	
	if isNumber(vls_NomeTurma) or isNull(vls_NomeTurma) Then
		
		vii_Opcao = f_messageBox('Atenção!','O Campo não pode ser vazio ou conter números!~r~rDeseja Retornar?','SIM','')  
		if vii_Opcao = 1 then dw_show.setColumn('turmas_nome_turma')
		return
		
	end if
	
	///////////
	
	if vgs_TipoAcesso = 'I' Then
		
		
	ElseIf vgs_TipoAcesso = 'G' Then
		
		vli_CargaHoraria = dw_show.getITemNumber(1, 'carga_horaria')
		
		if not isNumber(string(vli_CargaHoraria)) or isNull(vli_CargaHoraria) Then
			vii_Opcao = f_messageBox('Atenção!','O Campo não pode ser vazio ou conter caracteres!~r~rDeseja Retornar?','SIM','')  
			if vii_Opcao = 1 then dw_show.setColumn('carga_horaria')
			return
		end if
		
		if vli_CargaHoraria < 32 or vli_CargaHoraria > 120 Then
			vii_Opcao = f_messageBox('Atenção!','A Carga horária mínima é de 32h e a máxima é de 120h!~r~rDeseja Retornar?','SIM','')  
			if vii_Opcao = 1 then dw_show.setColumn('carga_horaria')
			return
		end if
		
	End if
	
	
	//Chama o Evento para Fazer Update dos Dados
	triggerEvent('u_update_dados')
Else
	//Click no Salvar
	f_messageBox('Atenção!','Não é possível salvar sem antes recuperar os registros!~r~rDeseja Retornar?','SIM','')
End if
end event

event u_delete_dados;call super::u_delete_dados;integer vli_Ret
uo_matricula	uol_matricula
uol_matricula = create uo_matricula

//Recuperou Registros
//Apto para Excluir
if dw_show.RowCount() > 0 Then
	
	//Se não existir nenhuma matrícula
	if(uol_matricula.of_existe_matricula_turma(vii_Id_Turma)) = False Then
		
		vii_Opcao = f_messageBox('Atenção!','Tem certeza que deseja excluir a turma?','SIM','NÃO')
		IF (vii_Opcao = 1) THEN
			//Deleta
			dw_show.deleteRow(1)
			vli_Ret = dw_show.update()
			IF vli_Ret = 1 Then
				// confirma gravação no banco
				commit;
				f_messageBox('Sucesso!','Exclusão Realizada Com Sucesso! ~r~rDeseja Retornar?','SIM','')
				
				//Reseta as drops da get
				triggerEvent('u_carrega_dddw')
			ELSE
				//Faz o Roolback
				rollback;
				f_messageBox('Erro!','Erro ao Excluir Dados! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','') 
			END IF
			
		ELSE
			RETURN
		END IF

	else
		vii_Opcao = f_messageBox('Erro!','Impossível deletar turma com alunos matriculados. ~r~rDeseja Retornar?','SIM','')
	end if
end if
end event

type dw_get from w_cadastro_simples_padrao`dw_get within w_manutencao_turmas
integer x = 0
string dataobject = "dw_10"
end type

event dw_get::itemchanged;call super::itemchanged;integer vli_Nulo
setNull(vli_Nulo)

choose case dwo.name
	case 'instrutor_id'
		
		//Reseta a dddw de tickets ao trocar o 
		if vidwc_Turma.rowCount() > 0 Then
			this.setItem(1, 'turmas_id', vli_Nulo)
		end if
		
		vidwc_Instrutor.getRow()
		vii_Instrutor_Turma = vidwc_Instrutor.getItemNumber(vidwc_Instrutor.getRow(), 'instrutor_id_usuario')
		
		this.GetChild("turmas_id", vidwc_Turma)
		vidwc_Turma.setTransObject(SQLCA)
		vidwc_Turma.Retrieve(vii_Instrutor_Turma)

end choose
end event

type st_1 from w_cadastro_simples_padrao`st_1 within w_manutencao_turmas
string text = "Manutenção de Turmas"
end type

type dw_show from w_cadastro_simples_padrao`dw_show within w_manutencao_turmas
string dataobject = "dw_13"
end type

