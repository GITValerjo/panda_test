#!/usr/bin/perl
use strict;
use warnings;
use Scalar::Util qw(weaken);

# Создаём объект
my $object1 = { name => "Object1" };

# Создаём сильную ссылку на объект
my $object2 = $object1;

# Делаем ссылку слабой
weaken($object2);

# Проверяем состояние ссылок
print "Before undef:\n";
print "object1 exists: ", defined $object1 ? "yes\n" : "no\n";
print "object2 exists: ", defined $object2 ? "yes\n" : "no\n";

# Уничтожаем сильную ссылку
undef $object1;

# Проверяем состояние ссылок после уничтожения
print "After undef:\n";
print "object1 exists: ", defined $object1 ? "yes\n" : "no\n";
print "object2 exists: ", defined $object2 ? "yes\n" : "no\n";

