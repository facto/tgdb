defmodule Tgdb.Developer do
  use Tgdb.Resource

  def get_all(params \\ [], opts \\ []) do
    get("", "v1", params, opts)
  end

  def supported_endpoints do
    %{
      "" => ["v1"],
    }
  end



  def required_params("", "v1") do
    ~w(
    )a
  end



  def optional_params("", "v1") do
    ~w(
    )a
  end
end
