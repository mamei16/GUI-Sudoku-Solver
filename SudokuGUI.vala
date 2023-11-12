public class SudokoGUI : Gtk.Application{

    private Gtk.Window main_window;
    private Gtk.Grid unsolved_sudoku_table;
    private Gtk.Label unsolved_sudoku_label;
    private Gtk.Grid solved_sudoku_table;
    private Gtk.Label solved_sudoku_label;
    private Sudoko sudoku;

    construct {
        flags |= ApplicationFlags.FLAGS_NONE;
        application_id = "com.Sudoku.GUISolver";
    }

    void fill_playfield_from_file(Gtk.Dialog dialog, int response) { 
      if (response == Gtk.ResponseType.ACCEPT){
        update_label(unsolved_sudoku_label, format_label_str("Unsolved"));
        update_label(solved_sudoku_label, format_label_str("Ready"));
        solved_sudoku_table.set_opacity(0.0d);
        Gtk.FileChooser chooser = (Gtk.FileChooser) (dialog);
    
        var file = chooser.get_file();

        sudoku.playfield.from_file(file.get_path());
        fill_sudoku_table(unsolved_sudoku_table, sudoku.playfield.field);
        fill_sudoku_table(solved_sudoku_table, sudoku.playfield.field);
      }
      dialog.close();
    }
      
    public void init_from_file() {
      var dialog = new Gtk.FileChooserDialog("Open File", main_window, Gtk.FileChooserAction.OPEN,
                                         _("_Cancel"), Gtk.ResponseType.CANCEL, _("_Open"), Gtk.ResponseType.ACCEPT, null);
      dialog.present();
      dialog.response.connect(fill_playfield_from_file);
    }

    public string format_label_str(string str, string foreground_color="#ffffff") {
      return @"<b><span font='20' foreground='$(foreground_color)'> $(str) </span></b>";
    }

    public void update_label(Gtk.Label label, string new_text) {
      label.set_text(new_text);
      label.set_use_markup(true);
    }

    public void set_frame_margins(Gtk.Frame f, int i, int j) {
      int wide = 10;
      switch (i) {
        case 2:
        case 5:
          f.set_margin_bottom(wide); 
          break;
      }
      switch (j) {
        case 2:
        case 5:
          f.set_margin_end(wide);
          break;
      }
    } 

    public Gtk.Grid init_sudoku_table() {
      var sudoku_table = new Gtk.Grid();
      sudoku_table.set_row_spacing(5);
      sudoku_table.set_column_spacing(5);

      for (int i = 0; i < PlayField.SIZE; i++) {
        for (int j = 0; j < PlayField.SIZE; j++) {
          var label_frame = new Gtk.Frame(null);
          set_frame_margins(label_frame, i, j);
          sudoku_table.attach(label_frame, j, i, 1, 1);
          var label = new Gtk.Label(format_label_str("0", "#717171"));
          label.use_markup = true;
          label_frame.set_child(label);
        }
      }
      return sudoku_table;
    }

    public void fill_sudoku_table(Gtk.Grid table, int[,] values, bool after_solve = false) {
      string new_text;
      for (int i = 0; i < PlayField.SIZE; i++) {
        for (int j = 0; j < PlayField.SIZE; j++) {
          Gtk.Frame label_frame = (Gtk.Frame) table.get_child_at(j, i);
          Gtk.Label label = (Gtk.Label) label_frame.get_child();
          var cell_str_val = values[i, j].to_string();
          if (after_solve && label.get_text() == " 0 ") {
            new_text = format_label_str(cell_str_val, "#24ff17");
          }
          else if (cell_str_val == "0") {
            new_text = format_label_str(cell_str_val, "#717171");
          }
          else {
            new_text = format_label_str(cell_str_val);
          }
          update_label(label, new_text);
        }
      }
    }

    public void solve_sudoku() {
      int64 msec = GLib.get_monotonic_time();
      bool solved = sudoku.solve(sudoku.playfield, 0, 0);
      msec = GLib.get_monotonic_time() - msec;
      if (solved){
          fill_sudoku_table(solved_sudoku_table, sudoku.playfield.field, true);
          solved_sudoku_table.set_opacity(1.0d);
          double time_ms = (double) msec / 1000;
          update_label(solved_sudoku_label, format_label_str("Solved") + "(%.2lf ms)".printf(time_ms));
      } 
      else {
        update_label(solved_sudoku_label, format_label_str("Could not solve."));
      }
    }

    public override void activate() {
      main_window = new Gtk.ApplicationWindow(this);
      main_window.set_title("Sudoku Solver");
      sudoku = new Sudoko();
      sudoku.playfield = new PlayField();
      int margin = 5;

      var sudoku_gtk_grid = new Gtk.Grid();
      sudoku_gtk_grid.set_halign(Gtk.Align.CENTER);
      sudoku_gtk_grid.set_valign(Gtk.Align.CENTER);

      main_window.set_child(sudoku_gtk_grid);

      unsolved_sudoku_label = new Gtk.Label(format_label_str(" "));
      unsolved_sudoku_label.set_use_markup(true);
      var unsolved_labelframe = new Gtk.Frame(null);
      unsolved_labelframe.set_child(unsolved_sudoku_label);
      sudoku_gtk_grid.attach(unsolved_labelframe, 0, 0, 1, 1);
      var unsolved_sudoku_frame = new Gtk.Frame(null);
      sudoku_gtk_grid.attach(unsolved_sudoku_frame, 0, 1, 1, 1);
      unsolved_sudoku_table = init_sudoku_table();
      unsolved_sudoku_table.set_margin_top(margin);
      unsolved_sudoku_table.set_margin_bottom(margin);
      unsolved_sudoku_table.set_margin_start(margin);
      unsolved_sudoku_table.set_margin_end(margin);
      unsolved_sudoku_frame.set_child(unsolved_sudoku_table);

      solved_sudoku_label = new Gtk.Label(format_label_str(" "));
      solved_sudoku_label.set_use_markup(true);
      var solved_labelframe = new Gtk.Frame(null);
      solved_labelframe.set_child(solved_sudoku_label);
      sudoku_gtk_grid.attach(solved_labelframe, 1, 0, 1, 1);
      var solved_sudoku_frame = new Gtk.Frame(null);
      sudoku_gtk_grid.attach(solved_sudoku_frame, 1, 1, 1, 1);
      solved_sudoku_table = init_sudoku_table();
      solved_sudoku_table.set_margin_top(margin);
      solved_sudoku_table.set_margin_bottom(margin);
      solved_sudoku_table.set_margin_start(margin);
      solved_sudoku_table.set_margin_end(margin);
      solved_sudoku_frame.set_child(solved_sudoku_table);
      solved_sudoku_table.set_opacity(0.0d);

      var btn_open_file = new Gtk.Button.with_label("Open File");
      btn_open_file.clicked.connect(init_from_file);
      sudoku_gtk_grid.attach(btn_open_file, 0, 2, 1, 1);

      var btn_solve = new Gtk.Button.with_label("Solve");
      btn_solve.clicked.connect(solve_sudoku);
      sudoku_gtk_grid.attach(btn_solve, 1, 2, 1, 1);

      main_window.present();
    }


    public static int main(string[] args) {
      var app = new SudokoGUI();
      return app.run(args);
    }
}