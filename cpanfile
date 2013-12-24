requires 'Otogiri';
requires 'Otogiri::Plugin';
requires 'SQL::Maker', '1.09'; #InsertOnDuplicate
requires 'perl', '5.008005';

on configure => sub {
    requires 'CPAN::Meta';
    requires 'CPAN::Meta::Prereqs';
    requires 'Module::Build';
};

on test => sub {
    requires 'DBI';
    requires 'Test::More';
    requires 'Test::mysqld';
};
