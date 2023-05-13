$PBExportHeader$w_motivo_finaliza_matricula.srw
$PBExportComments$Janela para Adicionar motivo da finalização da matrícula
forward
global type w_motivo_finaliza_matricula from modal_padrao_response
end type
type cb_1 from commandbutton within w_motivo_finaliza_matricula
end type
type st_1 from statictext within w_motivo_finaliza_matricula
end type
type dw_finaliza_matricula from datawindow within w_motivo_finaliza_matricula
end type
end forward

global type w_motivo_finaliza_matricula from modal_padrao_response
integer width = 2194
integer height = 1224
string title = ""
cb_1 cb_1
st_1 st_1
dw_finaliza_matricula dw_finaliza_matricula
end type
global w_motivo_finaliza_matricula w_motivo_finaliza_matricula

type variables
String vis_Motivo
end variables

on w_motivo_finaliza_matricula.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.st_1=create st_1
this.dw_finaliza_matricula=create dw_finaliza_matricula
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_finaliza_matricula
end on

on w_motivo_finaliza_matricula.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.dw_finaliza_matricula)
end on

event open;call super::open;dw_finaliza_matricula.setTransObject(SQLCA)
dw_finaliza_matricula.insertRow(0)

dw_finaliza_matricula.object.motivo.protect = TRUE
dw_finaliza_matricula.object.motivo.Background.Color = rgb(220,220,220)

dw_finaliza_matricula.AcceptText()
end event

type cb_1 from commandbutton within w_motivo_finaliza_matricula
integer y = 932
integer width = 2217
integer height = 216
integer taborder = 20
integer textsize = -17
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string text = "Finalizar"
end type

event clicked;uo_matricula 	uol_matricula
uol_matricula = create uo_matricula
String vls_Motivo
Boolean vlb_Exclusao

dw_finaliza_matricula.AcceptText()

if vis_Motivo = 'N/A' Then
	vis_Motivo = dw_finaliza_matricula.getItemString(1, 'motivo')
elseif vis_Motivo = '' Then
	f_MessageBox('Atenção', 'Um motivo deve ser selecionado para a finalização da Matrícula~r~rDeseja Retornar?', 'SIM', '')
	return
end if

vlb_Exclusao = uol_matricula.of_desativa_matricula(vgi_Id_Finaliza_Matricula, vis_Motivo, vgi_Id_Matricula)

if vlb_Exclusao Then
	f_messageBox('Atenção!','Matrícula desativada com Sucesso! ~r~rDeseja Retornar?','SIM','')
	close(w_motivo_finaliza_matricula)
else
	f_messageBox('Atenção!','Ocorreu um erro ao finalizar a Matrícula ~r~rDeseja Retornar?','SIM','')
end if

end event

type st_1 from statictext within w_motivo_finaliza_matricula
integer y = 52
integer width = 2185
integer height = 140
integer textsize = -17
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Finalizar Matrícula"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_finaliza_matricula from datawindow within w_motivo_finaliza_matricula
integer x = 110
integer y = 148
integer width = 1984
integer height = 768
integer taborder = 10
string title = "none"
string dataobject = "dw_27"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;
choose case dwo.name
	case 'outro'
	
		if data <> 'N/A' Then
			this.object.motivo.protect = TRUE
			this.object.motivo.Background.Color = rgb(220,220,220)
		else
			this.object.motivo.protect = FALSE
			this.object.motivo.Background.Color = rgb(255,255,255)
			this.setItem(getRow(), 'motivo', '')
		End if
		vis_Motivo = data
		
end choose
end event

