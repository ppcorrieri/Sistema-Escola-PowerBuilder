$PBExportHeader$sistemaescola.sra
$PBExportComments$Generated Application Object
forward
global type sistemaescola from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
//---------------------------------------------------------------------------------------
//  Dados Da Aplicação.
//---------------------------------------------------------------------------------------

String vgsVersao = '1.0'
String vgsData = ''

//Objeto Padrão de usuário
uo_usuario uog_usuario

//Objeto Padrão de Parâmetros do Sistema
uo_parametros_sistema uog_parametros_sistema

//Principais do usuário logado
String vgs_TipoAcesso, vgs_Email, vgs_Nome, vgs_Dta_Registro, vgs_Dta_Nascimento
Integer vgs_id_usuario


//Variáveis para transitar entre janelas

// Ex: Consulta Ticket por Status (Exibição de Detalhes)
Integer vgi_Id_Ticket_Detalhes

// Ex: Nova janela para inclusão de motivo ao finalizar matrícula
Integer vgi_Id_Finaliza_Matricula, vgi_Id_Matricula

//Variavel para transitar entre janelas
// Visualizar impressão
String vgs_Id_Usuario_Impressao_Visual



 
end variables
global type sistemaescola from application
string appname = "sistemaescola"
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 22.0\IDE\theme"
string themename = "Personalizado"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 5
long richtexteditx64type = 5
long richtexteditversion = 3
string richtexteditkey = ""
string appicon = ""
string appruntimeversion = "22.0.0.1900"
boolean manualsession = false
boolean unsupportedapierror = false
boolean bignoreservercertificate = false
uint ignoreservercertificate = 0
end type
global sistemaescola sistemaescola

forward prototypes
public function integer f_messagebox (string as_title, string as_text, string as_option1, string as_option2)
public function integer f_messagebox (string as_title, string as_text, string as_option1)
end prototypes

global function integer f_messagebox (string as_title, string as_text, string as_option1, string as_option2);string ls_return,ls_parm  
ls_parm = as_title+','+as_text+','+as_option1+','+as_option2+','  
openwithparm(w_MessageBox,ls_parm)  
ls_return = message.stringparm  
return integer(ls_return)
end function

global function integer f_messagebox (string as_title, string as_text, string as_option1);string ls_return,ls_parm  
ls_parm = as_title+','+as_text+','+as_option1+','
openwithparm(w_MessageBox,ls_parm)  
ls_return = message.stringparm  
return integer(ls_return)
end function

on sistemaescola.create
appname="sistemaescola"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on sistemaescola.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;// Dados de Conexão
SQLCA.DBMS = "MSOLEDBSQL SQL Server"
SQLCA.LogPass = 'admin123'
SQLCA.ServerName = "DESKTOP-3BSDQN9\MSSQLSERVER2"
SQLCA.LogId = "sa"
SQLCA.AutoCommit = False
SQLCA.DBParm = "Database='TrabalhoFinal'"


// Efetua a Conexão
CONNECT USING SQLCA;

// Verifica o Erro de Conexão
IF SQLCA.SQLCode < 0 THEN 
	MessageBox("Erro de Conexão", SQLCA.SQLErrText,Exclamation!)
ELSE
	//MessageBox("Conectado", "Conectado com Sucesso!",Exclamation!)
END IF

//Abre a Janela Principal da Aplicação
open (w_login)
	

end event

event close;// Desconexão com o Banco
DISCONNECT USING SQLCA;

IF SQLCA.SQLCode < 0 THEN
	MessageBox("Erro ao Desconectar", SQLCA.SQLErrText,Exclamation!)
ELSE
	//MessageBox("Desconectado", "Desconectado com Sucesso!",Exclamation!)
END IF
end event

