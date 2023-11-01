header:- write('  |    A   |    B   |    C   |    D   |    E   |'), nl.

is_player_piece(Board, Player, Row, Column, Piece):-
    nth1(Row, Board, Line),
    nth1(Column, Line, Piece),
    get_piece(Piece, Player).

initial_cube_position(3).

color(1, 1, 'black ').
color(1, 2, ' red  ').
color(1, 3, 'yellow').
color(1, 4, ' blue ').
color(1, 5, 'green ').

color(2, 1, ' red  ').
color(2, 2, 'yellow').
color(2, 3, ' blue ').
color(2, 4, 'green ').
color(2, 5, 'black ').

color(3, 1, 'yellow').
color(3, 2, ' blue ').
color(3, 3, 'green ').
color(3, 4, 'black ').
color(3, 5, ' red  ').

color(4, 1, ' blue ').
color(4, 2, 'green ').
color(4, 3, 'black ').
color(4, 4, ' red  ').
color(4, 5, 'yellow').

color(5, 1, 'green ').
color(5, 2, 'black ').
color(5, 3, ' red  ').
color(5, 4, 'yellow').
color(5, 5, ' blue ').


same_letter('a', 'A').
same_letter('b', 'B').
same_letter('c', 'C').
same_letter('d', 'D').
same_letter('e', 'E').
same_letter('f', 'F').
same_letter('g', 'G').
same_letter('h', 'H').
same_letter('i', 'I').
same_letter('j', 'J').
same_letter('k', 'K').
same_letter('l', 'L').
same_letter('m', 'M').
same_letter('n', 'N').
same_letter('o', 'O').
same_letter('p', 'P').
same_letter('q', 'Q').
same_letter('r', 'R').
same_letter('s', 'S').
same_letter('t', 'T').
same_letter('u', 'U').
same_letter('v', 'V').
same_letter('w', 'W').
same_letter('x', 'X').
same_letter('y', 'Y').
same_letter('z', 'Z').