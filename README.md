# DataFinder

Console app that reads specific data from a given text file and presents it on the screen after certain validation checks.

### Technologies: 
macOS, XCode 8.2 Beta, Swift 3, Git, XCTest(Unit Testing).

## Completed Tasks:
   
- App requires 3 arguments from user in console with filepath being mandatory and sort by date, search by project id, as optional.
- Dates (Start date) and money (Savings amount) values conform to certain 
format.
- Columns "Savings amount" and "Currency" can have empty values denoted
as NULL. Those should be printed as empty values.
- Column "Complexity" has a certain set of values (Simple, Moderate, Hazardous). 
The program should report an error if a source value differs from those three
but keep in mind that more options can be added in the future.
- The output should also have a header line.
- Lines that are empty or start with comment mark # are skipped.
- Order (but not names) of columns might be changed in future.
-  In case of an invalid source value (in a date, money or Complexity column) a
descriptive error message should be printed to console and the program terminated.


## Ongoing/Possible Tasks:
- App currently runs in XCode console. Can be implemented for terminal run.
- Testing/Bug fixing.

## Source Files Details:

### main
Handles user input and runs program.

### DataProcessor 
Holds application logic, reading file, cleaning, formatting, processing, validating and printing of data.

### DecimalExtension 
Returns number of decimal points in a number.

### DataFinderTests 
Unit tests of important functions.
