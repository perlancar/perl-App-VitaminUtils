package App::VitaminUtils;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

our %args_common = (
    quantity => {
        # schema => 'physical::mass*', # XXX Perinci::Sub::GetArgs::Argv is not smart enough to coerce from string
        schema => 'str*',
        req => 1,
        pos => 0,
    },
    to_unit => {
        # schema => 'physical::unit', # IU hasn't been added
        schema => 'str*',
        pos => 1,
    },
);

$SPEC{convert_vitamin_a_unit} = {
    v => 1.1,
    summary => 'Convert a vitamin A quantity from one unit to another',
    description => <<'_',

If target unit is not specified, will show all known conversions.

_
    args => {
        %args_common,
    },
    examples => [
        {args=>{quantity=>'mcg'}, summary=>'Show all possible conversions'},
        {args=>{quantity=>'1500 mcg', to_unit=>'IU'}, summary=>'Convert from mcg to IU (retinol)'},
        {args=>{quantity=>'1500 mcg', to_unit=>'IU-retinol'}, summary=>'Convert from mcg to IU (retinol)'},
        {args=>{quantity=>'1500 mcg', to_unit=>'IU-beta-carotene'}, summary=>'Convert from mcg to IU (beta-carotene)'},
        {args=>{quantity=>'5000 IU', to_unit=>'mg'}, summary=>'Convert from IU to mg'},
    ],
};
sub convert_vitamin_a_unit {
    require Physics::Unit;

    Physics::Unit::InitUnit(
        ['mcg'], '0.001 mg',
        ['IU', 'iu'], '0.3 microgram',
        ['IU-retinol', 'iu-retinol'], '0.3 microgram',
        ['IU-beta-carotene', 'iu-beta-carotene'], '0.6 microgram',
    );

    my %args = @_;
    my $quantity = Physics::Unit->new($args{quantity});
    return [412, "Must be a Mass quantity"] unless $quantity->type eq 'Mass';

    if ($args{to_unit}) {
        my $new_amount = $quantity->convert($args{to_unit});
        return [200, "OK", $new_amount];
    } else {
        my @rows;
        for my $u ('mg', 'IU-retinol', 'IU-beta-carotene') {
            push @rows, {
                unit => $u,
                amount => $quantity->convert($u),
            };
        }
        [200, "OK", \@rows];
    }
}

$SPEC{convert_vitamin_d_unit} = {
    v => 1.1,
    summary => 'Convert a vitamin D quantity from one unit to another',
    description => <<'_',

If target unit is not specified, will show all known conversions.

_
    args => {
        %args_common,
    },
    examples => [
        {args=>{quantity=>'mcg'}, summary=>'Show all possible conversions'},
        {args=>{quantity=>'2 mcg', to_unit=>'IU'}, summary=>'Convert from mcg to IU'},
        {args=>{quantity=>'5000 IU', to_unit=>'mg'}, summary=>'Convert from IU to mg'},
    ],
};
sub convert_vitamin_d_unit {
    require Physics::Unit;

    Physics::Unit::InitUnit(
        ['mcg'], '0.001 mg',
        ['IU', 'iu'], '0.025 microgram',
    );

    my %args = @_;
    my $quantity = Physics::Unit->new($args{quantity});
    return [412, "Must be a Mass quantity"] unless $quantity->type eq 'Mass';

    if ($args{to_unit}) {
        my $new_amount = $quantity->convert($args{to_unit});
        return [200, "OK", $new_amount];
    } else {
        my @rows;
        for my $u ('mcg', 'mg', 'IU') {
            push @rows, {
                unit => $u,
                amount => $quantity->convert($u),
            };
        }
        [200, "OK", \@rows];
    }
}

$SPEC{convert_vitamin_e_unit} = {
    v => 1.1,
    summary => 'Convert a vitamin E quantity from one unit to another',
    description => <<'_',

If target unit is not specified, will show all known conversions.

_
    args => {
        %args_common,
    },
    examples => [
        {args=>{quantity=>'mg'}, summary=>'Show all possible conversions'},
        {args=>{quantity=>'67 mg', to_unit=>'IU'}, summary=>'Convert from mg to IU (d-alpha-tocopherol/natural vitamin E)'},
        {args=>{quantity=>'67 mg', to_unit=>'IU-natural'}, summary=>'Convert from mg to IU (d-alpha-tocopherol/natural vitamin E)'},
        {args=>{quantity=>'90 mg', to_unit=>'IU-synthetic'}, summary=>'Convert from mg to IU (dl-alpha-tocopherol/synthetic vitamin E)'},
        {args=>{quantity=>'400 IU', to_unit=>'mg'}, summary=>'Convert from IU to mg'},
    ],
};
sub convert_vitamin_e_unit {
    require Physics::Unit;

    Physics::Unit::InitUnit(
        #['mcg'], '0.001 mg',
        ['IU', 'iu'], '0.67 mg',
        ['IU-natural', 'iu-natural'], '0.67 mg',
        ['IU-synthetic', 'iu-synthetic'], '0.9 mg',
    );

    my %args = @_;
    my $quantity = Physics::Unit->new($args{quantity});
    return [412, "Must be a Mass quantity"] unless $quantity->type eq 'Mass';

    if ($args{to_unit}) {
        my $new_amount = $quantity->convert($args{to_unit});
        return [200, "OK", $new_amount];
    } else {
        my @rows;
        for my $u ('mg', 'IU-natural', 'IU-synthetic') {
            push @rows, {
                unit => $u,
                amount => $quantity->convert($u),
            };
        }
        [200, "OK", \@rows];
    }
}

1;
#ABSTRACT: Utilities related to vitamins

=head1 DESCRIPTION

This distributions provides the following command-line utilities:

# INSERT_EXECS_LIST


=head1 SEE ALSO

L<Physics::Unit>

=cut
