$PBExportHeader$w_servicos_gera_declaracao2.srw
$PBExportComments$Tela para gerar declaração de matrículas
forward
global type w_servicos_gera_declaracao2 from w_consulta_simples_padrao
end type
type cb_salvar from commandbutton within w_servicos_gera_declaracao2
end type
type dw_print from datawindow within w_servicos_gera_declaracao2
end type
end forward

global type w_servicos_gera_declaracao2 from w_consulta_simples_padrao
integer height = 2600
string menuname = "m_cadastro"
cb_salvar cb_salvar
dw_print dw_print
end type
global w_servicos_gera_declaracao2 w_servicos_gera_declaracao2

type variables
String vis_Id_Usuario
end variables

event open;call super::open;//Fecha a Janela de Boas Vindas
close(w_home)

//Libera / Bloqueia os Menus
f_PermissaoAcessoMenu()

dw_show.setTransObject(SQLCA)
dw_print.setTransObject(SQLCA)

w_principal.SetMicroHelp("Geração de Declaração")

//Oculta o botão de recuperar
m_cadastro.m_cad.m_recuperar.Enabled = False
m_cadastro.m_cad.m_recuperar.ToolBarItemVisible = False

m_cadastro.m_cad.m_gravar.Enabled = False
m_cadastro.m_cad.m_gravar.ToolBarItemVisible = False

m_cadastro.m_cad.m_deletar.Enabled = False
m_cadastro.m_cad.m_deletar.ToolBarItemVisible = False

triggerEvent('u_carrega_dddw')
end event

event u_carrega_dddw;call super::u_carrega_dddw;DataWindowChild	vldwc

// DropDown de Alunos
dw_get.InsertRow(1)
dw_get.event losefocus( )
dw_get.GetChild("nome_usuario", vldwc)
vldwc.setTransObject(SQLCA)
vldwc.Retrieve('A')
end event

event u_retrieve_dados;call super::u_retrieve_dados;uo_matricula	uol_matricula
uol_matricula = create uo_matricula

uo_parametros_sistema	uol_parametros_sistema
uol_parametros_sistema = create uo_parametros_sistema

Integer vli_Opcao
String vls_NomeAluno, vls_NomeCurso, vls_NomeTurma, vls_Mes
Date vld_DataMatricula

uol_matricula.of_obtem_dados_matricula( integer(vis_Id_Usuario) )
uol_parametros_sistema.of_recupera_parametro(1)

integer(vis_Id_Usuario)
dw_print.retrieve(integer(vis_Id_Usuario))

dw_print.object.t_titulo.Text = 'DECLARAÇÃO DE MATRÍCULA'

dw_print.object.t_texto_declaracao.Text = 'Declaramos para os devidos fins que '+uol_matricula.vis_NomeAluno+', nascido(a) em '+string(uol_matricula.vid_DataNascimento)+', portador(a) do CPF '+String(Mid(string(uol_matricula.vis_Cpf), 1, 3)) + '.' + String(Mid(string(uol_matricula.vis_Cpf), 4, 3)) + '.' + String(Mid(string(uol_matricula.vis_Cpf), 7, 3)) + '-' + String(Mid(string(uol_matricula.vis_Cpf), 10, 2)) +' é aluno(a) do curso '+uol_matricula.vis_NomeCurso+', na instituição '+uol_parametros_sistema.vis_NomeSis+', regularmente matriculado na turma '+uol_matricula.vis_Turma+', desde '+string(uol_matricula.vid_DataMatricula)+'.'

vls_Mes = f_traducao_mes(String(Today(), "mm"))

dw_print.object.t_data_declaracao.Text = ''+uol_parametros_sistema.vis_Cidade+', ' +String(Today(), "d")+' de '+vls_Mes+' de '+String(Today(), "YYYY")+''

//Assinatura
dw_print.object.p_assinatura.filename = uol_parametros_sistema.vis_AssinaturaDir

//Emissão do Doc
dw_print.object.t_emissao.Text = 'Documento emitido as '+string(now(), "hh:mm")+'h do dia ' +String(Today(), "DD/MM/YYYY")+''

// Nome do Sistema
dw_print.object.t_nomesistema1.Text = uol_parametros_sistema.vis_nomesis
// Nome do Sistema
dw_print.object.t_nomesistema2.Text = uol_parametros_sistema.vis_nomesis

//Endereço
dw_print.object.t_endereco.Text = uol_parametros_sistema.vis_Endereco

//CEP
dw_print.object.t_CEP.Text = 'CEP: '+Left(uol_parametros_sistema.vis_CEP,5)+'-'+Mid(uol_parametros_sistema.vis_CEP,5,3)+''


//dw_print.setItem(dw_print.getRow(), 't_texto_declaracao', 'Declaramos para os devidos fins que '+uol_matricula.vis_NomeAluno+', com matrícula (informar), é aluno(a) do curso '+uol_matricula.vis_NomeCurso+', desta (nome da instituição de ensino), regularmente matriculado na turma '+uol_matricula.vis_Turma+', desde '+string(uol_matricula.vid_DataMatricula)+'')

end event

event u_valida_get;call super::u_valida_get;
Integer vli_Opcao

vis_Id_Usuario = dw_get.getItemString(1,'nome_usuario')

If isnull(vis_Id_Usuario) or vis_Id_Usuario  = "" THEN
	vli_Opcao = f_messageBox('Atenção!','Aluno não selecionado!~r~rDeseja Retornar?','SIM','')  
	if vli_Opcao = 1 then dw_get.setColumn('nome_usuario')
	return
End If


//Chama o Evento de Recuperação dos dados
triggerEvent('u_Retrieve_Dados')
end event

on w_servicos_gera_declaracao2.create
int iCurrent
call super::create
if this.MenuName = "m_cadastro" then this.MenuID = create m_cadastro
this.cb_salvar=create cb_salvar
this.dw_print=create dw_print
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_salvar
this.Control[iCurrent+2]=this.dw_print
end on

on w_servicos_gera_declaracao2.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_salvar)
destroy(this.dw_print)
end on

type st_2 from w_consulta_simples_padrao`st_2 within w_servicos_gera_declaracao2
end type

type dw_get from w_consulta_simples_padrao`dw_get within w_servicos_gera_declaracao2
string dataobject = "dw_26"
end type

type dw_show from w_consulta_simples_padrao`dw_show within w_servicos_gera_declaracao2
integer x = 1006
integer y = 308
integer height = 2096
string title = "Declaração de Matrícula"
string dataobject = "dw_declaracao_padrao"
end type

type cb_salvar from commandbutton within w_servicos_gera_declaracao2
integer x = 4489
integer y = 1144
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
string text = "Salvar"
boolean flatstyle = true
end type

event clicked;GraphicObject Controle
DataWindow DWControle
DataWindowChild DWCAux
Integer k
string vls_Diretorio, vls_DiretorioPrograma
long vllret
boolean VIBUtilizaGS
datastore dsTemp


vls_DiretorioPrograma =GetCurrentDirectory( )

If IsValid(dw_show) Then
	If TypeOf(dw_show) = DataWindow! Then
		DWControle = dw_print
		//GetFileSaveName ( "Selecionar Local", vls_Diretorio, DWControle.title, "PDF", "All Files (*.*),*.*" , vls_DiretorioPrograma, 32770)
		vllRet = DWControle.SaveAs(vls_Diretorio, pdf!, false)

		if vllRet <> -1 then
			f_messageBox('Atenção!','Declaração salva com Sucesso!~r~rDeseja Retornar?','SIM','')
		end if
	End if

End If
end event

type dw_print from datawindow within w_servicos_gera_declaracao2
boolean visible = false
integer x = 123
integer y = 992
integer width = 686
integer height = 400
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "dw_declaracao_matricula"
boolean border = false
boolean livescroll = true
end type

