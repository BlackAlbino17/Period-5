easy_level_ai(Board, Player, Row, Column, Row1, Column1,NewBoard) :- 
    get_all_player_moves(Board, Player, ValidMoves),
    random_member((Row, Column, Row1, Column1), ValidMoves),
    ((counter(Counter),Counter == 0, Piece == ' cube '  )-> retract(counter(0)), asserta(counter(1)), set_prevCubePos(Row,Column);
    (counter(Counter),Counter == 1, Piece == ' cube '  )-> \+ cube_non_repeated_move(Row, Column, Row1, Column1),fail;
    (counter(Counter),Counter == 1, Piece == ' cube '  )-> cube_non_repeated_move(Row, Column, Row1, Column1),nl;
    (counter(Counter),Counter == 1)->retract(counter(1)), asserta(counter(0));
    true),
    sleep(2),
    placePieceAndRemove(Board, Row, Column, Row1, Column1, NewBoard),
    nl,write('From row '),write(Row),write(' column '),write(Column),nl,write('To row '),write(Row1),write(' column '),write(Column1),nl.


ai_move(Board, Player, Row, Column, Row1, Column1,NewBoard,1) :-
    easy_level_ai(Board, Player, Row, Column, Row1, Column1,NewBoard).

ai_move(Board, Player, Row, Column, Row1, Column1,NewBoard,1) :-
    hard_level_ai(Board, Player, Row, Column, Row1, Column1,NewBoard).



