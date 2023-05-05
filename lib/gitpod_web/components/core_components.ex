defmodule GitpodWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.

  The components in this module use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn how to
  customize the generated components in this module.

  Icons are provided by [heroicons](https://heroicons.com), using the
  [heroicons_elixir](https://github.com/mveytsman/heroicons_elixir) project.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  import GitpodWeb.Gettext

  @doc """
  Renders a modal.

  ## Examples

      <.modal id="confirm-modal">
        Are you sure?
        <:confirm>OK</:confirm>
        <:cancel>Cancel</:cancel>
      </.modal>

  JS commands may be passed to the `:on_cancel` and `on_confirm` attributes
  for the caller to react to each button press, for example:

      <.modal id="confirm" on_confirm={JS.push("delete")} on_cancel={JS.navigate(~p"/posts")}>
        Are you sure you?
        <:confirm>OK</:confirm>
        <:cancel>Cancel</:cancel>
      </.modal>
  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  attr :on_confirm, JS, default: %JS{}

  attr :kind, :atom,
    values: [:none, :info, :success, :warning, :error],
    default: :none,
    doc: "used for styling the color backrgound icon slot"

  slot :inner_block, required: true
  slot :icon
  slot :title
  slot :subtitle
  slot :confirm
  slot :cancel

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      class="relative z-10 hidden"
      aria-labelledby={"#{@id}-title"}
      aria-describedby={"#{@id}-description"}
      role="dialog"
      aria-modal="true"
      tabindex="0"
    >
      <div
        id={"#{@id}-bg"}
        class="fixed inset-0 transition-opacity bg-gray-500/75"
        aria-hidden="true"
      />
      <div class="fixed inset-0 z-10 overflow-y-auto">
        <div class="flex items-end justify-center min-h-full p-4 text-center sm:items-center sm:p-0">
          <.focus_wrap
            id={"#{@id}-container"}
            class="relative px-4 pt-5 pb-4 overflow-hidden text-left transition-all transform bg-white rounded-lg shadow-xl dark:bg-slate-900 dark:text-gray-400 dark:shadow-slate-700/70 sm:my-8 sm:w-full sm:max-w-lg sm:p-6"
            phx-mounted={@show && show_modal(@id)}
            phx-window-keydown={hide_modal(@on_cancel, @id)}
            phx-key="escape"
            phx-click-away={hide_modal(@on_cancel, @id)}
          >
            <div class="absolute top-0 right-0 hidden pt-4 pr-4 sm:block">
              <button
                phx-click={hide_modal(@on_cancel, @id)}
                type="button"
                class="text-gray-400 transition-all bg-white rounded-md hover:text-gray-500 focus:ring-offset-white focus:outline-none focus:ring-2 focus:ring-primary-500 dark:bg-slate-900 dark:focus:ring-gray-500"
                aria-label={gettext("close")}
              >
                <span class="sr-only"><%= gettext("close") %></span>
                <Heroicons.x_mark solid class="w-6 h-6" />
              </button>
            </div>
            <div id={"#{@id}-content"} class="sm:flex sm:items-start">
              <div
                :if={@icon != []}
                class={[
                  "flex items-center justify-center flex-shrink-0 w-12 h-12 mx-auto rounded-full sm:mx-0 sm:h-10 sm:w-10",
                  @kind == :info && "bg-blue-100",
                  @kind == :success && "bg-green-100",
                  @kind == :warning && "bg-yellow-100",
                  @kind == :error && "bg-red-100"
                ]}
              >
                <%= render_slot(@icon) %>
              </div>
              <div class="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left">
                <header :if={@title != [] or @subtitle != []}>
                  <h3 id={"#{@id}-title"} class="text-base font-semibold leading-6 text-gray-900">
                    <%= render_slot(@title) %>
                  </h3>
                  <p
                    :if={@subtitle != []}
                    id={"#{@id}-description"}
                    class="mt-1 text-sm leading-6 text-gray-600"
                  >
                    <%= render_slot(@subtitle) %>
                  </p>
                </header>
                <div class="mt-2 text-gray-500">
                  <%= render_slot(@inner_block) %>
                </div>
              </div>
            </div>
            <div
              :if={@confirm != [] or @cancel != []}
              class="fmt-5 sm:mt-4 sm:flex sm:flex-row-reverse"
            >
              <.button
                :for={confirm <- @confirm}
                id={"#{@id}-confirm"}
                phx-click={@on_confirm}
                phx-disable-with
                kind={if @kind == :error, do: "danger", else: "primary"}
                class="inline-flex justify-center w-full sm:ml-3 sm:w-auto"
              >
                <%= render_slot(confirm) %>
              </.button>
              <.button
                :for={cancel <- @cancel}
                phx-click={hide_modal(@on_cancel, @id)}
                class="inline-flex justify-center w-full sm:mt-0 sm:w-auto"
                kind="secondary"
              >
                <%= render_slot(cancel) %>
              </.button>
            </div>
          </.focus_wrap>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, default: "flash", doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil

  attr :kind, :atom,
    values: [:info, :success, :warning, :error],
    doc: "used for styling and flash lookup"

  attr :autoshow, :boolean, default: true, doc: "whether to auto show the flash on mount"
  attr :close, :boolean, default: true, doc: "whether the flash can be closed"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-mounted={@autoshow && show("##{@id}")}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      aria-live="assertive"
      class="fixed inset-0 z-50 flex items-end hidden px-4 py-6 pointer-events-none sm:items-start sm:p-6"
      {@rest}
    >
      <div class="flex flex-col items-center w-full space-y-4 sm:items-end">
        <div class="w-full max-w-sm overflow-hidden bg-white rounded-lg shadow-lg pointer-events-auto ring-1 ring-black ring-opacity-5">
          <div class="p-4">
            <div class="flex items-start">
              <div class="flex-shrink-0">
                <Heroicons.information_circle
                  :if={@kind == :info}
                  outline
                  class="w-6 h-6 text-blue-400"
                />
                <Heroicons.check_circle
                  :if={@kind == :success}
                  outline
                  class="w-6 h-6 text-green-400"
                />
                <Heroicons.exclamation_triangle
                  :if={@kind == :warning}
                  outline
                  class="w-6 h-6 text-yellow-400"
                />
                <Heroicons.exclamation_circle
                  :if={@kind == :error}
                  outline
                  class="w-6 h-6 text-red-400"
                />
              </div>
              <div class="ml-3 w-0 flex-1 pt-0.5">
                <p :if={@title} class="text-sm font-medium text-gray-900">
                  <%= @title %>
                </p>
                <div class={["text-sm text-gray-500", @title && "mt-1"]}>
                  <%= msg %>
                </div>
              </div>
              <div :if={@close} class="flex flex-shrink-0 ml-4">
                <button
                  type="button"
                  class="inline-flex text-gray-400 bg-white rounded-md hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2"
                  aria-label={gettext("close")}
                >
                  <span class="sr-only"><%= gettext("close") %></span>
                  <Heroicons.x_mark solid class="w-5 h-5" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  def flash_group(assigns) do
    ~H"""
    <.flash kind={:info} title="Information!" flash={@flash} />
    <.flash kind={:success} title="Success!" flash={@flash} />
    <.flash kind={:warning} title="Warning!" flash={@flash} />
    <.flash kind={:error} title="Error!" flash={@flash} />
    <.flash
      id="disconnected"
      kind={:error}
      title={gettext("We can't find the internet")}
      close={false}
      autoshow={false}
      phx-disconnected={show("#disconnected")}
      phx-connected={hide("#disconnected")}
    >
      <%= gettext("Attempting to reconnect") %>
      <Heroicons.arrow_path class="inline w-3 h-3 ml-1 animate-spin" />
    </.flash>
    """
  end

  @doc """
  Renders alert notices.

  ## Examples

      <.alert kind={:error} title="There were 2 errors with your submission"} />
        <ul role="list" class="pl-5 space-y-1 list-disc">
          <li>Your password must be at least 8 characters</li>
          <li>Your password must include at least one pro wrestling finishing move</li>
        </ul>
      </.alert>
  """
  attr :id, :string, default: "alert", doc: "the optional id of alert container"
  attr :title, :string, default: nil

  attr :kind, :atom,
    values: [:info, :success, :warning, :error],
    doc: "used for styling of alert"

  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the alert container"

  slot :inner_block, doc: "the optional inner block that renders the alert message"

  def alert(assigns) do
    ~H"""
    <div
      id={@id}
      class={[
        "p-4 rounded-md",
        @kind == :info && "border-blue-400 bg-blue-50 text-blue-700",
        @kind == :success && "border-green-400 bg-green-50 text-green-700",
        @kind == :warning && "border-yellow-400 bg-yellow-50 text-yellow-700",
        @kind == :error && "border-red-400 bg-red-50 text-red-700"
      ]}
      {@rest}
    >
      <div class="flex">
        <div class="flex-shrink-0">
          <Heroicons.information_circle :if={@kind == :info} mini class="w-5 h-5 text-blue-400" />
          <Heroicons.check_circle :if={@kind == :success} mini class="w-5 h-5 text-green-400" />
          <Heroicons.exclamation_triangle
            :if={@kind == :warning}
            mini
            class="w-5 h-5 text-yellow-400"
          />
          <Heroicons.exclamation_circle :if={@kind == :error} mini class="w-5 h-5 text-red-400" />
        </div>
        <div class="ml-3">
          <h3
            :if={@title}
            class={[
              "text-sm font-medium",
              @kind == :info && "text-blue-800",
              @kind == :success && "text-green-800",
              @kind == :warning && "text-yellow-800",
              @kind == :error && "text-red-800"
            ]}
          >
            <%= @title %>
          </h3>
          <div
            :if={@inner_block}
            class={[
              "text-sm",
              @title && "mt-2",
              @kind == :info && "text-blue-700",
              @kind == :success && "text-green-700",
              @kind == :warning && "text-yellow-700",
              @kind == :error && "text-red-700"
            ]}
          >
            <%= render_slot(@inner_block) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders a simple form.

  ## Examples

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:email]} label="Email"/>
        <.input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """
  attr :for, :any, required: true, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="mt-10 space-y-8 bg-white">
        <%= render_slot(@inner_block, f) %>
        <div :for={action <- @actions} class="flex items-center justify-between gap-6 mt-2">
          <%= render_slot(action, f) %>
        </div>
      </div>
    </.form>
    """
  end

  @doc """
  Renders a button or a link styled like a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr :link, :boolean, default: false, doc: "if true, display a link styled like a button"

  attr :type, :string, default: nil
  attr :class, :string, default: nil

  attr :kind, :string,
    values: ~w(primary secondary danger),
    default: "primary",
    doc: "used for styling"

  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      :if={!@link}
      type={@type}
      class={[
        get_button_classes(@kind, "button"),
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    <.link
      :if={@link}
      class={[
        get_button_classes(@kind, "link"),
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  @doc """
  Renders an input with label and error messages.

  A `%Phoenix.HTML.Form{}` and field name may be passed to the input
  to build input names and error messages, or all the attributes and
  errors may be passed explicitly.

  ## Examples

      <.input field={@form[:email]} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :help_text, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range radio search select tel text textarea time url week)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"
  attr :rest, :global, include: ~w(autocomplete cols disabled form max maxlength min minlength
                                   pattern placeholder readonly required rows size step)
  slot :inner_block

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "checkbox", value: value} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn -> Phoenix.HTML.Form.normalize_value("checkbox", value) end)

    ~H"""
    <div phx-feedback-for={@name}>
      <input type="hidden" name={@name} value="false" />
      <div class="relative flex items-start">
        <div class="flex items-center h-6">
          <input
            type="checkbox"
            id={@id || @name}
            name={@name}
            value="true"
            checked={@checked}
            class={[
              "w-4 h-4 rounded",
              @errors == [] && "border-gray-300 text-primary-600 focus:ring-primary-600",
              @errors != [] && "border-red-300 text-red-600 focus:ring-red-600"
            ]}
            aria-describedby={
              if @errors != [],
                do:
                  '#{@errors |> Enum.with_index(fn _element, index -> "#{@id || @name}-error-#{index}" end) |> Enum.join(" ")} #{@id || @name}-description',
                else: "#{@id || @name}-description"
            }
            aria-invalid={if @errors != [], do: "true", else: "false"}
            {@rest}
          />
        </div>
        <div class="ml-3 text-sm leading-6">
          <.label for={@id || @name}><%= @label %></.label>
          <p :if={@help_text} class="text-sm text-gray-500" id={"#{@id || @name}-description"}>
            <%= @help_text %>
          </p>
        </div>
      </div>
      <.error
        :for={{msg, i} <- Enum.with_index(@errors)}
        :if={@errors != []}
        id={"#{@id || @name}-error-#{i}"}
      >
        <%= msg %>
      </.error>
    </div>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id || @name}><%= @label %></.label>
      <select
        id={@id || @name}
        name={@name}
        class="block w-full px-3 py-2 mt-1 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-zinc-500 focus:border-zinc-500 sm:text-sm"
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt} value=""><%= @prompt %></option>
        <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
      </select>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id || @name}><%= @label %></.label>
      <div class="relative mt-2">
        <textarea
          id={@id || @name}
          name={@name}
          class={[
            "block w-full border-0 rounded-md shadow-sm sm:py-1.5 sm:text-sm sm:leading-6",
            @errors == [] && "text-gray-900 placeholder:text-gray-400",
            @errors == [] &&
              "phx-no-feedback:ring-gray-300 phx-no-feedback:focus:ring-2 phx-no-feedback:focus:ring-inset phx-no-feedback:focus:ring-primary-600",
            @errors == [] &&
              "ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-inset focus:ring-primary-600",
            @errors != [] &&
              "pr-10 text-red-900 ring-1 ring-inset ring-red-300 placeholder:text-red-300 focus:ring-2 focus:ring-inset focus:ring-red-500"
          ]}
          aria-describedby={
            if @errors != [],
              do:
                '#{@errors |> Enum.with_index(fn _element, index -> "#{@id || @name}-error-#{index}" end) |> Enum.join(" ")} #{@id || @name}-description',
              else: "#{@id || @name}-description"
          }
          aria-invalid={if @errors != [], do: "true", else: "false"}
          {@rest}
        ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
        <div
          :if={@errors != []}
          class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none"
        >
          <Heroicons.exclamation_circle mini class="w-5 h-5 text-red-500" />
        </div>
      </div>
      <p :if={@help_text} class="mt-2 text-sm text-gray-500" id={"#{@id || @name}-description"}>
        <%= @help_text %>
      </p>
      <.error
        :for={{msg, i} <- Enum.with_index(@errors)}
        :if={@errors != []}
        id={"#{@id || @name}-error-#{i}"}
      >
        <%= msg %>
      </.error>
    </div>
    """
  end

  def input(assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id || @name}><%= @label %></.label>
      <div class="relative mt-2">
        <input
          type={@type}
          name={@name}
          id={@id || @name}
          value={Phoenix.HTML.Form.normalize_value(@type, @value)}
          class={[
            "block w-full border-0 rounded-md shadow-sm py-1.5 sm:text-sm sm:leading-6 focus-visible:outline-none",
            "disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-gray-500 disabled:ring-gray-200",
            @errors == [] && "text-gray-900 placeholder:text-gray-400",
            @errors == [] &&
              "phx-no-feedback:ring-gray-300 phx-no-feedback:focus:ring-2 phx-no-feedback:focus:ring-inset phx-no-feedback:focus:ring-primary-600",
            @errors == [] &&
              "ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-inset focus:ring-primary-600",
            @errors != [] &&
              "pr-10 text-red-900 ring-1 ring-inset ring-red-300 placeholder:text-red-300 focus:ring-2 focus:ring-inset focus:ring-red-500"
          ]}
          aria-describedby={
            if @errors != [],
              do:
                '#{@errors |> Enum.with_index(fn _element, index -> "#{@id || @name}-error-#{index}" end) |> Enum.join(" ")} #{@id || @name}-description',
              else: "#{@id || @name}-description"
          }
          aria-invalid={if @errors != [], do: "true", else: "false"}
          {@rest}
        />
        <div
          :if={@errors != []}
          class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none"
        >
          <Heroicons.exclamation_circle mini class="w-5 h-5 text-red-500" />
        </div>
      </div>
      <p :if={@help_text} class="mt-2 text-sm text-gray-500" id={"#{@id || @name}-description"}>
        <%= @help_text %>
      </p>
      <.error
        :for={{msg, i} <- Enum.with_index(@errors)}
        :if={@errors != []}
        id={"#{@id || @name}-error-#{i}"}
      >
        <%= msg %>
      </.error>
    </div>
    """
  end

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label for={@for} class="block text-sm font-medium leading-6 text-gray-900">
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """
  attr :id, :string

  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="flex gap-3 text-sm leading-6 text-red-600" id={@id}>
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  @doc """
  Renders a header with title.
  """
  attr :class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex items-center justify-between gap-6", @class]}>
      <div>
        <h1 class="text-lg font-semibold leading-8 text-zinc-800">
          <%= render_slot(@inner_block) %>
        </h1>
        <p :if={@subtitle != []} class="mt-2 text-sm leading-6 text-zinc-600">
          <%= render_slot(@subtitle) %>
        </p>
      </div>
      <div class="flex-none"><%= render_slot(@actions) %></div>
    </header>
    """
  end

  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id"><%= user.id %></:col>
        <:col :let={user} label="username"><%= user.username %></:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div class="px-4 overflow-y-auto sm:overflow-visible sm:px-0">
      <table class="mt-11 w-[40rem] sm:w-full">
        <thead class="text-left text-[0.8125rem] leading-6 text-zinc-500">
          <tr>
            <th :for={col <- @col} class="p-0 pb-4 pr-6 font-normal"><%= col[:label] %></th>
            <th class="relative p-0 pb-4"><span class="sr-only"><%= gettext("Actions") %></span></th>
          </tr>
        </thead>
        <tbody
          id={@id}
          phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
          class="relative text-sm leading-6 border-t divide-y divide-zinc-100 border-zinc-200 text-zinc-700"
        >
          <tr :for={row <- @rows} id={@row_id && @row_id.(row)} class="group hover:bg-zinc-50">
            <td
              :for={{col, i} <- Enum.with_index(@col)}
              phx-click={@row_click && @row_click.(row)}
              class={["relative p-0", @row_click && "hover:cursor-pointer"]}
            >
              <div class="block py-4 pr-6">
                <span class="absolute right-0 -inset-y-px -left-4 group-hover:bg-zinc-50 sm:rounded-l-xl" />
                <span class={["relative", i == 0 && "font-semibold text-zinc-900"]}>
                  <%= render_slot(col, @row_item.(row)) %>
                </span>
              </div>
            </td>
            <td :if={@action != []} class="relative p-0 w-14">
              <div class="relative py-4 text-sm font-medium text-right whitespace-nowrap">
                <span class="absolute left-0 -inset-y-px -right-4 group-hover:bg-zinc-50 sm:rounded-r-xl" />
                <span
                  :for={action <- @action}
                  class="relative ml-4 font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
                >
                  <%= render_slot(action, @row_item.(row)) %>
                </span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title"><%= @post.title %></:item>
        <:item title="Views"><%= @post.views %></:item>
      </.list>
  """
  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <div class="mt-14">
      <dl class="-my-4 divide-y divide-zinc-100">
        <div :for={item <- @item} class="flex gap-4 py-4 sm:gap-8">
          <dt class="w-1/4 flex-none text-[0.8125rem] leading-6 text-zinc-500"><%= item.title %></dt>
          <dd class="text-sm leading-6 text-zinc-700"><%= render_slot(item) %></dd>
        </div>
      </dl>
    </div>
    """
  end

  @doc """
  Renders a back navigation link.

  ## Examples

      <.back navigate={~p"/posts"}>Back to posts</.back>
  """
  attr :navigate, :any, required: true
  slot :inner_block, required: true

  def back(assigns) do
    ~H"""
    <div class="mt-16">
      <.link
        navigate={@navigate}
        class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
      >
        <Heroicons.arrow_left solid class="inline w-3 h-3 stroke-current" />
        <%= render_slot(@inner_block) %>
      </.link>
    </div>
    """
  end

  ## Helpers

  defp get_button_classes(color, type) do
    default =
      "phx-submit-loading:opacity-75 rounded-md py-2 px-3 shadow-sm disabled:opacity-50 disabled:cursor-not-allowed text-sm font-semibold focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2"

    if type == "button" do
      case color do
        "primary" ->
          "#{default} text-white bg-primary-600 active:text-white/80 enabled:hover:bg-primary-500 dark:enabled:hover:bg-primary-400 focus-visible:outline-primary-600 dark:bg-primary-500 dark:active:text-white/80 dark:focus-visible:outline-primary-500"

        "secondary" ->
          "#{default} text-gray-900 bg-white ring-1 ring-gray-300 active:text-gray-900/80 enabled:hover:bg-gray-50 focus-visible:outline-gray-600 dark:bg-white/10 dark:text-white dark:active:text-white/80 dark:enabled:hover:bg-white/20 dark:focus-visible:outline-gray-500"

        "danger" ->
          "#{default} text-white bg-red-600 active:text-white/80 enabled:hover:bg-red-500 focus-visible:outline-red-600 dark:bg-red-500 dark:active:text-white/80 dark:enabled:hover:bg-red-400 dark:focus-visible:outline-red-500"

        _ ->
          ""
      end
    else
      case color do
        "primary" ->
          "#{default} text-white bg-primary-600 active:text-white/80 hover:bg-primary-500 dark:hover:bg-primary-400 focus-visible:outline-primary-600 dark:bg-primary-500 dark:active:text-white/80 dark:focus-visible:outline-primary-500"

        "secondary" ->
          "#{default} text-gray-900 bg-white ring-1 ring-gray-300 active:text-gray-900/80 hover:bg-gray-50 dark:bg-white/10 focus-visible:outline-gray-600 dark:text-white dark:active:text-white/80 dark:hover:bg-white/20 dark:focus-visible:outline-gray-500"

        "danger" ->
          "#{default} text-white bg-red-600 active:text-white/80 hover:bg-red-500 focus-visible:outline-red-600 dark:bg-red-500 dark:active:text-white/80 dark:hover:bg-red-400 dark:focus-visible:outline-red-500"

        _ ->
          ""
      end
    end
  end

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      transition:
        {"transform ease-out duration-300 transition",
         "translate-y-2 opacity-0 sm:translate-y-0 sm:translate-x-2",
         "translate-y-0 opacity-100 sm:translate-x-0"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition: {"transition ease-in duration-100", "opacity-100", "opacity-0"}
    )
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}", transition: {"ease-out duration-300", "opacity-0", "opacity-100"})
    |> JS.show(
      to: "##{id}-container",
      transition:
        {"ease-out duration-300", "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(to: "##{id}", transition: {"ease-in duration-200", "opacity-100", "opacity-0"})
    |> JS.hide(
      to: "##{id}-container",
      transition:
        {"ease-in duration-200", "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate "is invalid" in the "errors" domain
    #     dgettext("errors", "is invalid")
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # Because the error messages we show in our forms and APIs
    # are defined inside Ecto, we need to translate them dynamically.
    # This requires us to call the Gettext module passing our gettext
    # backend as first argument.
    #
    # Note we use the "errors" domain, which means translations
    # should be written to the errors.po file. The :count option is
    # set by Ecto and indicates we should also apply plural rules.
    if count = opts[:count] do
      Gettext.dngettext(GitpodWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(GitpodWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end
