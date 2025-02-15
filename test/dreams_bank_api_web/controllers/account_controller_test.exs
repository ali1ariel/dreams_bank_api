defmodule DreamsBankApiWeb.AccountControllerTest do
  use DreamsBankApiWeb.ConnCase

  test "list accounts" do
    conn = get(build_conn(), "/api/accounts")
    assert json_response(conn, 200) == %{"data" => []}
  end

  test "show account" do
    account = insert(:account, %{owner: "Teste 00", balance: 100})
    conn = get(build_conn(), ~p"/api/accounts/#{account.id}")

    assert json_response(conn, 200) == %{
             "data" => %{
               "id" => account.id,
               "type" => "account",
               "owner" => "Teste 00",
               "balance" => "100",
               "number" => account.number
             }
           }
  end

  test "create account" do
    conn = post(build_conn(), "/api/accounts", %{account: %{owner: "Teste 00", balance: "100"}})

    assert %{
             "data" => %{
               "id" => _id,
               "type" => "account",
               "owner" => "Teste 00",
               "balance" => "100"
             }
           } = json_response(conn, 201)
  end

  test "create account with invalid data" do
    conn = post(build_conn(), "/api/accounts", %{account: %{owner: "Teste 00", balance: "-100"}})

    assert %{
             "errors" => _
           } = json_response(conn, 422)
  end

  test "update account" do
    account = insert(:account, %{owner: "Teste 00", balance: 100})

    conn =
      put(build_conn(), ~p"/api/accounts/#{account.id}", %{
        id: account.id,
        account: %{owner: "Teste 01", balance: 200}
      })

    assert json_response(conn, 200) == %{
             "data" => %{
               "id" => account.id,
               "type" => "account",
               "owner" => "Teste 01",
               "balance" => "200",
               "number" => account.number
             }
           }
  end

  test "update account with invalid data" do
    account = insert(:account, %{owner: "Teste 00", balance: 100})

    conn =
      put(build_conn(), ~p"/api/accounts/#{account.id}", %{
        id: account.id,
        account: %{owner: "Teste 01", balance: -200}
      })

    assert %{
             "errors" => _
           } = json_response(conn, 422)
  end

  test "delete account" do
    account = insert(:account, %{owner: "Teste 00", balance: 100})
    conn = delete(build_conn(), ~p"/api/accounts/#{account.id}")
    assert response(conn, 204) == ""
  end

  test "show account by number" do
    account = insert(:account, %{owner: "Teste 00", balance: 100})
    conn = get(build_conn(), ~p"/api/accounts/number/#{account.number}")

    assert json_response(conn, 200) == %{
             "data" => %{
               "id" => account.id,
               "type" => "account",
               "owner" => "Teste 00",
               "balance" => "100",
               "number" => account.number
             }
           }
  end
end
