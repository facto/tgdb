defmodule Tgdb.Resource do
  @moduledoc """
  Representation of resource inside the API
  """

  defmacro __using__(_opts) do
    quote location: :keep do
      def get(endpoint, api_version, params, opts) do
        Tgdb.Api.get(__MODULE__, endpoint, api_version, params, opts)
      end

      def supported_endpoints, do: raise "Please implement supported_endpoints/0 for #{__MODULE__}"

      def supported_params(endpoint, api_version) do
        required_params(endpoint, api_version) ++ optional_params(endpoint, api_version)
        |> Enum.sort()
      end

      def optional_params(_,_), do: raise "Please implement optional_params/2 for #{__MODULE__}"

      def required_params(_,_), do: raise "Please implement required_params/2 for #{__MODULE__}"

      def resource_collection_name do
        __MODULE__
        |> to_string()
        |> String.split(".")
        |> List.last()
        |> Kernel.<>("s")
      end

      defoverridable resource_collection_name: 0,
                     optional_params: 2,
                     required_params: 2,
                     supported_endpoints: 0
    end
  end
end
