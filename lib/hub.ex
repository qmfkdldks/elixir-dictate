defmodule Hub do
  @moduledoc """
  Documentation for Hub.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Hub.hello()
      :world

  """
  HTTPotion.start()
  @api_key "Za1aNI_dbulXiYBTeHZejkNqu6Oz6D8BCRiP9DnWhkGf"
  @external_resource audio_path = Path.join([__DIR__, "audio.flac"])
  audio = File.read!(audio_path)

  IO.inspect("hihihii")

  response =
    HTTPotion.post(
      "https://stream.watsonplatform.net/speech-to-text/api/v1/recognize",
      body: IO.iodata_to_binary(audio),
      basic_auth: {"apikey", @api_key},
      headers: [
        "Content-Type": "audio/flac"
      ],
      timeout: 50000
    )

  json =
    response
    |> Map.get(:body)
    |> Poison.decode!()

  IO.inspect(json)
  IO.inspect(json["results"])
  result_object = List.first(json["results"])

  best_candiate = List.first(result_object["alternatives"])
  IO.inspect(best_candiate)
  transcript = best_candiate["transcript"]

  transcript
  |> String.split(" ")
  |> Enum.each(fn word ->
    def unquote(String.to_atom(word))() do
      unquote(Macro.escape(word))
    end
  end)

  def hello do
    :world
  end
end
