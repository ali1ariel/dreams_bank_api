defmodule DreamsBankApiWeb.LoadBalancerPlug do
  @moduledoc """
  This plug is responsible for load balancing the requests between the nodes. It's a simple way to handle the connections inside the application.
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case Node.list() do
      [] ->
        conn

      nodes ->
        target_node = Enum.random(nodes)
        assign(conn, :target_node, target_node)
    end
  end
end
