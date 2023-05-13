$PBExportHeader$w_servicos_gera_declaracao.srw
$PBExportComments$Janela para geração de Declaração de Matrícula
forward
global type w_servicos_gera_declaracao from w_documento_consulta_simples_padrao
end type
type cb_visual_impressao from commandbutton within w_servicos_gera_declaracao
end type
type st_titulo_gerado from statictext within w_servicos_gera_declaracao
end type
type st_subtitulo_gerado from statictext within w_servicos_gera_declaracao
end type
end forward

global type w_servicos_gera_declaracao from w_documento_consulta_simples_padrao
boolean visible = false
integer height = 2600
string title = "Gerar Declaração de Matrícula"
string menuname = "m_documentos"
cb_visual_impressao cb_visual_impressao
st_titulo_gerado st_titulo_gerado
st_subtitulo_gerado st_subtitulo_gerado
end type
global w_servicos_gera_declaracao w_servicos_gera_declaracao

type variables
String vis_Id_Usuario
end variables

on w_servicos_gera_declaracao.create
int iCurrent
call super::create
if this.MenuName = "m_documentos" then this.MenuID = create m_documentos
this.cb_visual_impressao=create cb_visual_impressao
this.st_titulo_gerado=create st_titulo_gerado
this.st_subtitulo_gerado=create st_subtitulo_gerado
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_visual_impressao
this.Control[iCurrent+2]=this.st_titulo_gerado
this.Control[iCurrent+3]=this.st_subtitulo_gerado
end on

on w_servicos_gera_declaracao.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_visual_impressao)
destroy(this.st_titulo_gerado)
destroy(this.st_subtitulo_gerado)
end on

event open;call super::open;//Fecha a Janela de Boas Vindas
close(w_home)

//Libera / Bloqueia os Menus
f_PermissaoAcessoMenu()

dw_show.setTransObject(SQLCA)
dw_print.setTransObject(SQLCA)

//Oculta os botões de Imprimir / Exportar Documento
m_documentos.m_doc.m_imprimir0.Enabled = False
m_documentos.m_doc.m_imprimir0.ToolBarItemVisible = False

m_documentos.m_doc.m_exportar.Enabled = False
m_documentos.m_doc.m_exportar.ToolBarItemVisible = False

//Bloqueia A Drop já que só retornará a linha do usuário de acesso aluno
if (vgs_TipoAcesso = 'A') Then
	dw_get.setItem( 1, 'nome_usuario', vgs_Id_Usuario)
	dw_get.visible = FALSE
end if

w_principal.SetMicroHelp("Geração de Declaração")

triggerEvent('u_carrega_dddw')
end event

event u_carrega_dddw;call super::u_carrega_dddw;DataWindowChild	vldwc

if (vgs_TipoAcesso = 'G' or vgs_TipoAcesso = 'I') Then
	// DropDown de Alunos
	dw_get.InsertRow(1)
	dw_get.event losefocus( )
	dw_get.GetChild("nome_usuario", vldwc)
	vldwc.setTransObject(SQLCA)
	vldwc.Retrieve(0)
	
elseif (vgs_TipoAcesso = 'A') Then
	// DropDown de Alunos
	dw_get.InsertRow(1)
	dw_get.event losefocus( )
	dw_get.GetChild("nome_usuario", vldwc)
	vldwc.setTransObject(SQLCA)
	vldwc.Retrieve(vgs_id_usuario)
end if

//// DropDown de Alunos
//dw_get.InsertRow(1)
//dw_get.event losefocus( )
//dw_get.GetChild("nome_usuario", vldwc)
//vldwc.setTransObject(SQLCA)
//vldwc.Retrieve('A')
end event

event u_retrieve_dados;call super::u_retrieve_dados;//Libera os botões de Imprimir / Exportar Documento
m_documentos.m_doc.m_imprimir0.Enabled = True
m_documentos.m_doc.m_imprimir0.ToolBarItemVisible = True

m_documentos.m_doc.m_exportar.Enabled = True
m_documentos.m_doc.m_exportar.ToolBarItemVisible = True

st_titulo_gerado.visible = TRUE
st_subtitulo_gerado.visible = TRUE
cb_visual_impressao.visible = TRUE

f_gera_matricula(dw_print)
end event

event u_valida_get;call super::u_valida_get;
Integer vli_Opcao, vllCopia

if vgs_TipoAcesso = 'I' or vgs_TipoAcesso = 'G' Then
	vgs_Id_Usuario_Impressao_Visual = dw_get.getItemString(1,'nome_usuario')

	If isnull(vgs_Id_Usuario_Impressao_Visual) or vgs_Id_Usuario_Impressao_Visual  = "" THEN
		vli_Opcao = f_messageBox('Atenção!','Aluno não selecionado!~r~rDeseja Retornar?','SIM','')  
		if vli_Opcao = 1 then dw_get.setColumn('nome_usuario')
		return
	End If
Else
	vgs_Id_Usuario_Impressao_Visual = string(vgs_id_usuario)
end if



//Chama o Evento de Recuperação dos dados
triggerEvent('u_Retrieve_Dados')
end event

event u_exportar_pdf;call super::u_exportar_pdf;GraphicObject Controle
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

event u_imprimir_doc;call super::u_imprimir_doc;//dw_print.Print(true)

PrintSetup()
dw_print.Print(false, true)
end event

type dw_print from w_documento_consulta_simples_padrao`dw_print within w_servicos_gera_declaracao
integer x = 2597
integer y = 1372
integer width = 242
integer height = 88
string dataobject = "dw_declaracao_padrao"
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type st_2 from w_documento_consulta_simples_padrao`st_2 within w_servicos_gera_declaracao
string text = "Gerar Declaração de Matrícula"
end type

type dw_get from w_documento_consulta_simples_padrao`dw_get within w_servicos_gera_declaracao
string dataobject = "dw_26"
end type

type dw_show from w_documento_consulta_simples_padrao`dw_show within w_servicos_gera_declaracao
boolean visible = false
end type

type cb_visual_impressao from commandbutton within w_servicos_gera_declaracao
boolean visible = false
integer x = 2400
integer y = 1344
integer width = 690
integer height = 164
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string text = "Visualizar Impressão"
end type

event clicked;open(w_visualizar_impressao)
end event

type st_titulo_gerado from statictext within w_servicos_gera_declaracao
boolean visible = false
integer x = 2089
integer y = 996
integer width = 1294
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Documento Gerado com Sucesso!"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_subtitulo_gerado from statictext within w_servicos_gera_declaracao
boolean visible = false
integer x = 1170
integer y = 1100
integer width = 3163
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Visualize a Impressão/ Imprima ou Salve o Documento através das opções na Barra de Ferramentas"
alignment alignment = center!
boolean focusrectangle = false
end type

