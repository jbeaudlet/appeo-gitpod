defmodule Storybook.CoreComponents.Alert do
  use PhoenixStorybook.Story, :component
  alias Elixir.GitpodWeb.CoreComponents

  def function, do: &CoreComponents.alert/1

  def variations do
    [
      %Variation{
        id: :info_no_title,
        attributes: %{
          kind: :info
        },
        slots: ["Info message"]
      },
      %Variation{
        id: :error_with_title_and_slot,
        attributes: %{
          kind: :error,
          title: "There were 2 errors with your submission"
        },
        slots: [
          """
          <ul role="list" class="pl-5 space-y-1 list-disc">
            <li>Your password must be at least 8 characters</li>
            <li>Your password must include at least one pro wrestling finishing move</li>
          </ul>
          """
        ]
      },
      %Variation{
        id: :info_with_title,
        attributes: %{
          kind: :info,
          title: "Info message"
        },
        slots: ["A new software update is available. See what’s new in version 2.0.4."]
      }
    ]
  end
end
