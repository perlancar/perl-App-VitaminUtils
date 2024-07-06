package App::VitaminUtils;

use 5.010001;
use strict;
use warnings;

use Capture::Tiny 'capture_stderr';

# AUTHORITY
# DATE
# DIST
# VERSION

our %SPEC;

our %argspec_quantity_default1mg = (
    quantity => {
        # schema => 'physical::mass*', # XXX Perinci::Sub::GetArgs::Argv is not smart enough to coerce from string
        schema => 'str*',
        default => '1 mg',
        pos => 0,
    },
);

our %argspec_quantity_default1mcg = (
    quantity => {
        # schema => 'physical::mass*', # XXX Perinci::Sub::GetArgs::Argv is not smart enough to coerce from string
        schema => 'str*',
        default => '1 mcg',
        pos => 0,
    },
);

our %argspecs_common = (
    to_unit => {
        # schema => 'physical::unit', # IU hasn't been added
        schema => 'str*',
        pos => 1,
    },
);

$SPEC{convert_vitamin_a_unit} = {
    v => 1.1,
    summary => 'Convert a vitamin A quantity from one unit to another',
    description => <<'MARKDOWN',

If target unit is not specified, will show all known conversions.

MARKDOWN
    args => {
        %argspecs_common,
        %argspec_quantity_default1mcg,
    },
    examples => [
        {args=>{}, summary=>'Show all possible conversions'},
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
        ['mcg-all-trans-beta-carotene-as-food-supplement'], '0.5 mcg',
        ['mcg-all-trans-retinol'], '1 mcg',
        ['mcg-all-trans-retinyl-acetate'], '0.872180241224122 mcg',            # https://www.rfaregulatoryaffairs.com/vitamin-converter: 1mg all-trans-retinyl-acetate = 2906.976744IU, 1mg all-trans-retinol = 3333IU
        ['mcg-all-trans-retinyl-palmitate'], '0.545454545454545 mcg',          # "1 IU corresponds to the activity of 0.300  g of all-trans retinol, 0.359  g of all-trans retinyl propionate or 0.550  g of all-trans retinyl palmitate"
        ['mcg-all-trans-retinyl-propionate'], '0.835654596100279 mcg',         # "1 IU corresponds to the activity of 0.300  g of all-trans retinol, 0.359  g of all-trans retinyl propionate or 0.550  g of all-trans retinyl palmitate"
        ['mcg-alpha-carotene'],                             '0.041666667 mcg', # 1/24
        ['mcg-beta-cryptoxanthin'],                         '0.041666667 mcg', # 1/24
        ['mcg-dietary-all-trans-beta-carotene'],            '0.083333333 mcg', # 1/12
        ['IU', 'iu'], '0.3 microgram', # definition from European pharmacopoeia
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
        for my $u (
            'mg', 'mcg',
            'mcg-all-trans-retinol',
            'mcg-dietary-all-trans-beta-carotene',
            'mcg-alpha-carotene',
            'mcg-beta-cryptoxanthin',
            'mcg-all-trans-beta-carotene-as-food-supplement',
            'mcg-all-trans-retinyl-acetate',
            'mcg-all-trans-retinyl-palmitate',
            'mcg-all-trans-retinyl-propionate',
            'IU',
            'IU-retinol',
            'IU-beta-carotene') {
            push @rows, {
                unit => $u,
                amount => $quantity->convert($u),
            };
        }
        [200, "OK", \@rows];
    }
}

$SPEC{convert_vitamin_b5_unit} = {
    v => 1.1,
    summary => 'Convert a vitamin B5 (pantothenic acid) quantity from one unit to another',
    description => <<'MARKDOWN',

If target unit is not specified, will show all known conversions.

MARKDOWN
    args => {
        %argspecs_common,
        %argspec_quantity_default1mg,
    },
    examples => [
        {args=>{}, summary=>'Show all possible conversions'},
    ],
};
sub convert_vitamin_b5_unit {
    require Physics::Unit;

    Physics::Unit::InitUnit(
        ['mg-pantothenic-acid'], '1 mg',
        ['mg-d-calcium-pantothenate'], '0.916 mg', # https://www.rfaregulatoryaffairs.com/vitamin-converter
    );

    my %args = @_;
    my $quantity = Physics::Unit->new($args{quantity});
    return [412, "Must be a Mass quantity"] unless $quantity->type eq 'Mass';

    if ($args{to_unit}) {
        my $new_amount = $quantity->convert($args{to_unit});
        return [200, "OK", $new_amount];
    } else {
        my @rows;
        for my $u (
            'mg',
            'mg-pantothenic-acid',
            'mg-d-calcium-pantothenate',
        ) {
            push @rows, {
                unit => $u,
                amount => $quantity->convert($u),
            };
        }
        [200, "OK", \@rows];
    }
}

$SPEC{convert_vitamin_b6_unit} = {
    v => 1.1,
    summary => 'Convert a vitamin B6 (pyridoxine) quantity from one unit to another',
    description => <<'MARKDOWN',

If target unit is not specified, will show all known conversions.

MARKDOWN
    args => {
        %argspecs_common,
        %argspec_quantity_default1mg,
    },
    examples => [
        {args=>{}, summary=>'Show all possible conversions'},
    ],
};
sub convert_vitamin_b6_unit {
    require Physics::Unit;

    Physics::Unit::InitUnit(
        ['mg-pyridoxine'], '1 mg',
        ['mg-pyridoxine-hydrochloride'], '0.8227 mg',
    );

    my %args = @_;
    my $quantity = Physics::Unit->new($args{quantity});
    return [412, "Must be a Mass quantity"] unless $quantity->type eq 'Mass';

    if ($args{to_unit}) {
        my $new_amount = $quantity->convert($args{to_unit});
        return [200, "OK", $new_amount];
    } else {
        my @rows;
        for my $u (
            'mg',
            'mg-pyridoxine',
            'mg-pyridoxine-hydrochloride',
        ) {
            push @rows, {
                unit => $u,
                amount => $quantity->convert($u),
            };
        }
        [200, "OK", \@rows];
    }
}

$SPEC{convert_vitamin_b12_unit} = {
    v => 1.1,
    summary => 'Convert a vitamin B12 (cobalamin) quantity from one unit to another',
    description => <<'MARKDOWN',

If target unit is not specified, will show all known conversions.

MARKDOWN
    args => {
        %argspecs_common,
        %argspec_quantity_default1mcg,
    },
    examples => [
        {args=>{}, summary=>'Show all possible conversions'},
    ],
};
sub convert_vitamin_b12_unit {
    require Physics::Unit;

    Physics::Unit::InitUnit(
        ['mcg'], '0.001 mg',
        ['mcg-cobalamin'], '0.001 mg',
        ['mcg-cyanocobalamin'], '0.999988932992961 mg', # very close to cobalamin as it only adds CN-. molecular weight 1,355.38 g/mol vs 1,355.365
    );

    my %args = @_;
    my $quantity = Physics::Unit->new($args{quantity});
    return [412, "Must be a Mass quantity"] unless $quantity->type eq 'Mass';

    if ($args{to_unit}) {
        my $new_amount = $quantity->convert($args{to_unit});
        return [200, "OK", $new_amount];
    } else {
        my @rows;
        for my $u (
            'mg',
            'mcg',
            'mcg-cobalamin',
            'mcg-cyanocobalamin',
        ) {
            push @rows, {
                unit => $u,
                amount => $quantity->convert($u),
            };
        }
        [200, "OK", \@rows];
    }
}

$SPEC{convert_choline_unit} = {
    v => 1.1,
    summary => 'Convert a choline quantity from one unit to another',
    description => <<'MARKDOWN',

If target unit is not specified, will show all known conversions.

MARKDOWN
    args => {
        %argspecs_common,
        %argspec_quantity_default1mcg,
    },
    examples => [
        {args=>{}, summary=>'Show all possible conversions'},
    ],
};
sub convert_choline_unit {
    require Physics::Unit;

    Physics::Unit::InitUnit(
        ['mcg'], '0.001 mg',
        ['mcg-choline'], '0.001 mg',
        ['mcg-choline-bitartrate'], '0.000411332675222113 mg', # molecular weight: 253.25 vs 104.17
    );

    my %args = @_;
    my $quantity = Physics::Unit->new($args{quantity});
    return [412, "Must be a Mass quantity"] unless $quantity->type eq 'Mass';

    if ($args{to_unit}) {
        my $new_amount = $quantity->convert($args{to_unit});
        return [200, "OK", $new_amount];
    } else {
        my @rows;
        for my $u (
            'mg',
            'mcg',
            'mcg-choline',
            'mcg-choline-bitartrate',
        ) {
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
    description => <<'MARKDOWN',

If target unit is not specified, will show all known conversions.

MARKDOWN
    args => {
        %argspecs_common,
        %argspec_quantity_default1mcg,
    },
    examples => [
        {args=>{}, summary=>'Show all possible conversions'},
        {args=>{quantity=>'2 mcg', to_unit=>'IU'}, summary=>'Convert from mcg to IU'},
        {args=>{quantity=>'5000 IU', to_unit=>'mg'}, summary=>'Convert from IU to mg'},
    ],
};
sub convert_vitamin_d_unit {
    require Physics::Unit;

    capture_stderr {
        Physics::Unit::InitUnit(
            ['g'], 'gram', # emits warning 'already defined' warning, but '3g' won't work if we don't add this
            ['mcg'], '0.001 mg',
            ['IU', 'iu'], '0.025 microgram',
        );
    }; # silence warning

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
    description => <<'MARKDOWN',

If target unit is not specified, will show all known conversions.

MARKDOWN
    args => {
        %argspecs_common,
        %argspec_quantity_default1mg,
    },
    examples => [
        {args=>{}, summary=>'Show all possible conversions'},
        {args=>{quantity=>'67 mg', to_unit=>'IU'}, summary=>'Convert from mg to IU (d-alpha-tocopherol/natural vitamin E)'},
        {args=>{quantity=>'67 mg', to_unit=>'IU-natural'}, summary=>'Convert from mg to IU (d-alpha-tocopherol/natural vitamin E)'},
        {args=>{quantity=>'90 mg', to_unit=>'IU-synthetic'}, summary=>'Convert from mg to IU (dl-alpha-tocopherol/synthetic vitamin E)'},
        {args=>{quantity=>'400 IU', to_unit=>'mg'}, summary=>'Convert from IU to mg'},
    ],
};
sub convert_vitamin_e_unit {
    require Physics::Unit;

    Physics::Unit::InitUnit(
        ['mcg'], '0.001 mg',
        ['mg-alpha-tocopherol-equivalent'], '1 mg',
        ['mg-alpha-TE'], '1 mg',
        ['mg-rrr-alpha-tocopherol'], '1 mg',
        ['mg-d-alpha-tocopherol'], '1 mg', # RRR- = d-
        ['mg-dl-alpha-tocopherol'], '0.738255033557047 mg', # https://www.rfaregulatoryaffairs.com/vitamin-converter

        ['mg-d-alpha-tocopheryl-acetate'], '0.912751677852349 mg', # https://www.rfaregulatoryaffairs.com/vitamin-converter
        ['mg-dl-alpha-tocopheryl-acetate'], '0.671140939597315 mg', # https://www.rfaregulatoryaffairs.com/vitamin-converter

        ['mg-beta-tocopherol'], '0.5 mg',
        ['mg-gamma-tocopherol'], '0.1 mg',
        ['mg-alpha-tocotrienol'], '0.30 mg',
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
        for my $u (
            'mg',
            'mcg',
            'mg-alpha-TE',
            'mg-alpha-tocopherol-equivalent',
            'mg-rrr-alpha-tocopherol',
            'mg-d-alpha-tocopherol',
            'mg-d-alpha-tocopheryl-acetate',
            'mg-dl-alpha-tocopheryl-acetate',
            'mg-dl-alpha-tocopherol',
            'mg-beta-tocopherol',
            'mg-gamma-tocopherol',
            'mg-alpha-tocotrienol',
            'IU',
            'IU-natural',
            'IU-synthetic') {
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

L<App::MineralUtils>

L<Physics::Unit>

Online vitamin converters:
L<https://www.rfaregulatoryaffairs.com/vitamin-converter>,
L<https://avsnutrition.com.au/wp-content/themes/avs-nutrition/vitamin-converter.html>.

=cut
