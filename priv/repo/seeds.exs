{:ok, _character} = %{
  description: "first testing hero",
  attribution_text: "marvel inc",
  name: "Tester",
  etag: "abc",
  hero_id: 0
} |> MarvelGateway.Heroes.create_character()
