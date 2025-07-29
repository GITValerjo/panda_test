use strict;
use warnings;
use IO::Socket::INET;

# Создаем серверный сокет
my $server = IO::Socket::INET->new(
    LocalHost => '127.0.0.1',  # Локальный IP-адрес
    LocalPort => 12345,        # Порт для прослушивания
    Proto     => 'tcp',        # Протокол TCP
    Listen    => 5,            # Очередь подключений
    Reuse     => 1             # Повторное использование порта
) or die "Не удалось создать серверный сокет: $!\n";

print "Сервер запущен и ожидает подключения...\n";

# Ожидаем подключения клиента
while (my $client = $server->accept()) {
    print "Клиент подключился: ", $client->peerhost(), ":", $client->peerport(), "\n";

    # Читаем данные от клиента
    my $data = "";
    $client->recv($data, 1024);
    print "Получено от клиента: $data\n";

    # Отправляем ответ клиенту
    my $response = "Привет, клиент!";
    $client->send($response);

    # Закрываем соединение с клиентом
    $client->close();
}

# Закрываем серверный сокет
$server->close();
