easy_level_ai(Board, Player, Row, Column, Row1, Column1,NewBoard) :- 
    get_all_player_moves(Board, Player, ValidMoves),
    random_member((Row, Column, Row1, Column1), ValidMoves),
    ((counter(Counter),Counter == 0, Piece == ' cube '  )-> retract(counter(0)), asserta(counter(1)),counter(X),write(X),nl, set_prevCubePos(Row,Column);
    (counter(Counter),Counter == 1, Piece == ' cube '  )-> \+ cube_non_repeated_move(Row, Column, Row1, Column1),fail;
    (counter(Counter),Counter == 1, Piece == ' cube '  )-> cube_non_repeated_move(Row, Column, Row1, Column1),nl,counter(X),write(X),nl;
    (counter(Counter),Counter == 1)->retract(counter(1)), asserta(counter(0));
    true),
    sleep(2),
    placePieceAndRemove(Board, Row, Column, Row1, Column1, NewBoard),
    write(Row),nl,write(Column),nl,write(Row1),nl,write(Column1).


