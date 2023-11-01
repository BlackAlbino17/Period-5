:- dynamic counter/1, prevCubeX/1, prevCubeY/1.

:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(between)).
:- use_module(library(system)).
:- consult('logic.pl').
:- consult('utils.pl').
:- consult('board.pl').
:- consult('ai.pl').


% Define a predicate to start the game loop.

start_game :-
    % Initialize the initial board and other game parameters here.
    initialBoard(InitialBoard),
    display_initial_board,
    asserta(counter(0)),
    asserta(prevCubeX(3)),
    asserta(prevCubeY(3)),
    game_loop(InitialBoard, 'Player 1').

% Define the game loop predicate.
game_loop(Board, CurrentPlayer) :- 
    write(CurrentPlayer), write('\'s turn.'), nl,
    make_move(Board, Row, Column, Row1, Column1, NewBoard, CurrentPlayer),
    % Switch players and continue the game loop
    switch_player(CurrentPlayer, NextPlayer),
    game_loop(NewBoard, NextPlayer).




