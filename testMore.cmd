::ECHO OFF
::SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
::**********************************************************************
SET $NAME=testMore.cmd
SET $DESCRIPTION=DOS Batch implementation of Perl's Test::More test framework
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
SET AnsiOK=[97m[42m
SET AnsiFAIL=[97m[41m
SET AnsiSKIP=[97m[44m&
SET AnsiMissing=[97m[100m
SET AnsiRESET=[0m
SET AnsiItalic=[3m
Set AnsiRESET=[0m

    ::%_DEBUG_% Call subfunction [%~1]
    IF NOT DEFINED $TESTMORE_STATUS SET $TESTMORE_STATUS=TESTMORE_STATUS
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

:tests
:plan
:: :plan No_of_tests - Declare the entended no of tests to run
::
:: This basically declares how many tests your script is going to run to 
:: protect against premature failure.
::<<:plan
	%_DEBUG_% THIS IS A PLAN
	SET $testMore_plan=%~1
	IF NOT DEFINED $testMore_plan SET $testMore_plan=1
	SET $testMore_started=0
	SET $testMore_done=0
	SET $testMore_ok=0
	SET $testMore_fail=0
	SET $testMore_skip=0
	SET $testMore_fail_log=
	SET $testMore_log=%~dpn0.log
	IF DEFINED DEBUG (
		ECHO:
		ECHO:LISTING PLAN:
		SET $test
		ECHO:
	)
	ECHO:Planed no of tests: %$testMore_plan%
    ECHO:$testMore_log=[%$testMore_log%]
	ECHO:
GOTO :EOF *** :plan ***

::----------------------------------------------------------------------

:done_testing
:: :done_testing - The result of all your testing according to plan
:: $testMore_plan
::<<:done_testing
    1>&2 ECHO:
    IF /I ".%$testMore_plan%" equ ".%$testMore_done%" (
        IF /I ".0" == ".%$testMore_fail%" (
            1>&2 ECHO:*** SUCCESS : Ran as expected [Done:%$testMore_done%/ Plan:%$testMore_plan%]
        ) ELSE (
            1>&2 ECHO:*** FAILED : All tests ran, but with some errors [Done:%$testMore_done%/ Plan:%$testMore_plan%]
        )
    ) ELSE (
        1>&2 ECHO:*** FAILED : Ran NOT as expected: [Done:%$testMore_done%/ Plan:%$testMore_plan%]
    )
        1>&2 ECHO: Planed:   %$testMore_plan%
        1>&2 ECHO: Ran:      %$testMore_done%
        1>&2 ECHO: OK:       %$testMore_ok%
        1>&2 ECHO: Failed:   %$testMore_fail%
        1>&2 ECHO: Skipped:  %$testMore_skip%
        IF DEFINED $testMore_fail_log (
			1>&2 ECHO: - Tests failed:
			:: https://ss64.com/nt/echo.html#path - replacing the semicolons with newlines
			1>&2 ECHO:    - %$testMore_fail_log:\n= & ECHO:    - %
		)
    )
	TITLE %_LIB%: [%$testMore_done% done/%$testMore_plan% planed]
GOTO :EOF   *** :done_testing ***

::----------------------------------------------------------------------

:ok
:: :ok ERRORLEVEL $test_name - Evaluate a TRUE expression
::
:: This simply evaluates any expression ($got eq $expected is just a simple example) 
:: and uses that to determine if the test succeeded or failed. 
:: A true expression passes, a false one fails. Very simple.
::<<:ok
    SET $testMore_tmp=%temp%\%random%.txt
    IF ".0" == ".%~1" (
        CALL :_DID_succeed "%~2"
    ) ELSE (
        CALL :_DID_fail "%~2" $testMore_tmp
    )
    IF DEFINED DEBUG  (
        ECHO:OK	$testMore_done=%$testMore_done% $testMore_ok=%$testMore_ok%
        ECHO:OK $testMore_fail=%$testMore_fail%
		CALL :_state
    )
	CALL :_state
EXIT /b %Errorlevel%
:: OK

::----------------------------------------------------------------------

:notok
:: :notok ERRORLEVEL $test_name - Evaluate a FALSE expression
::
:: This simply evaluates any expression ($got eq $expected is just a simple example) 
:: and uses that to determine if the test succeeded or failed. 
:: A true expression passes, a false one fails. Very simple.
::<<:notok
    SET $testMore_tmp=%temp%\%random%.txt
    IF /I ".0" NEQ ".%~1" (
        CALL :_DID_succeed "%~2"
    ) ELSE (
        CALL :_DID_fail "%~2" $testMore_tmp
    )
    IF DEFINED DEBUG  (
        ECHO:NOTOK $testMore_ok=%$testMore_ok%
        ECHO:NOTOK $testMore_fail=%$testMore_fail%
		CALL :_state
    )
	CALL :_state
EXIT /b %Errorlevel%
:: OK

::----------------------------------------------------------------------

:like
:: :like $got "/expected/i"  $test_name - Similar to :ok using regex
::
:: Similar to :ok, :like matches $got against the regex qr/expected/.
::<<:like
    SET $testMore_tmp=%temp%\%random%.txt
    ::fc "%~1" "%~2" 2>&1 1> "%$testMore_tmp%"
    SET $str=%~1
    CALL :trimregex $str "/" $opts
    %_DEBUG_% :Output str[%$str%] Options[%$opts%]
    IF NOT "." == ".%$opts%" SET $opts=/%$opts%
    FINDSTR %$opts% /r "%$str%" "%~2" ^
        2>&1 1> "%$testMore_tmp%"   

    IF ERRORLEVEL 1 (
        CALL :_DID_Fail "%~3" $testMore_tmp
    ) ELSE (
        CALL :_DID_succeed "%~3"
    )
    IF DEFINED DEBUG  (
        ECHO:like $testMore_ok=%$testMore_ok%
        ECHO:like $testMore_fail=%$testMore_fail%
		CALL :_state
    )
	CALL :_state
EXIT /b %Errorlevel%
:: Like

::----------------------------------------------------------------------

:is
:: :is $got $expected $test_name - Compare arguments with eq
::
:: Similar to :ok, :is and :isnt compare their two arguments with 
:: eq and ne respectively and use the result of that to determine 
:: if the test succeeded or failed.
::<<:is
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
        ECHO:IS $testMore_ok=%$testMore_ok%
        ECHO:IS $testMore_fail=%$testMore_fail%
		CALL :_state
    )
	CALL :_state
EXIT /b %IS_OK%
:: IS

::----------------------------------------------------------------------

:isnt
:: :isnt $got $expected $test_name - Compare arguments with ne
::
:: Similar to :ok, :is and :isnt compare their two arguments with 
:: eq and ne respectively and use the result of that to determine 
:: if the test succeeded or failed.
::<<:isnt
    SET $testMore_tmp=%temp%\%random%.txt
    FC "%~1" "%~2" 2>&1 1> "%$testMore_tmp%"

    IF ERRORLEVEL 1 (
        CALL :_DID_succeed "%~3"
    ) ELSE (
        CALL :_DID_Fail "%~3" $testMore_tmp
    )

    IF DEFINED DEBUG (
        ECHO:ISNT $testMore_fail=%$testMore_ok%
        ECHO:ISNT $testMore_fail=%$testMore_fail%
		CALL :_state
    )
	CALL :_state
ENDLOCAL&EXIT /b %Errorlevel%
:: ISNT

::----------------------------------------------------------------------

:unlike
:: :unlike $got qr/expected/ $test_name - Check match with regex
:: NOT IMPLEMENTED
:: Works exactly as :like, only it checks if $got does not match the given pattern.
::<<:unlike
    ECHO:$0 - NOT implemented
	CALL :_DID_skip %*
	CALL :_state
EXIT /B 255

GOTO :EOF

::----------------------------------------------------------------------

:cmp_ok
:: :cmp_ok( $got, $op, $expected, $test_name );
:: NOT IMPLEMENTED
:: Halfway between :ok and :is lies :cmp_ok. This allows you to 
:: compare two arguments using any binary perl operator. 
:: The test passes if the comparison is true and fails otherwise.
::<<:cmp_ok
    ECHO:$0 - NOT implemented
	CALL :_DID_skip %*
	CALL :_state
EXIT /B 255

::----------------------------------------------------------------------

:can_ok
:: can_ok $module @methods - NOT implemented
:: can_ok $object @methods - NOT implemented
::
:: Checks to make sure the $module or $object can do these @methods 
:: (works with functions, too).
::<<:can_ok
    ECHO:$0 - NOT implemented
	CALL :_DID_skip %*
	CALL :_state
EXIT /B 255

::----------------------------------------------------------------------

:isa_ok
:: :isa_ok $object   $class $object_name - NOT implemented
:: :isa_ok $subclass $class $object_name - NOT implemented
:: :isa_ok $ref      $type  $ref_name - NOT implemented
::
:: Checks to see if the given $object->isa($class). 
:: Also checks to make sure the object was defined in the first place. 
::<<:isa_ok
    ECHO:$0 - NOT implemented
	CALL :_DID_skip %*
	CALL :_state
EXIT /B 255

::----------------------------------------------------------------------

:new_ok
:: my $obj = new_ok( $class );- NOT implemented
:: my $obj = new_ok( $class => \@args ); - NOT implemented
:: my $obj = new_ok( $class => \@args, $object_name ); - NOT implemented
::
:: A convenience function which combines creating an object and calling
:: :isa_ok on that object.
::<<:new_ok
    ECHO:$0 - NOT implemented
	CALL :_DID_skip %*
	CALL :_state
EXIT /B 255

::----------------------------------------------------------------------

:subtest
:: :subtest $name => \&code, @args; - NOT implemented
::
:: :subtest runs the &code as its own little test with its own plan and its 
:: own result. The main test counts this as a single test using the result 
:: of the whole subtest to determine if its ok or not ok.
::<<:subtest
    ECHO:$0 - NOT implemented
	CALL :_DID_skip %*
	CALL :_state
EXIT /B 255

::----------------------------------------------------------------------

:pass
:: :pass $test_name - Just pass and forget
::
:: Sometimes you just want to say that the tests have passed.
:: Usually the case is you've got some complicated condition that 
:: is difficult to wedge into an :ok.
:: In this case, you can simply use :pass (to declare the test ok) 
:: or fail (for not ok). 
:: Synonym for: ok 0
:: 
:: Use these very, very, very sparingly.
::<<:pass
    CALL :%AnsiMissing=%OK   %AnsiRESET%0 %*
	CALL :_state
GOTO :EOF

::----------------------------------------------------------------------

:fail
:: :fail $test_name - Just fail and go on
::
:: Sometimes you just want to say that the tests have passed.
:: Usually the case is you've got some complicated condition that 
:: is difficult to wedge into an :ok.
:: In this case, you can simply use :pass (to declare the test ok) 
:: or fail (for not ok). 
:: Synonyms for: :ok 1
:: 
:: Use these very, very, very sparingly.
::<<:fail
    CALL :%AnsiSKIP=%FAIL  %AnsiRESET% 1 %*
	CALL :_state
GOTO :EOF

::----------------------------------------------------------------------

:require_ok
:: :require_ok - Cannot be implemented, since BATCH has no include function
::<<:require_ok
    ECHO:$0 - NOT implemented
	CALL :_DID_skip %*
	CALL :_state
EXIT /B 255

::----------------------------------------------------------------------

:use_ok
:: :use_ok - Cannot be implemented, since BATCH has no include function
::<<:use_ok
    ECHO:$0 - NOT implemented
	CALL :_DID_skip %*
	CALL :_state
EXIT /B 255

::----------------------------------------------------------------------

:is_deeply
:: :is_deeply - Cannot be implemented, since BATCH has no structure functions. 
:: Use dump and compare :is or :isnt
::<<:is_deeply
    ECHO:$0 - NOT implemented
	CALL :_DID_skip %*
	CALL :_state
EXIT /B 255

::----------------------------------------------------------------------

:skip
:: :skip - declares a block of tests
::
:: This declares a block of tests that might be skipped, $how_many 
:: tests there are, $why and under what $condition to skip them
:: This can be acheved using:
::SET SKIP==
::  IF NOT DEFINED skip (
::      echo :: bla bla bla
::  )
::<<:skip
    ::1>&2 ECHO Not implemented [%0]
    ::SET /A $testMore_done+=1
    ::SET /A $testMore_skip+=1
	%_DEBUG_%	%0 SKIP 1: Done:%$testMore_done% SKip:%$testMore_skip%
    SET $testMore_tmp=%temp%\%random%.txt
    CALL :_DID_skip "%~1" $testMore_tmp
	%_DEBUG_%	%0 SKIP 2: Done:%$testMore_done% SKip:%$testMore_skip%
	SET ERRORLEVEL=-1
	CALL :_state
GOTO :EOF

::----------------------------------------------------------------------

:TODO
:: :TODO - Declares a block of tests you expect to fail and $why. 
:: Perhaps it's because you haven't fixed a bug or haven't finished a new feature:
::<<:TODO
    %_DEBUG_%	%0 TODO 1: Done:%$testMore_done% TODO:%$testMore_skip%
    SET $testMore_tmp=%temp%\%random%.txt
    CALL :_DID_skip "%~1" $testMore_tmp TODO
    %_DEBUG_%	%0 SKIP 2: Done:%$testMore_done% TODO:%$testMore_skip%
    SET ERRORLEVEL=-1
	CALL :_state
GOTO :EOF :TODO

::----------------------------------------------------------------------

:BAIL_OUT
:: :BAIL_OUT $reason - Bail out and stop all processing
::
::Indicates to the harness that things are going so badly all testing 
:: should terminate. This includes the running of any additional test scripts.
::
::This is typically used when testing cannot continue such as a critical 
:: module failing to compile or a necessary external utility not being 
:: available such as a database connection failing.
::
::The test will exit with 255.
::<<:BAIL_OUT
    >&2 ECHO:%*
    ECHO:%AnsiMissing=%Bailing out%AnsiRESET%
    TIMEOUT /T 10
EXIT 255

::----------------------------------------------------------------------

:diag
:: :diag - Print diagnostic message
::
:: Prints a diagnostic message which is guaranteed not to interfere 
:: with test output.
::<<:diag
    ECHO:#%AnsiItalic% %* %AnsiRESET=% 1>&2
GOTO:EOF

::----------------------------------------------------------------------

:note
:: :note - Print a note
::
:: Like :diag, except the message will not be seen when the test is 
:: run in a harness. It will only be visible in the verbose TAP stream.
:: Handy for putting in notes which might be useful for debugging, but 
:: don't indicate a problem.
::<<:note
    ECHO:#%AnsiItalic% %* %AnsiRESET=% 2>&1
GOTO:EOF

::----------------------------------------------------------------------

:explain
:: :explain - :explain - Will dump in a human readable format
::
:: Will dump the contents of any references in a human readable format. 
::<<:explain
    FOR /F %%i IN ( 'TYPE "!%~1!"' ) DO ECHO:# %%i
GOTO:EOF

::----------------------------------------------------------------------

:_DID_Fail
:: :_DID_Fail - Action on failure
::<<:_DID_Fail
    SET /A $testMore_done+=1
    SET /A $testMore_fail+=1
    IF "." == ".%$testMore_fail_log%" (
        SET $testMore_fail_log=%$testMore_done% _ %~1
    ) ELSE (
        SET $testMore_fail_log=%$testMore_fail_log%\n%$testMore_done% _ %~1
    )
    %_VERBOSE_% Not OK	[%$testMore_done%] - %~1
    ECHO:%AnsiFAIL=%Not OK	%AnsiRESET%[%$testMore_done%] - %~1>>%$TESTMORE_STATUS%

    IF EXIST "%~2%" (
        :: Display diff
        FOR /F %%i IN ( 'TYPE "!%~2!"' ) DO ECHO:# %%i
        :: Delete diff
        %_DEBUG_% Deleting [%~2]
        DEL "%~2"
    )
	SET ERRORLEVEL=1
GOTO :EOF

::----------------------------------------------------------------------

:_DID_succeed
:: :_DID_succeed - Action on success
::<<:_DID_succeed
    SET /A $testMore_OK+=1
    SET /A $testMore_done+=1
    %_VERBOSE_% OK	[%$testMore_done%] - %~1
    ECHO:%AnsiOK% OK	%AnsiRESET%[%$testMore_done%] - %~1>>%$TESTMORE_STATUS%
    IF EXIST "%$testMore_tmp%" (
        %_DEBUG_% Deleting [%$testMore_tmp%]
        DEL "%$testMore_tmp%"
    )
	SET ERRORLEVEL=0
GOTO :EOF

::----------------------------------------------------------------------

:_DID_skip
:: :_DID_skip - Action on skip
::<<:_DID_skip
	SET _CAUSE=%~3
	IF NOT DEFINED _CAUSE SET _CAUSE=SKIP
	
    SET /A $testMore_skip+=1
    SET /A $testMore_done+=1
	
	%_DEBUG_%	%0 %_CAUSE%: Done:%$testMore_done% %_CAUSE%:%$testMore_skip%
    %_VERBOSE_% %_CAUSE%	[%$testMore_done%] - %~1.
    ECHO:%AnsiSKIP%%_CAUSE%	%AnsiRESET%[[%$testMore_done%] - %~1>>%$TESTMORE_STATUS%
	
    IF EXIST "%$testMore_tmp%" (
        %_DEBUG_% Deleting [%$testMore_tmp%]
        DEL "%$testMore_tmp%"
    )
GOTO :EOF

::----------------------------------------------------------------------

:_onFail
:: :_onFail - Handle valid expected failure and restore testresults
::<<:_onFail
    IF /I "%$Stored_testMore_fail%" LSS "%$testMore_fail%" (
        :: Expected failure
        CALL :_restoreTestReults :: Restore after valid failure
        CALL testMore :ok   0   %1
    ) ELSE ( :: Didn't fail as expected - which is a failure
        CALL testMore :ok   1   %1
    )
GOTO :EOF

::----------------------------------------------------------------------

:_expectFail
:: :_expectFail - Expect next test to fail
::<<:_expectFail

:_saveTestReults
:: :_saveTestReults - Save current test results before handling an expected/valid failure
::<<:_saveTestReults
    SET $Stored_testMore_done=%$testMore_done%
    SET $Stored_testMore_ok=%$testMore_ok%
    SET $Stored_testMore_fail=%$testMore_fail%
    SET $Stored_testMore_faillog=%$testMore_fail_log%
GOTO :EOF

::----------------------------------------------------------------------

:_restoreTestReults
:: :_restoreTestReults - Restore test results after handling an expected/valid failure
::<<:_restoreTestReults
    SET $testMore_done=%$Stored_testMore_done%
    SET $testMore_ok=%$Stored_testMore_ok%
    SET $testMore_fail=%$Stored_testMore_fail%
    SET $testMore_fail_log=%$Stored_testMore_faillog%
GOTO :EOF

::----------------------------------------------------------------------

:harness
:: :harness diag func args... - Test harness to handle valid failures
::<<:harness
    SET $diag=
    SET $args=
    :: Save last argument as diagnostic
    CALL :lastarg     $diag %*
    :: Skip last argument
    CALL :skiplastarg $args %*
    :: Expected to fail
    CALL testMore :_expectFail
    :: Run test that is intended to fail
    1>NUL 2>&1 CALL testMore %$args% "%$diag%"
    :: Handle valid faliure
    CALL testMore :_onFail "%$diag:~1,-1%"
GOTO :EOF

::----------------------------------------------------------------------

:skiplastarg
:: :skiplastarg returnvar args ...
::
:: Return all but last arg in variable given in %1
:: https://stackoverflow.com/a/70810459/7485823
::<<:skiplastarg
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

:lastarg
:: :lastarg returnvar args ...
:: Return last arg in variable given in %1
::
:: https://stackoverflow.com/a/70810459/7485823
::<<:lastarg
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
::<<:trimregex
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
        %_DEBUG_% Max=%max%

        if "%char%"=="" set char= &rem one space

        %_DEBUG_% char=[%char%]
        ::if "%max%"=="" set max=32

        for /l %%a in (1,1,%max%) do (
            %_DEBUG_% loop:%%a
            if "!string:~-1!"=="%char%" (
                set string=!string:~0,-1!
                %_DEBUG_% newstr[!string!]
                GOTO :trimregex_done
            ) ELSE (
                SET arg=!string:~-1!!arg!
                set string=!string:~0,-1!
                %_DEBUG_% newstr[!string!]
                %_DEBUG_% arg[!arg!]
            )
        )
        :trimregex_done
        %_DEBUG_% String[%string%] arg[%arg%]

    ( ENDLOCAL & REM RETURN VALUES
        IF "%~1" NEQ "" SET %~1=%string%
        IF "%~3" NEQ "" SET %~3=%arg%
    )
EXIT /b

::----------------------------------------------------------------------

:strLen
:: :strLen - returns the length of a string
::
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
::<<:strlen
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
    if /i "%%B"=="%emk%" set "bExtr="&set "bSubs="
    if defined bExtr if defined bSubs (call echo.%%B) ELSE (echo.%%B) 
    if /i "%%B"=="%bmk%"   set "bExtr=Y"
    if /i "%%B"=="%bmk%:S" set "bExtr=Y"&set "bSubs=Y"
)
EXIT /b

::----------------------------------------------------------------------

:: Count all calls to test functions to set plan
:PLAN_TESTMORE sourcefile returnvar
	SETLOCAL ENABLEDELAYEDEXPANSION
		SET CALL_TESTMORE=
		FOR %%i IN ( ok notok is isnt like skip todo ) DO CALL SET "CALL_TESTMORE= /C:^"[^^^^:]CALL .$TestMore. :%%i^" !CALL_TESTMORE!"
		
		(
			%_DEBUG_% $testMore_plan.CALL_TESTMORE=%CALL_TESTMORE%
			ECHO: $testMore_plan.CALL_TESTMORE=%CALL_TESTMORE%
			findstr /I /N /R %CALL_TESTMORE% "%~1" 
		)> CALL_TESTMORE.txt

		FOR /F %%i IN ( 'findstr /R %CALL_TESTMORE% "%~1" ^|find /c ":"' ) DO CALL SET $testMore_plan=%%i
		%_DEBUG_% %$testMore_plan% Found
	ENDLOCAL&CALL SET "%~2=%$testMore_plan%
GOTO :EOF :PLAN_TESTMORE

::----------------------------------------------------------------------
:_state
	::ECHO:$testMore_done=%$testMore_done% $testMore_ok=%$testMore_ok% $testMore_fail=%$testMore_fail%
	::ECHO:$testMore_done=%$testMore_done%
GOTO :EOF

::*** End of File ******************************************************