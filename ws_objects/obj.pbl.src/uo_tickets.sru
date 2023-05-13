$PBExportHeader$uo_tickets.sru
$PBExportComments$Objeto para Controle de Tickets
forward
global type uo_tickets from nonvisualobject
end type
end forward

global type uo_tickets from nonvisualobject
end type
global uo_tickets uo_tickets

type variables
Integer vii_Status
end variables

forward prototypes
public function boolean of_atualiza_status (integer p_id_ticket, integer p_id_status)
public function boolean of_verifica_status_ticket (integer p_id_ticket)
public function boolean of_verifica_existe_respostas (integer p_id_ticket)
end prototypes

public function boolean of_atualiza_status (integer p_id_ticket, integer p_id_status);//Função para assumir Ticket
//Só é permitido para usuários de nível acesso Gerência / Instrutor
//Ao Assumir o Ticket o Status muda para : Assumido (Status 2)

//Status Ticket Aberto -> Assumido
if p_id_status = 1 then
	update tickets
		set tickets.id_atendido_por = :vgs_id_usuario,
			 tickets.id_status = 2
	 where tickets.id = :p_id_ticket;
end if

//Status Ticket Assumido -> Resolvido
if p_id_status = 2 then
	update tickets
		set tickets.id_status = 3
	 where tickets.id = :p_id_ticket;
end if

//Status Ticket Resolvido -> Fechado
if p_id_status = 3 then
	update tickets
		set tickets.id_status = 4,
			 tickets.fechado_em = CURRENT_TIMESTAMP
	 where tickets.id = :p_id_ticket;
end if

if SQLCA.SQLCode < 0 Then
	f_MessageBox('Atenção', 'Erro ao avançar Status do Ticket, Operação não Concluída! ~r~rDeseja Retornar?', 'SIM', '')
	ROLLBACK;
	Return False
end if

COMMIT;

return True
end function

public function boolean of_verifica_status_ticket (integer p_id_ticket);select id_status
into :vii_Status
from tickets
where tickets.id = :p_id_ticket;

if SQLCA.SQLCode < 0 Then
	f_MessageBox('Atenção', 'Erro ao verificar Status do Ticket no Banco de Dados ~r~rDeseja Retornar?', 'SIM', '')
	return False
end if

end function

public function boolean of_verifica_existe_respostas (integer p_id_ticket);integer vli_Count

select count(*)
into :vli_Count
from tickets_respostas, tickets
where tickets_respostas.id_ticket = tickets.id
 and tickets.id = :p_id_ticket;

if SQLCA.SQLCode < 0 Then
	f_MessageBox('Atenção', 'Erro ao verificar a existência de respostas no Ticket ~r~rDeseja Retornar?', 'SIM', '')
	return False
end if

if vli_Count > 0 Then Return True

return False
end function

on uo_tickets.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_tickets.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

