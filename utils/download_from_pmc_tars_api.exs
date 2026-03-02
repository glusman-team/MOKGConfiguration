Mix.install([
  {:req, "~> 0.4"},
  {:yaml_elixir, "~> 2.9"}
])

[dir] = System.argv()

table_configs =
  dir <> "*.yaml"
  |> Path.wildcard()

Task.async_stream(
  table_configs,
  fn yaml_file ->
    try do
      data = YamlElixir.read_from_file!(yaml_file)

      file_name =
        data["template"]["source"]["url"]
        |> Path.basename()

      pmc_id = data["template"]["provenance"]["publication"]
      local_path = data["template"]["source"]["local"]

      url = "http://localhost:8051/extract-from-tar?" <>
        URI.encode_query(%{
          "filename" => "#{pmc_id}/#{file_name}",
          "tarpath" => "/15TB_1/users/gglusman/PMC/tars/#{String.slice(pmc_id, -3..-1)}/#{pmc_id}.tar.xz"
        })

      unless File.exists?(local_path) do
        case Req.get(url) do
          {:ok, %{status: 200, body: body}} ->
            File.write!(local_path, body)

          {:ok, %{status: status}} ->
            IO.puts("CODE 03 | HTTP ERROR #{status} FOR #{yaml_file}")

          {:error, reason} ->
            IO.puts("CODE 04 | REQUEST FAILED FOR #{yaml_file}: #{inspect(reason)}")
        end
      end

      IO.puts("CODE 01 | SUCCEDED #{yaml_file}")
    rescue
      e -> IO.puts("CODE 02 | FAILED #{yaml_file}: #{Exception.message(e)}")
    end
  end,
  max_concurrency: 10,
  timeout: 60_000,
  ordered: false
)
|> Stream.run()
