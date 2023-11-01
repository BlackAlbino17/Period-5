get_game_option(GameOption) :-
    read(GameOption),
    (GameOption >= 1, GameOption =< 4; 
    write('Invalid choice. Please select a valid option.'), nl, 
    get_game_option(GameOption)).


validate_move(Board, Player, Row, Column, Row1, Column1) :-
    repeat,
    write('Which piece do you want to move?'), nl,
    write('Row: '), nl, read(Row),
    write('Column: '), nl, read(Column),
    (is_player_piece(Board, Player, Row, Column,Piece) ->
        write('Where do you want to place it?'), nl,
        write('Row: '), nl, read(Row1),
        write('Column: '), nl, read(Column1),
        valid_piece_move(Board, Row, Column, Row1, Column1, Piece),
        !;
        write('Invalid move. Try again.'), nl
    );
    write('Invalid piece selection. Try again.'), nl.