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
               "balance" => "100"
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
               "balance" => "200"
             }
           }
  end

  test "delete account" do
    account = insert(:account, %{owner: "Teste 00", balance: 100})
    conn = delete(build_conn(), ~p"/api/accounts/#{account.id}")
    assert response(conn, 204) == ""
  end
end
