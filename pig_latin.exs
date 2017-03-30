defmodule PigLatin do

  @vowel_clusters ~w(yt xr)
  @consonant_clusters_3 ~w(thr sch) # also <<consonant>> + "qu"
  @consonant_clusters_2 ~w(ch qu th)
  @vowels ~w(a e i o u)

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    _translate(String.split(phrase, ~r/\W/, trim: true), [])
  end

  defp _translate([], acc), do: Enum.join(acc, " ")
  defp _translate([h|t], acc) do
    _translate(t, acc ++ [_pigify(h)])
  end

  defp _pigify(word) do
    cond do
      String.match?(word, ~r/^[^aeiou]qu/) -> _combine(String.split_at(word, 3))
      String.starts_with?(word, @vowel_clusters) -> _combine(String.split_at(word, 0))
      String.starts_with?(word, @consonant_clusters_3) -> _combine(String.split_at(word, 3))
      String.starts_with?(word, @consonant_clusters_2) -> _combine(String.split_at(word, 2))
      String.starts_with?(word, @vowels) -> _combine(String.split_at(word, 0))
      true -> _combine(String.split_at(word, 1))
    end
  end

  defp _combine({cluster, word}) do
    word <> cluster <> "ay"
  end

end
