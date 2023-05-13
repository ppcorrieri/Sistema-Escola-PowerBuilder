$PBExportHeader$w_cadastro_aluno.srw
$PBExportComments$Tela para Cadastro de Aluno
forward
global type w_cadastro_aluno from w_cadastro_simples_padrao
end type
type dw_aluno from datawindow within w_cadastro_aluno
end type
end forward

global type w_cadastro_aluno from w_cadastro_simples_padrao
dw_aluno dw_aluno
end type
global w_cadastro_aluno w_cadastro_aluno

type variables
Integer vis_id_usuario, vii_Opcao
uo_usuario uoi_usuario
end variables
forward prototypes
public function boolean wf_calcularidade (date p_idade)
end prototypes

public function boolean wf_calcularidade (date p_idade);integer vli_AnosBissextos[], vli_AnoNasc, vli_Anos365, vli_Anos366, vli_Dias, vli_IdadePermitida
integer i, vli_i, count = 0
uo_parametros_sistema uol_parametros_sistema
uol_parametros_sistema = create uo_parametros_sistema

vli_AnoNasc = Year(p_idade)

vli_AnosBissextos = {1972, 1976, 1980, 1984, 1988, 1992, 1996, 2000, 2004, 2008, 2012, 2016, 2020, 2024, 2028, 2032}

//Verifica se o ano atual é bissexto
for i = 1 to UpperBound(vli_AnosBissextos[])
	if (vli_AnoNasc = vli_AnosBissextos[i]) then
		count ++
		vli_i = i
	end if
next

for i = 1 to UpperBound(vli_AnosBissextos[])
	if (vli_AnosBissextos[i] > vli_AnoNasc) then
		if (Year(Today()) > vli_AnoNasc) and (vli_AnosBissextos[i] < Year(Today()))  then
			count++
		end if
	end if
next

uol_parametros_sistema.of_recupera_parametro(1)

vli_IdadePermitida = uol_parametros_sistema.vis_IdadeMinCur

// Quantidade de anos normais com 365
vli_Anos365 = vli_IdadePermitida - count

// Quantidade de anos normais com 366
vli_Anos366 = vli_IdadePermitida - vli_Anos365

//Dias entre data de hoje e nascimento
vli_Dias = int(daysAfter(p_idade,Today()))

if vli_Dias >= (365 * vli_Anos365) + (366 * vli_Anos366) -1 then
	return True
else
	return False
end if

end function

on w_cadastro_aluno.create
int iCurrent
call super::create
this.dw_aluno=create dw_aluno
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_aluno
end on

on w_cadastro_aluno.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_aluno)
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

// Cria os Objetos Necessários
uoi_usuario = create uo_usuario

//Seta as transações das Dw's
dw_show.setTransObject(sqlca)
dw_aluno.setTransObject(sqlca)

//Obtem o último ID de usuário cadastrado
vis_id_usuario = wf_obtem_id_ultimo_usuario()

dw_show.insertRow(0)
dw_aluno.insertRow(0)

w_principal.SetMicroHelp("Cadastro de Alunos")

//Evento para Inicializar os campos
triggerEvent('u_inicializa_campos')


end event

event u_inicializa_campos;call super::u_inicializa_campos;String vls_DataRegistro

//Seta a data Atual para a Data de Registro
vls_DataRegistro = String(Today(), "dd/mm/yyyy")
dw_show.setItem(1, 'usuarios_dta_registro', date(vls_DataRegistro))

//Seta o próximo ID
dw_show.setItem(1, 'usuarios_id_usuario', vis_id_usuario+1)

//Seta o próximo ID
dw_aluno.setItem(1, 'alunos_id_usuario', vis_id_usuario+1)

//Seta o tipo de usuário 'I' -> Instrutor
dw_show.setItem(1, 'usuarios_tipo_usuario', 'A')
dw_aluno.setItem(1, 'alunos_tipo_usuario', 'A')
end event

event u_valida_dados;call super::u_valida_dados;Integer vli_Opcao, vli_NumLinhas
String vls_NomeUsuario, vls_Cpf_Usuario, vls_Email_Usuario, vls_Senha
Date vldt_Nascimento
Boolean vlb_EmailValido

//Sem modificações
if dw_show.RowCount() = 0 Then
	f_messageBox('Atenção!','Nenhuma modificação feita!~r~rDeseja Retornar?','SIM','')
	return
End if

dw_show.AcceptText()

//Atribui Todos os campos para fazer as devidas validações
vls_NomeUsuario = dw_show.getItemString(1,'usuarios_nome')
vls_Cpf_Usuario = dw_show.getItemString(1,'usuarios_cpf')
vldt_Nascimento = dw_show.getItemDate(1,'usuarios_dta_nascimento')
vls_Email_Usuario = dw_show.getItemString(1,'usuarios_email')
vls_Senha = dw_show.getItemString(1,'usuarios_senha')

If isnull(vls_NomeUsuario) then
	vli_Opcao = f_messageBox('Atenção!','Nome inválido ou não informado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('usuarios_nome')
	return
End If
		
If isnull(vls_Cpf_Usuario) then
	vli_Opcao = f_messageBox('Atenção!','CPF inválido ou não informado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('usuarios_cpf')
	return
End If
	
If not isnull(vls_Email_Usuario) then
	vlb_EmailValido = uoi_usuario.of_valida_email(vls_Email_Usuario)
	
	if not vlb_EmailValido then
		vli_Opcao = f_messageBox('Atenção!','Email inválido ou não informado!~r~rDeseja Retornar?','SIM','')  
		if vli_Opcao = 1 then dw_show.setColumn('usuarios_email')
		return
	End if
End If
	
If isnull(vls_Senha) then
	vli_Opcao = f_messageBox('Atenção!','Senha inválida ou não informada!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('usuarios_senha')
	return
End If
	
If isnull(vldt_Nascimento) then
	vli_Opcao = f_messageBox('Atenção!','Data de Nascimento inválida ou não informada!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_show.setColumn('usuarios_dta_nascimento')
	return
Else
	if vldt_Nascimento > Today() Then
		vli_Opcao = f_messageBox('Atenção!','Data de Nascimento não pode ser maior que a Data de hoje!~r~rDeseja Retornar?','SIM','')
		return
	Else
		if wf_calcularIdade(vldt_Nascimento) = False Then
			vli_Opcao = f_messageBox('Atenção!','Idade mínima para realizar os cursos é de 15 anos!~r~rDeseja Retornar?','SIM','')
			return
		End if	
	End if
End if

//Chama o Evendo para Fazer Update dos Dados
triggerEvent('u_update_dados')
end event

event u_retrieve_dados;call super::u_retrieve_dados;integer vli_Ret, vli_Ret2, vli_Opcao

vli_Ret = dw_show.update()
vli_Ret2 = dw_aluno.update()

IF vli_Ret = 1 and vli_Ret2 = 1 Then
	
	// confirma gravação no banco
	commit;
	vli_Opcao = f_messageBox('Sucesso!!','Cadastro Realizado Com Sucesso! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','')
	
	dw_show.Reset()
	dw_aluno.Reset()
	triggerEvent('open')

ELSE
	
	//Faz o Roolback
	rollback;
	vli_Opcao = f_messageBox('Erro!','Erro ao Cadastrar Aluno! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','') 
		
End if

return
end event

event u_update_dados;call super::u_update_dados;integer vli_Ret, vli_Ret2, vli_Opcao

vli_Ret = dw_show.update()
vli_Ret2 = dw_aluno.update()

IF vli_Ret = 1 and vli_Ret2 = 1 Then
	
	// confirma gravação no banco
	commit;
	vli_Opcao = f_messageBox('Sucesso!!','Cadastro Realizado Com Sucesso!~r~rDeseja Retornar?','SIM','')
	
	dw_show.Reset()
	dw_aluno.Reset()
	
	//Chama Evento Open
	//Através dele irá gerar próximo ID inicializando os campos invisíveis
	triggerevent('open')

ELSE
	
	//Faz o Roolback
	rollback;
	vli_Opcao = f_messageBox('Erro!','Erro ao Cadastrar Instrutor! ~r~n ' + sqlca.sqlErrText + '~r~rDeseja Retornar?','SIM','') 
		
End if

return
end event

event u_abandonar_cadastro;call super::u_abandonar_cadastro;dw_show.AcceptText()

//Verifica se a DW foi Modificada
if (dw_show.ModifiedCount() > 0) Then
	vii_Opcao = f_messageBox('Atenção!','Deseja Abandonar O Cadastro Atual?','SIM','NÃO')  
	if vii_Opcao = 1 then return
	if vii_Opcao = 2 then return
	
Else
	vii_Opcao = f_messageBox('Atenção!','Nenhum dado foi modificado~r~rDeseja Retornar?','SIM','')  
	if vii_Opcao = 1 then return
End if
end event

type dw_get from w_cadastro_simples_padrao`dw_get within w_cadastro_aluno
boolean visible = false
end type

type st_1 from w_cadastro_simples_padrao`st_1 within w_cadastro_aluno
string text = "Cadastro de Aluno"
end type

type dw_show from w_cadastro_simples_padrao`dw_show within w_cadastro_aluno
integer x = 1207
integer y = 532
integer width = 3127
string dataobject = "dw_01"
end type

type dw_aluno from datawindow within w_cadastro_aluno
boolean visible = false
integer x = 1010
integer y = 1600
integer width = 3365
integer height = 400
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "dw_02"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = styleshadowbox!
end type

