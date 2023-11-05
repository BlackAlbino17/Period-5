start_game(CurrentPlayer,NextPlayer) :-
    initialBoard(InitialBoard),
    display_initial_board,
    asserta(counter(0)),
    asserta(prevCubeX(3)),
    asserta(prevCubeY(3)),
    asserta(get_piece('square',CurrentPlayer)),
    asserta(get_piece(' cube ',CurrentPlayer)),
    asserta(get_piece('circle',NextPlayer)),
    asserta(get_piece(' cube ',NextPlayer)),
    asserta(switch_player(CurrentPlayer, NextPlayer)),
    asserta(switch_player(NextPlayer, CurrentPlayer)),
    game_loop(InitialBoard, CurrentPlayer, NextPlayer).


game_loop(Board, CurrentPlayer, NextPlayer) :-
    write(CurrentPlayer), write('\'s turn.'), nl,
    (winning_next_move(Board, NextPlayer) ->
        retract(get_piece(' cube ', CurrentPlayer)),
        make_move(Board, Row, Column, Row1, Column1, NewBoard, CurrentPlayer),
        asserta(get_piece(' cube ', CurrentPlayer)) 
    ;
    make_move(Board, Row, Column, Row1, Column1, NewBoard, CurrentPlayer)),
    (player_victory(NewBoard, CurrentPlayer) -> end_game(CurrentPlayer); true),
    header,
    display_board(NewBoard, 1, 1),
    nl,
    display_color_board,

    switch_player(CurrentPlayer, NextPlayer),
    game_loop(NewBoard, NextPlayer, CurrentPlayer).




player_victory(Board, CurrentPlayer):- 
    color_check(Board, CurrentPlayer),
    one_piece_per_column_check(Board, CurrentPlayer).

end_game(CurrentPlayer) :-
    display_end_game_menu(CurrentPlayer),
    ask_eog_option(Choice),
    end_game_option(Choice).
