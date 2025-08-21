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

# Последовательное решение с разворотом хэша
sub sequential {
    my %reversed;  # Хеш для разворота (значение => ключ)

    # Перебираем пары (ключ => значение) в исходном хэше
    foreach my $key (keys %h) {
        my $value = $h{$key};
        # Если значение уже встречалось, оно перезапишет ключ в %reversed
        $reversed{$value} = $key;
    }

    # Восстанавливаем исходный хэш из развернутого
    my %result;
    foreach my $value (keys %reversed) {
        my $key = $reversed{$value};
        $result{$key} = $value;
    }

    # Обновляем исходный хэш
    %h = %result;
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
