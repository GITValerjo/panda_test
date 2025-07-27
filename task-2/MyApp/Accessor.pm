package MyApp::Accessor;

use strict;
use warnings;

# Конструктор для создания объекта
sub new {
    my ($class, %args) = @_;
    return bless \%args, $class;
}

# Метод для генерации аксессоров
sub import {
    my ($class, @fields) = @_;

    for my $field (@fields) {
        no strict 'refs'; # Отключаем строгую проверку ссылок
        *{"${class}::$field"} = sub {
            my ($self, $value) = @_;
            if (@_ == 2) {
                $self->{$field} = $value; # Устанавливаем значение
            }
            return $self->{$field}; # Возвращаем значение
        };
    }
}

1;