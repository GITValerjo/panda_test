#!/usr/bin/perl
use strict;
use warnings;

# Подключаем модуль MyApp::Accessor
use lib '.'; 
use MyApp::Accessor qw(brand model); # Генерируем аксессоры для класса машин 'brand' и 'model'

# Создаем объект напрямую из MyApp::Accessor
my $car = MyApp::Accessor->new(brand => 'Chrysler', model => 'Sebring');

# Используем аксессоры
print "brand: ", $car->brand, "\n";   # brand: Chrysler
print "model: ", $car->model, "\n";   # model: Sebring

# Устанавливаем новые значения
$car->brand('Dodge');
$car->model('Avenger');

print "Updated brand: ", $car->brand, "\n"; # Updated brand: Dodge
print "Updated model: ", $car->model, "\n";   # Updated model: Avenger
