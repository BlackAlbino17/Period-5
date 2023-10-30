



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

menu_option(1) :- player_player.
menu_option(2) :- player_ai.
menu_option(3) :- ai_ai.
menu_option(4) :- true.
menu_option(_) :- write('Invalid choice'), nl, play.



player_player:-initialBoard(InitialBoard),
                display_initial_board,
             game_loop(InitialBoard, 'Player 1').
% player_ai :- 

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
    display_end_game_menu(Player),
    read(Choice).

end_game_option(1) :- play.
end_game_option(2) :- true.
end_game_option(_) :- write('Invalid choice'), nl, play.    