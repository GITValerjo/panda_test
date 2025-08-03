#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use Benchmark qw(:all);

# Загрузка хеша из файла
my $filename = 'hash.json';
open my $fh, '<', $filename or die "Не удалось открыть файл '$filename': $!";
my $json_text = do { local $/; <$fh> };
close $fh;

my %h = %{ decode_json($json_text) };

# Последовательное решение
sub sequential {
    my %seen;  # Хеш для отслеживания уже встреченных значений

    # Перебираем пары (ключ => значение) в исходном хеше
    foreach my $key (keys %h) {
        my $value = $h{$key};
        # Если значение уже встречалось, удаляем пару из исходного хэша
        if ($seen{$value}) {
            delete $h{$key};
        } else {
            $seen{$value} = 1;  # Помечаем значение как встреченное
        }
    }
}

# Тестирование последовательного решения
print "Запуск последовательного решения...\n";
my $results = timethese(5, {
    'Sequential' => sub {
        sequential();  # Удаляем дубликаты непосредственно из %h
        print "Последовательное решение: осталось пар: " . scalar(keys %h) . "\n";
    },
});

# Выводим результаты
cmpthese($results);
