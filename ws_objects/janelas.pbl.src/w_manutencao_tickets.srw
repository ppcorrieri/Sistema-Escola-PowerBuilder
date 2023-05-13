$PBExportHeader$w_manutencao_tickets.srw
$PBExportComments$Tela para manutenção de Tickets
forward
global type w_manutencao_tickets from w_cadastro_simples_padrao
end type
end forward

global type w_manutencao_tickets from w_cadastro_simples_padrao
string title = "Manutenção de Tickets"
event u_valida_get ( )
end type
global w_manutencao_tickets w_manutencao_tickets

type variables
Integer vis_Ticket_Status, vii_Opcao
end variables

forward prototypes
public function boolean wf_assumir_ticket (integer p_id_ticket)
end prototypes

event u_valida_get();Integer vli_Opcao

vis_Ticket_Status = dw_get.getItemNumber(1,'status_id')

If isnull(vis_Ticket_Status) THEN
	vli_Opcao = f_messageBox('Atenção!','Status não selecionado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_get.setColumn('status_id')
	return
End If

//Chama o Evento de Recuperação dos dados
triggerEvent('u_Retrieve_Dados')
end event

public function boolean wf_assumir_ticket (integer p_id_ticket);//Função para assumir Ticket
//Só é permitido para usuários de nível acesso Gerência / Instrutor
//Ao Assumir o Ticket o Status muda para : Assumido (Status 2)

update tickets
   set tickets.id_atendido_por = :vgs_id_usuario,
		 tickets.id_status = 2
 where tickets.id = :p_id_ticket;

if SQLCA.SQLCode < 0 Then
	f_MessageBox('Atenção', 'Erro ao atribuir ticket ao usuário responsável pelo atendimento ~r~rDeseja Retornar?', 'SIM', '')
	ROLLBACK;
	Return False
end if

COMMIT;

return True
end function

on w_manutencao_tickets.create
call super::create
end on

on w_manutencao_tickets.destroy
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

//Oculta o botão de recuperar
m_cadastro.m_cad.m_recuperar.Enabled = False
m_cadastro.m_cad.m_recuperar.ToolBarItemVisible = False

//Oculta o botão de gravar
m_cadastro.m_cad.m_gravar.Enabled = False
m_cadastro.m_cad.m_gravar.ToolBarItemVisible = False

//Oculta o botão de deletar
m_cadastro.m_cad.m_deletar.Enabled = False
m_cadastro.m_cad.m_deletar.ToolBarItemVisible = False
end event

event u_retrieve_dados;call super::u_retrieve_dados;dw_Show.retrieve(vis_Ticket_Status)

//Verifica se Encontrou Registros
if dw_show.rowCount() = 0 Then
	f_messageBox('Atenção!','Nenhum Registro Encontrado!~r~rDeseja Retornar?','SIM','')  
End If
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

type dw_get from w_cadastro_simples_padrao`dw_get within w_manutencao_tickets
integer x = 0
string dataobject = "dw_19"
end type

type st_1 from w_cadastro_simples_padrao`st_1 within w_manutencao_tickets
string text = "Manutenção de Tickets"
end type

type dw_show from w_cadastro_simples_padrao`dw_show within w_manutencao_tickets
integer x = 82
integer y = 656
integer width = 5326
integer height = 1536
string title = "Manutenção / Consulta de Tickets"
string dataobject = "dw_18"
end type

event dw_show::clicked;call super::clicked;integer i

choose case dwo.name
	case 'b_detalhes'
		
		this.accepttext( )
		//Obetem o Id do ticket da linha clicada
		vgi_Id_Ticket_Detalhes = this.getItemNumber(this.GetClickedRow(), 'tickets_id')
		this.accepttext( )	
		
		//Abre nova janela para exibição de detalhes
		open(w_detalhes_ticket)
	
end choose
end event

event dw_show::itemchanged;call super::itemchanged;integer i, vll_Linha, vii_StatusTicket
uo_tickets 	uol_tickets
uol_tickets = create uo_tickets

choose case dwo.name
	case 'assumir_ticket'
		vll_Linha = this.GetRow()
		
		for i = 1 to this.RowCount()
			this.setItem(i, 'assumir_ticket', 'N')
		next
		
		if this.getItemString(vll_Linha, 'assumir_ticket')  = 'N' Then
			this.setItem(vll_Linha, 'assumir_ticket', 'S')
		end if
		
		//Função para assumir ticket
		uol_tickets.of_verifica_status_ticket(this.getItemNumber(vll_Linha, 'tickets_id'))
		vii_StatusTicket = uol_tickets.vii_status
		
		vii_Opcao = f_messageBox('Atenção!','Tem certeza que deseja assumir o ticket: '+ string(this.getItemNumber(vll_Linha, 'tickets_id')) +' ?','SIM','NÃO')
		
		if vii_Opcao = 1 Then
			//Passa o Ticket e o Status Atual do Ticket
			uol_tickets.of_atualiza_status( this.getItemNumber(vll_Linha, 'tickets_id'), vii_StatusTicket)
		end if
		
		if vii_Opcao <> 1 Then
			this.reset()
			w_manutencao_tickets.triggerEvent('u_valida_get')
			
		end if
		
	case 'resolver_ticket'
		vll_Linha = this.GetRow()
		
		for i = 1 to this.RowCount()
			this.setItem(i, 'resolver_ticket', 'N')
		next
		
		if this.getItemString(vll_Linha, 'resolver_ticket')  = 'N' Then
			this.setItem(vll_Linha, 'resolver_ticket', 'S')
		end if
		
		//Função para assumir ticket
		uol_tickets.of_verifica_status_ticket(this.getItemNumber(vll_Linha, 'tickets_id'))
		vii_StatusTicket = uol_tickets.vii_status
		
		vii_Opcao = f_messageBox('Atenção!','Tem certeza que deseja avançar o status do ticket: '+ string(this.getItemNumber(vll_Linha, 'tickets_id')) +' ?','SIM','NÃO')
		
		if vii_Opcao = 1 Then
			//Passa o Ticket e o Status Atual do Ticket
			uol_tickets.of_atualiza_status( this.getItemNumber(vll_Linha, 'tickets_id'), vii_StatusTicket)
		end if
		
		if vii_Opcao <> 1 Then
			this.reset()
			w_manutencao_tickets.triggerEvent('u_valida_get')
			
		end if
		
	case 'fechar_ticket'
		vll_Linha = this.GetRow()
		
		for i = 1 to this.RowCount()
			this.setItem(i, 'fechar_ticket', 'N')
		next
		
		if this.getItemString(vll_Linha, 'fechar_ticket')  = 'N' Then
			this.setItem(vll_Linha, 'fechar_ticket', 'S')
		end if
		
		//Função para assumir ticket
		uol_tickets.of_verifica_status_ticket(this.getItemNumber(vll_Linha, 'tickets_id'))
		vii_StatusTicket = uol_tickets.vii_status
		
		vii_Opcao = f_messageBox('Atenção!','Tem certeza que deseja Fechar o Ticket: '+ string(this.getItemNumber(vll_Linha, 'tickets_id')) +' ?','SIM','NÃO')
		
		if vii_Opcao = 1 Then
			//Passa o Ticket e o Status Atual do Ticket
			uol_tickets.of_atualiza_status( this.getItemNumber(vll_Linha, 'tickets_id'), vii_StatusTicket)
		end if
		
		if vii_Opcao <> 1 Then
			this.reset()
			w_manutencao_tickets.triggerEvent('u_valida_get')
			
		end if
			
end choose
end event

