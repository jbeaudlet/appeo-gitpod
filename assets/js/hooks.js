let Hooks = {};

Hooks.FlashTimer = {
	mounted() {
		console.log("mounted flash");
	},
	updated() {
		console.log("updated flash");
	},
};

export default Hooks;
