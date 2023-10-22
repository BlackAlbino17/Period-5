:- use_module(library(lists)).
:- consult('board.pl').
:- consult('utils.pl').

% Define a predicate to start the game loop.

start_game :-
    % Initialize the initial board and other game parameters here.
    initialBoard(InitialBoard),
    display_initial_board,
    game_loop(InitialBoard, 'Player 1').

% Define the game loop predicate.
game_loop(Board, CurrentPlayer) :-
    write(CurrentPlayer), write('\'s turn.'), nl,

    make_move(Board, Row, Column, Row1, Column1, NewBoard),
    
    % Switch players and continue the game loop
    switch_player(CurrentPlayer, NextPlayer),
    game_loop(NewBoard, NextPlayer).


% Predicate to switch players.
switch_player('Player 1', 'Player 2').
switch_player('Player 2', 'Player 1').


% Predicate to make a move.
make_move(Board, Row, Column, Row1, Column1, NewBoard) :-
    nl,
    write('Which piece do you want to move?'), nl,
    write('Row: '), nl, read(Row),
    write('Column: '), nl, read(Column),
    write('Where do you want to place it?'), nl,
    write('Row: '), nl, read(Row1),
    write('Column: '), nl, read(Column1),
    placePieceAndRemove(Board, Row, Column, Row1, Column1, NewBoard).

% Predicado para mover a peça e remover a peça na posição original.
placePieceAndRemove(Board, Row, Column, Row1, Column1, NewBoard) :-
    % Get the piece from the original cell.
    nth1(Row, Board, Line),
    nth1(Column, Line, Piece),

    % Remove the piece from the original cell.
    removePiece(Board, Row, Column, TempBoard),

    % Place the piece in the new cell.
    placePiece(TempBoard, Piece, Row1, Column1, NewBoard),
    header,
    display_board(NewBoard, 1, 1),
    nl,
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




