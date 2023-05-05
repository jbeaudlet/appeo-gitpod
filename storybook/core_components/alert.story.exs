defmodule Storybook.CoreComponents.Alert do
  use PhoenixStorybook.Story, :component
  alias Elixir.GitpodWeb.CoreComponents

  def function, do: &CoreComponents.alert/1

  def variations do
    [
      %VariationGroup{
        id: :no_title,
        description: "Different king alert",
        variations: [
          %Variation{
            id: :info,
            attributes: %{kind: :info},
            slots: ["Info message"]
          },
          %Variation{
            id: :success,
            attributes: %{kind: :success},
            slots: ["Success message"]
          },
          %Variation{
            id: :warning,
            attributes: %{kind: :warning},
            slots: ["Warning message"]
          },
          %Variation{
            id: :error,
            attributes: %{kind: :error},
            slots: ["Erro message"]
          }
        ]
      },
      %VariationGroup{
        id: :title_only,
        description: "Alert with title only",
        variations: [
          %Variation{
            id: :info,
            attributes: %{title: "There were 2 info with your submission", kind: :info}
          },
          %Variation{
            id: :success,
            attributes: %{title: "There were 2 success with your submission", kind: :success}
          },
          %Variation{
            id: :warning,
            attributes: %{title: "There were 2 warning with your submission", kind: :warning}
          },
          %Variation{
            id: :error,
            attributes: %{title: "There were 2 errors with your submission", kind: :error}
          }
        ]
      },
      %VariationGroup{
        id: :title_and_slot,
        description: "Alert with title and slot",
        variations: [
          %Variation{
            id: :info,
            attributes: %{title: "There were 2 info with your submission", kind: :info},
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
            id: :success,
            attributes: %{title: "There were 2 success with your submission", kind: :success},
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
            id: :warning,
            attributes: %{title: "There were 2 warning with your submission", kind: :warning},
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
            id: :error,
            attributes: %{title: "There were 2 errors with your submission", kind: :error},
            slots: [
              """
              <ul role="list" class="pl-5 space-y-1 list-disc">
                <li>Your password must be at least 8 characters</li>
                <li>Your password must include at least one pro wrestling finishing move</li>
              </ul>
              """
            ]
          }
        ]
      }
    ]
  end
end
