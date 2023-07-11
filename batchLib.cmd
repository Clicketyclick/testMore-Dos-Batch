::ECHO OFF
::SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
::**********************************************************************
SET $NAME=batchLib.cmd
SET $DESCRIPTION=DOS Batch library framework
SET $AUTHOR=Erik Bachmann, ClicketyClick.dk [ErikBachmann@ClicketyClick.dk]
SET $SOURCE=%~f0
:testMore
:: NAME
::@(-)  The name of the command or function, followed by a one-line description of what it does.
::       testMore.cmd -- DOS Batch implementation of Perl's Test::More test framework
::  
:: SYNOPSIS
::@(-)  In the case of a command, a formal description of how to run it and what command line options it takes. 
::@(-)  For program functions, a list of the parameters the function takes and which header file contains its definition.
::@(-)  
::       testMore.cmd [Options]
::       testMore.cmd [Function]
::  
:: OPTIONS
::@(-)  Flags, parameters, arguments (NOT the Monty Python way)
::   -h      Help page
::   --help  Help page
::  
:: DESCRIPTION
::@(-)  A textual description of the functioning of the command or function.
::  The purpose of this module is to provide a wide range of testing utilities.
::  Various ways to say "ok" with better diagnostics, facilities to skip tests,
::  test future features and compare complicated data structures. 
::  While you can do almost anything with a simple :ok function, 
::  it doesn't provide good diagnostic output.
::
:: TESTS  
::  :plan No_of_tests - Declare the entended no of tests to run
::  :done_testing - The result of all your testing according to plan
::  :ok ERRORLEVEL $test_name - Evaluate a TRUE expression
::  :like $got "/expected/i"  $test_name - Similar to :ok using regex
::  :is $got $expected $test_name - Compare arguments with eq
::  :isnt $got $expected $test_name - Compare arguments with ne
::  :unlike $got qr/expected/ $test_name - Check match with regex
::  :cmp_ok( $got, $op, $expected, $test_name );
::  :pass $test_name - Just pass and forget
::  :fail $test_name - Just fail and go on
::  :skip - declares a block of tests
::  :TODO - Declares a block of tests you expect to fail and $why.
::  :BAIL_OUT $reason - Bail out and stop all processing
::  :diag - Print diagnostic message
::  :note - Print a note
::  :explain - Will dump in a human readable format
::  :harness diag func args... - Test harness to handle valid failures
::
:: Not implemented
::  :isa_ok $object   $class $object_name - NOT implemented
::  :isa_ok $subclass $class $object_name - NOT implemented
::  :isa_ok $ref      $type  $ref_name - NOT implemented
::  :isa_ok on that object.
::  :subtest $name => \&code, @args; - NOT implemented
::  :subtest runs the &code as its own little test with its own plan and its
::  :require_ok - Cannot be implemented, since BATCH has no include function
::  :use_ok - Cannot be implemented, since BATCH has no include function
::  :is_deeply - Cannot be implemented, since BATCH has no structure functions.
::
:: General functions
::  :skiplastarg returnvar args ...
::  :lastarg returnvar args ...
::  :strLen - returns the length of a string
::  :extractFileSection - extracts a section of file that is defined by a start and end mark
::
::  Functions with prefix  ":_" are all for internal use only = not addressable
::  
:: EXAMPLES
::@(-)  Some examples of common usage.
::  
::   CALL testMore :plan 2
::   CALL testMore          :ok 0 "	[OK    ]	ok:Test 0"
::   CALL testMore :harness :ok 1 "	[OK/fail]	ok:Test 1"
::   CALL testMore :done_testing
::  
::  First test has an Errorlevel of 0 (= OK)
::  First test has an Errorlevel of 1 (= Error), but this is expected and valid.
::  The harness ensures that the result is OK since the "Failure" is valid
::  
::  Please see unitTest.testMore.cmd for a more extended example
::  
:: EXIT STATUS
::@(-)  Exit status / errorlevel is 0 if OK, otherwise 1+.
:: 
:: ENVIRONMENT
::@(-)  Variables affected
:: 
:: 
:: FILES, 
::@(-)  Files used, required, affected
:: 
:: 
:: BUGS / KNOWN PROBLEMS
::@(-)  If any known
:: 
:: 
:: REQUIRES
::@(-)  Dependecies
::  testMore.cmd
::  
:: SEE ALSO
::@(-)  A list of related commands or functions.
::   
::   
:: REFERENCE
::@(-)  References to inspiration, clips and other documentation
::   Author: 
::   URL: https://metacpan.org/pod/Test::More
::   URL: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes
::   URL: https://en.wikipedia.org/wiki/Test::More
::  
:: 
:: SOURCE
::@(-)  Where to find
::
:: Author       Erik Bachmann, ClicketyClick.dk [ErikBachmann@ClicketyClick.dk]
:: Copyright    http://www.gnu.org/licenses/lgpl.txt LGPL version 3
:: Since        2022-01-21T20:54:11 / erba
:: Version      01.03
:: Release      2023-05-08T20:51:26
::<<testMore

:run
    ::%_DEBUG_% Call subfunction [%~1]
    SET $sub=%~1
    IF "-" == "%$SUB:~0,1%" (   :: Flags
        IF /I "-h" == "%$SUB:~0,2%" (
            CALL :_usage %2
        )
        IF /I "--help" == "%$SUB:~0,6%" (
            CALL :_usage %2
        )
    ) ELSE IF ":_" == "%$SUB:~0,2%" (
        1>&2 ECHO:ERROR - Calling internal sub function in %0 [%~1]
        EXIT /b 255
    ) ELSE (
        CALL %*
    )
GOTO :EOF

::----------------------------------------------------------------------

:usage
    SET _f=%~1

    IF DEFINED _f (
        CALL :extractFileSection "%_f%" "::<<%_f%" "%~f0"  2>&1
    ) ELSE (
        CALL :extractFileSection ":testMore" "::<<testMore" "%~f0" 2>&1
    )

GOTO :EOF

::----------------------------------------------------------------------


:Header - Header in block
	SET ERRORLEVEL=0
	SET /A $testMore_started+=1
    SETLOCAL
    SET LEN=30
    ::ECHO:
	SET TITLE=%$testMore_started%/%$testMore_plan% %* [HEADER]
	%_DEBUG_% TITLE=%$testMore_started%/%$testMore_plan% %* [HEADER]

	:: Parsing "Fn - desc". 
::    FOR /F "delims=- tokens=1*" %%a IN ( "%~1" ) DO (
::        SET TAG=%%a                                                    .
::		:: Send fn to STDERR
::        SET /P=- !tag:~0,%len%!<nul 1>&2
::		:: Send desc to STDOUT
::        ECHO desc[%%b %~2] 2>&1
::    )
::	TITLE !TITLE!
	::%_VERBOSE_% [%~2] 2>&1
    TITLE %TITLE%
    %_DEBUG_% TITLE %TITLE%
	ECHO:TITLE %TITLE%
    ENDLOCAL
GOTO:EOF    :: :Header 

::----------------------------------------------------------------------

:Footer - Footer in block (0=OK, ELSE=FAIL)
    TITLE %$testMore_done%/%$testMore_plan% %* [Footer]
    %_DEBUG_% TITLE %$testMore_done%/%$testMore_plan% %* [Footer]
    ECHO TITLE %$testMore_done%/%$testMore_plan% %* [Footer]
	
    SETLOCAL
		%_DEBUG_% %%ERRORLEVEL%%=%ERRORLEVEL%

		IF ERRORLEVEL 1 (
			%_DEBUG_% ERRORLEVEL=1+
		) ELSE (
			%_DEBUG_% ERRORLEVEL=1+
		)
        SET _=%$testMore_done%/%$testMore_plan%
        IF DEFINED DEBUG SET _= %~1
    
        IF ".0" EQU ".%~1" (
            ECHO [OK   %_%] [%~2 - %~3%~4] 1>&2
        ) ELSE IF ".-1" EQU ".%~1" (
            ECHO [SKIP %_%] [%~2 - %~3%~4] 1>&2
        ) ELSE (
            ECHO [FAIL %_%] [%~1] [%~2 - %~3%~4] 1>&2
        )
    ENDLOCAL
GOTO :EOF   :: :Footer

::----------------------------------------------------------------------

:: Simple wrapper that executes :Header before and :Footer after test
:test_wrapper
	CALL %$batchLib% :Header %*
    :: Delete TMP dump files
    FOR %%i IN ( expected.txt got.txt ) DO IF EXIST %%i DEL %%i
    
	CALL %$TESTLIB% %*
	CALL %$batchLib% :Footer %ErrorLevel% %*
GOTO :EOF	:: :test_wrapper

::----------------------------------------------------------------------

:testMore_init
    :: DEBUG
    SET _DEBUG_=^>NUL ECHO:
    IF DEFINED DEBUG SET _DEBUG_=^>^&2 ECHO:[DEBUG] 
    ::SET _DEBUG_=IF DEFINED DEBUG IF NOT "0"=="%DEBUG%" 2^>^&1 ECHO:[%%0]: 

    :: VERBOSE
    SET _VERBOSE_=^>NUL ECHO:
    IF DEFINED VERBOSE SET _VERBOSE_=^>^&2 ECHO:

    :: callTestWrapper
    SET callTestWrapper=CALL %$batchLib% :test_wrapper
GOTO :EOF	:: :init

::----------------------------------------------------------------------

:testMore_main
	:: IF argument test specific
	IF NOT "." == ".%~1" (
		::CALL %$TestMore% :plan 1
		ECHO Test one specific function>&2
		SET $testMore_plan=1
		CALL %$TestMore% :plan 1
        
		CALL %*
		GOTO :EOF
	)

	:: Testing all
	ECHO:Testing %$LIB%>&2
	ECHO:Testing all functions>&2

	:: Count no of tests
	CALL %$TestMore% :plan_testmore %$TESTLIB% $testMore_plan
	%_DEBUG_% $testMore_plan=%$testMore_plan%

	:: Set no of test
	CALL %$TestMore% :plan %$testMore_plan%
	%_DEBUG_% PLAN:%$testMore_plan%

	:: Call all tests
	%_DEBUG_% CALL %$TESTLIB% :callAllTests
	CALL %$TESTLIB% :callAllTests

	:: Show status
	%_DEBUG_% $testMore_plan=%$testMore_plan%
	CALL %$TestMore% :done_testing
GOTO :EOF


:: No unit tests for this section - yet!

:: NOTE! ERRORLEVEL is NOT %ERRORLEVEL% 
:: https://devblogs.microsoft.com/oldnewthing/20080926-00/?p=20743
:isDefined VAR
    IF DEFINED %1 SET ERRORLEVEL=0 & EXIT /b 0 
    SET ERRORLEVEL=1 & EXIT /b 1
GOTO :EOF

::----------------------------------------------------------------------


::*** End of File ******************************************************