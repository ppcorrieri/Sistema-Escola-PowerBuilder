$PBExportHeader$w_presencas_turma.srw
$PBExportComments$Tela para gerenciamento de presenças da turma por horário
forward
global type w_presencas_turma from w_cadastro_simples_padrao
end type
end forward

global type w_presencas_turma from w_cadastro_simples_padrao
event u_valida_get ( )
event u_carrega_dddw ( )
end type
global w_presencas_turma w_presencas_turma

type variables
Integer vii_Id_Instrutor, vii_Id_Turma, vii_Instrutor_Turma
DataWindowChild	vidwc_Instrutor, vidwc_Turma
end variables
event u_valida_get();uo_turmas	uol_turmas
uol_turmas = create uo_turmas

Integer vli_Opcao

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

//Verifica se está no dia / hora da turma
IF uol_turmas.of_verifica_dia_aula(vii_Id_Turma) = False THEN
	f_MessageBox('Atenção!', 'Não é permitido dar presença de forma adiantada ou retroativa~rO horário dessa turma é ' +uol_turmas.vis_DiaDaSemana+ ' De ' +uol_turmas.vis_HoraInicio+ 'h às '+uol_turmas.vis_HoraFim+'h~r~rDeseja Retornar?', 'SIM', '')
	return
END IF

//Chama o Evento de Recuperação dos dados
triggerEvent('u_Retrieve_Dados')
end event

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

on w_presencas_turma.create
call super::create
end on

on w_presencas_turma.destroy
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

event u_retrieve_dados;call super::u_retrieve_dados;dw_show.visible = TRUE

if vgs_TipoAcesso = 'G' Then
	dw_show.retrieve(vii_Id_Instrutor,vii_Id_Turma)
ElseIf vgs_TipoAcesso = 'I' Then
	dw_show.retrieve(vgs_id_usuario,vii_Id_Turma)
End IF

//Verifica se Encontrou Registros
if dw_show.rowCount() = 0 Then
	f_messageBox('Atenção!','Nenhum Registro Encontrado!~r~rDeseja Retornar?','SIM','')  
End If
end event

type dw_get from w_cadastro_simples_padrao`dw_get within w_presencas_turma
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

type st_1 from w_cadastro_simples_padrao`st_1 within w_presencas_turma
string text = "Presenças"
end type

type dw_show from w_cadastro_simples_padrao`dw_show within w_presencas_turma
boolean visible = false
integer x = 1280
integer y = 684
integer width = 2912
integer height = 1364
string dataobject = "dw_28"
end type

