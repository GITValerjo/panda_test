#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use threads;
use Thread::Queue;
use Benchmark qw(:all);

# Загрузка хеша из файла
my $filename = 'hash.json';
open my $fh, '<', $filename or die "Не удалось открыть файл '$filename': $!";
my $json_text = do { local $/; <$fh> };
close $fh;

# Декодируем JSON
my %h = %{ decode_json($json_text) };

# Оптимизированное параллельное решение с использованием threads и Thread::Queue
sub parallel_optimized {
    my $max_threads = 4;  # Количество потоков
    my @keys = keys %h;   # Ключи исходного хэша
    my $chunk_size = int(@keys / $max_threads) + 1;

    # Разбиваем ключи на части
    my @chunks;
    while (@keys) {
        push @chunks, [splice(@keys, 0, $chunk_size)];
    }

    # Создаем очередь задач
    my $work_queue = Thread::Queue->new(@chunks);

    # Создаем очередь для результатов
    my $result_queue = Thread::Queue->new();

    # Создаем потоки
    my @threads;
    for (1 .. $max_threads) {
        push @threads, threads->create(sub {
            while (my $chunk = $work_queue->dequeue_nb()) {
                my %local_reversed;

                # Разворачиваем хэш в локальном потоке
                foreach my $key (@$chunk) {
                    my $value = $h{$key};
                    $local_reversed{$value} = $key;  # Перезаписываем дубли
                }

                # Отправляем результат в очередь
                $result_queue->enqueue(\%local_reversed);
            }
        });
    }

    # Ждем завершения потоков
    $_->join() for @threads;

    # Собираем результаты из очереди
    my %final_reversed;
    while (my $result_ref = $result_queue->dequeue_nb()) {
        foreach my $value (keys %$result_ref) {
            $final_reversed{$value} //= $result_ref->{$value};
        }
    }

    # Восстанавливаем исходный хэш из развернутого
    my %final_result;
    foreach my $value (keys %final_reversed) {
        my $key = $final_reversed{$value};
        $final_result{$key} = $value;
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
