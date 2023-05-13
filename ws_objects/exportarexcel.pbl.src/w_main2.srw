$PBExportHeader$w_main2.srw
forward
global type w_main2 from window
end type
type cb_export from commandbutton within w_main2
end type
type dw_data from datawindow within w_main2
end type
type cb_import from commandbutton within w_main2
end type
end forward

global type w_main2 from window
integer width = 2665
integer height = 1524
boolean titlebar = true
string title = "Import/Export Excel Using OLE Basic"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_export cb_export
dw_data dw_data
cb_import cb_import
end type
global w_main2 w_main2

on w_main2.create
this.cb_export=create cb_export
this.dw_data=create dw_data
this.cb_import=create cb_import
this.Control[]={this.cb_export,&
this.dw_data,&
this.cb_import}
end on

on w_main2.destroy
destroy(this.cb_export)
destroy(this.dw_data)
destroy(this.cb_import)
end on

type cb_export from commandbutton within w_main2
integer x = 2158
integer y = 1260
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Export"
end type

event clicked;Int li_columnCount, li_column, li_row
String ls_colname, ls_headertext
Long ll_value
String ls_file, ls_name
OLEObject xlApp, xlBook, xlSheet

//Check Data
If dw_data.RowCount() < 1 Then Return

//Connect Excel
xlApp = Create OLEObject
If xlApp.ConnectToNewObject("excel.application") <> 0 Then
	MessageBox("Warning",'OLE cannot connect! Please check whether your EXCEL is installed correctly!')
	Return
End If

//Get the path and file name to save
ll_value = GetFileSaveName("Select Excel File", ls_file, ls_name, "xlsx" , "Excel Files (*.xls;*.xlsx),*.xls*;*.xlsx, All Files (*.*),*.*")
If ll_value = 1 Then
	If FileExists ( ls_file ) Then
		FileDelete(ls_file)
	End If
Else
	Return
End If

SetPointer (HourGlass!)

// Add Sheet
xlApp.Application.Visible = False //hide excel
xlApp.DisplayAlerts = False
xlBook = xlApp.Workbooks.Add()
xlSheet = xlBook.WorkSheets(1)

//Format Row Header
xlSheet.Rows("1:1").Select
xlSheet.Rows(1).RowHeight = 25
xlSheet.Rows(1).Font.Size = 14
xlSheet.Rows(1).Font.Bold = True
xlSheet.Columns(1).ColumnWidth = 15 // using column number
//xlSheet.Columns(1).Borders().LineStyle = 1// using column number
xlSheet.Columns("B").ColumnWidth = 25 // using column name
xlSheet.Columns("C").ColumnWidth = 15 // using column name
xlSheet.Columns("D").ColumnWidth = 15 // using column name

//Write Hearder
li_columnCount = Integer(dw_data.Describe('DataWindow.Column.Count'))
For li_column = 1 To li_columnCount
	ls_colname = dw_data.Describe ("#"+String(li_column)+".name")
	ls_headertext = dw_data.Describe (ls_colname + "_t.text")
	xlSheet.cells(1,li_column).Value = ls_headertext
	xlSheet.cells(11,li_column).Borders().LineStyle = 1 //set Borders
Next

//Write Detail
For li_row = 1 To dw_data.RowCount()
	For li_column = 1 To li_columnCount
		xlSheet.cells(li_row + 1,li_column).Value = dw_data.Object.Data[li_row,li_column]
		xlSheet.cells(li_row + 1,li_column).Borders().LineStyle = 1 //set Borders
	Next
Next

//Save To File
If Pos(Lower(ls_file), ".xlsx") > 0 Then
	xlBook.SaveAs(ls_file, 51)
Else
	xlBook.SaveAs(ls_file, 39)
End If

//xlApp.Application.activeworkbook.worksheets[1].cells(1,1).Value = "This is the first SHEET"
//xlApp.activeworkbook.worksheets[2].cells(1,1 ).Value = "This is the second sheet"
//xlApp.activeworkbook.worksheets[3].cells(1,1).Value = "This is the third SHEET"
//By specifying parameter 1 in worksheets[1] , 2, 3 to set to different sheets can be
//xlApp.activeworkbook.SaveAs(ls_file, 39)

//Close
xlBook.Close()
xlApp.Application.quit()
xlApp.DisconnectObject()

Destroy xlApp

MessageBox("Warning",'Excel file successfully Export!!')
SetPointer(Arrow!)


end event

type dw_data from datawindow within w_main2
integer x = 18
integer y = 12
integer width = 2592
integer height = 1192
integer taborder = 20
string title = "none"
string dataobject = "d_departments"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_import from commandbutton within w_main2
integer x = 78
integer y = 1260
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Import"
end type

event clicked;oleobject xlApp, xlBook, xlSheet
Integer net , ll_value , ll_return , ll_error_cnt ,ll_error_cnt1
String  ls_file, ls_name, ls_txt_file
Long  ll_ins_row
Long ll_tot_Row , ll_tot_col , ll_row, ll_col
Long ll_department_id	, ll_manager_id,ll_location_id
String ls_depart_name
String ls_Coltype, ls_colname

// Initialize the variable
SetPointer (HourGlass!)

dw_data.Reset()
ll_error_cnt = 0
ll_error_cnt1 = 0

//Get the path and file name to save
ll_value = GetFileSaveName("Select Excel File", ls_file, ls_name, "xls;xlsx" , "Excel Files (*.xls;*.xlsx),*.xls*;*.xlsx, All Files (*.*),*.*")

If ll_value = 1 Then
	If FileExists ( ls_file ) Then
	Else
		MessageBox("Warning", "No Excel file to upload.!!")
		Return
	End If
Else
	Return;
End If

// Using Excel OLE
xlApp = Create oleobject

ll_return = xlApp.ConnectToNewObject( "excel.application" )
If ll_return < 0 Then
	MessageBox("An error occurred when connecting to Excel..~r~n Check if Excel is installed on your computer..!",String(ll_return))
	SetPointer(Arrow!)
	Return
End If

//Open Excel
xlApp.Application.Visible = False
xlApp.Workbooks.Open(ls_file)
xlBook = xlApp.Application.WorkBooks(1)
xlSheet = xlBook.Worksheets(1)

// total row col count
ll_tot_Row = xlApp.ActiveSheet.UsedRange.Rows.Count //Total rows of excel to upload
ll_tot_col = xlApp.ActiveSheet.UsedRange.Columns.Count //Total columns of exe to upload

If ll_tot_col = 4 Then
	dw_data.DataObject = "d_departments"
ElseIf ll_tot_col = 12 Then
	dw_data.DataObject = "d_employees"
Else
	MessageBox("Warning", "File invalid department")
	Return
End If

If ll_tot_col = 4 Then //departments basic read/wirte datawindow column

	//For ll_row = 2 To ll_tot_Row + 1 //If head exists in Excel, it starts from 2.
	For ll_row = 2 To ll_tot_Row
		
		ll_department_id =  Long(xlSheet.cells(ll_row,1).Value)
		ls_depart_name =  String(xlSheet.cells(ll_row,2).Value)
		ll_manager_id =  Long(xlSheet.cells(ll_row,3).Value)
		ll_location_id =  Long(xlSheet.cells(ll_row,4).Value)
		
		If ll_department_id = 0 Then
			MessageBox("Warning",'There is an invalid department id in the format.')
			Exit
		End If
		
		If Trim(ls_depart_name) = '' Or IsNull(ls_depart_name) Then
			MessageBox("Warning","There is an invalid department name is null")
			Exit
		End If
		
		ll_ins_row  = dw_data.InsertRow(0)
		dw_data.Object.department_id[ll_ins_row]     = ll_department_id
		dw_data.Object.depart_name[ll_ins_row]    = ls_depart_name
		dw_data.Object.manager_id[ll_ins_row]     = ll_manager_id
		dw_data.Object.location_id[ll_ins_row]     = ll_location_id
		
	Next
ElseIf ll_tot_col = 12 Then //dynamic read/wirte datawindow column
	
	For ll_row = 2 To ll_tot_Row
		
		ll_ins_row = dw_data.InsertRow(0)
		
		For ll_col = 1 To ll_tot_col
			
			ls_colname = dw_data.Describe ("#"+String(ll_col)+".name")
			ls_Coltype = dw_data.Describe (ls_colname+".Coltype")
			
			If left(Lower(ls_Coltype),4)  = "char" Then
				dw_data.Object.Data[ll_ins_row,ll_col] = String( xlSheet.cells(ll_row,ll_col).Value)
			Else
				dw_data.Object.Data[ll_ins_row,ll_col] = Dec( xlSheet.cells(ll_row,ll_col).Value)
			End If
			
		Next
		
	Next
	
End If

//Close Excel
xlApp.Application.Quit
xlApp.DisconnectObject()

Destroy xlSheet
Destroy xlBook
Destroy xlApp

MessageBox("Warning",'Excel file successfully uploaded!!')
SetPointer(Arrow!)






end event

