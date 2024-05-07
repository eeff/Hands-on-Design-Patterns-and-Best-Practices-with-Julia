module CreditApproval

using Mocking

export open_account

# Open a new account.
# Returns `:success` if account is created successfully.
# Returns `:failure` if background check fails.
function open_account(first_name, last_name, email)
    @mock(check_background(first_name, last_name)) || return :failure
    account_number = @mock(create_account(first_name, last_name, email))
    @mock(notify_downstream(account_number))
    :success
end

# Background check.
function check_background(first_name, last_name)
    println("Doing background check for $first_name $last_name")
    true
end

# Create an account, return the account number.
function create_account(first_name, last_name, email)
    println("Creating an account for $first_name $last_name")
    42
end

# Notify downstream system by sending a message.
function notify_downstream(account_number)
    println("Notifying downstream system about new account $account_number")
    nothing
end

end
