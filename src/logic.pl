
% Predicate to make a move.
make_move(Board, Row, Column, Row1, Column1, NewBoard, Player) :-
    repeat,
    nl,
    ((Player == 'Player 1'; Player == 'Player 2') ->   
    write('Which piece do you want to move?'), nl,
    write('Row: '), nl, read(Row),
    write('Column: '), nl, read(Column),
    is_player_piece(Board, Player, Row, Column, Piece),
    write('Where do you want to place it?'), nl,
    write('Row: '), nl, read(Row1),
    write('Column: '), nl, read(Column1),
    valid_piece_move(Board, Row, Column, Row1, Column1, Piece),
    ((counter(Counter),Counter == 0, Piece == ' cube '  )-> retract(counter(0)), asserta(counter(1)), set_prevCubePos(Row,Column);
    (counter(Counter),Counter == 1, Piece == ' cube '  )-> \+ cube_non_repeated_move(Row, Column, Row1, Column1),fail;
    (counter(Counter),Counter == 1, Piece == ' cube '  )-> cube_non_repeated_move(Row, Column, Row1, Column1);
    (counter(Counter),Counter == 1)->retract(counter(1)), asserta(counter(0));
    true),
    placePieceAndRemove(Board, Row, Column, Row1, Column1, NewBoard);
    level(Player,Level) -> ai_move(Board, Player, Row, Column, Row1, Column1,NewBoard,Level)
    ).




% Predicado para mover a peça e remover a peça na posição original.
placePieceAndRemove(Board, Row, Column, Row1, Column1, NewBoard) :-
    % Get the piece from the original cell.
    nth1(Row, Board, Line),
    nth1(Column, Line, Piece),

    % Remove the piece from the original cell.
    removePiece(Board, Row, Column, TempBoard),

    % Place the piece in the new cell.
    placePiece(TempBoard, Piece, Row1, Column1, NewBoard).



% Implement the update_board predicate to update the game board based on the move.

replace([_|T], 1, X, [X|T]) :- !.
replace([H|T], I, X, [H|R]) :- I > 1,
                    NI is I-1,
                    replace(T, NI, X, R).

placePiece(Board, Piece, X, Y, NewBoard) :- 

                        nth1(X, Board, Line),
                        replace(Line, Y, Piece, NewLine),
                        replace(Board, X, NewLine, NewBoard).


removePiece(Board, X, Y, NewBoard) :- 
                        nth1(X, Board, Line),
                        replace(Line, Y, '------', NewLine),
                        replace(Board, X, NewLine, NewBoard).


landing_on_occupied_square(Board, Row1, Column1, Piece) :-
    nth1(Row1, Board, Line),
    nth1(Column1, Line, Occupied),
    Occupied \== '------',
    Occupied \== Piece.


piece_jumps_over(Board, Row, Column, Row1, Column1) :-
    \+ is_empty_path(Board, Row, Column, Row1, Column1),
    \+ is_empty_path(Board, Row1, Column1, Row, Column).

is_empty_path(Board, Row, Column, Row1, Column1) :-
    Row < Row1, is_empty_between_rows(Board, Row, Row1, Column).
is_empty_path(Board, Row, Column, Row1, Column1) :-
    Row > Row1, is_empty_between_rows(Board, Row1, Row, Column).
is_empty_path(Board, Row, Column, Row1, Column1) :-
    Column < Column1, is_empty_between_columns(Board, Row, Column, Column1).
is_empty_path(Board, Row, Column, Row1, Column1) :-
    Column > Column1, is_empty_between_columns(Board, Row, Column1, Column).

is_empty_between_rows(Board, Row, Row1, Column) :-
    Row2 is Row + 1,
    (Row2 == Row1; (nth1(Row2, Board, Line), nth1(Column, Line, '------'), is_empty_between_rows(Board, Row2, Row1, Column))).
is_empty_between_columns(Board, Row, Column, Column1) :-
    Column2 is Column + 1,
    (Column2 == Column1; (nth1(Row, Board, Line), nth1(Column2, Line, '------'), is_empty_between_columns(Board, Row, Column2, Column1))).

orthogonally_moved(Row, Column, Row1, Column1) :-
    (Row == Row1, abs(Column - Column1) >= 1; Column == Column1, abs(Row - Row1) >= 1).

valid_piece_move(Board, Row, Column, Row1, Column1, Piece) :-
    orthogonally_moved(Row, Column, Row1, Column1),
    \+ piece_jumps_over(Board, Row, Column, Row1, Column1),
    \+ landing_on_occupied_square(Board, Row1, Column1, Piece).


% Predicate to handle a cube move.

cube_non_repeated_move(Row, Column, Row1, Column1) :-
    prevCubeX(X),
    prevCubeY(Y),
    dif(X, Row1); dif(Y,Column1),
    set_prevCubePos(Row,Column).

set_prevCubePos(Row,Column):-
    retract(prevCubeX(X)),
    retract(prevCubeY(Y)),
    asserta(prevCubeX(Row)),
    asserta(prevCubeY(Column)).


get_all_player_moves(Board, Player, ValidMoves) :-
    get_all_player_pieces_positions(Board, Player, Positions),
    get_moves(Positions, Player, Board, [], ValidMoves).

get_moves([], _, _, ValidMoves, ValidMoves).
get_moves([(Row, Column) | Rest], Player, Board, Acc, ValidMoves) :-
    findall((Row, Column, Row1, Column1), (
        between(1, 5, Row1),
        between(1, 5, Column1),
        valid_piece_move(Board, Row, Column, Row1, Column1, Piece),
        is_player_piece(Board, Player, Row, Column, Piece)
    ), Moves),
    append(Acc, Moves, NewAcc),
    get_moves(Rest, Player, Board, NewAcc, ValidMoves).


get_all_player_pieces_positions(Board, Player, Positions) :-
    findall((Row, Column), (
        nth1(Row, Board, Line),
        nth1(Column, Line, Piece),
        get_piece(Piece, Player)
    ), Positions).






winning_next_move(Board, Player) :-

    get_all_player_moves(Board, Player, ValidMoves),
    member((Row, Column, Row1, Column1), ValidMoves),
    simulate_move(Board, Row, Column, Row1, Column1, SimulatedBoard, Player).


simulate_move(Board, Row, Column, Row1, Column1, NewBoard, Player) :-
    copy_term(Board, NewBoard),
    placePieceAndRemove(NewBoard, Row, Column, Row1, Column1, Recent),
    one_piece_per_column_check(Recent, Player),
    color_check(Recent, Player).

winning_state(Board, Player, Row, Column, Row1, Column1) :-
    get_all_player_moves(Board, Player, ValidMoves),
    member((Row, Column, Row1, Column1), ValidMoves),
    simulate_move(Board, Row, Column, Row1, Column1, SimulatedBoard, Player),
    !.


get_player_colors(Board, Player, PlayerColors, BoardColors) :-
    initialBoardColor(BoardColors),
    findall(Color, (
        nth1(Row, Board, Line), 
        nth1(Column, Line, Piece),
        get_piece(Piece, Player),
        nth1(Row, BoardColors, RowColors),
        nth1(Column, RowColors, Color)
    ), RawPlayerColors),
    list_to_set(RawPlayerColors, PlayerColors).

% Predicado Para Player has 5 Colors
color_check(Board, Player) :-
    get_player_colors(Board, Player, PlayerColors, _),
    length(PlayerColors, 5).  

/*------------------------------------------------------------------------------------------------------------------------------------------------- */
% Predicado Para Player1 or 2 has 1 Piece In Each Column
 
 one_piece_per_column_check(Board, Player) :-
    findall(Column,
    (
        between(1, 5, Column),
        member(Row, [1, 2, 3, 4, 5]),
        is_player_piece(Board, Player, Row, Column,Piece)

    ), Columns),
    list_to_set(Columns, UniqueColumns),
    length(UniqueColumns, 5).



  