defmodule Tgdb.Api do
  alias Tgdb.Config

  require Logger

  def base_url(module, endpoint, api_version) do
    case validate_endpoint(module, endpoint, api_version) do
      :ok ->
        url = Config.api_root()
              |> URI.parse()
              |> URI.merge("#{api_version}/#{module.resource_collection_name()}")
              |> to_string()
        {:ok, url}
      error -> error
    end
  end

  def url(module, endpoint, api_version, params) do
    with {:ok, base_url} <- base_url(module, endpoint, api_version),
         :ok <- validate_params(module, endpoint, api_version, params)
    do
      query = build_query_params(params)
      {:ok, "#{base_url}#{endpoint_for_url(endpoint)}?#{query}"}
    else
      error -> error
    end
  end

  def request_headers do
    [Accept: "application/json; charset=utf-8"]
  end

  def get(module, endpoint, api_version, params, opts \\ []) do
    with :ok <- validate_endpoint(module, endpoint, api_version),
         :ok <- validate_params(module, endpoint, api_version, params),
         {:ok, url} <- build_request(module, endpoint, api_version, params),
         {:ok, response} <- send_request(url, opts),
         {:ok, parsed_response} <- parse_response(response)
    do
      {:ok, parsed_response}
    else
      error -> error
    end
  end

  def get(url, opts \\ []) do
    with {:ok, response} <- send_request(url, opts),
         {:ok, parsed_response} <- parse_response(response)
    do
      {:ok, parsed_response}
    else
      error -> error
    end
  end

  def get_next_page(%{pages: %{next: nil}}), do: nil
  def get_next_page(%{pages: %{next: next_page_url}}), do: get(next_page_url)

  def get_previous_page(%{pages: %{previous: nil}}), do: nil
  def get_previous_page(%{pages: %{previous: previous_page_url}}), do: get(previous_page_url)

  def remaining_monthly_allowance(%{remaining_monthly_allowance: allowance}), do: allowance
  def remaining_monthly_allowance(_other), do: nil

  def extra_allowance(%{extra_allowance: allowance}), do: allowance
  def extra_allowance(_other), do: nil

  # PRIVATE ##################################################

  defp validate_endpoint(module, endpoint, api_version) do
    api_versions = Map.get(module.supported_endpoints(), endpoint)
    if api_versions do
      if Enum.member?(api_versions, api_version) do
        :ok
      else
        {:error, "Unsupported API version for #{module.resource_collection_name()} API: #{api_version}"}
      end
    else
      {:error, "Unsupported endpoint for #{module.resource_collection_name()} API: #{endpoint}"}
    end
  end

  defp validate_params(module, endpoint, api_version, params) do
    supported_params = module.supported_params(endpoint, api_version) ++ always_supported_params()
    present_params = params
                     |> Keyword.keys()
                     |> Enum.sort()
    unsupported_params = present_params -- supported_params

    if length(unsupported_params) == 0 do
      missing_required_params = module.required_params(endpoint, api_version) -- present_params
      if length(missing_required_params) == 0 do
        :ok
      else
        {:error, "Missing required param(s) for /#{api_version}/#{module.resource_collection_name()}#{endpoint_for_url(endpoint)}: #{inspect(missing_required_params)}"}
      end
    else
      {:error, "Unsupported param(s) for /#{api_version}/#{module.resource_collection_name()}#{endpoint_for_url(endpoint)}: #{inspect(unsupported_params)}"}
    end
  end

  defp always_supported_params() do
    [:apikey]
  end

  defp build_request(module, endpoint, api_version, params) do
    url(module, endpoint, api_version, params)
  end

  defp send_request(url, opts) do
    # Logger.debug("Requesting #{url}")
    httpoison_opts = Keyword.get(opts, :httpoison_opts, [])

    HTTPoison.get(url, request_headers(), httpoison_opts)
  end

  defp parse_response(%{body: body, status_code: 200}) do
    {:ok, Jason.decode!(body, keys: :atoms)}
  end

  defp parse_response(%{body: body, status_code: 400}) do
    {:error, "Server reported bad input parameter: #{inspect(body)}"}
  end

  defp parse_response(%{body: body, status_code: 403}) do
    {:error, "Server reported bad API key or hit rate-limit cap: #{inspect(body)}"}
  end

  defp build_query_params(params) do
    params
    |> Keyword.put_new(:apikey, Config.api_key())
    |> URI.encode_query()
  end

  defp endpoint_for_url("" = endpoint), do: endpoint

  defp endpoint_for_url(endpoint), do: "/#{endpoint}"
end
