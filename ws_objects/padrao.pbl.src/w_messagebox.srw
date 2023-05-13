$PBExportHeader$w_messagebox.srw
$PBExportComments$MessageBox Personalizada
forward
global type w_messagebox from window
end type
type cb_2 from commandbutton within w_messagebox
end type
type cb_1 from commandbutton within w_messagebox
end type
type st_msg from statictext within w_messagebox
end type
type r_1 from rectangle within w_messagebox
end type
end forward

global type w_messagebox from window
integer width = 1815
integer height = 840
boolean titlebar = true
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AsteriskIcon!"
boolean center = true
integer animationtime = 100
cb_2 cb_2
cb_1 cb_1
st_msg st_msg
r_1 r_1
end type
global w_messagebox w_messagebox

type variables

end variables

on w_messagebox.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_msg=create st_msg
this.r_1=create r_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.st_msg,&
this.r_1}
end on

on w_messagebox.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_msg)
destroy(this.r_1)
end on

event open;string ls_data,ls_parse
integer li_loop,li_count

ls_data = message.stringparm 

for li_loop = 1 to len(ls_data)  
	ls_parse += mid(ls_data,li_loop,1)  
	if right(ls_parse,1) = ',' then  
		ls_parse = left(ls_parse,len(ls_parse) - 1)  
		li_count++  
		choose case li_count  
			case 1  
				title = ls_parse
			case 2  
				st_msg.text = ls_parse  
			case 3  
				cb_1.text = ls_parse  
			case 4  
				cb_2.text = ls_parse
				if cb_2.text = '' Then
					cb_2.visible = false
				End if
		 end choose  
		 ls_parse = ''  
	end if  
next  
end event

type cb_2 from commandbutton within w_messagebox
integer x = 946
integer y = 528
integer width = 357
integer height = 176
integer taborder = 20
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string pointer = "HyperLink!"
string text = "cb_2"
boolean default = true
end type

event clicked; closewithreturn(parent,'2')  
end event

type cb_1 from commandbutton within w_messagebox
accessiblerole accessiblerole = alertrole!
integer x = 1344
integer y = 528
integer width = 357
integer height = 176
integer taborder = 10
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string pointer = "HyperLink!"
string text = "cb_1"
boolean default = true
end type

event clicked; closewithreturn(parent,'1') 
end event

type st_msg from statictext within w_messagebox
integer x = 101
integer y = 120
integer width = 1591
integer height = 460
integer textsize = -11
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI Light"
long backcolor = 67108864
string text = "Teste"
boolean focusrectangle = false
end type

type r_1 from rectangle within w_messagebox
long linecolor = 33554431
linestyle linestyle = transparent!
integer linethickness = 4
long fillcolor = 26830387
integer y = 620
integer width = 1925
integer height = 180
end type

