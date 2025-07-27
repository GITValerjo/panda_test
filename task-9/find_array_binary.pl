#!/usr/bin/perl
use strict;
use warnings;
use Benchmark qw(:all);
use utf8;
binmode(STDOUT, ":utf8");

# Функция для поиска индекса элемента, ближайшего к заданному числу
sub find_closest_index {
    my ($array_ref, $target) = @_;
    my @array = @$array_ref;

    my $low = 0;
    my $high = $#array;

    # Бинарный поиск
    while ($low <= $high) {
        my $mid = int(($low + $high) / 2);

        if ($array[$mid] == $target) {
            return $mid; # Если нашли точное совпадение
        } elsif ($array[$mid] < $target) {
            $low = $mid + 1;
        } else {
            $high = $mid - 1;
        }
    }

    # После завершения бинарного поиска $low и $high указывают на соседние элементы
    # Проверяем, какой из них ближе к target
    if ($low > $#array) {
        return $#array; # Если target больше всех элементов массива
    } elsif ($high < 0) {
        return 0; # Если target меньше всех элементов массива
    } else {
        # Сравниваем расстояния до $array[$low] и $array[$high]
        return (abs($array[$low] - $target) < abs($array[$high] - $target)) ? $low : $high;
    }
}

# Пример использования
my @sorted_array = (1, 3, 5, 7, 9, 11, 13, 15, 17, 19); #Хороший пример для уточнения ТЗ - наиболее близкий в меньшую или большую сторону?
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
