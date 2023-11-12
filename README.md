# Usage
To solve a Sudoku, create a text file that contains the existing and missing numbers, seperated by spaces. 
A missing number is denoted by any non-digit character. For example:
```
X X 8 1 X X 5 X X
9 6 X X 8 X X X X
X 5 X X 3 6 X 9 8
X X 7 X 6 9 X 1 2
X X 6 8 X 7 3 X X
8 1 X 4 5 X 6 X X
4 2 X 6 7 X X 8 X
X X X X 4 X X 6 3
X X 5 X X 8 7 X X
```
To run the GUI Solver, run `./SudokuGUI`. Afterwards, select the file using the GUI and click "Solve".

To solve the Sudoku using the command line binary, call `./Sudoku <my_text_file>`. This will print the Sudoku grid before and after it was solved.
# Example Screenshot

![Screenshot_20231112_222918](https://github.com/mamei16/GUI-Sudoku-Solver/assets/25900898/6eaca0c3-462b-4d4f-bc05-6163a886ab29)