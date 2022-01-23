@ECHO OFF&
SETLOCAL EnableDelayedExpansion
:testMore
:: NAME
::@(-)  The name of the command or function, followed by a one-line description of what it does.
::       unitTest.testMore.cmd -- Unit Test for testMore.cmd - test framework
::  
:: SYNOPSIS
::@(-)  In the case of a command, a formal description of how to run it and what command line options it takes. 
::@(-)  For program functions, a list of the parameters the function takes and which header file contains its definition.
::@(-)  
::       unitTest.testMore.cmd [Options]
::       unitTest.testMore.cmd [Function]
::  
:: OPTIONS
::@(-)  Flags, parameters, arguments (NOT the Monty Python way)
::   -h      Help page
::   --help  Help page
::  
:: DESCRIPTION
::@(-)  A textual description of the functioning of the command or function.
:: Unit Test for testMore.cmd - test framework
::@(-):: Tests are named as [UnitOfWork_StateUnderTest_ExpectedBehavior]
::
:: TESTS  
:: - :OK
:: - :IS
:: - :ISNT
:: - :LIKE
:: - :PASS / :FAIL
::
:: FILES
::@(-)  Files used, required, affected
::  file1 = Base file for comparing
::  file2 = Identical copy
::  file3 = Diverting file
:: 
:: BUGS / KNOWN PROBLEMS
::@(-)  If any known
:: 
:: REQUIRES
::@(-)  Dependecies
::  testMore.cmd
::  
:: SEE ALSO
::@(-)  A list of related commands or functions.
::   
:: REFERENCES
::@(-)  References to inspiration, clips and other documentation
::   Author: 
::   URL: https://metacpan.org/pod/Test::More
::   URL: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes
::   URL: https://en.wikipedia.org/wiki/Test::More
:: 
:: SOURCE
::@(-)  Where to find
::
:: Author       Erik Bachmann, ClicketyClick.dk [ErikBachmann@ClicketyClick.dk]
:: Copyright    http://www.gnu.org/licenses/lgpl.txt LGPL version 3
:: Since        2022-01-21T20:54:11 / erba
:: Version      01.03
:: Release      2022-01-23T21:25:41
::<<testMore

:run
    SET $sub=%~1
    IF NOT DEFINED $sub GOTO:main
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
        ::CALL %*
        GOTO:main
    )
GOTO :EOF

::----------------------------------------------------------------------

:_usage
    SET _f=%~1

    IF DEFINED _f (
        ::CALL testMore :extractFileSection "%_f%" "::<<%_f%" "%~f0" 2>&1
        CALL :extractFileSection "%_f%" "::<<%_f%" "%~f0" 2>&1
    ) ELSE (
        ::CALL testMore :extractFileSection ":testMore" "::<<testMore" "%~f0" 2>&1
        CALL :extractFileSection ":testMore" "::<<testMore" "%~f0" 2>&1
    )
GOTO :EOF

::----------------------------------------------------------------------

:main

    :: Set debugging: On if defined
    ::SET DEBUG=
    ::SET DEBUG=1

    :: Write header
    CALL testMore :note %~n0 - Testing: testMore
    CALL testMore :note Test :ok DeBUG=%DEBUG%
    CALL testMore :note 
    CALL testMore :note *** Please note that the expected result is given in []
    CALL testMore :note So a result like: "OK  [99] - [OK/fail]" 
    CALL testMore :note is actually a valid and expected result of a test failing on purpos
    CALL testMore :note 

:init - Initiating variables

    :: file1 = Base file for comparing
     >file1 ECHO:Hello world
    >>file1 ECHO:Hello World

    :: file2=Identical copy
     >nul COPY file1 file2 

    :: file3=Diverting file
     >file3 ECHO:Hello world
    >>file3 ECHO:Hello my world

    IF DEFINED DEBUG (
        ECHO:Starts testing
    )

:plan
    CALL testMore :plan 15

    IF DEFINED DEBUG (  :: Write header for columns
        ECHO:          ----------------- Run no
        ECHO:         /         -------- Expected status
        ECHO:         ^|        /     +-- Test message
        ECHO:        vv     vvvvvv   vv
    )

::---------------------------------------------------------------------

:tests
:: OK
    CALL testMore :note --- OK
    CALL testMore :note :: Testing on ErrorLevel or logical values
    CALL testMore :ok   0   "	[OK     ]	ok:Test 0"
    CALL testMore :harness :ok   1   "	[OK/fail]	ok:Test 1"

:: IS
    CALL testMore :note --- IS
    CALL testMore :note :: Testing on files
    CALL testMore :is  file1 file2 "	[OK     ]	is:Test equal 1 EQU 2"
    CALL testMore :harness :is  file1 file3 "	[OK/fail]	is:Test equal 1 NEQ 3"

:: ISNT
    CALL testMore :note --- ISNT
    CALL testMore :harness :isnt file1 file2 "	[OK/fail]	isnt:Test equal 1 NEQ 2"
    CALL testMore :isnt file1 file3 "	[OK     ]	isnt:Test equal 1 EQU 3"

:: LIKE
    CALL testMore :note --- like
    CALL testMore :like "/Hello.world/"     "file1" "	[OK     ]	like: /Hello.world/"
    CALL testMore :harness :like "/Hello.World/"     "file3" "	[OK/fail]	like: /Hello.World/"

    CALL testMore :like "/Hello.World/i"    "file3" "	[OK     ]	like: /Hello.World/i"
    CALL testMore :harness :like "/Hello[ ]world/"   "file1" "	[OK/fail]*1	like: /Hello[ ]world/"
    CALL testMore :harness :like "/Hello\sworld/"    "file1" "	[OK/fail]*1	like: /Hello\sworld/"
    CALL testMore :like "/Hello.my.world/"  "file3" "	[OK     ]	like: /Hello.my.world/"
    CALL testMore :harness :like "/Hello.My.world/"  "file3" "	[OK/fail]	like: /Hello.My.world/"

::PASS / FAIL
    CALL testMore :note --- pass / fail
    CALL testMore :pass "	[OK     ]	pass:Test 0"
    CALL testMore :harness :fail "	[OK/fail]	fail:Test 1"

:done
    CALL testMore :note --- DONE
    CALL testMore :done_testing
    CALL testMore :note Entended to fail	2, 4, 5, 8, 10, 11, 13, 15
    CALL testMore :note Handled by :harness
    CALL testMore :note *1) Note that FINDSTR does NOT handle regex very well.

    :: Will exit after en short warning
    ::CALL testMore :BAIL_OUT "Out of air - Bailing out and exit"

    CALL testMore :note Done [%0]

GOTO:EOF

::----------------------------------------------------------------------

:extractFileSection
:: :extractFileSection - extracts a section of file that is defined by a start and end mark
::Description:	call:extractFileSection StartMark EndMark FileName
::Syntax:	:extractFileSection StartMark EndMark FileName
:: -- extracts a section of file that is defined by a start and end mark
::                  -- [IN]     StartMark - start mark, use '...:S' mark to allow variable substitution
::                  -- [IN,OPT] EndMark   - optional end mark, default is first empty line
::                  -- [IN,OPT] FileName  - optional source file, default is THIS file
::$created=20080219
::$changed=20100205
::$categories=FileOperation
::$source=https://www.dostips.com
::$VERSION=2010-02-05
::<<extractFileSection
SETLOCAL Disabledelayedexpansion
set "bmk=%~1"
set "emk=%~2"
set "src=%~3"
set "bExtr="
set "bSubs="
if "%src%"=="" set src=%~f0&        rem if no source file then assume THIS file
for /f "tokens=1,* delims=]" %%A in ('find /n /v "" "%src%" ^| find /v "::@(-)"') do (
::for /f "tokens=1,* delims=]" %%A in ('find /n /v "" "%src%"') do (
    if /i "%%B"=="%emk%" set "bExtr="&set "bSubs="
    if defined bExtr if defined bSubs (call echo.%%B) ELSE (echo.%%B) 
    if /i "%%B"=="%bmk%"   set "bExtr=Y"
    if /i "%%B"=="%bmk%:S" set "bExtr=Y"&set "bSubs=Y"
)
EXIT /b

::*** End of File ******************************************************
