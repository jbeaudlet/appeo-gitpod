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
            attributes: %{class: "w-full", kind: "primary"},
            slots: ["primary classes"]
          },
          %Variation{
            id: :secondary,
            attributes: %{class: "w-full", kind: "secondary"},
            slots: ["secondary classes"]
          },
          %Variation{
            id: :danger,
            attributes: %{class: "w-full", kind: "danger"},
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
      },
      %VariationGroup{
        id: :lead_icon,
        description: "Buttons with leading icon",
        variations: [
          %Variation{
            id: :primary,
            attributes: %{link: true, kind: "primary"},
            slots: [
              "primary link",
              """
              <:lead_icon>
                <Heroicons.plus_circle
                  mini
                  class="w-5 h-5"
                />
              </:lead_icon>
              """
            ]
          },
          %Variation{
            id: :secondary,
            attributes: %{link: true, kind: "secondary"},
            slots: [
              "secondary link",
              """
              <:lead_icon>
                <Heroicons.printer
                  mini
                  class="w-5 h-5"
                />
              </:lead_icon>
              """
            ]
          },
          %Variation{
            id: :danger,
            attributes: %{link: true, kind: "danger"},
            slots: [
              "danger link",
              """
              <:lead_icon>
                <Heroicons.x_circle
                  mini
                  class="w-5 h-5"
                />
              </:lead_icon>
              """
            ]
          }
        ]
      },
      %VariationGroup{
        id: :trail_icon,
        description: "Buttons with trailing icon",
        variations: [
          %Variation{
            id: :primary,
            attributes: %{link: true, kind: "primary"},
            slots: [
              "primary link",
              """
              <:trail_icon>
                <Heroicons.plus_circle
                  mini
                  class="w-5 h-5"
                />
              </:trail_icon>
              """
            ]
          },
          %Variation{
            id: :secondary,
            attributes: %{link: true, kind: "secondary"},
            slots: [
              "secondary link",
              """
              <:trail_icon>
                <Heroicons.printer
                  mini
                  class="w-5 h-5"
                />
              </:trail_icon>
              """
            ]
          },
          %Variation{
            id: :danger,
            attributes: %{link: true, kind: "danger"},
            slots: [
              "danger link",
              """
              <:trail_icon>
                <Heroicons.x_circle
                  mini
                  class="w-5 h-5"
                />
              </:trail_icon>
              """
            ]
          }
        ]
      }
    ]
  end
end
