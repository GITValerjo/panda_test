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
    my %input = @_;
    my %seen;      # Хеш для отслеживания уже встреченных значений
    my %result;    # Результирующий хеш

    # Перебираем пары (ключ => значение) в исходном хеше
    foreach my $key (keys %input) {
        my $value = $input{$key};
        # Если значение еще не встречалось, добавляем его в результат
        if (!$seen{$value}) {
            $seen{$value} = 1;  # Помечаем значение как встреченное
            $result{$key} = $value;
        }
    }

    return \%result;  # Возвращаем результат
}

# Тестирование последовательного решения
print "Запуск последовательного решения...\n";
my $results = timethese(5, {
    'Sequential' => sub {
        my $result = sequential(%h);
        print "Последовательное решение: осталось пар: " . scalar(keys %$result) . "\n";
    },
});

# Выводим результаты
cmpthese($results);
