$PBExportHeader$w_consulta_ticket_gerencial.srw
$PBExportComments$Consulta Gerencial de Tickets por Status
forward
global type w_consulta_ticket_gerencial from w_consulta_simples_padrao
end type
end forward

global type w_consulta_ticket_gerencial from w_consulta_simples_padrao
integer height = 2600
string title = "Consulta Gerencial Ticket por Status"
string menuname = "m_consulta"
end type
global w_consulta_ticket_gerencial w_consulta_ticket_gerencial

type variables
integer vis_Ticket_Status
end variables

on w_consulta_ticket_gerencial.create
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
end on

on w_consulta_ticket_gerencial.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;//Fecha a Janela de Boas Vindas
close(w_home)

//Libera / Bloqueia os Menus
f_PermissaoAcessoMenu()

w_principal.SetMicroHelp("Consulta Gerencial de Ticket Por Status")

dw_get.insertRow(0)

dw_Show.setTransObject(SQLCA)
//dw_Show.insertRow(0)


end event

event u_valida_get;call super::u_valida_get;Integer vli_Opcao

vis_Ticket_Status = dw_get.getItemNumber(1,'status_id')

If isnull(vis_Ticket_Status) THEN
	vli_Opcao = f_messageBox('Atenção!','Status não selecionado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_get.setColumn('status_id')
	return
End If

//Chama o Evento de Recuperação dos dados
triggerEvent('u_Retrieve_Dados')
end event

event u_retrieve_dados;call super::u_retrieve_dados;dw_Show.retrieve(vis_Ticket_Status)

end event

type st_2 from w_consulta_simples_padrao`st_2 within w_consulta_ticket_gerencial
string text = "Consulta Ticket por Status"
end type

type dw_get from w_consulta_simples_padrao`dw_get within w_consulta_ticket_gerencial
string dataobject = "dw_19"
end type

type dw_show from w_consulta_simples_padrao`dw_show within w_consulta_ticket_gerencial
integer x = 96
integer y = 700
integer width = 5280
integer height = 1508
string dataobject = "dw_18"
end type

event dw_show::constructor;call super::constructor;//this.Modify("datawindow.detail.color='536870912~tif(getrow() = currentrow(), rgb(30,144,255), rgb (255,255,255))'")
end event

event dw_show::clicked;call super::clicked;choose case dwo.name
	case 'b_detalhes'
		
		this.accepttext( )
		//Obetem o Id do ticket da linha clicada
		vgi_Id_Ticket_Detalhes = this.getItemNumber(this.GetClickedRow(), 'tickets_id')
		this.accepttext( )	
		
		//Abre nova janela para exibição de detalhes
		open(w_detalhes_ticket)
		
end choose
end event

