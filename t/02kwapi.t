=pod

=encoding utf-8

=head1 PURPOSE

Check that the C<assert> keyword's preferred implementation, which
uses the Perl keyword API on recent releases of Perl, but falls
back to a L<Devel::Declare>-based version on older Perls.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2013-2014 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

use Test::Modern;
no warnings qw(void);

BEGIN {
	$ENV{AUTHOR_TESTING} = $ENV{AUTOMATED_TESTING} = $ENV{EXTENDED_TESTING} = $ENV{RELEASE_TESTING} = 0;
};

#line 0 02kwapi.t
{
	package Foo;
	use PerlX::Assert;
	sub go {
		my $self = shift;
		my ($x) = @_;
		assert { $x < 5 };
		return 1;
	}
}
	
die("Could not compile class Foo: $@") if $@;

ok( 'Foo'->go(6), 'class compiled with no relevant environment variables; assertions are ignored' );
ok( 'Foo'->go(4), '... and a dummy value that should not cause assertion to fail anyway' );

{
	BEGIN {
		$ENV{AUTHOR_TESTING} = $ENV{AUTOMATED_TESTING} = $ENV{EXTENDED_TESTING} = $ENV{RELEASE_TESTING} = 0;
		$ENV{AUTHOR_TESTING} = 1;
	};
	
#line 0 02kwapi.t
	{
		package Foo_AUTHOR;
		use PerlX::Assert;
		sub go {
			my $self = shift;
			my ($x) = @_;
			assert { $x < 5 };
			return 1;
		}
	}
	
	like(
		exception { 'Foo_AUTHOR'->go(6) },
		qr{^Assertion failed at 02kwapi.t line 6},
		"class compiled with \$ENV{AUTHOR_TESTING}; assertions are working",
	);
	ok( 'Foo_AUTHOR'->go(4), '... and a dummy value that should not cause assertion to fail anyway' );
}

{
	BEGIN {
		$ENV{AUTHOR_TESTING} = $ENV{AUTOMATED_TESTING} = $ENV{EXTENDED_TESTING} = $ENV{RELEASE_TESTING} = 0;
		$ENV{AUTOMATED_TESTING} = 1;
	};
	
#line 0 02kwapi.t
	{
		package Foo_AUTOMATED;
		use PerlX::Assert;
		sub go {
			my $self = shift;
			my ($x) = @_;
			assert { $x < 5 };
			return 1;
		}
	}
	
	like(
		exception { 'Foo_AUTOMATED'->go(6) },
		qr{^Assertion failed at 02kwapi.t line 6},
		"class compiled with \$ENV{AUTOMATED_TESTING}; assertions are working",
	);
	ok( 'Foo_AUTOMATED'->go(4), '... and a dummy value that should not cause assertion to fail anyway' );
}

{
	BEGIN {
		$ENV{AUTHOR_TESTING} = $ENV{AUTOMATED_TESTING} = $ENV{EXTENDED_TESTING} = $ENV{RELEASE_TESTING} = 0;
		$ENV{EXTENDED_TESTING} = 1;
	};
	
#line 0 02kwapi.t
	{
		package Foo_EXTENDED;
		use PerlX::Assert;
		sub go {
			my $self = shift;
			my ($x) = @_;
			assert { $x < 5 };
			return 1;
		}
	}
	
	like(
		exception { 'Foo_EXTENDED'->go(6) },
		qr{^Assertion failed at 02kwapi.t line 6},
		"class compiled with \$ENV{EXTENDED_TESTING}; assertions are working",
	);
	ok( 'Foo_EXTENDED'->go(4), '... and a dummy value that should not cause assertion to fail anyway' );
}

{
	BEGIN {
		$ENV{AUTHOR_TESTING} = $ENV{AUTOMATED_TESTING} = $ENV{EXTENDED_TESTING} = $ENV{RELEASE_TESTING} = 0;
		$ENV{RELEASE_TESTING} = 1;
	};
	
#line 0 02kwapi.t
	{
		package Foo_RELEASE;
		use PerlX::Assert;
		sub go {
			my $self = shift;
			my ($x) = @_;
			assert { $x < 5 };
			return 1;
		}
	}
	
	like(
		exception { 'Foo_RELEASE'->go(6) },
		qr{^Assertion failed at 02kwapi.t line 6},
		"class compiled with \$ENV{RELEASE_TESTING}; assertions are working",
	);
	ok( 'Foo_RELEASE'->go(4), '... and a dummy value that should not cause assertion to fail anyway' );
}

{
	BEGIN {
		$ENV{AUTHOR_TESTING} = $ENV{AUTOMATED_TESTING} = $ENV{EXTENDED_TESTING} = $ENV{RELEASE_TESTING} = 0;
	};
	
#line 0 02kwapi.t
	{
		package Foo_EXPLICIT;
		use PerlX::Assert -check;
		sub go {
			my $self = shift;
			my ($x) = @_;
			assert { $x < 5 };
			return 1;
		}
	}
	
	like(
		exception { 'Foo_EXPLICIT'->go(6) },
		qr{^Assertion failed at 02kwapi.t line 6},
		"class compiled with -check; assertions are working",
	);
	ok( 'Foo_EXPLICIT'->go(4), '... and a dummy value that should not cause assertion to fail anyway' );
}

done_testing;
