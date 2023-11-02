:- use_module(library(sets)).
:- use_module(library(between)).
:- use_module(library(random)).
:- consult('logic.pl').
:- consult('utils.pl').
:- consult('board.pl').
:- consult('input.pl').
:- consult('menu.pl').
:- consult('ai.pl').



start_game :-
    initialBoard(InitialBoard),
    display_initial_board,
    game_loop(InitialBoard, 'Player 1').


game_loop(Board, CurrentPlayer) :-
    write(CurrentPlayer), write('\'s turn.'), nl,
    (player_victory(Board, CurrentPlayer) -> end_game(CurrentPlayer); true),
    make_move(Board, Row, Column, Row1, Column1, NewBoard, CurrentPlayer),
    (player_victory(NewBoard, CurrentPlayer) -> end_game(CurrentPlayer); true),
    
    header,
    display_board(NewBoard, 1, 1),
    nl,
    display_color_board,

/*
    (winning_next_move(NewBoard, CurrentPlayer) -> 
       \+ get_piece(' cube ', NextPlayer); 
       get_piece(' cube ', NextPlayer)),
*/
    switch_player(CurrentPlayer, NextPlayer),
    game_loop(NewBoard, NextPlayer).



player_victory(Board, CurrentPlayer):- 
    color_check(Board, CurrentPlayer),
    one_piece_per_column_check(Board, CurrentPlayer).

end_game(CurrentPlayer) :-
    display_end_game_menu(CurrentPlayer),
    ask_eog_option(Choice),
    end_game_option(Choice).








