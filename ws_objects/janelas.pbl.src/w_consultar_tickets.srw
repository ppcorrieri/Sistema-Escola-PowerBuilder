$PBExportHeader$w_consultar_tickets.srw
$PBExportComments$Janela para a consulta de Tickets
forward
global type w_consultar_tickets from w_consulta_simples_padrao
end type
type dw_respostas_tickets from datawindow within w_consultar_tickets
end type
type cb_detalhes from commandbutton within w_consultar_tickets
end type
end forward

global type w_consultar_tickets from w_consulta_simples_padrao
integer height = 2600
string title = "Consulta de Tickets"
string menuname = "m_consulta"
dw_respostas_tickets dw_respostas_tickets
cb_detalhes cb_detalhes
end type
global w_consultar_tickets w_consultar_tickets

type variables
DataWindowChild	vidwcUsuarios, vidwcTickets

Integer vii_Opcao, vii_Ticket_id, vii_UsuarioTicket, vii_Id_Ticket, vii_Id_Usuario

boolean vib_Click
end variables

event open;call super::open;//Fecha a Janela de Boas Vindas
close(w_home)

//Libera / Bloqueia os Menus
f_PermissaoAcessoMenu()

w_principal.SetMicroHelp("Consulta Tickets")

if (vgs_TipoAcesso = 'A') Then
	//Muda a Posição
	dw_get.object.t_ticket_id.X = 107
	dw_get.object.t_ticket_id.Y = 96
		
	dw_get.object.ticket_id.X = 347
	dw_get.object.ticket_id.Y = 96
End if

triggerEvent('u_carrega_dddw')

dw_respostas_tickets.setTransObject(SQLCA)
end event

event u_retrieve_dados;call super::u_retrieve_dados;uo_tickets uol_tickets
uol_tickets = create uo_tickets
boolean vlb_ExisteResposta

dw_Show.retrieve(integer(vii_Id_Usuario), integer(vii_Id_Ticket))

if dw_show.rowCount() > 0 Then
	cb_detalhes.visible = true
	vii_Ticket_id = dw_show.getItemNumber(1, 'tickets_id')
	vlb_ExisteResposta = uol_tickets.of_verifica_existe_respostas(vii_Ticket_id)
	
	if (vlb_ExisteResposta) Then
		dw_respostas_tickets.insertRow(0)
		dw_respostas_tickets.retrieve(vii_Ticket_id)
	end if
End if

//Verifica se Encontrou Registros
if dw_show.rowCount() = 0 Then
	f_messageBox('Atenção!','Nenhum Registro Encontrado!~r~rDeseja Retornar?','SIM','')  
End If
end event

event u_abandonar_consulta;call super::u_abandonar_consulta;if (dw_show.RowCount() > 0) Then
	vii_Opcao = f_messageBox('Atenção!','Deseja Abandonar a Consulta Atual?','SIM','NÃO')  
	if vii_Opcao = 1 then triggerEvent('u_reset_dddws')
	cb_detalhes.visible = FALSE
	if vii_Opcao = 2 then return
Else
	vii_Opcao = f_messageBox('Atenção!','Nenhuma consulta foi iniciada~r~rDeseja Retornar?','SIM','')  
	if vii_Opcao = 1 then return
End if
end event

on w_consultar_tickets.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.dw_respostas_tickets=create dw_respostas_tickets
this.cb_detalhes=create cb_detalhes
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_respostas_tickets
this.Control[iCurrent+2]=this.cb_detalhes
end on

on w_consultar_tickets.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_respostas_tickets)
destroy(this.cb_detalhes)
end on

event u_valida_get;call super::u_valida_get;Integer vli_Opcao

vii_Id_Usuario = dw_get.getItemNumber(1,'nome_usuario')
vii_Id_Ticket = dw_get.getItemNumber( 1, 'ticket_id')

If isnull(vii_Id_Usuario) THEN
	vli_Opcao = f_messageBox('Atenção!','Aluno não selecionado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_get.setColumn('nome_usuario')
	return
End If

If isnull(vii_Id_Ticket) THEN
	vli_Opcao = f_messageBox('Atenção!','Ticket não selecionado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_get.setColumn('ticket_id')
	return
End If

if dw_show.rowCount() > 0 then
	dw_show.deleteRow(1)
end if

if dw_respostas_tickets.rowCount() > 0 then
	dw_respostas_tickets.deleteRow(1)
end if


//Chama o Evento de Recuperação dos dados
triggerEvent('u_Retrieve_Dados')
end event

event u_carrega_dddw;call super::u_carrega_dddw;

if (vgs_TipoAcesso = 'G') Then
	// DropDown de Alunos
	dw_get.InsertRow(1)
	dw_get.event losefocus( )
	dw_get.GetChild("nome_usuario", vidwcUsuarios)
	vidwcUsuarios.setTransObject(SQLCA)
	vidwcUsuarios.Retrieve(0)
	
elseif (vgs_TipoAcesso = 'A') Then
	// DropDown de Alunos
	dw_get.InsertRow(1)
	dw_get.event losefocus( )
	dw_get.GetChild("nome_usuario", vidwcUsuarios)
	vidwcUsuarios.setTransObject(SQLCA)
	vidwcUsuarios.Retrieve(vgs_id_usuario)
	
	//Bloqueia A Drop já que só retornará a linha do usuário de acesso aluno
	dw_get.setItem(1, 'nome_usuario', vgs_Id_Usuario)
	dw_get.object.nome_usuario_t.visible = FALSE
	dw_get.object.nome_usuario.visible = FALSE
	
	vidwcUsuarios.getRow()
	vii_UsuarioTicket = vidwcUsuarios.getItemNumber(vidwcUsuarios.getRow(), 'id_usuario')
			
	dw_get.GetChild("ticket_id", vidwcTickets)
	vidwcTickets.setTransObject(SQLCA)
	vidwcTickets.Retrieve(vii_UsuarioTicket)

end if
end event

type st_2 from w_consulta_simples_padrao`st_2 within w_consultar_tickets
string text = "Consultar Tickets"
end type

type dw_get from w_consulta_simples_padrao`dw_get within w_consultar_tickets
string dataobject = "dw_16"
end type

event dw_get::itemchanged;call super::itemchanged;integer vli_Nulo
setNull(vli_Nulo)

if vgs_TipoAcesso = 'G' or vgs_TipoAcesso = 'I' Then
	choose case dwo.name
		case 'nome_usuario'
			this.getRow()
			
			//Reseta a dddw de tickets ao trocar o 
			if vidwcTickets.rowCount() > 0 Then
				this.setItem(1, 'ticket_id', vli_Nulo)
			end if
			
			vidwcUsuarios.getRow()
			vii_UsuarioTicket = vidwcUsuarios.getItemNumber(vidwcUsuarios.getRow(), 'id_usuario')
			
			this.GetChild("ticket_id", vidwcTickets)
			vidwcTickets.setTransObject(SQLCA)
			vidwcTickets.Retrieve(vii_UsuarioTicket)
		
	end choose
end if
	
	
end event

type dw_show from w_consulta_simples_padrao`dw_show within w_consultar_tickets
integer x = 1239
integer y = 832
integer width = 3035
integer height = 788
string dataobject = "dw_15"
end type

type dw_respostas_tickets from datawindow within w_consultar_tickets
boolean visible = false
integer x = 1239
integer y = 1388
integer width = 3035
integer height = 964
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "dw_17"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type cb_detalhes from commandbutton within w_consultar_tickets
boolean visible = false
integer x = 1307
integer y = 1400
integer width = 457
integer height = 120
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string text = "Exibir Detalhes"
end type

event clicked;//if(vib_Click) Then
//	dw_respostas_tickets.visible = true
//	cb_detalhes.text = '- Detalhes'
//	vib_Click = FALSE
//else
//	dw_respostas_tickets.visible = false
//	cb_detalhes.text = '+ Detalhes'
//	vib_Click = TRUE
//end if

vgi_Id_Ticket_Detalhes = dw_show.getItemNumber(1, 'tickets_id')
open(w_detalhes_ticket)

end event

