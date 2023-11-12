class Sudoko : GLib.Object {
    public PlayField playfield;
    bool solved;

    public bool solve(PlayField sudoku,int i,int j) {
        bool rec;                                            //True if recursion was successful
        bool worked = false;                                 //True if a value can be put into some cell
        if (i >= PlayField.SIZE) {                              //If row number is bigger than num. of actual rows (Sudoku solved)
            return true;
        }
        else if (j >= PlayField.SIZE) {                       //Moves to the next row if column number exceeds actual number of columns.
            return solve(sudoku, i + 1, 0);
        }
        else if (sudoku.is_empty(i, j)) {
            for (int k = 1; k <= PlayField.SIZE; k++) {
                worked = sudoku.try_value(k, i, j);              //See if num. between 1-9 can be put into cell i,j
                if (worked) {
                    rec = solve(sudoku,i,j+1);                  //If yes, recursively test if sudoku can be solved from here.
                    if (rec) { return true; }
                    else{ sudoku.clear(i,j); }                     //If it can't be solved, clear the field again and increase num.
                }
            }
            if (!worked) {                                    //If no num. can be put into cell i,j: move back up in recursion
                sudoku.clear(i,j);                            // i.e. try to increase the num. of the previous cell.
                return false;
            }
        }
        else {
            return solve(sudoku,i,j+1);                         //If the cell is not empty, move to the next cell
        }
        return false;
    }
    /*
    public static int main(string[] args) {
        Sudoko solver = new Sudoko();
        solver.playfield = new PlayField();
        var success = solver.playfield.from_file(args[1]);
        if (!success) {
            return -1;
        }
        print("Unsolved:\n");
        solver.playfield.print_field();
        int64 msec = GLib.get_monotonic_time();
        solver.solved = solver.solve(solver.playfield, 0, 0);
        msec = GLib.get_monotonic_time()- msec;
        if (solver.solved){
            double time_ms = (double) msec / 1000;
            stdout.printf("Solved in %.2lf ms!\n", time_ms);
            solver.playfield.print_field();
        } else print("Could not solve.\n");

        return 0;
    }
    */
}
