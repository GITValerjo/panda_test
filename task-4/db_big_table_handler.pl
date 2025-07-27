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

# Начальное значение для диапазона
my $start_row = 1;

while (1) {
    # Читаем порцию данных с использованием ROWNUM
    my $sql = qq{
        SELECT id, data
        FROM (
            SELECT id, data, ROWNUM AS rnum
            FROM some_table
            WHERE ROWNUM <= ?
        )
        WHERE rnum >= ?
    };

    my $sth = $dbh->prepare($sql);
    $sth->execute($start_row + $batch_size - 1, $start_row);

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
    $start_row += $batch_size;

    $sth->finish;
}

# Закрываем соединение с базой данных
$dbh->disconnect;
