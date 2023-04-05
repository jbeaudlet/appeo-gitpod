defmodule Storybook.CoreComponents.Button do
  use PhoenixStorybook.Story, :component

  def function, do: &Elixir.GitpodWeb.CoreComponents.button/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          kind: :secondary
        },
        slots: ["Button"]
      },
      %Variation{
        id: :custom_class,
        attributes: %{
          class: "rounded-full bg-indigo-500 hover:bg-indigo-600",
          kind: :secondary
        },
        slots: ["Disabled"]
      },
      %Variation{
        id: :disabled,
        attributes: %{
          disabled: true,
          kind: :primary
        },
        slots: ["Disabled"]
      }
    ]
  end
end
