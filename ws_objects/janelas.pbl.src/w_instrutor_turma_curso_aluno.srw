$PBExportHeader$w_instrutor_turma_curso_aluno.srw
$PBExportComments$Tela para consultar informações do Instrutor, Turma e Curso do Aluno
forward
global type w_instrutor_turma_curso_aluno from w_consulta_simples_padrao
end type
end forward

global type w_instrutor_turma_curso_aluno from w_consulta_simples_padrao
integer height = 2600
string title = "Consulta Turma por Status"
string menuname = "m_consulta"
end type
global w_instrutor_turma_curso_aluno w_instrutor_turma_curso_aluno

type variables
Integer vii_Id_Instrutor, vii_Id_Turma
String vis_Status_Turma

DataWindowChild	vidwc_Instrutor, vidwc_Turma
end variables

on w_instrutor_turma_curso_aluno.create
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
end on

on w_instrutor_turma_curso_aluno.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;//Fecha a Janela de Boas Vindas
close(w_home)

//Libera / Bloqueia os Menus
f_PermissaoAcessoMenu()

w_principal.SetMicroHelp("Consulta Analítica de Dados das Turmas por Status")

triggerEvent('u_carrega_dddw')
end event

event u_carrega_dddw;call super::u_carrega_dddw;dw_get.InsertRow(1)
dw_get.event losefocus( )

// DropDown de Instrutores
dw_get.GetChild("instrutor_id", vidwc_Instrutor)
vidwc_Instrutor.setTransObject(SQLCA)
vidwc_Instrutor.Retrieve(0)

vidwc_Instrutor.insertRow(1)
vidwc_Instrutor.setItem( 1, 'instrutor_id_usuario', 0)
vidwc_Instrutor.setItem( 1, 'instrutor_nome', '<TODOS>')

// DropDown de Turmas
dw_get.GetChild("turmas_id", vidwc_Turma)
vidwc_Turma.insertRow(1)
vidwc_Turma.setItem(1, 'turmas_id', 0)
vidwc_Turma.setItem(1, 'id_nome_turma', '<TODAS>')

dw_get.AcceptText()
end event

event u_valida_get;call super::u_valida_get;Integer vli_Opcao

vii_Id_Instrutor = dw_get.getItemNumber(1,'instrutor_id')
vii_Id_Turma = dw_get.getItemNumber(1,'turmas_id')
vis_Status_turma = dw_get.getItemString(1,'status_turma')

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

//Chama o Evento de Recuperação dos dados
triggerEvent('u_Retrieve_Dados')
end event

event u_retrieve_dados;call super::u_retrieve_dados;dw_show.retrieve(vii_Id_Instrutor,vii_Id_Turma, vis_Status_Turma)


//Verifica se Encontrou Registros
if dw_show.rowCount() = 0 Then
	f_messageBox('Atenção!','Nenhum Registro Encontrado!~r~rDeseja Retornar?','SIM','')  
End If
end event

type st_2 from w_consulta_simples_padrao`st_2 within w_instrutor_turma_curso_aluno
string text = "Consulta de Turma por Status"
end type

type dw_get from w_consulta_simples_padrao`dw_get within w_instrutor_turma_curso_aluno
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
		vii_Id_Instrutor = vidwc_Instrutor.getItemNumber(vidwc_Instrutor.getRow(), 'instrutor_id_usuario')
		
		if vii_Id_Instrutor = 0 Then
			vidwc_Turma.deleteRow(0)
			vidwc_Turma.insertRow(1)
			vidwc_Turma.setItem(1, 'turmas_id', 0)
			vidwc_Turma.setItem(1, 'id_nome_turma', '<TODAS>')
		else
			this.GetChild("turmas_id", vidwc_Turma)
			vidwc_Turma.setTransObject(SQLCA)
			vidwc_Turma.Retrieve(vii_Id_Instrutor)
		end if

end choose

end event

type dw_show from w_consulta_simples_padrao`dw_show within w_instrutor_turma_curso_aluno
integer x = 1463
integer y = 664
integer width = 2674
integer height = 1352
string dataobject = "dw_09"
boolean vscrollbar = true
end type

event dw_show::constructor;call super::constructor;//this.Modify("datawindow.detail.color='536870912~tif(getrow() = currentrow(), rgb(30,144,255), rgb (255,255,255))'")
end event

