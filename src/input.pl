get_game_option(GameOption) :-
    read(GameOption),
    (GameOption >= 1, GameOption =< 4; 
    write('Invalid choice. Please select a valid option.'), nl, 
    get_game_option(GameOption)).