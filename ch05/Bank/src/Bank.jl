module Bank

using Dates: Date
using Lazy: @forward

export Account, SavingsAccount
export account_number, balance, date_opened, interest_rate, deposit!, withdraw!, transfer!, accrue_daily_interest!

mutable struct Account
    account_number::String
    balance::Float64
    date_opened::Date
end

# Accessors

account_number(a::Account) = a.account_number
balance(a::Account) = a.balance
date_opened(a::Account) = a.date_opened

# Functions

function deposit!(a::Account, amount::Real)
    a.balance += amount
    a.balance
end

function withdraw!(a::Account, amount::Real)
    a.balance -= amount
    a.balance
end

function transfer!(from::Account, to::Account, amount::Real)
    withdraw!(from, amount)
    deposit!(to, amount)
    amount
end

# Delegation

struct SavingsAccount
    acct::Account
    interest_rate::Float64

    SavingsAccount(account_number, balance, date_opened, interest_rate) = new(Account(account_number, balance, date_opened), interest_rate)
end

# Method Forwarding

@forward SavingsAccount.acct account_number, balance, date_opened, deposit!, withdraw!

transfer!(from::SavingsAccount, to::SavingsAccount, amount::Real) = transfer!(from.acct, to.acct, amount)

# new accessor
interest_rate(sa::SavingsAccount) = sa.interest_rate

# new behavior
function accrue_daily_interest!(sa::SavingsAccount)
    interest = balance(sa.acct) * interest_rate(sa) / 365
    deposit!(sa.acct, interest)
end

end
