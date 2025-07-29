use strict;
use warnings;

# Создаем стандартную колоду из 52 карт
my @suits = ('Hearts', 'Diamonds', 'Clubs', 'Spades'); # Масти: Черви, Бубны, Трефы, Пики
my @ranks = ('2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'); # Достоинства карт
my @deck = map { my $suit = $_; map { "$_ of $suit" } @ranks } @suits; # Создаем массив карт

# Перемешиваем колоду
srand; # Инициализация генератора случайных чисел
@deck = sort { rand() <=> rand() } @deck; # Перемешиваем карты случайным образом

# Раздаем карты 9 игрокам по 2 карты
my %players;
for my $player (1..9) {
    $players{"Player $player"} = [splice(@deck, 0, 2)]; # Извлекаем 2 карты для каждого игрока
}

# Оставляем 5 карт отдельно (например, для стола)
my @table_cards = splice(@deck, 0, 5); # Извлекаем 5 карт из оставшейся колоды

# Вывод результатов
print "Карты игроков:\n";
for my $player (sort keys %players) {
    print "$player: @{$players{$player}}\n"; # Печатаем карты каждого игрока
}

print "\nКарты на столе:\n";
print join(", ", @table_cards), "\n"; # Печатаем карты, оставленные на столе
