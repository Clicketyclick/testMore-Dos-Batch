@ECHO OFF
::SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
::**********************************************************************
SET $NAME=testMore.cmd
SET $DESCRIPTION=DOS Batch implementation of Perl's Test::More test framework
SET $AUTHOR=Erik Bachmann, ClicketyClick.dk [ErikBachmann@ClicketyClick.dk]
SET $SOURCE=%~f0
::@(#)NAME
::@(-)  The name of the command or function, followed by a one-line description of what it does.
::@(#)      testMore.cmd -- DOS Batch implementation of Perl's Test::More test framework
::@(#) 
::@(#)SYNOPSIS
::@(-)  In the case of a command, a formal description of how to run it and what command line options it takes. 
::@(-)  For program functions, a list of the parameters the function takes and which header file contains its definition.
::@(-)  
::@(#)      testMore.cmd [VAR]
::@(#) 
::@(#)OPTIONS
::@(-)  Flags, parameters, arguments (NOT the Monty Python way)
::@(#)  -h      Help page
::@(#) 
::@ (#) 
::@(#)DESCRIPTION
::@(-)  A textual description of the functioning of the command or function.
::@(#) The purpose of this module is to provide a wide range of testing utilities.
::@(#) Various ways to say "ok" with better diagnostics, facilities to skip tests,
::@(#) test future features and compare complicated data structures. 
::@(#) While you can do almost anything with a simple ok() function, 
::@(#) it doesn't provide good diagnostic output.
::@(#) 
::@(#)EXAMPLES
::@(-)  Some examples of common usage.
::@(#) 
::@(#)  CALL testMore :plan 2
::@(#)  CALL testMore :ok   0   "	[OK    ]	ok:Test 0"
::@(#)  CALL testMore :harness :ok   1   "	[OK/fail]	ok:Test 1"
::@(#)  CALL testMore :done_testing
::@(#) 
::@(#) First test has an Errorlevel of 0 (= OK)
::@(#) First test has an Errorlevel of 1 (= Error), but this is expected and valid.
::@(#) The harness ensures that the result is OK since the "Failure" is valid
::@(#) 
::@(#) Please se testMore.unitTest.cmd for a more extended example
::@(#) 
::@ (#)EXIT STATUS
::@(-)  Exit status / errorlevel is 0 if OK, otherwise 1+.
::@ (#)
::@ (#)ENVIRONMENT
::@(-)  Variables affected
::@ (#)
::@ (#)
::@ (#)FILES, 
::@(-)  Files used, required, affected
::@ (#)
::@ (#)
::@ (#)BUGS / KNOWN PROBLEMS
::@(-)  If any known
::@ (#)
::@ (#)
::@(#)REQUIRES
::@(-)  Dependecies
::@(#) testMore.cmd
::@(#) 
::@ (#)SEE ALSO
::@(-)  A list of related commands or functions.
::@ (#)  
::@ (#)  
::@ (#)REFERENCE
::@(-)  References to inspiration, clips and other documentation
::@ (#)  Author: 
::@ (#)  URL: https://metacpan.org/pod/Test::More
::@ (#)  URL: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes
::@ (#)  URL: https://en.wikipedia.org/wiki/Test::More
::@ (#) 
::@(#)
::@(#)SOURCE
::@(-)  Where to find


:run
    IF DEFINED DEBUG ECHO:: Call subfunction [%~1]
    SET $sub=%~1
    IF ":_" == "%$SUB:~0,2%" (
        1>&2 ECHO:ERROR - Calling internal sub function in %0 [%~1]
        EXIT /b 255
    )
    CALL %*
GOTO :EOF

::----------------------------------------------------------------------

:: This basically declares how many tests your script is going to run to 
:: protect against premature failure.
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
        SET $testMore_log=%~dpn0.log
        IF DEFINED DEBUG (
            ECHO:
            ECHO:LISTING PLAN:
            SET $test
            ECHO:
        )
    )
        echo $testMore_log=[%$testMore_log%]

GOTO :EOF *** :plan ***

::----------------------------------------------------------------------

:: The result of all your testing according to plan
:done_testing
    1>&2 ECHO:
    IF /I ".%$testMore_plan%" equ ".%$testMore_done%" (
        IF /I ".0" == ".%$testMore_fail%" (
            1>&2 ECHO:*** SUCCESS : Ran as expected
        ) ELSE (
            1>&2 ECHO:*** FAILED : All tests ran, but with some errors
        )
    ) ELSE (
        1>&2 ECHO:*** FAILED : Ran NOT as expected
    )
        1>&2 ECHO: Planed:   %$testMore_plan%
        1>&2 ECHO: Ran:      %$testMore_done%
        1>&2 ECHO: OK:       %$testMore_ok%
        1>&2 ECHO: Failed:   %$testMore_fail%
        IF DEFINED $testMore_faillog 1>&2 ECHO: - Tests failed:	%$testMore_faillog%
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
        CALL :_DID_succeed "%~2"
    ) ELSE (
        CALL :_DID_fail "%~2" $testMore_tmp
    )
    IF DEFINED DEBUG  (
        ECHO:OK_$testMore_fail=%$testMore_ok%
        ECHO:OK_$testMore_fail=%$testMore_fail%
    )
EXIT /b %Errorlevel%
:: OK

::----------------------------------------------------------------------

:: Similar to ok(), like() matches $got against the regex qr/expected/.
:like $got "/expected/i"  $test_name
    SET /A $testMore_done+=1

    SET $testMore_tmp=%temp%\%random%.txt
    ::fc "%~1" "%~2" 2>&1 1> "%$testMore_tmp%"
    SET $str=%~1
    CALL :trimregex $str "/" $opts
    IF DEFINED DEBUG ECHO:Output str[%$str%] Options[%$opts%]
    IF NOT "." == ".%$opts%" SET $opts=/%$opts%
    FINDSTR %$opts% /r "%$str%" "%~2" ^
        2>&1 1> "%$testMore_tmp%"   

    IF ERRORLEVEL 1 (
        CALL :_DID_Fail "%~3" $testMore_tmp
    ) ELSE (
        CALL :_DID_succeed "%~3"
    )
    IF DEFINED DEBUG  (
        ECHO:like_$testMore_fail=%$testMore_ok%
        ECHO:like_$testMore_fail=%$testMore_fail%
    )
EXIT /b %Errorlevel%
:: Like

::----------------------------------------------------------------------

:: Similar to ok(), is() and isnt() compare their two arguments with 
:: eq and ne respectively and use the result of that to determine 
:: if the test succeeded or failed.
:is $got $expected $test_name
    SET /A $testMore_done+=1
    SET IS_OK=0
    SET $testMore_tmp=%temp%\%random%.txt
    fc "%~1" "%~2" 2>&1 1> "%$testMore_tmp%"

    IF ERRORLEVEL 1 (
        CALL :_DID_Fail "%~3" $testMore_tmp
        SET IS_OK=2
    ) ELSE (
        CALL :_DID_succeed "%~3"
    )
    IF DEFINED DEBUG  (
        ECHO:OK_$testMore_fail=%$testMore_ok%
        ECHO:OK_$testMore_fail=%$testMore_fail%
    )
EXIT /b %IS_OK%
:: IS

::----------------------------------------------------------------------

:: Similar to ok(), is() and isnt() compare their two arguments with 
:: eq and ne respectively and use the result of that to determine 
:: if the test succeeded or failed.
:isnt $got $expected $test_name
    SET /A $testMore_done+=1

    SET $testMore_tmp=%temp%\%random%.txt
    FC "%~1" "%~2" 2>&1 1> "%$testMore_tmp%"

    IF ERRORLEVEL 1 (
        CALL :_DID_succeed "%~3"
    ) ELSE (
        CALL :_DID_Fail "%~3" $testMore_tmp
    )

    IF DEFINED DEBUG (
        ECHO:NOT_OK_$testMore_fail=%$testMore_ok%
        ECHO:NOT_OK_$testMore_fail=%$testMore_fail%
    )
ENDLOCAL&EXIT /b %Errorlevel%
:: ISNT

::----------------------------------------------------------------------

:: :unlike( $got, qr/expected/, $test_name );
:: Works exactly as like(), only it checks if $got does not match the given pattern.
:unlike

GOTO :EOF

::----------------------------------------------------------------------

:: :cmp_ok( $got, $op, $expected, $test_name );
:: Halfway between ok() and is() lies cmp_ok(). This allows you to 
:: compare two arguments using any binary perl operator. 
:: The test passes if the comparison is true and fails otherwise.
:cmp_ok

::----------------------------------------------------------------------

:: can_ok($module, @methods);
:: can_ok($object, @methods);
:: Checks to make sure the $module or $object can do these @methods 
:: (works with functions, too).
:can_ok

::----------------------------------------------------------------------

:: :isa_ok($object,   $class, $object_name);
:: :isa_ok($subclass, $class, $object_name);
:: :isa_ok($ref,      $type,  $ref_name);
:: Checks to see if the given $object->isa($class). 
:: Also checks to make sure the object was defined in the first place. 
:: Handy for this sort of thing:
:: my $obj = Some::Module->new;
:: isa_ok( $obj, 'Some::Module' );
:isa_ok

::----------------------------------------------------------------------

:: my $obj = new_ok( $class );
:: my $obj = new_ok( $class => \@args );
:: my $obj = new_ok( $class => \@args, $object_name );
:: A convenience function which combines creating an object and calling
:: :isa_ok on that object.
:new_ok

::----------------------------------------------------------------------

:: :subtest $name => \&code, @args;
:: :subtest runs the &code as its own little test with its own plan and its 
:: own result. The main test counts this as a single test using the result 
:: of the whole subtest to determine if its ok or not ok.
:subtest

:pass
    CALL :OK 0 %*
GOTO :EOF

:fail
    CALL :OK 1 %*
GOTO :EOF
:: :pass($test_name);
:: :fail($test_name);
:: Sometimes you just want to say that the tests have passed.
:: Usually the case is you've got some complicated condition that 
:: is difficult to wedge into an ok().
:: In this case, you can simply use pass() (to declare the test ok) 
:: or fail (for not ok). 
:: They are synonyms for ok(1) and ok(0).
:: 
:: Use these very, very, very sparingly.

::----------------------------------------------------------------------
:: Cannot be implemented, since BATCH has no include function
:require_ok
:use_ok

:: Cannot be implemented, since BATCH has no structure functions. 
:: Use dump and compare :is or :isnt
:is_deeply

::----------------------------------------------------------------------

:: This declares a block of tests that might be skipped, $how_many 
:: tests there are, $why and under what $condition to skip them
:: This can be acheved using:
::SET SKIP==
::  IF NOT DEFINED skip (
::      echo :: bla bla bla
::  )
:skip

::----------------------------------------------------------------------

:: Declares a block of tests you expect to fail and $why. 
:: Perhaps it's because you haven't fixed a bug or haven't finished a new feature:
:TODO

    1>&2 ECHO Not implemented [%0]
GOTO :EOF

::----------------------------------------------------------------------

:BAIL_OUT
:: BAIL_OUT($reason);
::Indicates to the harness that things are going so badly all testing 
:: should terminate. This includes the running of any additional test scripts.
::
::This is typically used when testing cannot continue such as a critical 
:: module failing to compile or a necessary external utility not being 
:: available such as a database connection failing.
::
::The test will exit with 255.
    >&2 ECHO:%*
    ECHO:Bailing out
    TIMEOUT /T 10
EXIT 255

::----------------------------------------------------------------------

:: Prints a diagnostic message which is guaranteed not to interfere 
:: with test output.
:diag
    ECHO:# %* 1>&2
GOTO:EOF

::----------------------------------------------------------------------

:: Like diag(), except the message will not be seen when the test is 
:: run in a harness. It will only be visible in the verbose TAP stream.
:: Handy for putting in notes which might be useful for debugging, but 
:: don't indicate a problem.
:note
    ECHO:# %* 2>&1
GOTO:EOF

::----------------------------------------------------------------------

:: Will dump the contents of any references in a human readable format. 
:explain
    FOR /F %%i IN ( 'TYPE "!%~1!"' ) DO ECHO:# %%i
GOTO:EOF

::----------------------------------------------------------------------

:_DID_Fail
    SET /A $testMore_fail+=1
    IF "." == ".%$testMore_faillog%" (
        SET $testMore_faillog=%$testMore_done%
    ) ELSE (
        SET $testMore_faillog=%$testMore_faillog%, %$testMore_done%
    )
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

:_DID_succeed
    SET /A $testMore_OK+=1
    ECHO:OK	[%$testMore_done%] - %~1
    IF EXIST "%$testMore_tmp%" (
        IF DEFINED DEBUG ECHO: Deleting [%$testMore_tmp%]
        DEL "%$testMore_tmp%"
    )
GOTO :EOF

::----------------------------------------------------------------------

:: Handle valid expected failure and restore testresults
:onFail
    IF /I "%$Stored_testMore_fail%" LSS "%$testMore_fail%" (
        :: Expected failure
        CALL :_restoreTestReults :: Restore after valid failure
        CALL testMore :ok   0   %1
    ) ELSE ( :: Didn't fail as expected - which is a failure
        CALL testMore :ok   1   %1
    )
GOTO :EOF

::----------------------------------------------------------------------

:: Expect next test to fail
:expectFail

:: Save current test results before handling an expected/valid failure
:_saveTestReults
    SET $Stored_testMore_done=%$testMore_done%
    SET $Stored_testMore_ok=%$testMore_ok%
    SET $Stored_testMore_fail=%$testMore_fail%
    SET $Stored_testMore_faillog=%$testMore_faillog%
GOTO :EOF

::----------------------------------------------------------------------

:: Restore test results after handling an expected/valid failure
:_restoreTestReults
    SET $testMore_done=%$Stored_testMore_done%
    SET $testMore_ok=%$Stored_testMore_ok%
    SET $testMore_fail=%$Stored_testMore_fail%
    SET $testMore_faillog=%$Stored_testMore_faillog%
GOTO :EOF

::----------------------------------------------------------------------

:: Test harness to handle valid failures
:harness diag func args...
    SET $diag=
    SET $args=
    :: Save last argument as diagnostic
    CALL :lastarg     $diag %*
    :: Skip last argument
    CALL :skiplastarg $args %*
::ECHO diag[%$diag%]
::ECHO diag[%$diag:"=_%]
::ECHO args[%$args%]

    CALL testMore :expectFail    :: Expected to fail
::    1>NUL 2>&1 CALL testMore %2 %3 %4 %5 "	[Not OK]	%~1"
::    CALL testMore :onFail "	[OK    ]	%~1"
::    1>NUL 2>&1 CALL testMore %$args% "%$diag% %~1"
    :: Run test that is intended to fail
    1>NUL 2>&1 CALL testMore %$args% "%$diag%"
    :: Handle valid faliure
    CALL testMore :onFail "%$diag:~1,-1%"
GOTO :EOF

::----------------------------------------------------------------------

:: https://stackoverflow.com/a/70810459/7485823
:: Return all but last arg in variable given in %1
:skiplastarg returnvar args ...
    SETLOCAL
        SET $return=%1
        SET SKIP_LAST_ARG=
        SHIFT
    :skiplastarg_2
        IF NOT "%~2"=="" SET "SKIP_LAST_ARG=%SKIP_LAST_ARG% %1"
        SHIFT
        IF NOT "%~1"=="" GOTO skiplastarg_2
    ENDLOCAL&CALL SET "%$return%=%SKIP_LAST_ARG:~1%"
GOTO :EOF

::----------------------------------------------------------------------

:: https://stackoverflow.com/a/70810459/7485823
:: Return last arg in variable given in %1
:lastarg returnvar args ...
    SETLOCAL
      SET $return=%1
      SET LAST_ARG=
      SHIFT
    :LASTARG_2
      SET "LAST_ARG=%1"
      SHIFT
      IF NOT "%~1"=="" GOTO lastarg_2
    ENDLOCAL&call SET %$return%=%LAST_ARG%
GOTO :EOF

::----------------------------------------------------------------------

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
            ECHO: Failed: Not a regex [%$str%]. 
            ECHO: - Expects string like: "/expression/options"
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

::----------------------------------------------------------------------

:strLen - returns the length of a string
::Description:	call:strLen string len
::Syntax:	:strLen string len -- returns the length of a string
:: -- string [in]  - variable name containing the string being measured for length
:: -- len    [out] - variable to be used to return the string length
:: Many thanks to 'sowgtsoi', but also 'jeb' and 'amel27' dostips forum 
:: users helped making this short and efficient
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
