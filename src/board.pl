

initialBoard([
    [------, 'circle', ------, ------, ------],
    ['square', ------, 'circle', ------, ------],
    [------, 'square', ' cube ', 'circle', ------],
    [------, ------, 'square', ------, 'circle'],
    [------, ------, ------, 'square', ------]
]).

initialBoardColor([
    ['black ', ' red  ', 'yellow', ' blue ', 'green '],
    [' red  ', 'yellow', ' blue ', 'green ', 'black '],
    ['yellow', ' blue ', 'green ', 'black ', ' red  '],
    [' blue ', 'green ', 'black ', ' red  ', 'yellow'],
    ['green ', 'black ', ' red  ', 'yellow', ' blue ']
]).


display_initial_board :-
    initialBoard(Board),
    header,
    display_board(Board, 1, 1), nl,
    display_color_board.

display_color_board :-  
    initialBoardColor(Color),
    header,
    display_board(Color, 1, 1), nl.



display_board([], 6, _).
display_board([Row | Rest], RowNumber, Column) :-
    write(RowNumber), write(' | '), display_row(Row, Column), nl,
    NextRowNumber is RowNumber + 1,
    display_board(Rest, NextRowNumber, Column).

display_row([], _).
display_row([Cell | Rest], Column) :-
    format("~|~a | ", [Cell]), 
    NextColumn is Column + 1,
    display_row(Rest, NextColumn).
