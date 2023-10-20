
% Define o tabuleiro inicial.
initialBoard([
    [------, circle, ------, ------, ------],
    [square, ------, circle, ------, ------],
    [------, square, ' cube ', circle, ------],
    [------, ------, square, ------, circle],
    [------, ------, ------, square, ------]
]).

% Predicado para exibir o tabuleiro com números de linha e letras de coluna.
display_initial_board :-
    % Acesse o tabuleiro inicial.
    initialBoard(Board),

    % Imprima o tabuleiro com números de linha e letras de coluna.
    write('  |    A   |    B   |    C   |    D   |    E   |'), nl,

    % Chame um predicado auxiliar para exibir o tabuleiro com números de linha e letras de coluna.
    display_board(Board, 1, 1).

% Predicado auxiliar para exibir o tabuleiro com números de linha e letras de coluna.
display_board([], 6, _).
display_board([Row | Rest], RowNumber, Column) :-
    write(RowNumber), write(' | '), display_row(Row, Column), nl,
    NextRowNumber is RowNumber + 1,
    display_board(Rest, NextRowNumber, Column).

display_row([], _).
display_row([Cell | Rest], Column) :-
    format("~|~a | ", [Cell]),  % Ajuste o espaçamento para que todas as colunas tenham o mesmo tamanho.
    NextColumn is Column + 1,
    display_row(Rest, NextColumn).
