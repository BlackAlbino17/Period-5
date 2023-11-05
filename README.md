# Period-5

## Elementos 
> João Pedro Oliveira Sequeira - up202108823
> Tiago Rocha Silveira Pires - up202008790

### Contribuição 
> João Pedro Oliveira Sequeira - 50%
> Tiago Rocha Silveira Pires - 50%

# Instalação e Execução
> Para executar o jogo é necessário fazer *consult* do ficheiro menu.pl e depois executar "play.".

# Descrição do jogo
> O Period_5 é jogado num tabuleiro 5x5 com quadrados pintados em 5 cores.
> Existem dois jogadores, cada um com 4 peças. Há também uma peça adicional - o cubo.
> A coloração do tabuleiro e a posição inicial das peças e do cubo são mostradas na imagem a seguir:


![Tabuleiro](period_5.png)

### **Movimentação** - Todas as peças e o cubo são capazes de se mover ortogonalmente por qualquer número de espaços vazios. Eles não podem pular outras peças ou cair numa casa ocupada.
> Quando o cubo é movido, ele não pode ser devolvido imediatamente ao mesmo quadrado pelo próximo jogador.
> O cubo não pode ser movido se o outro jogador ameaça vencer na sua próxima jogada.

### **Objetivo** - Um jogador ganha o jogo quando suas peças e o cubo puderem ser encontrados em todas as colunas do tabuleiro e em cada uma das 5 cores diferentes.

# Lógica do jogo 

## Representação interna do jogo 

> A represtação é feita através de uma matriz (lista de listas) onde cada lista representa uma linha e cada elemento representa uma célula do tabuleiro. Dentro de uma matriz temos elementos do tipo square, circle e ------ sendo que cada célula têm a sua cor associada, apresentada numa matriz equivalente com as cores.


*Initial representation of the board:*
```prolog
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
```

> Para alcançarmos esta representação, a função `displayInitialBoard` é chamada. Por sua vez esta função irá chamar a `InitialBoard` e o predicado `display_board(+Board,+RowNumber,+ColumnNumber)`.

## Visualização do estado de jogo 

> O ficheiro principal menu.pl contém a função play/0 que chama o menu onde o utilizador escolherá o modo de jogo pretendido (player vs player, player vs ai, ai vs player ou ai vs ai).

> A função display_board está implementada em board.pl permitindo a visualização do estado do jogo. 

## Validação de moves e execução

> O jogo baseia-se em troca de turnos. Em todos os turnos os jogadores são questionados sobre a jogada que querem fazer onde foi definido que têm que dar input as coordenadas da peça que querem mover (row,column) e também a nova posição que a peça vai ter (row,column).
De forma a um jogador conseguir mover as suas peças, foram criados os predicados de `is_player_piece(+Board, +Player, +Row, +Column, -Piece)`, `valid_piece_move(+Board, +Row, +Column, +Row1, +Column1, +Piece)` e `placePieceAndRemove(+Board, +Row, +Column, +Row1, +Column1, -NewBoard)` que são todos chamados num predicado que os junta todos e é usado para fazer a jogada -> `make_move(+Board, +Row, +Column, +Row1, +Column1, -NewBoard, +Player)`.
Neste predicado, começamos então por usar a is_player_piece após o primeiro input do jogador para confirmar se a peça que este inseriu é mesmo uma peça que lhe pertence (evitando escolhas de peças adversárias e/ou empty spaces).
Após esta validação o jogador dá um novo input (coordenadas finais da peça após o move). Antes de ocorrer o movimento da peça há um check geral feito pelo predicado valid_piece_move que confirma se a move é possível ou não de acordo com as regras do nosso jogo (entre elas: apenas moves ortogonais, peça não pode movimentar-se se isto implicar que passe "por cima" de uma outra peça e ainda se a peça vai se movimentar para uma coordenada onde já se encontra uma outra peça).
Se a move escolhida pelo jogador passar em todos estes checks é então feita pelo predicado placePieceAndRemove que irá mudar a game board substituindo o lugar original da peça por empty ('------') e o novo lugar com o nome da peça.

## Lista de Moves Válidas

> Para obter a lista completa de moves válidas que um jogador pode efetuar, foi desenvolvido o predicado `get_all_player_moves(+Board, +Player, -List)` que é auxiliado por `get_all_player_pieces_positions(+Board, +Player, -List)` e `get_moves(+PiecePositions, +Player, +Board, +Acc, -List)` sendo este ultimo o predicado responsável pela iteração de moves e confirmação da validez de cada uma.

## Fim de Jogo

> O fim de jogo é controlado por dois predicados de verificação chamados em `player_victory(+Board, +CurrentPlayer)`, sendo estes `color_check(+Board, +Player)` e  `one_piece_per_column_check(Board, Player)`. O nome descreve quase o que os predicados fazem. Ambos são responsáveis por confirmar as winning conditions do nosso jogo sendo essas o jogador possuir todas as 5 diferentes cores do tabuleiro e a verificação de que estas são obtidas com as 5 peças em colunas diferentes do tabuleiro.

## Avaliação Do Game State

> Não possuimos funções para avaliar o game state apenas os predicados responsáveis por auxiliar se o jogador alcançou ou não o end state (5 cores e 5 colunas).

## Jogadas do Computador

> Foram construídas duas dificuldades do computador -> "Easy" e "Hard".
No modo "Easy" implementamos apenas o uso de random, isto é, o computador dá retrieve a lista de todas as moves válidas possíveis e escolhe uma aleatoriamente.
No modo "Hard" foi implementado um predicado para avaliar moves consoante o resultado que essas teriam para a lista de cores que o jogador possui. Em síntese, o predicado `evaluate_move_aux(+Board, +Player, +Row, +Column, +Row1, +Column1, -List)` é chamado para fazer o cálculo do impacto da move na lista de cores do jogador. Este avalia as moves pegando na quantidade de cores inicial que o jogador possui e verifica quantas cores o jogador vai ter após a sua jogada.
Estas são avaliadas em 3 categorias -> "Color_Gain", "Color_Kept", "Color_Lost"
e são depois filtradas através dos predicados de find_moves_with_color_X.
No corpo da AI esta filtragem e categorização de moves é usada para escolher a move do computador. Damos prioridade a o computador adquirir novas cores para si e tentamos ainda evitar que este vá adquirir uma cor numa coluna onde já possui uma cor.
Em termos de prioridade mesmo definimos sempre a verificação de que se houver uma winning move esta é instantaneamente jogada sem qualquer outra verificação senão passamos para o algoritmo de escolher moves consoante o adquirir/manter/perder cores (por esta ordem). Realçamos ainda que se houver mais do que uma move para qualquer uma destas categorias, é efetuada uma seleção aleatória da mesma.

## Conclusões 

> O AI poderia ser melhorado no que diz respeito ao **predict** de jogadas futuras, isto é, só consegue prever uma única jogada baseada na disposição atual do tabuleiro, não consegue prever múltiplas jogadas numa só rodada. Poderia também extender o algoritmo para a tentativa de avaliar o ganho de colunas e não só de cores.

> Poderia também haver uma melhor organização de código (reduzir o tamanho dos predicados) e talvez mais eficiência na maneira de como escrevemos certos predicados. 

> De uma forma geral este projeto permitiu-nos adquirir bastantes conhecimentos novos sobre Prolog bem como reforçar algum conhecimento prévio das aulas práticas da unidade curricular.


## Bibliografia

Documentos disponibilizados no moodle.

https://www.iggamecenter.com/en/rules/period5.

https://stackoverflow.com/

https://sicstus.sics.se/documentation.html

