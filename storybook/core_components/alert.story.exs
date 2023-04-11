defmodule Storybook.CoreComponents.Alert do
  use PhoenixStorybook.Story, :component
  alias Elixir.GitpodWeb.CoreComponents

  def function, do: &CoreComponents.alert/1

  def variations do
    [
      %Variation{
        id: :info_no_title,
        attributes: %{
          kind: :info,
          autoshow: false
        },
        slots: ["Info message"]
      },
      %Variation{
        id: :error_with_title,
        attributes: %{
          kind: :error,
          autoshow: false,
          title: "Alert title"
        },
        slots: ["Error message"]
      },
      %Variation{
        id: :no_close_button,
        attributes: %{
          kind: :info,
          autoshow: false,
          close: false
        },
        slots: ["Info message"]
      }
    ]
  end
end
