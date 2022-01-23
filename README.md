## testMore.cmd

### NAME

testMore.cmd -- DOS Batch implementation of Perl's Test::More test framework
 
### SYNOPSIS
- `testMore.cmd [Options]`
- `testMore.cmd [Function]`
 
### OPTIONS

.|.
---|---
`-h`      |Help page
`--help`  |Help page
 
### DESCRIPTION

The purpose of this module is to provide a wide range of testing utilities.
Various ways to say "ok" with better diagnostics, facilities to skip tests,
test future features and compare complicated data structures. 

While you can do almost anything with a simple :ok function, 
it doesn't provide good diagnostic output.

### TESTS  

Test | Purpos
---|---
`:plan No_of_tests`	| Declare the entended no of tests to run
`:done_testing`	| The result of all your testing according to plan
`:ok ERRORLEVEL $test_name`	| Evaluate a TRUE expression
`:like $got "/expected/i"  $test_name`	| Similar to :ok using regex
`:is $got $expected $test_name`	| Compare arguments with eq
`:isnt $got $expected $test_name`	| Compare arguments with ne
`:pass $test_name`	| Just pass and forget
`:fail $test_name`	| Just fail and go on
`:skip`	| declares a block of tests
`:TODO`	| Declares a block of tests you expect to fail and $why.
`:BAIL_OUT $reason`	| Bail out and stop all processing
`:diag`	| Print diagnostic message
`:note`	| Print a note
`:explain`	| Will dump in a human readable format
`:harness diag func args...`	| Test harness to handle valid failures

### Not implemented

Test | Purpos
---|---
`:unlike $got qr/expected/ $test_name`	| Check match with regex
`:cmp_ok`	|This allows you to compare two arguments using any binary perl operator. 
`:isa_ok $object   $class $object_name`	| NOT implemented
`:isa_ok $subclass $class $object_name`	| NOT implemented
`:isa_ok $ref      $type  $ref_name`	| NOT implemented
`:isa_ok on that object.
`:subtest $name => \&code, @args;`	| NOT implemented
`:subtest` |runs the &code as its own little test with its own plan and its
`:require_ok`	| Cannot be implemented, since BATCH has no include function
`:use_ok`	| Cannot be implemented, since BATCH has no include function
`:is_deeply`	| Cannot be implemented, since BATCH has no structure functions.

### General functions

Test | Purpos
---|---
`:skiplastarg`	| Return all but last arg in variable given in arg1
`:lastarg`	| Return last arg in variable given in arg1
`:strLen`	| returns the length of a string
`:extractFileSection`	| extracts a section of file that is defined by a start and end mark

Functions with prefix  ":_" are all for internal use only = not addressable
 
### EXAMPLES

```batch
CALL testMore :plan 2
CALL testMore          :ok 0 "	[OK    ]	ok:Test 0"
CALL testMore :harness :ok 1 "	[OK/fail]	ok:Test 1"
CALL testMore :done_testing
```

- Plan to run 2 tests
- First test has an Errorlevel of 0 (= OK)
- Second test has an Errorlevel of 1 (= Error), but this is expected and valid. The harness ensures that the result is OK since the "Failure" is valid
- Get the result
 
Please see unitTest.testMore.cmd for a more extended example
 
### EXIT STATUS

### ENVIRONMENT

### FILES

### BUGS / KNOWN PROBLEMS

### REQUIRES

- testMore.cmd
 
### SEE ALSO
  
  
### REFERENCE
- Author: 
- URL: https://metacpan.org/pod/Test::More
- URL: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes
- URL: https://en.wikipedia.org/wiki/Test::More
 

### SOURCE

.|.
---|---
Author       | Erik Bachmann, ClicketyClick.dk [ErikBachmann@ClicketyClick.dk]
Copyright    | http://www.gnu.org/licenses/lgpl.txt LGPL version 3
Since        | 2022-01-21T20:54:11 / erba
Version      | 01.03
Release      | 2022-01-23T21:02:24

---

## unitTest.testMore.cmd

### NAME

unitTest.testMore.cmd -- Unit Test for testMore.cmd - test framework
 
### SYNOPSIS

- `unitTest.testMore.cmd [Options]`
- `unitTest.testMore.cmd [Function]`
 
### OPTIONS

.|.
---|---
`-h`      |Help page
`--help`  |Help page
 
### DESCRIPTION

Unit Test for testMore.cmd - test framework

### TESTS  

- :OK
- :IS
- :ISNT
- :LIKE
- :PASS / :FAIL

### FILES

- file1 = Base file for comparing
- file2 = Identical copy
- file3 = Diverting file

### BUGS / KNOWN PROBLEMS

### REQUIRES
- `testMore.cmd`
 
### SEE ALSO
  
### REFERENCES

.|.
---|---
Author: |
URL: | https://metacpan.org/pod/Test::More
URL: | https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes
URL: | https://en.wikipedia.org/wiki/Test::More

### SOURCE

.|.
---|---
Author       | Erik Bachmann, ClicketyClick.dk [ErikBachmann@ClicketyClick.dk]
Copyright    | http://www.gnu.org/licenses/lgpl.txt LGPL version 3
Since        | 2022-01-21T20:54:11 / erba
Version      | 01.03
Release      | 2022-01-23T21:25:41
