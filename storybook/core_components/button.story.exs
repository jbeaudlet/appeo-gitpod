defmodule Storybook.CoreComponents.Button do
  use PhoenixStorybook.Story, :component

  def function, do: &Elixir.GitpodWeb.CoreComponents.button/1

  def variations do
    [
      %VariationGroup{
        id: :colors,
        description: "Different color buttons",
        variations: [
          %Variation{
            id: :primary,
            attributes: %{kind: "primary"},
            slots: ["primary button"]
          },
          %Variation{
            id: :secondary,
            attributes: %{kind: "secondary"},
            slots: ["secondary button"]
          },
          %Variation{
            id: :danger,
            attributes: %{kind: "danger"},
            slots: ["danger button"]
          }
        ]
      },
      %VariationGroup{
        id: :classes,
        description: "Buttons with classes",
        variations: [
          %Variation{
            id: :primary,
            attributes: %{class: "rounded-full", kind: "primary"},
            slots: ["primary classes"]
          },
          %Variation{
            id: :secondary,
            attributes: %{class: "rounded-full", kind: "secondary"},
            slots: ["secondary classes"]
          },
          %Variation{
            id: :danger,
            attributes: %{class: "rounded-full", kind: "danger"},
            slots: ["danger classes"]
          }
        ]
      },
      %VariationGroup{
        id: :disabled,
        description: "Disabled buttons",
        variations: [
          %Variation{
            id: :primary,
            attributes: %{disabled: true, kind: "primary"},
            slots: ["primary classes"]
          },
          %Variation{
            id: :secondary,
            attributes: %{disabled: true, kind: "secondary"},
            slots: ["secondary classes"]
          },
          %Variation{
            id: :danger,
            attributes: %{disabled: true, kind: "danger"},
            slots: ["danger classes"]
          }
        ]
      },
      %VariationGroup{
        id: :link,
        description: "Link styles as buttons",
        variations: [
          %Variation{
            id: :primary,
            attributes: %{link: true, kind: "primary"},
            slots: ["primary link"]
          },
          %Variation{
            id: :secondary,
            attributes: %{link: true, kind: "secondary"},
            slots: ["secondary link"]
          },
          %Variation{
            id: :danger,
            attributes: %{link: true, kind: "danger"},
            slots: ["danger link"]
          }
        ]
      }
    ]
  end
end
