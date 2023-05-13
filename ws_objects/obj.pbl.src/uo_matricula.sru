$PBExportHeader$uo_matricula.sru
$PBExportComments$Objeto para controle de matrículas
forward
global type uo_matricula from nonvisualobject
end type
end forward

global type uo_matricula from nonvisualobject
end type
global uo_matricula uo_matricula

type variables
String vis_NomeCurso, vis_NomeAluno, vis_Turma, vis_Cpf
Date vid_DataMatricula, vid_DataNascimento

end variables

forward prototypes
public function boolean of_existe_matricula_ativa_usuario (integer p_id_usuario)
public function boolean of_existe_matricula_turma (integer p_id_turmas)
public function boolean of_obtem_dados_matricula (integer p_id_usuario)
public function boolean of_desativa_matricula (integer p_id_usuario, string p_motivo, integer p_id_matricula)
end prototypes

public function boolean of_existe_matricula_ativa_usuario (integer p_id_usuario);//====================================================================
// Função: of_existe_matricula_ativa_usuario
//--------------------------------------------------------------------
// Descrição: Verifica se existe matrícula ativa de acordo com a 
//	data do término do curso para o usuario X
//--------------------------------------------------------------------
// Argumentos: integer -> :p_id_usuario
//--------------------------------------------------------------------
// Returns:  boolean | True -> Existe matrícula / False -> Não existe
//====================================================================

Integer vll_Count

SELECT count(*)
  INTO :vll_Count
  FROM matriculas, turmas
 WHERE matriculas.alunos_id = :p_id_usuario
   AND DATEADD(dd,DATEDIFF(dd,0,GETDATE()),0) <= turmas.data_final
   AND matriculas.turmas_id = turmas.id;

//if sqlca.SQLCODE < 0 Then
//	return
//end if

if vll_Count > 0 Then
	return True
else
	return false
end if
	
	
	
end function

public function boolean of_existe_matricula_turma (integer p_id_turmas);integer vliCount

select count(*)
into :vliCount
from matriculas, turmas
where DATEADD(dd,DATEDIFF(dd,0,GETDATE()),0) <= turmas.data_final
and matriculas.turmas_id = turmas.id
and matriculas.turmas_id = :p_id_turmas
and alunos_id is not null;


if (vliCount = 0 )Then
	return False
Else
	return True
end if
end function

public function boolean of_obtem_dados_matricula (integer p_id_usuario);//====================================================================
// Função: of_obtem_dados_matricula
//--------------------------------------------------------------------
// Descrição: Obtem todos os dados da tabela matrícula
//--------------------------------------------------------------------
// Argumentos: integer -> :p_id_usuario
//--------------------------------------------------------------------
// Returns:  boolean | True -> Existe matrícula / False -> Não existe
//====================================================================

 SELECT cursos.nome NOME_CURSO,
		  al.nome NOME_ALUNO,
		  CONCAT(turmas.id,' - ',turmas.nome_turma) ID_NOME_TURMA,
		  matriculas.data_matricula,
		  al.cpf,
		  al.dta_nascimento
	INTO :vis_NomeCurso, :vis_NomeAluno, :vis_Turma, :vid_DataMatricula, :vis_Cpf, :vid_DataNascimento
   FROM cursos, 
           instrutor, 
		  turmas, 
		  usuarios ins,
		  usuarios al,
		  matriculas,
		  alunos
  WHERE ins.id_usuario = instrutor.id_usuario
    AND cursos.id = turmas.cursos_id
    AND turmas.instrutores_id = instrutor.id_usuario
	 AND matriculas.turmas_id = turmas.id
	 AND al.id_usuario = alunos.id_usuario
    AND cursos.id = turmas.cursos_id
  	 AND matriculas.turmas_id = turmas.id
	 AND al.id_usuario = matriculas.alunos_id
	 AND al.id_usuario = :p_id_usuario;

//if sqlca.SQLCODE < 0 Then
//	return
//end if

return True
end function

public function boolean of_desativa_matricula (integer p_id_usuario, string p_motivo, integer p_id_matricula);//====================================================================
// Função: of_desativa_matricula
//--------------------------------------------------------------------
// Descrição: Exclui a matrícula e joga a mesma 
//  para uma tabela de exclusão
//--------------------------------------------------------------------
// Argumentos: integer -> :p_id_usuario
//--------------------------------------------------------------------
// Returns:  boolean | True -> Deletado / False -> Não deletado
//====================================================================

Integer vll_Count

DELETE FROM matriculas
 WHERE matriculas.alunos_id = :p_id_usuario
 	AND matriculas.id = :p_id_matricula;

if sqlca.SQLCODE < 0 Then
	return False
else
	UPDATE matriculas_finalizadas
		 SET matriculas_finalizadas.motivo = :p_motivo
	WHERE matriculas_finalizadas.alunos_id = :p_id_usuario
	    AND matriculas_finalizadas.id = :p_id_matricula;
	
	if sqlca.SQLCODE < 0 Then
		return False
	else
		return True //OK
	end if
end if

end function

on uo_matricula.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_matricula.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

