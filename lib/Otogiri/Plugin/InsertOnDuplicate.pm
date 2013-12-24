package Otogiri::Plugin::InsertOnDuplicate;
use 5.008005;
use strict;
use warnings;
use Otogiri;
use Otogiri::Plugin;
use SQL::Maker;

our $VERSION = "0.01";

our @EXPORT = qw(insert_on_duplicate);

SQL::Maker->load_plugin('InsertOnDuplicate');

sub insert_on_duplicate {
    my ($self, $table_name, $insert_value, $update_value) = @_;
    $insert_value = $self->_deflate_param($table_name, $insert_value);
    $update_value = $self->_deflate_param($table_name, $update_value);
    my ($sql, @binds) = $self->maker->insert_on_duplicate($table_name, $insert_value, $update_value);
    $self->dbh->query($sql, @binds);
}


1;
__END__

=encoding utf-8

=head1 NAME

Otogiri::Plugin::InsertOnDuplicate - provide insert_on_duplicate method to Otogiri

=head1 SYNOPSIS

    use Otogiri;
    Otogiri::load_plugin('InsertOnDuplicate');
    my $db = Otogiri->new( connect_info => ["dbi:mysql:dbname=$dbname", $user, $pass] );
    $db->insert_on_duplicate('table_1', { id => 100, name => 'aaa' }, { name => 'bbb' });

=head1 DESCRIPTION

Otogiri::Plugin::InsertOnDuplicate is plugin for L<Otogiri>. This module provides insert_on_duplicate method to L<Otogiri>.
This module provides insert_on_duplicate(execute INSERT ... ON DUPLICATE KEY UPDATE) method. Note that, this SQL is supported
only MySQL. So this module can be used only MySQL.

=head1 METHODS

=head2 insert_on_duplicate($table_name, $insert_param, $update_param)

execute INSERT ... ON DUPLICATE KEY UPDATE query for MySQL.

=head1 LICENSE

Copyright (C) Takuya Tsuchida.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takuya Tsuchida E<lt>tsucchi@cpan.orgE<gt>

=cut

