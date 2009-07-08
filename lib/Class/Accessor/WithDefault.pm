package Class::Accessor::WithDefault;
use base qw/Class::Accessor/;
use 5.006;

our $VERSION = '0.19';

sub mk_accessors {
    my $self = shift;
    my @fields;
    foreach (@_) {
        if ( ref $_ eq 'HASH' ) {
            $self->mk_default( %{$_} );
        }
        else {
            push @fields, $_;
        }
    }
    $self->SUPER::mk_accessors(@fields);
}

sub mk_ro_accessors {
    my $self = shift;
    my @fields;
    foreach (@_) {
        if ( ref $_ eq 'HASH' ) {
            $self->mk_ro_default( %{$_} );
        }
        else {
            push @fields, $_;
        }
    }
    $self->SUPER::mk_ro_accessors(@fields);
}

sub mk_default {
    my ( $self, %args ) = @_;
    $self->_make_default( "rw", %args );
}

sub mk_ro_default {
    my ( $self, %args ) = @_;
    $self->_make_default( 'ro', %args );
}

## make accessors and set the default value
## mostly copied from Class::Accessor::_mk_accessors
sub _make_default {
    my ( $self, $access, %args ) = @_;
    my $class = ref $self || $self;
    my $ra = $access eq 'rw' || $access eq 'ro';
    my $wa = $access eq 'rw' || $access eq 'wo';

    while ( my ( $field, $value ) = each %args ) {
        my $accessor_name = $self->accessor_name_for($field);
        my $mutator_name  = $self->mutator_name_for($field);
        if ( $accessor_name eq 'DESTROY' or $mutator_name eq 'DESTROY' ) {
            $self->_carp(
                "Having a data accessor named DESTROY  in '$class' is unwise.");
        }

        if ( $accessor_name eq $mutator_name ) {
            my $accessor;
            if ( $ra && $wa ) {
                $accessor = $self->make_default( $field, $value );
            }
            elsif ($ra) {
                $accessor = $self->make_ro_default( $field, $value );
            }
            my $fullname = "${class}::$accessor_name";
            my $subnamed = 0;
            subname( $fullname, $accessor ) if defined &subname;
            $subnamed = 1;
            *{$fullname} = $accessor;
        }
        else {
            my $fullaccname = "${class}::$accessor_name";
            my $fullmutname = "${class}::$mutator_name";
            if ( $ra and not defined &{$fullaccname} ) {
                my $accessor = $self->make_ro_default( $field, $value );
                subname( $fullaccname, $accessor ) if defined &subname;
                *{$fullaccname} = $accessor;
            }
            if ( $wa and not defined &{$fullmutname} ) {
                my $mutator = $self->make_wo_accessor($field);
                subname( $fullmutname, $mutator ) if defined &subname;
                *{$fullmutname} = $mutator;
            }
        }
    }
}

sub make_default {
    my ( $class, $field, $value ) = @_;
    return sub {
        my $self = shift;

        if (@_) {
            return $self->set( $field, @_ );
        }
        elsif ( !$self->get($field) ) {
            return $self->set( $field, $value );
        }
        else {
            return $self->get($field);
        }
    };

}

sub make_ro_default {
    my ( $class, $field, $value ) = @_;
    return sub {
        my $self = shift;
        if (@_) {
            my $caller = caller;
            $self->_croak(
"'$caller' cannot alter the value of '$field' on objects of class '$class'"
            );
        }
        elsif ( !$self->get($field) ) {
            return $self->set( $field, $value );
        }
        else {
            return $self->get($field);
        }
      }
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Class::Accessor::WithDefault - Set Default Value Implement on Class::Accessor

=head1 SYNOPSIS

	use Class::Accessor::WithDefault;
	__PACKAGE__->mk_accessors(qw/a b/,{c => 'default value'});

	....
	#..->new();
	print $object->c;  #default value

=head1 DESCRIPTION
	
Class::Accessor is great, except for some inconvenience in setting the default value for the fields. Overrding the new method is some kind of inconvenient too.

This module allows you to set the default value for all the generated accessors by passing a hashref to the method.
	

B<NOTE:> Don't use 

	$object->get("c");

to get  the default value, this won't work.

=head1 SEE ALSO
	
Class::Accessor
	
=head1 AUTHOR

Woosely.Xu

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
