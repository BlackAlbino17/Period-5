:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(between)).
:- use_module(library(system)).
:- use_module(library(sets)).

:- consult('input.pl').
:- consult('board.pl').
:- consult('logic.pl').
:- consult('utils.pl').
:- consult('game.pl').
:- consult('ai.pl').

:- dynamic counter/1, prevCubeX/1, prevCubeY/1, get_piece/2, level1/2, level2/2.

display_main_menu :-
    write('************************************'), nl,
    write('*        Welcome to Period 5       *'), nl,
    write('************************************'), nl,
    write('Main Menu:'), nl,
    write('1. Player vs Player'), nl,
    write('2. Player vs Computer'), nl,
    write('3. Computer vs Player'), nl,
    write('4. Computer vs Computer'), nl,
    write('5. Quit'), nl,
    write('Enter Your Choice: ').

ask_option(Choice) :-
    display_main_menu,
    read(Choice).

menu_option(1) :- player_player.
menu_option(2) :- player_ai.
menu_option(3) :- ai_player.
menu_option(4) :- ai_ai.
menu_option(5) :- halt.
menu_option(_) :- write('Invalid choice'), nl, play.



player_player:-
            CurrentPlayer = 'Player 1',
            NextPlayer = 'Player 2',
            start_game(CurrentPlayer,NextPlayer).

player_ai:-
            write('Select ai difficulty: '), nl,
            write('     1 - Easy '), nl,
            write('     2 - Hard '), nl,
            write('     3 - Go back '), nl,
            write('AI Level: '),
            read(Level),
            (Level == 3 -> play;
            CurrentPlayer = 'Player 1',
            NextPlayer = 'AI 1',
            asserta(level(NextPlayer,Level)),
            start_game(CurrentPlayer,NextPlayer)).

ai_player:-
            write('Select ai difficulty: '), nl,
            write('     1 - Easy '), nl,
            write('     2 - Hard '), nl,
            write('     3 - Go back '), nl,
            write('AI Level: '),
            read(Level),
            (Level == 3 -> play;
            CurrentPlayer = 'AI 1',
            NextPlayer = 'Player 1',
            asserta(level(CurrentPlayer,Level)),
            start_game(CurrentPlayer,NextPlayer)).

ai_ai:- 
            write('Select ai1 difficulty: '), nl,
            write('     1 - Easy '), nl,
            write('     2 - Hard '), nl,
            write('     3 - Go back '), nl,
            write('AI 1 Level: '),
            read(Level1),
            write('Select ai2 difficulty: '), nl,
            write('     1 - Easy '), nl,
            write('     2 - Hard '), nl,
            write('     3 - Go back '), nl,
            write('AI Level: '),
            read(Level2),
            ((Level1 == 3 ; Level2 == 3) -> play;
            CurrentPlayer = 'AI 1',
            NextPlayer = 'AI 2',
            asserta(level(CurrentPlayer,Level1)),
            asserta(level(NextPlayer,Level2)),
            start_game(CurrentPlayer,NextPlayer)).

play :- ask_option(Choice),
        menu_option(Choice).

display_end_game_menu(Player) :-
    nl,
    write('************************************'), nl,
    format('*        ~w wins the game!      *', [Player]), nl,
    write('************************************'), nl,

    write('1. Return to Menu'), nl,
    write('2. Exit'), nl,
    write('Enter Your Choice: ').

ask_eog_option(Choice) :-
    read(Choice).

end_game_option(1) :- play.
end_game_option(2) :- halt.
end_game_option(_) :- write('Invalid choice'), nl, play.    

