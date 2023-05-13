$PBExportHeader$w_cadastro_matricula.srw
$PBExportComments$Janela Para fazer nova matrícuila ( Relação com Turma e Alunos)
forward
global type w_cadastro_matricula from w_cadastro_simples_padrao
end type
type dw_selecao_alunos from datawindow within w_cadastro_matricula
end type
end forward

global type w_cadastro_matricula from w_cadastro_simples_padrao
string title = "Cadastro de Matrículas"
dw_selecao_alunos dw_selecao_alunos
end type
global w_cadastro_matricula w_cadastro_matricula

type variables
Integer vis_QtdCheck = 0
Integer vis_QtdCheck2
Integer vii_Opcao

Integer vii_CountSelecaoAlunos, vii_Id_Turma, vii_Aluno_Id
Date vidt_Dta_Matricula

DataWindowChild	vidwc
end variables

forward prototypes
public function boolean wf_insere_nova_matricula (integer p_turma, integer p_aluno, date p_data_mat, integer p_id_inseriu)
public function string wf_verifica_existe_mat_usuario (integer p_usuario)
end prototypes

public function boolean wf_insere_nova_matricula (integer p_turma, integer p_aluno, date p_data_mat, integer p_id_inseriu);
INSERT INTO matriculas (turmas_id, alunos_id, data_matricula, id_criado_por)
VALUES (:p_turma, :p_aluno, :p_data_mat, :p_id_inseriu);
	

return TRUE
end function

public function string wf_verifica_existe_mat_usuario (integer p_usuario);Integer vli_Count
String vls_NomeRepetido

select count(*) COUNT, usuarios.nome
into :vli_Count, :vls_NomeRepetido
from matriculas, usuarios
where alunos_id = :p_usuario
and matriculas.alunos_id = usuarios.id_usuario
GROUP BY usuarios.nome
USING SQLCA;

//Trata Erro
if SQLCA.SQLCode < 0 Then
	f_MessageBox('Atenção', 'Ocorreu um erro ao verificar se o aluno já possui matrícula~r~rTente novamente!~rDeseja Retornar?', 'SIM', '')
else
	if vli_Count > 0 Then
		return vls_NomeRepetido
	else
		return ''
	end if
End if
end function

on w_cadastro_matricula.create
int iCurrent
call super::create
this.dw_selecao_alunos=create dw_selecao_alunos
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_selecao_alunos
end on

on w_cadastro_matricula.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_selecao_alunos)
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

dw_show.Object.nome_aluno.Protect = 1
dw_show.Object.data_matricula.Protect = 1

dw_show.setTransObject(SQLCA)
dw_show.insertRow(0)

w_principal.SetMicroHelp("Cadastro de Matrículas")

triggerEvent('u_inicializa_campos')
end event

event u_inicializa_campos;call super::u_inicializa_campos;String vls_DataMatricula

//Seta a data Atual para a Data de Registro
vls_DataMatricula = String(Today(), "dd/mm/yyyy")
dw_show.setItem(1, 'data_matricula', date(vls_DataMatricula))

//Seta o Id do usuário logado
dw_show.setItem(1, 'id_criado_por', vgs_id_usuario)

//Retriva com todas as Turmas
dw_show.GetChild("turmas_id", vidwc)
vidwc.setTransObject(SQLCA)
vidwc.Retrieve(0)



end event

event u_update_dados;call super::u_update_dados;Integer i
String vls_NomeRepetido

vii_Id_Turma = dw_show.getItemNumber(1, 'turmas_id')
vidt_Dta_Matricula = dw_show.getItemDate(1, 'data_matricula')
vii_CountSelecaoAlunos = dw_selecao_alunos.RowCount()

for i = 1 to vii_CountSelecaoAlunos
	if dw_selecao_alunos.getItemString(i, 'selecao') = 'S' Then
		
		//Obtem o Id do usuário atual
		vii_Aluno_Id = dw_selecao_alunos.getItemNumber(i, 'id_usuario')
		
		//Verifica se já existe uma matrícula para o usuário
		vls_NomeRepetido = wf_verifica_existe_mat_usuario(vii_Aluno_Id)
		if vls_NomeRepetido <> '' Then
			f_messageBox('Erro!','O Aluno(a): '+ vls_NomeRepetido +' já está matriculado(a) em uma turma~r~rMatrícula(s) não realizada(s)~rDeseja Retornar?','SIM','')
			Return
		ElseIf vls_NomeRepetido = '-1' Then
			f_messageBox('Erro!!','Erro de Comunicação com o Banco ~r'+ SQLCA.SQLErrText +'.~r~rDeseja Retornar?','SIM','')
			Return
		End if
		
		// Apenas Insere usuários não matriculados
		wf_insere_nova_matricula(vii_Id_Turma, vii_Aluno_Id, vidt_Dta_Matricula, vgs_id_usuario)
		
	End if
next

//Só faz a gravação se rodar para todos os usuários
//Dados parciais não serão gravados
if SQLCA.SQLCode = 0 Then
	COMMIT USING SQLCA;
	f_messageBox('Sucesso!!','Matrícula(s) Realizada(s) Com Sucesso!~r~rDeseja Retornar?','SIM','')
else
	ROLLBACK USING SQLCA;
	f_messageBox('Erro!!','Erro ao Realizar Matrícula(s)~r~rTente novamente! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','')
End if
	
end event

event u_valida_dados;call super::u_valida_dados;Integer vli_Opcao, vliNulo, vli_TurmasId, vli_TurmasId_dddw, i
String vls_Aluno, vls_NomeTurma
Date vld_DataInicio


setNull(vliNulo)

//Sem modificações
if dw_show.RowCount() = 0 Then
	f_messageBox('Atenção!','Nenhuma modificação feita!~r~rDeseja Retornar?','SIM','')
	return
End if

dw_show.AcceptText()

//Atribui Todos os campos para fazer as devidas validações
vii_Id_Turma = dw_show.getItemNumber(1,'turmas_id')
vls_Aluno = dw_show.getItemString(1,'nome_aluno')
vidt_Dta_Matricula = dw_show.getItemDate(1,'data_matricula')

If isnull(vii_Id_Turma) then
	vli_Opcao = f_messageBox('Atenção!','Turma não informada!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('turmas_id')
	return
End If

for i = 1 to vidwc.rowCount()
	dw_show.accepttext( )
	vli_TurmasId = dw_show.getItemNumber( 1, 'turmas_id')
	vli_TurmasId_dddw = vidwc.getItemNumber(i, 'turmas_id')
	if (vli_TurmasId = vli_TurmasId_dddw) Then
		vls_NomeTurma = vidwc.getItemString(i, 'turmas_nome_turma')
		vld_DataInicio = vidwc.getItemDate(i, 'turmas_data_inicio')
	end if
next

if(Today() > vld_DataInicio) Then
	f_MessageBox('Atenção!','As atividades da turma ('+ vls_NomeTurma +') já iniciaram.~rImpossível realizar matrícula~r~rDeseja Retornar?','SIM','')
	vidwc.reset()
	dw_show.setItem(1, 'turmas_id', vliNulo)
	vidwc.retrieve(0)
	return
end if

If isnull(vls_Aluno) then
	vli_Opcao = f_messageBox('Atenção!','Aluno(s) não informado(s)!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('nome_aluno')
	return
End If

If isnull(vidt_Dta_Matricula) then
	vli_Opcao = f_messageBox('Atenção!','Data da Matrícula não informada!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('data_matricula')
	return
End If

///////////

//Chama o Evendo para Fazer Update dos Dados
triggerEvent('u_update_dados')
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

event u_reset_dw;call super::u_reset_dw;Integer i

//Reseta todos os CheckBox Marcados
for i = 0 to dw_selecao_alunos.RowCount()
	dw_selecao_alunos.setItem(i, 'selecao', 'N')
next
end event

type dw_get from w_cadastro_simples_padrao`dw_get within w_cadastro_matricula
boolean visible = false
end type

type st_1 from w_cadastro_simples_padrao`st_1 within w_cadastro_matricula
string text = "Matricular Alunos na Turma"
end type

type dw_show from w_cadastro_simples_padrao`dw_show within w_cadastro_matricula
integer x = 1125
integer y = 612
integer width = 2894
integer height = 1488
string dataobject = "dw_08"
end type

event dw_show::clicked;call super::clicked;
CHOOSE CASE dwo.name
	//Click no Botão de +
	CASE 'b_selecao'
		if(dw_selecao_alunos.visible = TRUE) Then
			dw_selecao_alunos.visible = FALSE
		Else
			dw_selecao_alunos.visible = TRUE
			dw_selecao_alunos.setFocus()
		End If
END CHOOSE
end event

event dw_show::itemchanged;call super::itemchanged;//Date vld_DataInicio
//String vls_NomeTurma
//integer vliNulo
//
//setNull(vliNulo)
//
//CHOOSE CASE dwo.name
//	//Click no Botão de +
//	CASE 'turmas_id'
//		this.AcceptText()
//		this.GetChild("turmas_id", vidwc)
//		vls_NomeTurma = vidwc.getItemString(1, 'turmas_nome_turma')
//		vld_DataInicio = vidwc.getItemDate(1, 'turmas_data_inicio')
//		
//		//vidwc.insertRow()
//		//vidwc.retrieve(0)
//		//this.AcceptText()
//		
//		if(Today() > vld_DataInicio) Then
//			f_MessageBox('Atenção!','As atividades da turma ('+ vls_NomeTurma +') já iniciaram.~rImpossível realizar matrícula~r~rDeseja Retornar?','SIM','')
//			vidwc.reset()
//			this.setItem(1, 'turmas_id', vliNulo)
//			vidwc.retrieve(0)
//		end if
//		
//		
//END CHOOSE
end event

type dw_selecao_alunos from datawindow within w_cadastro_matricula
boolean visible = false
integer x = 1568
integer y = 1196
integer width = 2258
integer height = 484
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "dddw_alunos_multipla_selecao"
boolean vscrollbar = true
boolean livescroll = true
end type

event constructor;this.setTransObject(SQLCA)
this.retrieve()
end event

event itemchanged;Integer i, vil_Linha
String vlsNomeAluno
boolean vlb_Check = false

CHOOSE CASE dwo.name
	//Click no Botão de +
	CASE 'selecao'
		if data = 'S' Then
			vis_QtdCheck++
			vlsNomeAluno = this.getItemString(row,'usuarios_nome')
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
				dw_show.setItem(1, 'nome_aluno', '[AGRUPADOS]')
			ElseIf vis_QtdCheck2 = 1 Then
				dw_show.setItem(1, 'nome_aluno', this.getItemString(vil_Linha,'usuarios_nome'))
			Else
				dw_show.setItem(1, 'nome_aluno', '')
			End if
		End If
		
		if vlb_Check then
			If vis_QtdCheck > 1 Then
				dw_show.setItem(1, 'nome_aluno', '[AGRUPADOS]')
			
			ElseIf vis_QtdCheck = 1 Then
				dw_show.setItem(1, 'nome_aluno', vlsNomeAluno)
				
			Else
				dw_show.setItem(1, 'nome_aluno', '')
			End if
		end if
		
END CHOOSE
end event

