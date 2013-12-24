use strict;
use warnings;
use Test::More;
use DBI;
use Otogiri;
use Otogiri::Plugin;
use Test::mysqld;

my $mysqld = Test::mysqld->new(
    my_cnf => {
        'skip-networking' => '',
    }
) or plan skip_all => $Test::mysqld::errstr;

Otogiri->load_plugin('InsertOnDuplicate');

my $dbh = DBI->connect($mysqld->dsn(dbname => 'test'));

my $sql = <<'EOF';
CREATE TABLE member (
    id   INTEGER PRIMARY KEY AUTO_INCREMENT,
    name TEXT    NOT NULL
);
EOF
$dbh->do($sql);

subtest 'insert_on_duplicate', sub {
    my $db = Otogiri->new( connect_info => [$mysqld->dsn(dbname => 'test'), '', '', { RaiseError => 1, PrintError => 0 }] );
    my $insert_param = {
        name => 'mimorin',
    };
    my $update_param = {
        name => 'izusama',
    };
    my $id;

    subtest 'insert', sub {
        $db->insert_on_duplicate('member', $insert_param, $update_param);
        $id = $db->last_insert_id;
        my $row = $db->single('member', { id => $id });
        ok( defined $row );
        is( $row->{id}, $db->last_insert_id() );
        is( $row->{name}, $insert_param->{name} );
    };

    subtest 'update', sub {
        $insert_param->{id} = $id;
        $db->insert_on_duplicate('member', $insert_param, $update_param);
        my $row = $db->single('member', { id => $id });
        ok( defined $row );
        is( $row->{name}, $update_param->{name} );
    };
};

subtest 'deflate', sub {
    my $db = Otogiri->new( 
        connect_info => [$mysqld->dsn(dbname => 'test'), '', '', { RaiseError => 1, PrintError => 0 }],
        deflate      => sub {
            my ($data, $table_name) = @_;
            if ( defined $data->{name} ) {
                $data->{name} .= '-san';
            }
            return $data;
        },
    );
    my $insert_param = {
        name => 'tsucchi',
    };
    my $update_param = {
        name => 'ytnobody',
    };
    my $id;

    subtest 'insert', sub {
        $db->insert_on_duplicate('member', $insert_param, $update_param);
        $id = $db->last_insert_id;
        my $row = $db->single('member', { id => $id });
        ok( defined $row );
        is( $row->{id}, $db->last_insert_id() );
        is( $row->{name}, 'tsucchi-san' );
    };

    subtest 'update', sub {
        $insert_param->{id} = $id;
        $db->insert_on_duplicate('member', $insert_param, $update_param);
        my $row = $db->single('member', { id => $id });
        ok( defined $row );
        is( $row->{name}, 'ytnobody-san' );
    };
};


done_testing;
