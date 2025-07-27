#!/usr/bin/perl
use strict;
use warnings;
use mro 'c3';  # Включаем C3 Linearization

# Определение классов
package AA;
sub func {
    print "AA\n";
}

package BB;
use base 'AA';
sub func {
    print "BB\n";
    shift->next::method(@_);  # Используем next::method для вызова следующего метода
}

package CC;
use base 'AA';
sub func {
    print "CC\n";
    shift->next::method(@_);  # Используем next::method для вызова следующего метода
}

package DD;
use base qw/BB CC/;
sub func {
    print "DD\n";
    shift->next::method(@_);  # Используем next::method для вызова следующего метода
}

# Основной скрипт для проверки
package main;

# Вызов метода func для класса DD
DD->func();

# $ ./inheritance_test.pl
# DD
# BB
# CC
# AA
