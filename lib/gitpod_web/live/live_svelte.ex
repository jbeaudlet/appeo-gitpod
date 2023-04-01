defmodule GitpodWeb.SvelteLive do
  use GitpodWeb, :live_view

  def render(assigns) do
    ~H"""
    <LiveSvelte.render name="Example" props={%{number: @number}} />
    <sl-input label="What is your name?" />
    <sl-input label="Nickname" help-text="What would you like people to call you?" />
    <.sl_input label="check me" type="checkbox" value={true} name="check" />
    <%!-- <.sl_input
      label="Nickname"
      name="nickname"
      help-text="What would you like people to call you?"
    /> --%>
    <.sl_input
      type="select"
      value=""
      label="select"
      options={[Europe: ["UK", "Sweden", "France"], USA: ["NY", "LA"]]}
      name="select"
      helpText="chosse user"
      multiple
      clearable
      maxOptionsVisible={1}
    />
    """
  end

  def handle_event("set_number", %{"number" => number}, socket) do
    {:noreply, assign(socket, :number, number)}
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :number, 5)}
  end
end
