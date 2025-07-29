use strict;
use warnings;
use IO::Socket::INET;

sub http_get {
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

    # Формируем HTTP-запрос
    my $request = "GET /$path?$query_string HTTP/1.1\r\n";
    $request .= "Host: $host\r\n";
    $request .= "Connection: close\r\n\r\n";

    # Отправляем запрос
    $socket->send($request);

    # Читаем ответ
    my $response = '';
    while (<$socket>) {
        $response .= $_;
    }

    # Закрываем сокет
    $socket->close();

    # Возвращаем ответ
    return $response;
}

# Пример использования
my $host = 'example.com';
my $path = 'index.html';
my $query = { key1 => 'value1', key2 => 'value2' };
my $timeout = 5;

my $response = http_get($host, $path, $query, $timeout);
print "Ответ сервера:\n$response\n";
