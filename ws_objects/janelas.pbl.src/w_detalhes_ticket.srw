$PBExportHeader$w_detalhes_ticket.srw
$PBExportComments$Janela Responde para exibição de detalhes do ticket
forward
global type w_detalhes_ticket from modal_padrao_response
end type
type st_3 from statictext within w_detalhes_ticket
end type
type st_2 from statictext within w_detalhes_ticket
end type
type st_1 from statictext within w_detalhes_ticket
end type
type dw_novo_comentario from datawindow within w_detalhes_ticket
end type
type dw_respostas_tickets from datawindow within w_detalhes_ticket
end type
type dw_detalhes from datawindow within w_detalhes_ticket
end type
type cb_add_comentario from commandbutton within w_detalhes_ticket
end type
end forward

global type w_detalhes_ticket from modal_padrao_response
integer width = 4997
integer height = 1748
string title = "Detalhes do Ticket"
string icon = "C:\Users\Pedro Paulo\Documents\PROJETO FINAL PB\IMG\icons8-view-details-70.ico"
st_3 st_3
st_2 st_2
st_1 st_1
dw_novo_comentario dw_novo_comentario
dw_respostas_tickets dw_respostas_tickets
dw_detalhes dw_detalhes
cb_add_comentario cb_add_comentario
end type
global w_detalhes_ticket w_detalhes_ticket

on w_detalhes_ticket.create
int iCurrent
call super::create
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_novo_comentario=create dw_novo_comentario
this.dw_respostas_tickets=create dw_respostas_tickets
this.dw_detalhes=create dw_detalhes
this.cb_add_comentario=create cb_add_comentario
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_novo_comentario
this.Control[iCurrent+5]=this.dw_respostas_tickets
this.Control[iCurrent+6]=this.dw_detalhes
this.Control[iCurrent+7]=this.cb_add_comentario
end on

on w_detalhes_ticket.destroy
call super::destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_novo_comentario)
destroy(this.dw_respostas_tickets)
destroy(this.dw_detalhes)
destroy(this.cb_add_comentario)
end on

event open;call super::open;uo_tickets uol_tickets
uol_tickets = create uo_tickets

boolean vlb_ExisteResposta
String vls_StatusTicket

dw_detalhes.setTransObject(SQLCA)
dw_novo_comentario.setTransObject(SQLCA)
dw_respostas_tickets.setTransObject(SQLCA)

dw_detalhes.retrieve(vgi_Id_Ticket_Detalhes)

vls_StatusTicket = dw_detalhes.getItemString(1, 'ticket_status_dsc_status')

if vls_StatusTicket = 'Fechado' Then
	dw_novo_comentario.object.mensagem.protect = 1
	dw_novo_comentario.object.mensagem.Background.Color = rgb(220,220,220)
	cb_add_comentario.enabled = FALSE
end if

if dw_detalhes.rowCount() > 0 Then
	dw_novo_comentario.insertRow(0)
	
	vlb_ExisteResposta = uol_tickets.of_verifica_existe_respostas(vgi_Id_Ticket_Detalhes)
	
	if (vlb_ExisteResposta) Then
		dw_respostas_tickets.insertRow(0)
		dw_respostas_tickets.retrieve(vgi_Id_Ticket_Detalhes)
	else
		this.Resize(2555,1800)
	end if
End if



end event

type st_3 from statictext within w_detalhes_ticket
integer x = 2693
integer y = 56
integer width = 1367
integer height = 152
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Comentários"
boolean focusrectangle = false
end type

type st_2 from statictext within w_detalhes_ticket
integer x = 114
integer y = 56
integer width = 485
integer height = 152
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalhes"
boolean focusrectangle = false
end type

type st_1 from statictext within w_detalhes_ticket
integer x = 114
integer y = 960
integer width = 1367
integer height = 152
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Novo Comentário"
boolean focusrectangle = false
end type

type dw_novo_comentario from datawindow within w_detalhes_ticket
integer x = 37
integer y = 1092
integer width = 2478
integer height = 416
integer taborder = 20
string title = "none"
string dataobject = "dw_22"
boolean border = false
boolean livescroll = true
end type

type dw_respostas_tickets from datawindow within w_detalhes_ticket
integer x = 2619
integer y = 216
integer width = 2345
integer height = 1408
integer taborder = 20
string title = "none"
string dataobject = "dw_21"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_detalhes from datawindow within w_detalhes_ticket
integer x = 37
integer y = 216
integer width = 2478
integer height = 704
integer taborder = 10
string title = "none"
string dataobject = "dw_20"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_add_comentario from commandbutton within w_detalhes_ticket
integer x = 105
integer y = 1468
integer width = 2341
integer height = 152
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string text = "Adicionar Comentário"
end type

event clicked;integer vli_Ret
String vls_DataResposta, vls_Msg

//Seta a data Atual para a Data de Registro
vls_DataResposta = String(today(), "yyyy/mm/dd hh:mm:ss.ffffff")

dw_novo_comentario.setItem(1, 'id_ticket', vgi_Id_Ticket_Detalhes)
dw_novo_comentario.setItem(1, 'id_resposta_por', vgs_id_usuario)
dw_novo_comentario.setItem(1, 'respondido_em', dateTime(vls_DataResposta))

//Valida Dados para Update
dw_novo_comentario.AcceptText()
vls_Msg = dw_novo_comentario.getItemString(1, 'mensagem')

if (isNull(vls_Msg) or vls_Msg = '') Then
	f_MessageBox('Atenção', 'Comentário não informado.~r~rDeseja Retornar?', 'SIM', '')
else
	
	vli_Ret = f_MessageBox('Atenção', 'Tem certeza que deseja inserir o comentário?', 'SIM', 'NÃO')
	
	//Ok para Update e Commit
	if vli_Ret = 1 Then
	
		vli_Ret = dw_novo_comentario.update()
		
		IF (vli_Ret = 1) Then
			
			// confirma gravação no banco
			commit;
			f_messageBox('Sucesso!','O Comentário adicionado com Sucesso! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','')
			
			dw_novo_comentario.Reset()
			dw_novo_comentario.InsertRow(0)
			
			//Chama o Retrieve para carregar o novo comentário
			dw_respostas_tickets.retrieve(vgi_Id_Ticket_Detalhes)
		
		ELSE
			
			//Faz o Roolback
			rollback;
			f_messageBox('Erro!','Erro ao adicionar comentário! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','') 
				
		End if
	Else
		return
	End if
End if
end event

