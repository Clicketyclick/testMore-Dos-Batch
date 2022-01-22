@ECHO OFF&
SETLOCAL EnableDelayedExpansion

CALL testMore :note %~n0 - Unit Test for testMore.cmd - test framework

:: Tests are named as [UnitOfWork_StateUnderTest_ExpectedBehavior]

:: Set debugging: On if defined
::SET DEBUG=
::SET DEBUG=1

:: Write header
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

CALL testMore :note --- DONE
CALL testMore :done_testing
CALL testMore :note Entended to fail	2, 4, 5, 8, 10, 11, 13, 15
CALL testMore :note Handled by :harness
CALL testMore :note *1) Note that FINDSTR does NOT handle regex very well.

:: Will exit after en short warning
::CALL testMore :BAIL_OUT "Out of air - Bailing out and exit"

CALL testMore :note Done [%0]

::*** End of File ***
