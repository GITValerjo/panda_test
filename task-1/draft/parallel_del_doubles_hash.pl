#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use Benchmark qw(:all);
use Parallel::ForkManager;

# Загрузка хеша из файла
my $filename = 'hash.json';
open my $fh, '<', $filename or die "Не удалось открыть файл '$filename': $!";
my $json_text = do { local $/; <$fh> };
close $fh;

my %h = %{ decode_json($json_text) };

# Параллельное решение с использованием процессов
sub parallel_with_forkmanager {
    my %input = @_;
    my $max_processes = 4;  # Количество процессов
    my @keys = keys %input; # Ключи исходного хеша
    my $chunk_size = int(@keys / $max_processes) + 1;

    # Разбиваем ключи на части
    my @chunks;
    while (@keys) {
        push @chunks, [splice(@keys, 0, $chunk_size)];
    }

    my $pm = Parallel::ForkManager->new($max_processes);
    my @results;  # Массив для хранения результатов от дочерних процессов

    # Обрабатываем каждый кусок в отдельном процессе
    foreach my $chunk (@chunks) {
        $pm->start and next;  # Запускаем новый процесс

        my %local_seen;
        my %local_result;

        foreach my $key (@$chunk) {
            my $value = $input{$key};
            if (!$local_seen{$value}) {
                $local_seen{$value} = 1;
                $local_result{$key} = $value;
            }
        }

        $pm->finish(0, \%local_result);  # Передаем результат в родительский процесс
    }

    # Собираем результаты из всех процессов
    $pm->run_on_finish(sub {
        my ($pid, $exit_code, $ident, $exit_signal, $core_dump, $data) = @_;
        if (defined $data) {
            push @results, $data;
        }
    });

    $pm->wait_all_children;

    # Объединяем результаты из всех процессов
    my %final_result;
    my %global_seen;
    foreach my $result_ref (@results) {
        foreach my $key (keys %$result_ref) {
            my $value = $result_ref->{$key};
            if (!$global_seen{$value}) {
                $global_seen{$value} = 1;
                $final_result{$key} = $value;
            }
        }
    }

    return \%final_result;  # Возвращаем итоговый результат
}

# Тестирование параллельного решения
print "Запуск параллельного решения с использованием процессов...\n";
my $results = timethese(5, {
    'Parallel_with_forkmanager' => sub {
        my $result = parallel_with_forkmanager(%h);
        print "Параллельное решение с использованием процессов: осталось пар: " . scalar(keys %$result) . "\n";
    },
});

# Выводим результаты
cmpthese($results);
