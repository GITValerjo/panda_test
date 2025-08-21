#!/usr/bin/perl
use strict;
use warnings;
use DBI;

# Настройки подключения к базе данных Oracle (в задаче нет конкретизации, использовал привычный)
my $dsn      = "DBI:Oracle:host=some_host;sid=some_sid;port=some_port";
my $username = "username";
my $password = "password";

# Подключение к базе данных
my $dbh = DBI->connect($dsn, $username, $password, { RaiseError => 1, AutoCommit => 1 })
    or die "Не удалось подключиться к базе данных: $DBI::errstr";

# Размер порции
my $batch_size = 1000;

# Начальное значение для диапазона id
my $start_id = 0;

while (1) {
    # Читаем порцию данных с использованием диапазона id
    my $sql = qq{
        SELECT id, data
        FROM some_table
        WHERE id > ? AND id <= ?
    };

    my $sth = $dbh->prepare($sql);
    $sth->execute($start_id, $start_id + $batch_size);

    # Проверяем, есть ли данные
    my $rows = $sth->fetchall_arrayref({});
    last unless @$rows; # Если данных больше нет, выходим из цикла

    # Обрабатываем данные
    foreach my $row (@$rows) {
        my $id   = $row->{id};
        my $data = $row->{data};

        # Здесь выполняется обработка данных
        print "Обрабатываю ID=$id, DATA=$data\n";
    }

    # Увеличиваем начальный диапазон
    $start_id += $batch_size;

    $sth->finish;
}

# Закрываем соединение с базой данных
$dbh->disconnect;
