$PBExportHeader$w_consulta_dados_aluno.srw
$PBExportComments$Janela de Consulta de Dados de Alunos
forward
global type w_consulta_dados_aluno from w_consulta_simples_padrao
end type
end forward

global type w_consulta_dados_aluno from w_consulta_simples_padrao
integer height = 2600
string title = "Consulta Dados do Aluno"
string menuname = "m_consulta"
end type
global w_consulta_dados_aluno w_consulta_dados_aluno

type variables
String vis_Id_Usuario
Integer vii_Opcao
end variables

on w_consulta_dados_aluno.create
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
end on

on w_consulta_dados_aluno.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;//Fecha a Janela de Boas Vindas
close(w_home)

//Libera / Bloqueia os Menus
f_PermissaoAcessoMenu()

w_principal.SetMicroHelp("Consulta Dados de Alunos")

triggerEvent('u_carrega_dddw')
end event

event u_retrieve_dados;call super::u_retrieve_dados;integer(vis_Id_Usuario)
dw_Show.retrieve(integer(vis_Id_Usuario))

this.setFocus()

end event

event u_valida_get;call super::u_valida_get;Integer vli_Opcao

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

event u_carrega_dddw;call super::u_carrega_dddw;DataWindowChild	vldwc

// DropDown de Alunos
dw_get.InsertRow(1)
dw_get.event losefocus( )
dw_get.GetChild("nome_usuario", vldwc)
vldwc.setTransObject(SQLCA)
vldwc.Retrieve('A')
end event

event u_abandonar_consulta;call super::u_abandonar_consulta;
if (dw_show.RowCount() > 0) Then
	vii_Opcao = f_messageBox('Atenção!','Deseja Abandonar a Consulta Atual?','SIM','NÃO')  
	if vii_Opcao = 1 then triggerEvent('u_reset_dddws')
	if vii_Opcao = 2 then return
Else
	vii_Opcao = f_messageBox('Atenção!','Nenhuma consulta foi iniciada~r~rDeseja Retornar?','SIM','')  
	if vii_Opcao = 1 then return
End if
end event

type st_2 from w_consulta_simples_padrao`st_2 within w_consulta_dados_aluno
string text = "Consulta Dados do Aluno"
end type

type dw_get from w_consulta_simples_padrao`dw_get within w_consulta_dados_aluno
string dataobject = "dw_03"
end type

type dw_show from w_consulta_simples_padrao`dw_show within w_consulta_dados_aluno
integer x = 1061
integer y = 592
string title = "Consulta Dados do Aluno"
string dataobject = "dw_04"
end type

