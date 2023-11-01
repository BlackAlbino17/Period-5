:- consult('input.pl').
:- consult('board.pl').
:- consult('logic.pl').
:- consult('utils.pl').
:- consult('game.pl').


display_main_menu :-
    write('************************************'), nl,
    write('*        Welcome to Period 5       *'), nl,
    write('************************************'), nl,
    write('Main Menu:'), nl,
    write('1. Player vs Player'), nl,
    write('2. Player vs Computer'), nl,
    write('3. Computer vs Computer'), nl,
    write('4. Quit'), nl,
    write('Enter Your Choice: ').

ask_option(Choice) :-
    display_main_menu,
    read(Choice).

menu_option(1) :- player_player, play.
menu_option(2) :- player_ai, play.
menu_option(3) :- ai_ai, play.
menu_option(4) :- true.
menu_option(_) :- write('Invalid choice'), nl, play.



player_player:-
            CurrentPlayer = 'Player 1',
            NextPlayer = 'Player 2',
            start_game(CurrentPlayer,NextPlayer).

player_ai:-
            CurrentPlayer = 'Player 1',
            NextPlayer = 'AI',
            start_game(CurrentPlayer,NextPlayer).

play :- ask_option(Choice),
        menu_option(Choice).



