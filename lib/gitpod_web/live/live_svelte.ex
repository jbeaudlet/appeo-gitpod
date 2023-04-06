defmodule GitpodWeb.SvelteLive do
  use GitpodWeb, :live_view

  def render(assigns) do
    ~H"""
    <%!-- <LiveSvelte.render name="Example" props={%{number: @number}} /> --%>
    <.input
      type="checkbox"
      label="input with errors"
      value=""
      placeholder="error"
      name="my-input"
      help_text="C'est une aide"
    />
    <.button disabled type="button">Boutton</.button>
    <.button kind={:secondary} type="button">Boutton</.button>
    """
  end

  def handle_event("set_number", %{"number" => number}, socket) do
    {:noreply, assign(socket, :number, number)}
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :number, 5)}
  end
end
