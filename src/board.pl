% Define o tabuleiro inicial.
initialBoard([
    [empty, circle, empty, empty, empty],
    [square, empty, circle, empty, empty],
    [empty, square, cube, circle, empty],
    [empty, empty, square, empty, circle],
    [empty, empty, empty, square, empty]
]).

% Predicado para exibir o tabuleiro com números de linha e letras de coluna.
display_initial_board :-
    % Acesse o tabuleiro inicial.
    initialBoard(Board),

    % Imprima o tabuleiro com números de linha e letras de coluna.
    write('  |   A   |   B   |   C   |   D   |   E   |'), nl,

    % Chame um predicado auxiliar para exibir o tabuleiro com números de linha e letras de coluna.
    display_board(Board, 5, 1).

% Predicado auxiliar para exibir o tabuleiro com números de linha e letras de coluna.
display_board([], 0, _).
display_board([Row | Rest], RowNumber, Column) :-
    write(RowNumber), write(' | '), display_row(Row, Column), nl,
    NextRowNumber is RowNumber - 1,
    display_board(Rest, NextRowNumber, Column).

display_row([], _).
display_row([Cell | Rest], Column) :-
    format("~|~a | ", [Cell]),  % Ajuste o espaçamento para que todas as colunas tenham o mesmo tamanho.
    NextColumn is Column + 1,
    display_row(Rest, NextColumn).

% Exemplo de uso:
:- display_initial_board.
