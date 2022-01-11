@ECHO OFF&
SETLOCAL EnableDelayedExpansion

::SET DEBUG=
::SET DEBUG=1
>&2 ECHO %~n0 - Testing: testMore
IF DEFINED DEBUG ECHO Test :ok DeBUG=%DEBUG%
>&2 ECHO:
:: 1=Base file
ECHO:Hello world>1
ECHO:Hello World>>1
:: 2=Identical copy
COPY 1 2 >nul
:: 3=Diverting file
ECHO:Hello world>3
ECHO:Hello my world>>3

IF DEFINED DEBUG (
    ECHO:Starts testing
)
CALL testMore :plan 6
CALL testMore :note --- IS
IF DEFINED DEBUG (
    ECHO:          ----------------- Run no
    ECHO:         /         -------- Expected status
    ECHO:         ^|        ^/     +-- Test message
    ECHO:        vv     vvvvvv   vv
)
CALL testMore :is   1 2 "[OK    ] is:Test equal 1 EQU 2"
CALL testMore :is   1 3 "[Not OK] is:Test equal 1 NEQ 3"
CALL testMore :note --- ISNT
CALL testMore :isnt 1 2 "[Not OK] isnt:Test equal 1 NEQ 2"
CALL testMore :isnt 1 3 "[OK    ] isnt:Test equal 1 EQU 3"
CALL testMore :note --- OK
CALL testMore :ok   0   "[OK    ] ok:Test 0"
CALL testMore :ok   1   "[Not OK] ok:Test 1"
CALL testMore :note --- like
CALL testMore :like "/Hello.world/"     "1" "[OK    ] like: /Hello.world/"
CALL testMore :like "/Hello.World/"     "3" "[Not OK] like: /Hello.World/"
CALL testMore :like "/Hello.World/i"    "3" "[OK    ] like: /Hello.World/i"
CALL testMore :like "/Hello[ ]world/"   "1" "[OK -- ] like: /Hello[ ]world/"
CALL testMore :like "/Hello\sworld/"    "1" "[OK -- ] like: /Hello\sworld/"
CALL testMore :like "/Hello.my.world/"  "3" "[OK    ] like: /Hello.my.world/"
CALL testMore :like "/Hello.My.world/"  "3" "[Not OK] like: /Hello.My.world/"

CALL testMore :note --- pass / fail
CALL testMore :pass "[OK    ] pass:Test 0"
CALL testMore :fail "[Not OK] fail:Test 1"
CALL testMore :note --- like

CALL testMore :note --- DONE

CALL testMore :done_testing

CALL testMore :BAIL_OUT "Out of air"

ECHO End of file
pause
