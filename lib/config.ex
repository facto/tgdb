defmodule Tgdb.Config do
  @otp_app :tgdb

  def api_key, do: from_env(:api_key)

  def api_root, do: from_env(:api_root)

  def from_env(key, default \\ nil) do
    @otp_app
    |> Application.get_env(key, default)
    |> maybe_read_from_system(default)
  end

  defp maybe_read_from_system({:system, env}, default), do: System.get_env(env) || default
  defp maybe_read_from_system(value, _default), do: value
end
