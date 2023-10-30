:- use_module(library(sets)).
:- use_module(library(between)).
:- consult('logic.pl').
:- consult('utils.pl').
:- consult('board.pl').




start_game :-
    initialBoard(InitialBoard),
    display_initial_board,
    game_loop(InitialBoard, 'Player 1').


game_loop(Board, CurrentPlayer) :-
    write(CurrentPlayer), write('\'s turn.'), nl,
    
   (opponent_winning_next_move(Board, CurrentPlayer) -> 
    \+ is_player_piece(' cube ', CurrentPlayer); 
    is_player_piece(' cube ', CurrentPlayer)),

    make_move(Board, Row, Column, Row1, Column1, NewBoard, CurrentPlayer),
    
    (player_victory(Board, CurrentPlayer) -> end_game(CurrentPlayer); true),
    switch_player(CurrentPlayer, NextPlayer),
    game_loop(NewBoard, NextPlayer).



player_victory(Board, CurrentPlayer):- 
    color_check(Board, Player),
    one_piece_per_column_check(Board, Player).

end_game(Player) :-
    display_end_game_menu(Player),
    ask_eog_option(Choice),
    end_game_option(Choice).
