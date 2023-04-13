defmodule Storybook.CoreComponents.Modal do
  use PhoenixStorybook.Story, :component
  alias Elixir.GitpodWeb.CoreComponents

  def function, do: &CoreComponents.modal/1
  def imports, do: [{CoreComponents, [button: 1, hide_modal: 1, show_modal: 1]}]

  def template do
    """
    <.button phx-click={show_modal(":variation_id")} lsb-code-hidden>
      Open modal
    </.button>
    <.lsb-variation/>
    """
  end

  def variations do
    [
      %Variation{
        id: :default,
        slots: ["Modal body"]
      },
      %Variation{
        id: :with_title_and_subtitle,
        slots: [
          "<:title>Title</:title>",
          "<:subtitle>Subtitle</:subtitle>",
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        ]
      },
      %Variation{
        id: :with_actions,
        attributes: %{
          :on_confirm => {:eval, ~s|hide_modal("modal-single-with-actions")|},
          kind: :error
        },
        slots: [
          "Are you sure you want to deactivate your account? All of your data will be permanently removed. This action cannot be undone.",
          "<:icon><Heroicons.exclamation_triangle outline class='w-6 h-6 text-red-600' /></:icon>",
          "<:title>Deactivate account</:title>",
          "<:confirm>Deactivate</:confirm>",
          "<:cancel>Cancel</:cancel>"
        ]
      }
    ]
  end
end
