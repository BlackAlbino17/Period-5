/*

easy_ai_move(Board, 'Computer', NewBoard) :-
    get_player_moves(Board, 'Computer', ValidMoves),
    random_member((Row, Column, Row1, Column1), ValidMoves),
    placePieceAndRemove(Board, Row, Column, Row1, Column1, NewBoard).

    */