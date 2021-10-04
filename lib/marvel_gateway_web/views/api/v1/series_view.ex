defmodule MarvelGatewayWeb.Api.V1.SeriesView do
  use MarvelGatewayWeb, :view
  alias MarvelGatewayWeb.Api.V1.SeriesView

  # def render("index.json", %{series: series}) do
  #   %{series: render_many(series, SeriesView, "series.json")}
  # end
  #
  # def render("show.json", %{series: series}) do
  #   %{series: render_one(series, SeriesView, "series.json")}
  # end

  def render("show.json", %{series: series}) do
    %{data: render_many(series, SeriesView, "series.json")}
  end

  def render("series.json", %{series: series}) do
    %{
      id: series.id,
      title: series.title,
      description: series.description,
      etag: series.etag,
      thumbnail: series.thumbnail,
      story_count: series.story_count
    }
  end
end
