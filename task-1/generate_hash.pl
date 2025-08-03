#!/usr/bin/perl
use strict;
use warnings;
use JSON;

# Генерация большого хеша с повторяющимися значениями
my %h;
my @fixed_values = (42, 100, 256, 512, 1024);  
for my $i (1..1_500_000) {
    $h{"key$i"} = $fixed_values[int(rand(@fixed_values))];  # Выбор случайного значения из набора
}

# Сохранение хеша в файл
my $filename = 'hash.json';
open my $fh, '>', $filename or die "Не удалось открыть файл '$filename': $!";
print $fh encode_json(\%h);
close $fh;

print "Хеш сохранен в файл '$filename'.\n";
