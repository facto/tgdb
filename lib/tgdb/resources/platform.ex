defmodule Tgdb.Platform do
  use Tgdb.Resource

  def get_all(params \\ [], opts \\ []) do
    get("", "v1", params, opts)
  end

  def get_by_id(params, opts \\ []) do
    get("ByPlatformID", "v1", params, opts)
  end

  def get_by_name(params, opts \\ []) do
    get("ByPlatformName", "v1", params, opts)
  end

  def get_by_images(params, opts \\ []) do
    get("Images", "v1", params, opts)
  end

  def supported_endpoints do
    %{
      "" => ["v1"],
      "ByPlatformID" => ["v1"],
      "ByPlatformName" => ["v1"],
      "Images" => ["v1"],
    }
  end



  def required_params("", "v1") do
    ~w(
    )a
  end

  def required_params("ByPlatformID", "v1") do
    ~w(
      id
    )a
  end

  def required_params("ByPlatformName", "v1") do
    ~w(
      name
    )a
  end

  def required_params("Images", "v1") do
    ~w(
      platforms_id
    )a
  end



  def optional_params("", "v1") do
    ~w(
      fields
    )a
  end

  def optional_params("ByPlatformID", "v1") do
    ~w(
      fields
    )a
  end

  def optional_params("ByPlatformName", "v1") do
    ~w(
      fields
    )a
  end

  def optional_params("Images", "v1") do
    ~w(
      filter[type]
      page
    )a
  end
end
