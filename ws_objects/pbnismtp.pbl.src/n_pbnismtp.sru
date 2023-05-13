$PBExportHeader$n_pbnismtp.sru
forward
global type n_pbnismtp from n_cpp_smtp
end type
end forward

global type n_pbnismtp from n_cpp_smtp autoinstantiate
end type

type variables
// Authentication Method
Constant Integer AUTH_NONE = 0
Constant Integer AUTH_CRAM_MD5 = 1
Constant Integer AUTH_LOGIN = 2
Constant Integer AUTH_PLAIN = 3
Constant Integer AUTH_NTLM = 4
Constant Integer AUTH_AUTO = 5
Constant Integer AUTH_XOAUTH2 = 6

// Connection Type
Constant Integer PlainText = 0
Constant Integer SSL_TLS = 1
Constant Integer STARTTLS = 2
Constant Integer AutoUpgradeToSTARTTLS = 3

// Priority
Constant Integer NoPriority = 0
Constant Integer LowPriority = 1
Constant Integer NormalPriority = 2
Constant Integer HighPriority = 3

// Character Set Values (default = iso-8859-1)
//
// windows-1256	Arabic (Windows)
// windows-1257	Baltic (Windows)
// iso-8859-2		Central European (ISO)
// windows-1250	Central European (Windows)
// gb2312			Chinese Simplified (GB2312)
// hz-gb-2312		Chinese Simplified (HZ)
// big5				Chinese Traditional (Big5)
// koi8-r			Cyrilic (KOI8-R)
// windows-1251	Cyrillic (Windows)
// windows-1253	Greek (Windows)
// windows-1255	Hebrew (Windows)
// iso-2022-jp		Japanese (JIS)
// ks_c_5601		Korean
// euc-kr			Korean (EUC)
// iso-8859-15		Latin 9 (ISO)
// windows-874		Thai (Windows)
// windows-1254	Turkish (Windows)
// utf-7				Unicode (UTF-7)
// utf-8				Unicode (UTF-8)
// windows-1258	Vietnamese (Windows)
// iso-8859-1		Western European (ISO)
// windows-1252	Western European (Windows)

end variables

forward prototypes
public function string emailname (string as_email, string as_name)
public function long parse (readonly string as_string, readonly string as_separator, ref string as_outarray[])
public function boolean validemail (string as_email, ref string as_errormsg)
public subroutine addtostring (ref string as_outputstring, string as_newstring)
end prototypes

public function string emailname (string as_email, string as_name);// -----------------------------------------------------------------------------
// SCRIPT:		EmailName
//
// PURPOSE:		This function combines email address and name in the
//					proper format.
//
// ARGUMENTS:  as_email	- The email address
//					as_name	- The name associated with the email address
//
//	RETURN:		String to pass to one of the email address functions
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 08/12/2017  RolandS		Initial creation
// -----------------------------------------------------------------------------

If Trim(as_name) = "" Then
	Return Trim(as_email)
Else
	Return '"' + Trim(as_name) + '"' + ' <' + Trim(as_email) + '>'
End If

end function

public function long parse (readonly string as_string, readonly string as_separator, ref string as_outarray[]);// -----------------------------------------------------------------------------
// SCRIPT:     Parse
//
// PURPOSE:    This function parses a string into an array.
//
// ARGUMENTS:  as_string		- The string to be separated
//					as_separator	- The separator characters
//					as_outarray		- By ref output array
//
//	RETURN:		The number of items in the array
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 08/12/2017  RolandS		Initial creation
// -----------------------------------------------------------------------------

Long ll_PosEnd, ll_PosStart = 1, ll_SeparatorLen, ll_Counter = 1

If UpperBound(as_OutArray) > 0 Then as_OutArray = {""}

ll_SeparatorLen = Len(as_Separator)

ll_PosEnd = Pos(as_String, as_Separator, 1)

Do While ll_PosEnd > 0
	as_OutArray[ll_Counter] = Mid(as_String, ll_PosStart, ll_PosEnd - ll_PosStart)
	ll_PosStart = ll_PosEnd + ll_SeparatorLen
	ll_PosEnd = Pos(as_String, as_Separator, ll_PosStart)
	ll_Counter++
Loop

as_OutArray[ll_Counter] = Right(as_String, Len(as_String) - ll_PosStart + 1)

Return ll_Counter

end function

public function boolean validemail (string as_email, ref string as_errormsg);// -----------------------------------------------------------------------------
// SCRIPT:     ValidEmail
//
// PURPOSE:    This function determines if the email address is valid syntax.
//
// ARGUMENTS:  as_email		- Email address to analyze
//					as_errormsg	- Error message describing the problem
//
// RETURN:     True = Valid syntax, False = Invalid Syntax
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/12/2017  RolandS		Initial creation
// -----------------------------------------------------------------------------

String ls_localpart, ls_domain, ls_domainpart[]
Integer li_pos, li_idx, li_max, li_asc

If Len(as_email) > 254 Then
	as_errormsg = "Email address cannot be more than 254 characters!"
	Return False
End If

li_pos = Pos(as_email, "@")
If li_pos < 2 Then
	as_errormsg = "Email address must have an @ character!"
	Return False
End If

If LastPos(as_email, "@") > Pos(as_email, "@") Then
	as_errormsg = "Email address cannot have more than one @ character!"
	Return False
End If

li_pos = Pos(as_email, " ")
If li_pos > 0 Then
	as_errormsg = "Email address cannot have any spaces!"
	Return False
End If

// split local & domain
li_pos = Pos(as_email, "@")
ls_localpart = Left(as_email, li_pos - 1)
ls_domain    = Mid(as_email, li_pos + 1)

If Len(ls_localpart) > 64 Then
	as_errormsg = "The mailbox part of the email address cannot be more than 64 characters!"
	Return False
End If

If Len(ls_domain) > 253 Then
	as_errormsg = "The domain part of the email address cannot be more than 253 characters!"
	Return False
End If

If Left(ls_localpart, 1) = "." Then
	as_errormsg = "The mailbox part of the email address cannot start with a period!"
	Return False
End If

If Right(ls_localpart, 1) = "." Then
	as_errormsg = "The mailbox part of the email address cannot end with a period!"
	Return False
End If

If Pos(ls_localpart, "..") > 0 Then
	as_errormsg = "The mailbox part of the email address cannot have more than one period in a row!"
	Return False
End If

// check local for allowed characters
li_max = Len(ls_localpart)
For li_idx = 1 To li_max
	li_asc = Asc(Mid(ls_localpart, li_idx, 1))
	choose case li_asc
		case 65 to 90
			// Lower case a-z
		case 97 to 122
			// Upper case A-Z
		case 48 to 57
			// Digits 0-9
		case 33, 35 to 39, 42, 43, 45, 47, 61, 63, 94 to 96, 123 to 126
			// Characters !#$%&'*+-/=?^_`{|}~
		case 46
			// Period
		case else
			as_errormsg = "The mailbox part of the email address contains invalid characters!"
			Return False
	end choose
Next

If Left(ls_domain, 1) = "." Then
	as_errormsg = "The domain part of the email address cannot start with a period!"
	Return False
End If

If Right(ls_domain, 1) = "." Then
	as_errormsg = "The domain part of the email address cannot end with a period!"
	Return False
End If

li_pos = Pos(ls_domain, ".")
If li_pos = 0 Then
	as_errormsg = "The domain part of the email address must have at least one period!"
	Return False
End If

// check domain for allowed characters
li_max = Len(ls_domain)
For li_idx = 1 To li_max
	li_asc = Asc(Mid(ls_domain, li_idx, 1))
	choose case li_asc
		case 65 to 90
			// Lower case a-z
		case 97 to 122
			// Upper case A-Z
		case 48 to 57
			// Digits 0-9
		case 45
			// Hyphen
		case 46
			// Period
		case else
			as_errormsg = "The domain part of the email address contains invalid characters!"
			Return False
	end choose
Next

// break domain into parts
li_max = Parse(ls_domain, ".", ls_domainpart)

If li_max > 127 Then
	as_errormsg = "The domain part of the email address contains too many periods!"
	Return False
End If

For li_idx = 1 To li_max
	If Left(ls_domainpart[li_idx], 1) = "-" Then
		as_errormsg = "The domain part of the email address cannot have a hyphen and a period next to one another!"
		Return False
	End If
	If Right(ls_domainpart[li_idx], 1) = "-" Then
		as_errormsg = "The domain part of the email address cannot have a hyphen and a period next to one another!"
		Return False
	End If
Next

Return True

end function

public subroutine addtostring (ref string as_outputstring, string as_newstring);// -----------------------------------------------------------------------------
// SCRIPT:		AddToString
//
// PURPOSE:		This function adds an item to a semi-colon separated string.
//
//					Valid attachment separators are comma and semicolon.
//
// ARGUMENTS:  as_outputstring	- The string to update
//					as_newstring		- The string to add to as_outputstring
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 08/12/2017  RolandS		Initial creation
// -----------------------------------------------------------------------------

If Len(as_outputstring) = 0 Then
	as_outputstring = Trim(as_newstring)
Else
	as_outputstring = as_outputstring + ";" + Trim(as_newstring)
End If

end subroutine

on n_pbnismtp.create
call super::create
end on

on n_pbnismtp.destroy
call super::destroy
end on

