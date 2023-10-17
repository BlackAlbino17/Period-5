replace_element_in_row(GameState, RowIndex, Team, FinalBoard) :-
    same_team(Team, T),
    nth1(RowIndex, GameState, Row), 
    (   member(Team, Row) -> 
        nth1(Col, Row, Team),
        replace(Col, T, Row, NR), 
        replace(RowIndex, NR, GameState, FinalBoard);
        FinalBoard = GameState 
    ). 