defmodule DreamsBankApiWeb.BankControllerTest do
  use DreamsBankApiWeb.ConnCase

  describe "deposit" do
    test "deposit in account" do
      account = insert(:account, %{owner: "Teste 00", balance: 100})
      conn = post(build_conn(), ~p"/api/accounts/#{account.number}/deposit", %{amount: 100})

      assert json_response(conn, 200) == %{
               "data" => %{
                 "type" => "deposit",
                 "account" => %{
                   "number" => account.number,
                   "owner" => "Teste 00",
                   "balance" => "200"
                 }
               }
             }
    end

    test "deposit in account with invalid amount" do
      account = insert(:account, %{owner: "Teste 00", balance: 100})
      conn = post(build_conn(), ~p"/api/accounts/#{account.number}/deposit", %{amount: -100})

      assert %{
               "error" => "Invalid amount for deposit"
             } = json_response(conn, 422)
    end

    test "deposit in account not found" do
      conn = post(build_conn(), ~p"/api/accounts/123/deposit", %{amount: 100})

      assert %{
               "error" => "Account not found"
             } = json_response(conn, 404)
    end
  end

  describe "withdrawal" do
    test "withdrawal in account" do
      account = insert(:account, %{owner: "Teste 00", balance: 100})
      conn = post(build_conn(), ~p"/api/accounts/#{account.number}/withdrawal", %{amount: 50})

      assert json_response(conn, 200) == %{
               "data" => %{
                 "type" => "withdrawal",
                 "account" => %{
                   "number" => account.number,
                   "owner" => "Teste 00",
                   "balance" => "50"
                 }
               }
             }
    end

    test "withdrawal in account with invalid amount" do
      account = insert(:account, %{owner: "Teste 00", balance: 100})
      conn = post(build_conn(), ~p"/api/accounts/#{account.number}/withdrawal", %{amount: -100})

      assert %{
               "error" => "Invalid amount for withdrawal"
             } = json_response(conn, 422)
    end

    test "withdrawal in account with insufficient funds" do
      account = insert(:account, %{owner: "Teste 00", balance: 100})
      conn = post(build_conn(), ~p"/api/accounts/#{account.number}/withdrawal", %{amount: 200})

      assert %{
               "error" => "Insufficient funds"
             } = json_response(conn, 422)
    end

    test "withdrawal in account not found" do
      conn = post(build_conn(), ~p"/api/accounts/123/withdrawal", %{amount: 100})

      assert %{
               "error" => "Account not found"
             } = json_response(conn, 404)
    end
  end

  describe "transfer" do
    test "transfer between accounts" do
      from_account = insert(:account, %{owner: "Teste 00", balance: 100})
      to_account = insert(:account, %{owner: "Teste 01", balance: 100})

      conn =
        post(build_conn(), ~p"/api/accounts/transfer", %{
          from_account: from_account.number,
          to_account: to_account.number,
          amount: 50
        })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "type" => "transfer",
                 "from_account" => %{
                   "number" => from_account.number,
                   "owner" => "Teste 00",
                   "balance" => "50"
                 },
                 "to_account" => %{
                   "number" => to_account.number,
                   "owner" => "Teste 01",
                   "balance" => "150"
                 }
               }
             }
    end

    test "transfer between same accounts" do
      account = insert(:account, %{owner: "Teste 00", balance: 100})

      conn =
        post(build_conn(), ~p"/api/accounts/transfer", %{
          from_account: account.number,
          to_account: account.number,
          amount: 50
        })

      assert %{
               "error" => "Cannot transfer to the same account"
             } = json_response(conn, 422)
    end

    test "transfer between accounts with invalid amount" do
      from_account = insert(:account, %{owner: "Teste 00", balance: 100})
      to_account = insert(:account, %{owner: "Teste 01", balance: 100})

      conn =
        post(build_conn(), ~p"/api/accounts/transfer", %{
          from_account: from_account.number,
          to_account: to_account.number,
          amount: -50
        })

      assert %{
               "error" => "Invalid amount for transferences"
             } = json_response(conn, 422)
    end

    test "transfer between accounts with insufficient funds" do
      from_account = insert(:account, %{owner: "Teste 00", balance: 100})
      to_account = insert(:account, %{owner: "Teste 01", balance: 100})

      conn =
        post(build_conn(), ~p"/api/accounts/transfer", %{
          from_account: from_account.number,
          to_account: to_account.number,
          amount: 200
        })

      assert %{
               "error" => "Insufficient funds"
             } = json_response(conn, 422)
    end

    test "transfer between accounts with one account not found" do
      from_account = insert(:account, %{owner: "Teste 00", balance: 100})

      conn =
        post(build_conn(), ~p"/api/accounts/transfer", %{
          from_account: from_account.number,
          to_account: "123",
          amount: 50
        })

      assert %{
               "error" => "One or both accounts not found"
             } = json_response(conn, 404)
    end
  end
end
