$PBExportHeader$uo_usuario.sru
$PBExportComments$Objeto para controle de usuários
forward
global type uo_usuario from nonvisualobject
end type
end forward

global type uo_usuario from nonvisualobject
end type
global uo_usuario uo_usuario

forward prototypes
public function boolean wf_verifica_usuario_logado (string p_email, string p_senha)
public function boolean of_valida_email (string p_email)
public function string of_recupera_senha (string p_email)
public function boolean of_verifica_acesso_usuario_logado (string p_email)
end prototypes

public function boolean wf_verifica_usuario_logado (string p_email, string p_senha);//------------------------------------------------------------
//	Função para verificar se o login fornecido existe
//
// Retorno: True -> Dados Corretos
//				False -> Dados incorretos
//
//------------------------------------------------------------

integer vli_Count, vii_Opcao
String vls_Email, vls_Senha
boolean vlb_Logado = False

//Declaração do Cursor
DECLARE c_acesso CURSOR FOR 
 SELECT email, Senha
   FROM usuarios;

//Abre o Cursor
OPEN c_acesso;

DO WHILE sqlca.SQLCODE = 0
	
	FETCH c_acesso INTO :vls_Email, :vls_Senha;
	
	// Usuário e Senha OK
	If p_email = vls_Email and p_senha = vls_Senha Then
		vlb_Logado = True
		//Sai do Loop já que foi encontrado o usuário no banco
		EXIT
	End If

LOOP

//Fecha o Cursor
CLOSE c_acesso;

// Usuário e Senha OK
If vlb_Logado Then
	vgs_Email = vls_Email
	return True
Else  
 	vii_Opcao = f_messageBox('Atenção!','Usuário / Senha incorretos ou não informados!~r~rDeseja Retornar?','SIM','')  
	return False
End if


return False
end function

public function boolean of_valida_email (string p_email);//====================================================================
// Function: f_isvalidemail()
//--------------------------------------------------------------------
// Description: Check Invalid Email
//--------------------------------------------------------------------
// Arguments:
// 	value	string	p_email	: Email Address
//--------------------------------------------------------------------
// Returns:  boolean True Valid Email, False  InValid Email 
//====================================================================
 
 
Boolean lb_return = True
String ls_domaintype
String ls_domainname
Integer i
 
Constant String ls_invalidchars = "!#$%^&*()=+{}[]|\;:'/?>,< "
 
// if there double quote character  
If Pos(p_email, Char(34)) > 0 Then lb_return = False
If Left(p_email,1) = "." Or Right(p_email,1) = "." Then lb_return = False
 
If lb_return Then
	// check for invalid characters.  
	If Len(p_email) > Len(ls_invalidchars) Then
		For i = 1 To Len(ls_invalidchars)
			If Pos(p_email, Mid(ls_invalidchars, i, 1)) > 0 Then
				lb_return = False
				Exit
			End If
		Next
	Else
		For i = 1 To Len(p_email)
			If Pos(ls_invalidchars, Mid(p_email, i, 1)) > 0 Then
				lb_return = False
				Exit
			End If
		Next
	End If
	
	If lb_return Then
		//check for an @ symbol  
		If Pos(p_email, "@") > 1 Then
			//lb_return = f_if(Len(Left(p_email, Pos(p_email, "@", 1) - 1)) > 0,True,False)
			If Len(Left(p_email, Pos(p_email, "@", 1) - 1)) > 0 Then
				lb_return = True
			Else
				lb_return = False
			End If
		Else
			lb_return = False
		End If
		
		If lb_return Then
			//check to see if there are too many @'s  
			p_email = Right(p_email, Len(p_email) - Pos(p_email, "@"))
			//lb_return = f_if(Pos(p_email, "@") > 0, False, True)
			If Pos(p_email, "@") > 0 Then
				lb_return = False
			Else
				lb_return = True
			End If
			
			If lb_return Then
				ls_domaintype = Right(p_email, Len(p_email) - Pos(p_email, "."))
				//lb_return = f_if(Len(ls_domaintype) > 0 And Pos(p_email, ".") < Len(p_email), True, False)
				If Len(ls_domaintype) > 0 And Pos(p_email, ".") < Len(p_email) Then
					lb_return = True
				Else
					lb_return = False
				End If
				
				If lb_return Then
					p_email = Left(p_email, Len(p_email) - Len(ls_domaintype) - 1)
					Do Until Pos(p_email, ".") <= 1
						If Len(p_email) >= Pos(p_email, ".") Then
							p_email = Left(p_email, Len(p_email) - (Pos(p_email, ".") - 1))
						Else
							lb_return = False
							Exit
						End If
					Loop
					If lb_return Then
						If p_email = "." Or Len(p_email) = 0 Then lb_return = False
					End If
				End If
			End If
		End If
	End If
End If
 
Return lb_return
end function

public function string of_recupera_senha (string p_email);String vls_Senha

SELECT Senha
  INTO :vls_Senha
FROM USUARIOS
WHERE email = :p_email;

return vls_Senha
end function

public function boolean of_verifica_acesso_usuario_logado (string p_email);
SELECT ID_USUARIO,
		 NOME, 
       TIPO_USUARIO,
		 DTA_NASCIMENTO,
		 DTA_REGISTRO
  INTO :vgs_id_usuario, :vgs_Nome, :vgs_TipoAcesso, :vgs_Dta_Nascimento, :vgs_dta_Registro
FROM USUARIOS
WHERE email = :p_email;


return true
end function

on uo_usuario.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_usuario.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

