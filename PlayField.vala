public class PlayField : GLib.Object {
    public const int SIZE = 9;
    public int[,] field = new int[SIZE,SIZE];

    public bool is_empty(int i, int j){ return (field[i,j] == 0); }

    public void clear(int i,int j){ field[i, j] = 0; }

    /** The purpose of this subroutine is to print a Sudoku playing field.
     * It also adds some characters to emulate the look of a real Sudoku.*/
    public void print_field(){
        print("\n");
        print("+-------+-------+-------+\n");
        for (int i = 0; i < SIZE; i++) {
            if (i == 3 || i == 6) print("+-------+-------+-------+\n");
            for (int j = 0; j < SIZE; j++) {
                if (j == 0) print("| ");
                print(@"$(field[i,j]) ");
                switch (j) {
                    case 2:
                    case 5:
                    case 8:
                        print("| ");
                        break;
                }
                if (i == 8 && j == 8) print("\n+-------+-------+-------+\n");
                if (j == 8) print("\n");
            }
        }
    }

    /**This subroutine is used to initialize the Sudoku field. To do is this, it creates a new file object
     * from the parameter file name and fills the Sudoku grid with loops. It also converts the input strings
     * to integers.
     * @param filename The absolute path of the input file.
     */

    public bool from_file(string filename){
        int num, curr_pos, column_length, real_j;
        bool success;
        string content, curr_str;
        try {
            FileUtils.get_contents(filename, out content);
        }
        catch (FileError e) {
            print(@"$(e.message)");
            return false;
        }
        // There is a space between each two ints + "\n" at the end of each line
        column_length = SIZE + SIZE;
        for (int i=0; i<SIZE; i++){
            real_j = 0;  // The actual column in the "field" array
            for (int j=0; j<column_length; j++) {
                curr_pos = (i * column_length) + j;
                curr_str = content[curr_pos].to_string();
                if (curr_str == " ") {
                    continue;
                }
                success = int.try_parse(curr_str, out num);
                if (success) {
                    field[i, real_j] = num;
                }
                else {
                    field[i, real_j] = 0; //When an X is encountered in the input, insert a 0
                }
                real_j++;
            }
        }
        return true;
    }

    public bool check_block(int block, int val) {
        int min_j, max_j, min_i, max_i, i, j;
        min_i = (block / 3) * 3;
        max_i = min_i + 3;
        min_j = (block % 3) * 3;
        max_j = min_j + 3;
        for (i = min_i; i < max_i; i++) {
            for (j = min_j; j < max_j; j++) {
                if (field[i, j] == val) return false;
            }
        }
        return true;
    }

    /**This subroutine is used to check whether or not a value val can be placed
     * in the Sudoku grid at position i,j. If yes, the value is inserted in the cell
     * and the subroutine returns true, otherwise it returns false.
     * @param val The value to be tested. Has to be in interval 1-9, including 9.
     * @param i Row number. Has to be in interval 1-9, including 9.
     * @param j Column number. Has to be in interval 1-9, including 9.
     * @return
     */
    public bool try_value(int val,int i,int j) {
        int k;
        bool success;
        int block = 0;
        //Check in which of the 9 blocks cell i,j is located
        if (i < 3 && j < 3)                              block = 0;
        else if (i < 3 && j > 2 && j < 6)                block = 1;
        else if (i < 3 && j > 5 && j < SIZE)             block = 2;
        else if (i < 6 && i > 2 && j < 3)                block = 3;
        else if (i < 6 && i > 2 && j < 6 && j > 2)       block = 4;
        else if (i < 6 && i > 2 && j < SIZE && j > 5)    block = 5;
        else if (i < SIZE && i > 5 && j < 3)             block = 6;
        else if (i < SIZE && i > 5 && j < 6 && j > 2)    block = 7;
        else if (i < SIZE && i > 5 && j > 5 && j < SIZE) block = 8;

        //Check horizontal and vertical rows
        for (k = 0; k < SIZE; k++) {
            if (field[k, j] == val) return false;
            else if (field[i, k] == val) return false;
        }
        success = check_block(block, val);
        if (!success) return false;
        field[i, j] = val;
        return true;
    }
}
