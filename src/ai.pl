easy_level_ai(Board, Player, Row, Column, Row1, Column1,NewBoard) :- 
    get_all_player_moves(Board, Player, ValidMoves),
    random_member((Row, Column, Row1, Column1), ValidMoves),
    ((counter(Counter),Counter == 0, Piece == ' cube '  )-> retract(counter(0)), asserta(counter(1)),counter(X),write(X),nl, set_prevCubePos(Row,Column);
    (counter(Counter),Counter == 1, Piece == ' cube '  )-> \+ cube_non_repeated_move(Row, Column, Row1, Column1),fail;
    (counter(Counter),Counter == 1, Piece == ' cube '  )-> cube_non_repeated_move(Row, Column, Row1, Column1),nl,counter(X),write(X),nl;
    (counter(Counter),Counter == 1)->retract(counter(1)), asserta(counter(0));
    true),
    sleep(2),
    placePieceAndRemove(Board, Row, Column, Row1, Column1, NewBoard),
    write(Row),nl,write(Column),nl,write(Row1),nl,write(Column1).








/*------------------------------------------------------------------------------------------------------------------------------------------------- */
expert_level_ai(Board, Player, Row, Column, Row1, Column1) :-
    ((counter(Counter), Counter == 0, Piece == ' cube ') ->
        retract(counter(0)), asserta(counter(1)), counter(X), write(X), nl, set_prevCubePos(Row, Column);
    (counter(Counter), Counter == 1, Piece == ' cube ') ->
        \+ cube_non_repeated_move(Row, Column, Row1, Column1), fail;
    (counter(Counter), Counter == 1, Piece == ' cube ') ->
        cube_non_repeated_move(Row, Column, Row1, Column1), nl, counter(X), write(X), nl;
    (counter(Counter), Counter == 1) ->
        retract(counter(1)), asserta(counter(0));
    true),

    (winning_state(Board, Player, Row, Column, Row1, Column1) -> true ;
        (get_all_player_moves(Board, Player, ValidMoves), 
        evaluate_moves(Board, Player, ValidMoves, EvaluatedMoves), 
        find_moves_with_color_gain(EvaluatedMoves, MovesWithColorGain), 
        find_moves_with_color_kept(EvaluatedMoves, MovesWithColorKept),
        find_moves_with_color_lost(EvaluatedMoves, MovesWithColorLost),
        get_player_colors(Board, Player, CurrentColors, _), 

        ((MovesWithColorGain = [], MovesWithColorKept = []) ->
            repeat,
            random_member((Row, Column, Row1, Column1), MovesWithColorLost),
            \+ member(Column1, CurrentColors),
            !;  
        (MovesWithColorGain = []) ->
            repeat,
            (random_member((Row, Column, Row1, Column1), MovesWithColorKept) ;
            random_member((Row, Column, Row1, Column1), MovesWithColorLost)),
            \+ member(Column1, CurrentColors),  
            !;  
        repeat,
        random_member((Row, Column, Row1, Column1), MovesWithColorGain),
        \+ member(Column1, CurrentColors), 
        ! 
        ))),

    sleep(2),
    placePieceAndRemove(Board, Row, Column, Row1, Column1, NewBoard),
    write(Row), nl, write(Column), nl, write(Row1), nl, write(Column1).






/*------------------------------------------------------------------------------------------------------------------------------------------------- */
evaluate_moves(Board, Player, ValidMoves, EvaluatedMoves) :-
    maplist(evaluate_single_move(Board, Player), ValidMoves, EvaluatedMoves).

evaluate_single_move(Board, Player, (Row, Column, Row1, Column1), (Move, EvaluationResult)) :-
    evaluate_move_aux(Board, Player, Row, Column, Row1, Column1, EvaluationResult),
    Move = (Row, Column, Row1, Column1).

evaluate_move_aux(Board, Player, Row, Column, Row1, Column1, EvaluationResult) :-
    placePieceAndRemove(Board, Row, Column, Row1, Column1, NewBoard),
    get_player_colors(Board, Player, CurrentColors, _),
    get_player_colors(NewBoard, Player, NewColors, _),
    
    (subtract(CurrentColors, NewColors, LostColors), LostColors \= [] -> EvaluationResult = color_lost;
    CurrentColors = NewColors -> EvaluationResult = color_kept;
    EvaluationResult = color_gain).


find_moves_with_color_gain(EvaluatedMoves, MovesWithColorGain) :-
    findall(Move, (member((Move, color_gain), EvaluatedMoves)), MovesWithColorGain).


find_moves_with_color_kept(EvaluatedMoves, MovesWithColorKept) :-
    findall(Move, (member((Move, color_kept), EvaluatedMoves)), MovesWithColorKept).

find_moves_with_color_lost(EvaluatedMoves, MovesWithColorLost) :-
    findall(Move, (member((Move, color_lost), EvaluatedMoves)), MovesWithColorLost).



/*------------------------------------------------------------------------------------------------------------------------------------------------- */


% initialBoard(Board), evaluate_move_aux(Board, 'Player 1', 5, 4, 4, 4, EvaluationResult).

% initialBoard(Board),computer_move(Board, 'Player 1', Row, Column, Row1, Column1),write('Computer move: '),write((Row, Column, Row1, Column1)), nl.


% find_moves_with_color_gain(EvaluatedMoves, MovesWithColorGain).

% initialBoard(Board), Player = 'Player 1', ValidMoves = [(5,4,4,4),(2,1,2,2),(2,1,3,1),(2,1,4,1),(2,1,5,1)], evaluate_moves(Board, Player, ValidMoves, EvaluatedMoves)


/*------------------------------------------------------------------------------------------------------------------------------------------------- */
