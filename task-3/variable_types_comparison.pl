#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';
use feature 'state';

say "\n=== Start of script ===\n";
# === Сценарий с my ===
say "=== Using my ===";
sub func_my {
    my $var_my;  # Лексическая переменная, создается заново при каждом вызове,  доступна только внутри блока, в котором была объявлена
    $var_my++;
    say "A=$var_my";
}
func_my() for 1..10;

# === Сценарий с our ===
say "\n=== Using our ===";
sub func_our {
    our $var_our;  # Глобальная переменная, общая для всех вызовов, но доступ к ней ограничен текущим пакетом
    $var_our++;
    say "A=$var_our";
}
func_our() for 1..10;

# === Сценарий с local ===
say "\n=== Using local ===";
our $var_local = 5;  # Глобальная переменная, которую будем локализовать
sub func_local {
    local $var_local;  # Локализуем глобальную переменную, временно изменяет значение глобальной переменной в текущем блоке, после значение восстанавливается.
    $var_local++;
    say "A=$var_local";
}
func_local() for 1..10;
say "Finally A=$var_local";

# === Сценарий с state ===
say "\n=== Using state ===";
sub func_state {
    state $var_state;  # Переменная сохраняет свое значение между вызовами
    $var_state++;
    say "A=$var_state";
}
func_state() for 1..10;

# Конец рыботы скрипта
say "\n=== End of script ===\n";
