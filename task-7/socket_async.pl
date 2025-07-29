use strict;
use warnings;
use IO::Socket::INET;
use Time::HiRes qw(time);

sub http_get_async {
    my ($host, $path, $query, $timeout) = @_;

    # Формируем строку запроса из хеша $query
    my $query_string = join('&', map { "$_=$query->{$_}" } keys %$query);

    # Создаем сокет
    my $socket = IO::Socket::INET->new(
        PeerHost => $host,
        PeerPort => 80,
        Proto    => 'tcp',
        Timeout  => $timeout
    ) or die "Не удалось подключиться к $host: $!\n";

    # Переводим сокет в неблокирующий режим
    $socket->blocking(0);

    # Формируем HTTP-запрос
    my $request = "GET /$path?$query_string HTTP/1.1\r\n";
    $request .= "Host: $host\r\n";
    $request .= "Connection: close\r\n\r\n";

    # Отправляем запрос
    $socket->send($request);

    # Асинхронная обработка
    my $response = '';
    my @numbers;
    my $start_time = time;

    while (1) {
        # Используем select для ожидания данных на сокете
        my $readable;
        my $rin = '';
        vec($rin, fileno($socket), 1) = 1;
        my $nfound = select($readable = $rin, undef, undef, 0.1); # Ждем 0.1 секунды

        if ($nfound > 0) {
            # Читаем данные из сокета
            my $data;
            $socket->recv($data, 1024);
            if (defined $data && length($data) > 0) {
                $response .= $data;
            } else {
                # Если данных больше нет, выходим из цикла
                last;
            }
        }

        # Заполняем массив числами
        push @numbers, scalar(@numbers) + 1;

        # Выводим количество элементов в массиве
        print "Элементов в массиве: ", scalar(@numbers), "\n";

        # Проверяем таймаут
        last if time - $start_time > $timeout;
    }

    # Закрываем сокет
    $socket->close();

    # Возвращаем ответ
    return $response;
}

# Пример использования
my $host = 'example.com';
my $path = '';
my $query = { key1 => 'value1', key2 => 'value2' };
my $timeout = 5;

my $response = http_get_async($host, $path, $query, $timeout);
print "Ответ сервера:\n$response\n";
