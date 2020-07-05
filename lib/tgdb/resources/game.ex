defmodule Tgdb.Game do
  use Tgdb.Resource

  def get_by_id(params, opts \\ []) do
    get("ByGameID", "v1", params, opts)
  end

  def get_by_name(params, opts \\ []) do
    get("ByGameName", "v1.1", params, opts)
  end

  def get_by_platform_id(params, opts \\ []) do
    get("ByPlatformID", "v1", params, opts)
  end

  def get_images(params, opts \\ []) do
    get("Images", "v1", params, opts)
  end

  def get_updates(params, opts \\ []) do
    get("Updates", "v1", params, opts)
  end

  def supported_endpoints do
    %{
      "ByGameID" => ["v1"],
      "ByGameName" => ["v1.1", "v1"],
      "ByPlatformID" => ["v1"],
      "Images" => ["v1"],
      "Updates" => ["v1"],
    }
  end




  def required_params("ByGameID", "v1") do
    ~w(
      id
    )a
  end

  def required_params("ByGameName", api_version) when api_version in ["v1", "v1.1"] do
    ~w(
      name
    )a
  end

  def required_params("ByPlatformID", "v1") do
    ~w(
      id
    )a
  end

  def required_params("Images", "v1") do
    ~w(
      games_id
    )a
  end

  def required_params("Updates", "v1") do
    ~w(
    )a
  end




  def optional_params("ByGameID", "v1") do
    ~w(
      fields
      include
      page
    )a
  end

  def optional_params("ByGameName", api_version) when api_version in ["v1", "v1.1"] do
    ~w(
      fields
      filter[platform]
      include
      page
    )a
  end

  def optional_params("ByPlatformID", "v1") do
    ~w(
      fields
      include
      page
    )a
  end

  def optional_params("Images", "v1") do
    ~w(
      filter[type]
      page
    )a
  end

  def optional_params("Updates", "v1") do
    ~w(
      last_edit_id
      time
      page
    )a
  end
end
