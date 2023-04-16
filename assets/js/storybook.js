// If your components require any hooks or custom uploaders, or if your pages
// require connect parameters, uncomment the following lines and declare them as
// such:
//
// import * as Hooks from "./hooks";
// import * as Params from "./params";
// import * as Uploaders from "./uploaders";

// (function () {
//   window.storybook = { Hooks, Params, Uploaders };
// })();

// import * as Hooks from "./hooks";
// import * as Params from "./params";
// import * as Uploaders from "./uploaders";

// (function () {
//   window.storybook = { Hooks, Params, Uploaders };
// })();

// Use the Storybook theme settings to trigger the Tailwindcss dark mode
// Storybook theme dropdown menu
const themeDropdown = document.querySelectorAll("#lsb-theme-dropdown a");
// const themeBtn = themeDropdown.
themeDropdown.forEach((a) =>
	a.addEventListener("click", () =>
		a.getAttribute("phx-click").includes("dark")
			? document.documentElement.classList.add("dark")
			: document.documentElement.classList.remove("dark")
	)
);
// On first page load get the value fo the theme from the url parameter
const queryString = window.location.search;
const urlParams = new URLSearchParams(queryString);
const theme = urlParams.get("theme");
theme === "dark"
	? document.documentElement.classList.add("dark")
	: document.documentElement.classList.remove("dark");
