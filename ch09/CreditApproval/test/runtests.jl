using CreditApproval
using Mocking
using Test

# Mocking.jl needs these
using CreditApproval: check_background, create_account, notify_downstream
Mocking.activate()

@testset "CreditApproval.jl" begin
    let first_name = "John", last_name = "Doe", email = "jdoe@julia-is-awesome.com"
        check_background_failure_patch = @patch function check_background(
            first_name, last_name
        )
            println("check_background sub => simulating failure")
            false
        end

        apply(check_background_failure_patch) do
            @test open_account(first_name, last_name, email) == :failure
        end
    end

    let check_background_call = 0,
        create_account_call = 0,
        notify_downstream_call = 0,
        notify_downstream_received_proper_account_number = false

        check_background_success_patch = @patch function check_background(
            first_name, last_name
        )
            check_background_call += 1
            println("check_background mock is called, simulating success")
            true
        end

        create_account_patch = @patch function create_account(first_name, last_name, email)
            create_account_call += 1
            println("create account_number mock is called")
            314
        end

        notify_downstream_patch = @patch function notify_downstream(account_number)
            notify_downstream_call += 1
            if account_number > 0
                notify_downstream_received_proper_account_number = true
            end
            println("notify downstream mock is called")
            nothing
        end

        function verify()
            @test check_background_call == 1
            @test create_account_call == 1
            @test notify_downstream_call == 1
            @test notify_downstream_received_proper_account_number
        end

        apply([
            check_background_success_patch, create_account_patch, notify_downstream_patch
        ]) do
            @test open_account("peter", "doe", "pdoe@julia-is-awesome.com") == :success
        end

        verify()
    end
end
