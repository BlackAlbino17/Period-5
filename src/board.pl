:- use_module(library(lists)).

initialBoard([
    [empty, circle, empty, empty, empty],
    [square, empty, circle, empty, empty],
    [empty, square, cube, circle, empty],
    [empty, empty, square, empty, circle],
    [empty, empty, empty, square, empty]
]).

showGame(X) :- initialBoard(X).

/*
display_game(GameState) :-
    length(GameState, Length),
    write('  '), letters(1, Length), nl,
    display_matrix(GameState, 1).

% esta função print das letras em cima do board
letters(Length, Length) :-
    row(Length, Letter),
    write(Letter).
letters(N, Length) :-
    row(N, Letter),
    write(Letter),
    N1 is N + 1,
    letters(N1, Length).

% faz display da matriz 
display_matrix([], _).  
display_matrix([H | T], Length) :-
    (   Length < 10 -> 
        write(' '), write(Length);
        write(Length)
    ),
    display_line(H),
    L1 is Length + 1,
    display_matrix(T, L1).

% faz display de uma linha
display_line([]) :- nl.
display_line([H | T]) :-
    team(H, X),
    write(X),
    display_line(T).
    */