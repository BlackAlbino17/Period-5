:- use_module(library(lists)).
:- consult('logic.pl').
:- consult('utils.pl').
:- consult('board.pl').

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




