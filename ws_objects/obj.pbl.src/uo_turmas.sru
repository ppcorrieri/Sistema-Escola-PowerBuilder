$PBExportHeader$uo_turmas.sru
$PBExportComments$Objeto para controle de Turmas
forward
global type uo_turmas from nonvisualobject
end type
end forward

global type uo_turmas from nonvisualobject
end type
global uo_turmas uo_turmas

type variables
Integer vli_UltimoIdTurma
String vis_DiaDaSemana, vis_HoraInicio, vis_HoraFim
end variables
forward prototypes
public function integer of_ultima_turma ()
public function string of_verifica_disponibilidade_horario (integer p_id_dia, integer p_id_horario)
public function boolean of_insere (string p_nome_turma, integer p_id_instrutor, integer p_id_curso, date p_data_inicio, date p_data_final, integer p_carga_horaria, integer p_dia_aula, integer p_horario_aula, integer p_proxima_turma)
public function boolean of_verifica_dia_aula (integer p_id_turma)
end prototypes

public function integer of_ultima_turma ();//Retorna o ID da última turma cadastrada

SELECT MAX(turmas.id)
  INTO :vli_UltimoIdTurma
  FROM turmas
 USING SQLCA;
  
IF SQLCA.SQLCODE < 0 THEN
	f_messageBox('Atenção', 'Ocorreu um erro ao realizar verificação na Turma~r~rDeseja Retornar?', 'SIM', '')
	return -1
END IF

RETURN 1
end function

public function string of_verifica_disponibilidade_horario (integer p_id_dia, integer p_id_horario);Integer vli_Count
String vls_Dia, vls_Horario, vls_Dia_Hora

SELECT COUNT(*)
 INTO: vli_Count
FROM turmas AS t,
     turma_horarios AS th,
     horarios_aulas AS ha,
     dias_semana AS ds
WHERE t.id = th.id_turma
  AND th.id_horario = ha.id_horario
  AND th.id_dia_semana = ds.id_dia_semana
  AND ds.id_dia_semana = :p_id_dia
  AND ha.id_horario = :p_id_horario
USING SQLCA;

//Trata Erro
if SQLCA.SQLCode < 0 Then
	f_MessageBox('Atenção', 'Ocorreu um erro ao verificar a disponibilidade de Dia/Horário~r~rTente novamente!~rDeseja Retornar?', 'SIM', '')
else
	if vli_Count > 0 Then
		
		SELECT dias_semana.dia_semana, CONCAT(horario_inicio, 'h às ', horario_fim, 'h') AS HORARIO
		  INTO :vls_Dia, :vls_Horario
		  FROM dias_semana, horarios_aulas
		 WHERE dias_semana.id_dia_semana = :p_id_dia
  			AND horarios_aulas.id_horario = :p_id_horario
		 USING SQLCA;
		 
		if SQLCA.SQLCode < 0 Then
			f_MessageBox('Atenção', 'Ocorreu um erro ao verificar o Dia/Horário~r~rTente novamente!~rDeseja Retornar?', 'SIM', '')
		end if
		 
		vls_Dia_Hora = vls_Dia + " de " + vls_Horario
		
		return vls_Dia_Hora 
	else
		return ''
	end if
End if
end function

public function boolean of_insere (string p_nome_turma, integer p_id_instrutor, integer p_id_curso, date p_data_inicio, date p_data_final, integer p_carga_horaria, integer p_dia_aula, integer p_horario_aula, integer p_proxima_turma);integer vll_IdTurma
ROLLBACK USING SQLCA;

//INSERT TURMAS
INSERT INTO turmas (nome_turma, instrutores_id, cursos_id, data_inicio, data_final, carga_horaria)
VALUES (:p_nome_turma, :p_id_instrutor, :p_id_curso, :p_data_inicio, :p_data_final, :p_carga_horaria)
USING SQLCA;

IF SQLCA.SQLCODE = 0 THEN

	// INSERT TURMAS_HORARIOS
	INSERT INTO turma_horarios (id_turma, id_dia_semana, id_horario)
	VALUES (:p_proxima_turma, :p_dia_aula, :p_horario_aula)
	USING SQLCA;

	IF NOT SQLCA.SQLCODE = 0 THEN
		RETURN FALSE;
	END IF
ELSE
	RETURN FALSE;
END IF;

RETURN TRUE;
end function

public function boolean of_verifica_dia_aula (integer p_id_turma);integer vli_DiaDaSemana

// Função: of_verifica_dia_aula
// Descrição: Verifica se está no dia e horário da turma para permitir a marcação de presença dos alunos matriculados.
// Parâmetros:
// - p_id_turma: O ID da turma a ser verificada.
// Retorno: Booleano indicando se é permitido marcar presença (true) ou não (false).

SELECT dias_semana.dia_semana, 
		 horarios_aulas.horario_inicio, 
		 horarios_aulas.horario_fim
  INTO :vis_DiaDaSemana, 
  	    :vis_HoraInicio, 
		 :vis_HoraFim
  FROM turma_horarios
  JOIN dias_semana ON turma_horarios.id_dia_semana = dias_semana.id_dia_semana
  JOIN horarios_aulas ON turma_horarios.id_horario = horarios_aulas.id_horario
 WHERE turma_horarios.id_turma = :p_id_turma;

CHOOSE CASE vis_DiaDaSemana
	CASE 'Domingo'
		vli_DiaDaSemana = 1
	CASE 'Segunda-feira'
		vli_DiaDaSemana = 2
	CASE 'Terça-feira'
		vli_DiaDaSemana = 3
	CASE 'Quarta-feira'
		vli_DiaDaSemana = 4
	CASE 'Quinta-feira'
		vli_DiaDaSemana = 5
	CASE 'Sexta-feira' 
		vli_DiaDaSemana = 6
	CASE 'Sábado'
		vli_DiaDaSemana = 2
END CHOOSE

//Compara o dia de hoje com o dia do curso da turma
IF vli_DiaDaSemana <> dayNumber(Today()) THEN
	return FALSE
ELSE
	//Verifica se a hora atual está dentro do intervalo das horas do curso
	IF string(now(), "hh:mm") < vis_HoraInicio OR string(now(), "hh:mm") > vis_HoraFim THEN
		return FALSE
	END IF
END IF

return TRUE
end function

on uo_turmas.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_turmas.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

