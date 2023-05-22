let Hooks = {};

Hooks.FlashTimer = {
	mounted() {
		console.log("mounted flash", this);
	},
	updated() {
		console.log("updated flash");
	},
};

export default Hooks;
