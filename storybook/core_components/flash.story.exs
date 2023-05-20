defmodule Storybook.CoreComponents.Flash do
  use PhoenixStorybook.Story, :component
  alias Elixir.GitpodWeb.CoreComponents

  def function, do: &CoreComponents.flash/1
  def imports, do: [{CoreComponents, [button: 1, show: 1]}]

  def template do
    """
    <.button phx-click={show("#:variation_id")} lsb-code-hidden>
      Open #{":variation_id"}
    </.button>
    <.lsb-variation/>
    """
  end

  def variations do
    [
      %VariationGroup{
        id: :no_title,
        description: "Different flash message types without title",
        variations: [
          %Variation{
            id: :info,
            attributes: %{kind: :info, autoshow: false},
            slots: ["Info message"]
          },
          %Variation{
            id: :success,
            attributes: %{kind: :success, autoshow: false},
            slots: ["Success message"]
          },
          %Variation{
            id: :warning,
            attributes: %{kind: :warning, autoshow: false},
            slots: ["Warning message"]
          },
          %Variation{
            id: :error,
            attributes: %{kind: :error, autoshow: false},
            slots: ["Error message"]
          }
        ]
      },
      %Variation{
        id: :error_with_title,
        attributes: %{
          kind: :error,
          autoshow: false,
          title: "Flash title"
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
