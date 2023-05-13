$PBExportHeader$w_manutencao_matriculas.srw
$PBExportComments$Janela para a Manutenção de Matrículas
forward
global type w_manutencao_matriculas from w_cadastro_simples_padrao
end type
end forward

global type w_manutencao_matriculas from w_cadastro_simples_padrao
string title = "Finalizar Matrículas"
event u_carrega_dddw ( )
event u_valida_get ( )
end type
global w_manutencao_matriculas w_manutencao_matriculas

type variables
String vis_Id_Usuario
Integer vii_Opcao
end variables

event u_carrega_dddw();DataWindowChild	vldwc

// DropDown de Alunos
dw_get.InsertRow(1)
dw_get.event losefocus( )
dw_get.GetChild("nome_usuario", vldwc)
vldwc.setTransObject(SQLCA)
vldwc.Retrieve(0)
end event

event u_valida_get();Integer vli_Opcao

vis_Id_Usuario = dw_get.getItemString(1,'nome_usuario')

If isnull(vis_Id_Usuario) or vis_Id_Usuario  = "" THEN
	vli_Opcao = f_messageBox('Atenção!','Aluno não selecionado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_get.setColumn('nome_usuario')
	return
End If


//if vis_Id_Usuario is 

//Chama o Evento de Recuperação dos dados
triggerEvent('u_Retrieve_Dados')
end event

on w_manutencao_matriculas.create
call super::create
end on

on w_manutencao_matriculas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;//Fecha a Janela de Boas Vindas
close(w_home)

//Libera / Bloqueia os Menus
f_PermissaoAcessoMenu()

dw_show.setTransObject(SQLCA)

w_principal.SetMicroHelp("Manutenção de Matrículas")

//Oculta o botão de recuperar
m_cadastro.m_cad.m_recuperar.Enabled = False
m_cadastro.m_cad.m_recuperar.ToolBarItemVisible = False

m_cadastro.m_cad.m_gravar.Enabled = False
m_cadastro.m_cad.m_gravar.ToolBarItemVisible = False

m_cadastro.m_cad.m_deletar.Enabled = False
m_cadastro.m_cad.m_deletar.ToolBarItemVisible = False

triggerEvent('u_carrega_dddw')
end event

event u_retrieve_dados;call super::u_retrieve_dados;integer(vis_Id_Usuario)
dw_Show.retrieve(integer(vis_Id_Usuario))

end event

type dw_get from w_cadastro_simples_padrao`dw_get within w_manutencao_matriculas
integer x = 0
string dataobject = "dw_26"
end type

type st_1 from w_cadastro_simples_padrao`st_1 within w_manutencao_matriculas
string text = "Finalizar Matrículas"
end type

type dw_show from w_cadastro_simples_padrao`dw_show within w_manutencao_matriculas
integer x = 142
integer width = 5189
string dataobject = "dw_25"
end type

event dw_show::clicked;call super::clicked;uo_matricula 	uol_matricula
uol_matricula = create uo_matricula

Boolean vlb_ExisteMatricula, vlb_Exclusao
integer vli_Linha

choose case dwo.name
	case 'b_finalizar_matricula'
		//Função para deletar matrícula
		vgi_Id_Finaliza_Matricula = this.getItemNumber(this.getRow(), 'usuarios_id_usuario')
		vgi_Id_Matricula = this.getItemNumber(this.getRow(), 'matriculas_id')
		
		vlb_ExisteMatricula = uol_matricula.of_existe_matricula_ativa_usuario(vgi_Id_Finaliza_Matricula)
		
		if vlb_ExisteMatricula Then
			open(w_motivo_finaliza_matricula)
		else
			f_messageBox('Atenção!','Matrícula não encontrada para o aluno ~r~rDeseja Retornar?','SIM','')
			return
		end if	
end choose
end event

