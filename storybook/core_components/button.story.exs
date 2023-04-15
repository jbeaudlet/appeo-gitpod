defmodule Storybook.CoreComponents.Button do
  use PhoenixStorybook.Story, :component

  def function, do: &Elixir.GitpodWeb.CoreComponents.button/1

  def template do
    """
    <div class="text-gray-600 bg-white dark:bg-slate-900 dark:text-gray-400">
      <button onclick="document.documentElement.classList.toggle('dark')">Toggle Dark</button>
      <div class="lsb-p-10">
        <.lsb-variation/>
      </div>
    </div>
    """
  end

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
      }
    ]
  end
end
