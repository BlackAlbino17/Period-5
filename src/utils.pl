header:- write('  |    1   |    2   |    3   |    4   |    5   |'), nl.


/*
is_player_piece(+Board, +Player, +Row, +Column, -Piece)
Predicate to help define if a piece belongs or not to a player.
*/
is_player_piece(Board, Player, Row, Column, Piece):-
    nth1(Row, Board, Line),
    nth1(Column, Line, Piece),
    get_piece(Piece, Player).
