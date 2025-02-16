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
end
