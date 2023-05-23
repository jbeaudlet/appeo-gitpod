// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin");
const colors = require("tailwindcss/colors");
const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
	content: ["./js/**/*.js", "../lib/*_web.ex", "../lib/*_web/**/*.*ex", "./svelte/**/*.svelte"],
	darkMode: "class",
	theme: {
		extend: {
			colors: {
				primary: colors.blue,
			},
			fontFamily: {
				sans: ["Inter var", ...defaultTheme.fontFamily.sans],
			},
			animation: {
				"spin-quick": "spin 0.5s linear infinite",
				"progress-timer": "progress-timer 5s linear 1 forwards",
			},
			keyframes: {
				"progress-timer": {
					"0%": { width: "0%" },
					"80%": { opacity: "1" },
					"100%": { opacity: 0.5, width: "100%" },
				},
			},
		},
	},
	plugins: [
		require("@tailwindcss/forms"),
		plugin(({ addVariant }) =>
			addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])
		),
		plugin(({ addVariant }) =>
			addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])
		),
		plugin(({ addVariant }) =>
			addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])
		),
		plugin(({ addVariant }) =>
			addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])
		),
	],
};
