
# NAME

Otogiri::Plugin::InsertOnDuplicate - provide insert\_on\_duplicate method to Otogiri

# SYNOPSIS

    use Otogiri;
    Otogiri::load_plugin('InsertOnDuplicate');
    my $db = Otogiri->new( connect_info => ["dbi:mysql:dbname=$dbname", $user, $pass] );
    $db->insert_on_duplicate('table_1', { id => 100, name => 'aaa' }, { name => 'bbb' });

# DESCRIPTION

Otogiri::Plugin::InsertOnDuplicate is plugin for [Otogiri](http://search.cpan.org/perldoc?Otogiri). This module provides insert\_on\_duplicate method to [Otogiri](http://search.cpan.org/perldoc?Otogiri).
This module provides insert\_on\_duplicate(execute INSERT ... ON DUPLICATE KEY UPDATE) method. Note that, this SQL is supported
only MySQL. So this module can be used only MySQL.

# METHODS

## insert\_on\_duplicate($table\_name, $insert\_param, $update\_param)

execute INSERT ... ON DUPLICATE KEY UPDATE query for MySQL.

# LICENSE

Copyright (C) Takuya Tsuchida.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Takuya Tsuchida <tsucchi@cpan.org>
