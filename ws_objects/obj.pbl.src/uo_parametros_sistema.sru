$PBExportHeader$uo_parametros_sistema.sru
$PBExportComments$Parametros do Sistema
forward
global type uo_parametros_sistema from nonvisualobject
end type
end forward

global type uo_parametros_sistema from nonvisualobject
end type
global uo_parametros_sistema uo_parametros_sistema

type variables
String vis_NomeSis, vis_AssinaturaDir, vis_CEP, vis_Endereco, vis_Cidade, vis_Estado
Integer vis_IdadeMinCur
end variables
forward prototypes
public function boolean of_recupera_parametro (integer p_id)
end prototypes

public function boolean of_recupera_parametro (integer p_id);

SELECT PARAMETROS_SISTEMA.nome_sistema,
		   PARAMETROS_SISTEMA.idade_minima_curso,
		   PARAMETROS_SISTEMA.Assinatura_Diretor,
		   PARAMETROS_SISTEMA.CEP,
		   PARAMETROS_SISTEMA.Endereco,
		   PARAMETROS_SISTEMA.Cidade,
		   PARAMETROS_SISTEMA.Estado
   INTO :vis_NomeSis, :vis_IdadeMinCur, :vis_AssinaturaDir, :vis_CEP, :vis_Endereco, :vis_Cidade, :vis_Estado
FROM  PARAMETROS_SISTEMA
WHERE PARAMETROS_SISTEMA.ID = :p_id;

 
return true
end function

on uo_parametros_sistema.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_parametros_sistema.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

