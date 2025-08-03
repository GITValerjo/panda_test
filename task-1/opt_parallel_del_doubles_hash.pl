#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use threads;
use Benchmark qw(:all);

# Загрузка хеша из файла
my $filename = 'hash.json';
open my $fh, '<', $filename or die "Не удалось открыть файл '$filename': $!";
my $json_text = do { local $/; <$fh> };
close $fh;

my %h = %{ decode_json($json_text) };

# Оптимизированное параллельное решение
sub parallel_optimized {
    my $max_threads = 8;  # Количество потоков
    my @keys = keys %h;   # Ключи исходного хэша
    my $chunk_size = int(@keys / $max_threads) + 1;

    # Разбиваем ключи на части
    my @chunks;
    while (@keys) {
        push @chunks, [splice(@keys, 0, $chunk_size)];
    }

    # Создаем потоки
    my @threads;

    foreach my $chunk (@chunks) {
        push @threads, threads->create(sub {
            my %local_seen;
            my %local_result;

            foreach my $key (@$chunk) {
                my $value = $h{$key};
                if (!$local_seen{$value}) {
                    $local_seen{$value} = 1;
                    $local_result{$key} = $value;
                }
            }

            return \%local_result;  # Возвращаем локальный результат
        });
    }

    # Собираем результаты из всех потоков
    my %final_result;
    my %global_seen;

    foreach my $thread (@threads) {
        my $result_ref = $thread->join();  # Ждем завершения потока и получаем результат
        foreach my $key (keys %$result_ref) {
            my $value = $result_ref->{$key};
            if (!$global_seen{$value}) {
                $global_seen{$value} = 1;
                $final_result{$key} = $value;
            }
        }
    }

    # Обновляем исходный хэш
    %h = %final_result;

    return \%h;  # Возвращаем итоговый хеш
}

# Тестирование параллельного решения
print "Запуск оптимизированного параллельного решения...\n";
my $results = timethese(5, {
    'Parallel_optimized' => sub {
        my $result = parallel_optimized();
        print "Оптимизированное параллельное решение: осталось пар: " . scalar(keys %$result) . "\n";
    },
});

# Выводим результаты
cmpthese($results);
