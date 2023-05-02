defmodule Storybook.CoreComponents.Button do
  use PhoenixStorybook.Story, :component

  def function, do: &Elixir.GitpodWeb.CoreComponents.button/1

  def variations do
    [
      %Variation{
        id: :primary,
        attributes: %{
          kind: :primary
        },
        slots: ["Button"]
      },
      %Variation{
        id: :secondary,
        attributes: %{
          kind: :secondary
        },
        slots: ["Button"]
      },
      %Variation{
        id: :custom_class,
        attributes: %{
          class: "rounded-full",
          kind: :primary
        },
        slots: ["rounded class"]
      },
      %Variation{
        id: :disabled_primary,
        attributes: %{
          disabled: true,
          kind: :primary
        },
        slots: ["Disabled"]
      },
      %Variation{
        id: :disabled_secondary,
        attributes: %{
          disabled: true,
          kind: :secondary
        },
        slots: ["Disabled"]
      },
      %Variation{
        id: :link_primary,
        attributes: %{
          link: true,
          kind: :primary
        },
        slots: ["Link"]
      }
    ]
  end
end
