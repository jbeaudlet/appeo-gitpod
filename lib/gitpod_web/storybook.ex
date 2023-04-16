defmodule GitpodWeb.Storybook do
  use PhoenixStorybook,
    otp_app: :gitpod_web,
    content_path: Path.expand("../../storybook", __DIR__),
    # assets path are remote path, not local file-system paths
    css_path: "/assets/storybook.css",
    js_path: "/assets/storybook.js",
    sandbox_class: "font-sans",
    themes: [
      default: [name: "light"],
      dark: [name: "dark", dropdown_class: "text-slate-800"]
    ]
end
