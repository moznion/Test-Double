use lib qw(t/lib);
use Test::Double;
use Test::More;
use t::Utils;

subtest 'mock()' => sub {
    subtest 'should mock out method with coderef' => sub {
        my $foo = t::Foo->new;
        mock($foo)->expects('bar')->returns(sub { 'BAR' });

        is $foo->bar => 'BAR';
    };

    subtest 'should mock out method without coderef' => sub {
        for ('BAR', 1, [], {}) {
            my $foo = t::Foo->new;
            mock($foo)->expects('bar')->returns($_);

            is $foo->bar => $_;
        }
    };

    subtest 'should not mock out non-target method' => sub {
        my $foo = t::Foo->new;
        mock($foo)->expects('bar')->returns(sub { 'BAR' });

        is $foo->baz => 'baz';
    };

    subtest 'should not effect other instance' => sub {
        my $foo = t::Foo->new;
        my $other = t::Foo->new;
        mock($foo)->expects('bar')->returns(sub { 'BAR' });
        my $another = t::Foo->new;

        is $foo->bar => 'BAR';
        is $other->bar => 'bar';
        is $another->bar => 'bar';
    };

    subtest 'should subref can take argument' => sub {
        my $foo = t::Foo->new;
        mock($foo)->expects('bar')->returns(sub {
            my ($self, @args) = @_;

            is $args[0], 'arg1';
            is $args[1], 'arg2';

            return 'BAR';
        });

        is $foo->bar('arg1', 'arg2') => 'BAR';
    };
};

done_testing;
