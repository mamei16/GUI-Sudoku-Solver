project('SudokuSolver', 'vala', 'c')

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
]

dependencies_gui = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gtk4')
]

sources = files(
    'Sudoku.vala',
    'PlayField.vala'
)

sources_gui = files(
    'Sudoku.vala',
    'PlayField.vala',
    'SudokuGUI.vala',
)

i18n = import('i18n')
# define GETTEXT_PACKAGE
add_project_arguments('-DGETTEXT_PACKAGE="intltest"', language:'c')
i18n.gettext(meson.project_name())

add_project_link_arguments('-lffi', language: 'c') 

#executable('Sudoku', sources, dependencies: dependencies)
executable('SudokuGUI', sources_gui, dependencies: dependencies_gui)
