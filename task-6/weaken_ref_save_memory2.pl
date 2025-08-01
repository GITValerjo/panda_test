#!/usr/bin/perl
use strict;
use warnings;
use Scalar::Util qw(weaken);
use Devel::Cycle;

# Функция утечки памяти
sub memory_leak_example {
    my $a = {};  # Создаем хэш
    $a->{func} = sub {
        $a->{cnt}++;
    };  # Замыкание ссылается на $a, создавая циклическую ссылку

    # Проверяем наличие циклических ссылок
    print "Проверка на утечку памяти:\n";
    find_cycle($a);  # find_cycle покажет циклическую ссылку
}

# Функция с исправлением утечки памяти
sub fixed_memory_example {
    my $a = {};  # Создаем хэш
    $a->{func} = sub {
        $a->{cnt}++;
    };  # Замыкание ссылается на $a

    weaken($a);  # Ослабляем ссылку на $a, чтобы избежать утечки памяти

    # Проверяем наличие циклических ссылок
    print "Проверка после ослабления ссылки:\n";
    find_cycle($a);  # find_cycle ничего не выведет
}

# Демонстрация утечки памяти
memory_leak_example();

# Исправление утечки памяти
fixed_memory_example();
