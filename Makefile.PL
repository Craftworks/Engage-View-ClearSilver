use inc::Module::Install;

name     'Engage-View-ClearSilver';
all_from 'lib/Engage/View/ClearSilver.pm';
author   q{Craftworks <craftwork at cpan org>};
license  'perl';

build_requires('Test::More');
build_requires('Test::UseAllModules');
build_requires('Test::Exception');

requires('Moose');
requires('Moose::Util::TypeConstraints');
requires('ClearSilver');
requires('Data::ClearSilver::HDF');
requires('IPC::Cmd');

auto_install;

WriteAll;

