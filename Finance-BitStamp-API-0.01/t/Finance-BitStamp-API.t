#!/usr/bin/perl -wT

use 5.010;
use warnings;
use strict;
use lib qw(.);

use Test::More;

use Data::Dumper;
use JSON;

use constant DEBUG => 0;

# Enter your BitStamp API key, API secret and BitStamp client ID values here...
use constant KEY       => 'BitStamp API key      goes here';
use constant SECRET    => 'BitStamp API secret   goes here';
use constant CLIENT_ID => 'BitStamp API clientID goes here';

use constant PACKAGE   => 'Finance::BitStamp::API';

# Public Tests...
use constant TEST_TICKER           => 1;
use constant TEST_ORDERBOOK        => 1;
use constant TEST_PUB_TRANSACTIONS => 1;
use constant TEST_CONVERSION_RATE  => 1;

# Private Tests...
use constant TEST_BALANCE          => 1;
use constant TEST_TRANSACTIONS     => 1;
use constant TEST_WITHDRAWALS      => 1;
use constant TEST_RIPPLE_ADDRESS   => 1;
use constant TEST_BITCOIN_ADDRESS  => 1;
use constant TEST_ORDERS           => 1;
use constant TEST_PENDING_DEPOSITS => 1;

# THESE REMAIN TO BE TESTED...
# use constant TEST_BUY               => 0;
# use constant TEST_SELL              => 0;
# use constant TEST_CANCEL            => 0;
# use constant TEST_BITCOINwITHDRAWAL => 0;
# use constant TEST_RIPPLEwITHDRAWAL  => 0;

BEGIN { use_ok(PACKAGE) };

main->new->go;

sub new         { bless {} => shift }
sub json        { shift->{json}      || JSON->new }
sub bitstamp    { get_set(@_) }
sub set_public  { shift->bitstamp(Finance::BitStamp::API->new) }
sub set_private { shift->bitstamp(Finance::BitStamp::API->new(key => KEY, secret => SECRET, client_id => CLIENT_ID)) }

sub go  {
    my $self = shift;

    $self->test_count(1);

    can_ok(PACKAGE, qw(new));
    $self->inc_tests;

    say '=== Begin PUBLIC tests' if DEBUG;
    isa_ok($self->set_public, PACKAGE);
    $self->inc_tests;

    if (TEST_TICKER) {
        $self->ticker($self->bitstamp->ticker);
        ok($self->ticker, 'Ticker');
        $self->inc_tests;
    }

    if (TEST_ORDERBOOK) {
        $self->orderbook($self->bitstamp->orderbook);
        ok($self->orderbook, 'Orderbook');
        $self->inc_tests;
    }

    if (TEST_PUB_TRANSACTIONS) {
        $self->public_transactions($self->bitstamp->public_transactions);
        ok($self->public_transactions, 'Public Transactions');
        $self->inc_tests;
    }

    if (TEST_CONVERSION_RATE) {
        $self->conversion_rate($self->bitstamp->conversion_rate);
        ok($self->conversion_rate, 'Conversion Rate');
        $self->inc_tests;
    }
    say '=== Done PUBLIC tests' if DEBUG;

    say '=== Begin PRIVATE tests' if DEBUG;
    isa_ok($self->set_private, PACKAGE);
    $self->inc_tests;

    if (TEST_BALANCE) {
        $self->balance($self->bitstamp->balance);
        ok($self->balance, 'Balance');
        $self->inc_tests;
    }
    if (TEST_TRANSACTIONS) {
        $self->transactions($self->bitstamp->transactions);
        ok($self->transactions, 'Transactions');
        $self->inc_tests;
    }
    if (TEST_WITHDRAWALS) {
        $self->withdrawals($self->bitstamp->withdrawals);
        ok($self->withdrawals, 'Withdrawals');
        $self->inc_tests;
    }
    if (TEST_RIPPLE_ADDRESS) {
        $self->ripple_address($self->bitstamp->ripple_address);
        ok($self->ripple_address, 'Ripple Address');
        $self->inc_tests;
    }
    if (TEST_BITCOIN_ADDRESS) {
        $self->bitcoin_address($self->bitstamp->bitcoin_address);
        ok($self->bitcoin_address, 'Bitcoin Address');
        $self->inc_tests;
    }
    if (TEST_ORDERS) {
        $self->orders($self->bitstamp->orders);
        ok($self->orders, 'Orders');
        $self->inc_tests;
    }
    if (TEST_PENDING_DEPOSITS) {
        $self->pending_deposits($self->bitstamp->pending_deposits);
        ok($self->pending_deposits, 'Pending Deposits');
        $self->inc_tests;
    }
    say '=== Done PRIVATE tests' if DEBUG;
}

sub ticker              { get_set(@_) }
sub orderbook           { get_set(@_) }
sub public_transactions { get_set(@_) }
sub conversion_rate     { get_set(@_) }
sub balance             { get_set(@_) }
sub transactions        { get_set(@_) }
sub withdrawals         { get_set(@_) }
sub ripple_address      { get_set(@_) }
sub bitcoin_address     { get_set(@_) }
sub orders              { get_set(@_) }
sub pending_deposits    { get_set(@_) }
sub test_count          { get_set(@_) }

sub inc_tests {
    my $self = shift;
    return $self->test_count($self->test_count + 1);
}

sub get_set {
    my $self      = shift;
    my $attribute = ((caller(1))[3] =~ /::(\w+)$/)[0];
    $self->{$attribute} = shift if scalar @_;
    return $self->{$attribute};
}

sub DESTROY {
    my $self = shift;
    done_testing($self->test_count || 0);
}


1;

__END__

