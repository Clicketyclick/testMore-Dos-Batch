@ECHO OFF
::&SETLOCAL EnableDelayedExpansion
    IF DEFINED DEBUG ECHO:: Call subfunction [%~1]
    CALL %*

GOTO :EOF

::----------------------------------------------------------------------

:tests
:plan
    (
        ENDLOCAL
        SET $testMore_plan=%~1
        IF NOT DEFINED $testMore_plan SET $testMore_plan=%~1
        SET $testMore_done=0
        SET $testMore_ok=0
        SET $testMore_fail=0
        SET $testMore_faillog=

        IF DEFINED DEBUG (
            ECHO:
            ECHO:LISTING PLAN:
            SET $test
            ECHO:
        )
    )
GOTO :EOF *** :plan ***

::----------------------------------------------------------------------

:done_testing
    ECHO:
    IF /I ".%$testMore_plan%" equ ".%$testMore_done%" (
        ECHO:*** SUCCESS : Ran as expected
    ) ELSE (
        ECHO:*** FAILED : Ran NOT as expected
    )
        ECHO: Planed:   %$testMore_plan%
        ECHO: Ran:      %$testMore_done%
        ECHO: OK:       %$testMore_ok%
        ECHO: Failed:   %$testMore_fail% 
        IF DEFINED $testMore_faillog ECHO: - Tests: %$testMore_faillog:~1%
    )
GOTO :EOF   *** :done_testing ***

::----------------------------------------------------------------------

:: This simply evaluates any expression ($got eq $expected is just a simple example) 
:: and uses that to determine if the test succeeded or failed. 
:: A true expression passes, a false one fails. Very simple.
:ok ERRORLEVEL $test_name
    SET /A $testMore_done+=1
    SET $testMore_tmp=%temp%\%random%.txt
    IF ".0" == ".%~1" (
        CALL :DID_succeed "%~2"
    ) ELSE (
        ::ECHO Not OK: %~2
        REM TYPE "%$testMore_tmp%"
        REM CALL :DID_Fail $testMore_tmp
        CALL :DID_fail "%~2" $testMore_tmp

    )
    IF DEFINED DEBUG  (
        ECHO:OK_$testMore_fail=%$testMore_ok%
        ECHO:OK_$testMore_fail=%$testMore_fail%
    )
EXIT /b %Errorlevel%
:: OK

::----------------------------------------------------------------------

:like $got "/expected/i"  $test_name
    SET /A $testMore_done+=1

    SET $testMore_tmp=%temp%\%random%.txt
    ::fc "%~1" "%~2" 2>&1 1> "%$testMore_tmp%"
    SET $str=%~1
    CALL :trimregex $str "/" $opts
    IF DEFINED DEBUG ECHO:Output str[%$str%] Options[%$opts%]
    IF NOT "." == ".%$opts%" SET $opts=/%$opts%
    FINDSTR %$opts% /r "%$str%" "%~2"  2>&1 1> "%$testMore_tmp%"

    IF ERRORLEVEL 1 (
        CALL :DID_Fail "%~3" $testMore_tmp
    ) ELSE (
        CALL :DID_succeed "%~3"
    )
    IF DEFINED DEBUG  (
        ECHO:like_$testMore_fail=%$testMore_ok%
        ECHO:like_$testMore_fail=%$testMore_fail%
    )
EXIT /b %Errorlevel%
:: Like

::----------------------------------------------------------------------

:is $got $expected $test_name
    SET /A $testMore_done+=1

    SET $testMore_tmp=%temp%\%random%.txt
    fc "%~1" "%~2" 2>&1 1> "%$testMore_tmp%"

    IF ERRORLEVEL 1 (
        CALL :DID_Fail "%~3" $testMore_tmp
    ) ELSE (
        CALL :DID_succeed "%~3"
    )
    IF DEFINED DEBUG  (
        ECHO:OK_$testMore_fail=%$testMore_ok%
        ECHO:OK_$testMore_fail=%$testMore_fail%
    )
EXIT /b %Errorlevel%
:: IS

::----------------------------------------------------------------------

:isnt $got $expected $test_name
    SET /A $testMore_done+=1

    SET $testMore_tmp=%temp%\%random%.txt
    FC "%~1" "%~2" 2>&1 1> "%$testMore_tmp%"

    IF ERRORLEVEL 1 (
        CALL :DID_succeed "%~3"
    ) ELSE (
        CALL :DID_Fail "%~3" $testMore_tmp
    )

    IF DEFINED DEBUG (
        ECHO:NOT_OK_$testMore_fail=%$testMore_ok%
        ECHO:NOT_OK_$testMore_fail=%$testMore_fail%
    )
ENDLOCAL&EXIT /b %Errorlevel%
:: ISNT

::----------------------------------------------------------------------


:unlike
:: :unlike( $got, qr/expected/, $test_name );
:: Works exactly as like(), only it checks if $got does not match the given pattern.
GOTO :EOF
::----------------------------------------------------------------------
:cmp_ok
:: :cmp_ok( $got, $op, $expected, $test_name );
:: Halfway between ok() and is() lies cmp_ok(). This allows you to compare two arguments using any binary perl operator. The test passes if the comparison is true and fails otherwise.
:can_ok
:: can_ok($module, @methods);
:: can_ok($object, @methods);
:: Checks to make sure the $module or $object can do these @methods (works with functions, too).
::----------------------------------------------------------------------

:isa_ok
:: :isa_ok($object,   $class, $object_name);
:: :isa_ok($subclass, $class, $object_name);
:: :isa_ok($ref,      $type,  $ref_name);
:: Checks to see if the given $object->isa($class). Also checks to make sure the object was defined in the first place. Handy for this sort of thing:
:: my $obj = Some::Module->new;
:: isa_ok( $obj, 'Some::Module' );

:new_ok
:: my $obj = new_ok( $class );
:: my $obj = new_ok( $class => \@args );
:: my $obj = new_ok( $class => \@args, $object_name );
:: A convenience function which combines creating an object and calling isa_ok() on that object.

:subtest
:: :subtest $name => \&code, @args;
:: :subtest runs the &code as its own little test with its own plan and its own result. The main test counts this as a single test using the result of the whole subtest to determine if its ok or not ok.
:: :

:pass
    CALL :OK 0 %*
GOTO :EOF
:fail
    CALL :OK 1 %*
GOTO :EOF
:: :pass($test_name);
:: :fail($test_name);
:: Sometimes you just want to say that the tests have passed.
:: Usually the case is you've got some complicated condition that is difficult to wedge into an ok().
:: In this case, you can simply use pass() (to declare the test ok) or fail (for not ok). 
:: They are synonyms for ok(1) and ok(0).
:: 
:: Use these very, very, very sparingly.

::----------------------------------------------------------------------
:require_ok
:use_ok
:: Cannot be implemented, since BATCH has no include function
:is_deeply
:: Cannot be implemented, since BATCH has no structure functions. Use dump and compare :is or :isnt
::----------------------------------------------------------------------
::----------------------------------------------------------------------

:skip
:: This declares a block of tests that might be skipped, $how_many tests there are, $why and under what $condition to skip them
:: This can be acheved using:
::SET SKIP==
::  IF NOT DEFINED skip (
::      echo :: bla bla bla
::  )
:TODO
:: Declares a block of tests you expect to fail and $why. Perhaps it's because you haven't fixed a bug or haven't finished a new feature:


ECHO Not implemented
GOTO :EOF

:BAIL_OUT
:: BAIL_OUT($reason);
::Indicates to the harness that things are going so badly all testing should terminate. This includes the running of any additional test scripts.
::
::This is typically used when testing cannot continue such as a critical module failing to compile or a necessary external utility not being available such as a database connection failing.
::
::The test will exit with 255.
    >&2 ECHO:%*
    ECHO:Bailing out
    TIMEOUT /T 10
EXIT 255



:: Prints a diagnostic message which is guaranteed not to interfere with test output.
:diag
    ECHO: # %* 1>&2
GOTO:EOF

::----------------------------------------------------------------------

:: Like diag(), except the message will not be seen when the test is run in a harness. It will only be visible in the verbose TAP stream.
:: Handy for putting in notes which might be useful for debugging, but don't indicate a problem.
:note
    ECHO: # %* 2>&1
GOTO:EOF

::----------------------------------------------------------------------

:: Will dump the contents of any references in a human readable format. 
:explain
    FOR /F %%i IN ( 'TYPE "!%~1!"' ) DO ECHO:# %%i
GOTO:EOF

::----------------------------------------------------------------------

:DID_Fail
    SET /A $testMore_fail+=1
    SET $testMore_faillog=%$testMore_faillog%, %$testMore_done%
    ECHO:Not OK	[%$testMore_done%] - %~1

    IF EXIST "%~2%" (
        :: Display diff
        FOR /F %%i IN ( 'TYPE "!%~2!"' ) DO ECHO:# %%i
        :: Delete diff
        IF DEFINED DEBUG ECHO: Deleting [%~2]
        DEL "%~2"
    )
GOTO :EOF

::----------------------------------------------------------------------

:DID_succeed
    SET /A $testMore_OK+=1
    ECHO:OK	[%$testMore_done%] - %~1
    IF EXIST "%$testMore_tmp%" (
        IF DEFINED DEBUG ECHO: Deleting [%$testMore_tmp%]
        DEL "%$testMore_tmp%"
    )
GOTO :EOF








:trimregex
::Description:	call:trimregex string "/" opts
::Syntax:	:trimregex string char opts -- returns expression and options
::                 -- string [in]  - regular expression
::                 -- string [out] - expression
::                 -- char   [in]  - separator
::                 -- opts   [out] - options returned
::
::      SET $str=/reg ex/inc
::      CALL :trimregex $str "/" $opts
::      ECHO:Output str[%$str%] Options[%$opts%]
::
:: Will output:
::      Output str[reg ex] Options[inc]
::
:: Separates expression from options in "/expression/opt"
::$created=2022-01-11T22:57:02/Erik Bachmann
::$categories=StringOperation
    SETLOCAL ENABLEDELAYEDEXPANSION
        call set string=%%%~1%%
        IF NOT "/" == "%$str:~0,1%" (
            ECHO: Failed: Not a regex [%$str%]. Expects string like: "/expression/options"
            EXIT /b 1
        )
        :: Remove leading "/"
        set string=!string:~1!
        set char=%~2
        ::set max=%~3
        CALL :strlen %~1 max
        IF DEFINED DEBUG ECHO Max=%max%

        if "%char%"=="" set char= &rem one space

        IF DEFINED DEBUG ECHO char=[%char%]
        ::if "%max%"=="" set max=32

        for /l %%a in (1,1,%max%) do (
            IF DEFINED DEBUG echo loop:%%a
            if "!string:~-1!"=="%char%" (
                set string=!string:~0,-1!
                IF DEFINED DEBUG ECHO: newstr[!string!]
                GOTO :trimregex_done
            ) ELSE (
                SET arg=!string:~-1!!arg!
                set string=!string:~0,-1!
                IF DEFINED DEBUG ECHO: newstr[!string!]
                IF DEFINED DEBUG ECHO: arg[!arg!]
            )
        )
        :trimregex_done
        IF DEFINED DEBUG ECHO: String[%string%] arg[%arg%]

    ( ENDLOCAL & REM RETURN VALUES
        IF "%~1" NEQ "" SET %~1=%string%
        IF "%~3" NEQ "" SET %~3=%arg%
    )
EXIT /b

:strLen - returns the length of a string
::Description:	call:strLen string len
::Syntax:	:strLen string len -- returns the length of a string
::                 -- string [in]  - variable name containing the string being measured for length
::                 -- len    [out] - variable to be used to return the string length
:: Many thanks to 'sowgtsoi', but also 'jeb' and 'amel27' dostips forum users helped making this short and efficient
::$created=20081122
::$changed=20101116
::$categories=StringOperation
::$source=https://www.dostips.com
(   SETLOCAL ENABLEDELAYEDEXPANSION
    set "str=A!%~1!"&rem keep the A up front to ensure we get the length and not the upper bound
                     rem it also avoids trouble in case of empty string
    set "len=0"
    for /L %%A in (12,-1,0) do (
        set /a "len|=1<<%%A"
        for %%B in (!len!) do if "!str:~%%B,1!"=="" set /a "len&=~1<<%%A"
    )
)
( ENDLOCAL & REM RETURN VALUES
    IF "%~2" NEQ "" SET /a %~2=%len%
)
EXIT /b

::*** End of File ******************************************************
