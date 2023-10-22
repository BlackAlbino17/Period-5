:- use_module(library(lists)).
:- consult('utils.pl').
:- consult('board.pl').


% Predicate to make a move.
make_move(Row, Column, Row1, Column1) :-
    nl,
    display_initial_board,
    write('Which piece do you want to move?'),nl,
    write('Row: '),nl, read(Row),
    write('Column'),nl, read(Column),
    write('Where do you want to place it?'),nl,
    write('Row: ') ,nl, read(Row1),
    write('Column'),nl, read(Column1),
    placePieceAndRemove(Row, Column, Row1, Column1, NewBoard).



% Predicado para mover a peça e remover a peça na posição original.
placePieceAndRemove(Row, Column, Row1, Column1, NewBoard) :-
    initialBoard(Board),

    % Get the piece from the original cell.
    nth1(Row, Board, Line),
    nth1(Column, Line, Piece),

    % Remove the piece from the original cell.
    removePiece(Board, Row, Column, TempBoard),

    % Place the piece in the new cell.
    placePiece(TempBoard, Piece, Row1, Column1, NewBoard),
    header,
    display_board(NewBoard,1,1),nl,
    display_color_board.

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