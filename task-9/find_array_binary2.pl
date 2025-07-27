#!/usr/bin/perl
use strict;
use warnings;
use List::BinarySearch qw(binsearch_pos);
use Benchmark qw(:all);
use utf8;
binmode(STDOUT, ":utf8");

# Функция для поиска индекса ближайшего элемента
sub find_closest_index {
    my ($array_ref, $target) = @_;
    my @array = @$array_ref;

    # Используем binsearch_pos для бинарного поиска
    my $pos = binsearch_pos { $a <=> $b } $target, @array;

    # Проверяем соседние элементы
    if ($pos == @array) {
        return $#array; # Если target больше всех элементов массива
    } elsif ($pos == 0) {
        return 0; # Если target меньше всех элементов массива
    } else {
        # Сравниваем расстояния до $array[$pos] и $array[$pos - 1]
        return (abs($array[$pos] - $target) < abs($array[$pos - 1] - $target)) ? $pos : $pos - 1;
    }
}

# Пример использования
my @sorted_array = (1, 3, 5, 7, 9, 11, 13, 15, 17, 19);
my $target = 8;

my $index = find_closest_index(\@sorted_array, $target);
print "Индекс ближайшего элемента: $index (значение: $sorted_array[$index])\n";

# Оценка производительности с помощью Benchmark
my $count = 1_000_000; # Количество итераций для тестирования
timethese($count, {
    'find_closest_index' => sub {
        find_closest_index(\@sorted_array, $target);
    },
});
