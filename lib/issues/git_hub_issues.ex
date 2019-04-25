defmodule Issues.GitHubIssues do
  require Logger

  @user_agent [{"User-agent", "Elixir ray@raygesualdo.com"}]
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    Logger.info("Fetching #{user}'s project \"#{project}\"")

    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response()
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({_, %{status_code: status_code, body: body}}) do
    Logger.info("Got response: status_code=#{status_code}")
    Logger.debug(fn -> inspect(body) end)
    {
      status_code |> check_for_errors(),
      body |> Poison.decode!()
    }
  end

  defp check_for_errors(200), do: :ok
  defp check_for_errors(_), do: :error
end
