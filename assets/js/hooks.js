let Hooks = {};

Hooks.FlashTimer = {
	mounted() {
		// Smae time as the one set in Tailwindcss config file
		const timer = "5s";
		this.el.querySelector(".animate-progress-timer").style.animationDuration = timer;
		setTimeout(() => {
			this.pushEventTo(this.el, "lv:clear-flash");
			console.log("Delayed for 1 second.");
		}, "1000");

		setTimeout(() => {
			// this.pushEventTo(this.el, "lv:clear-flash");
			console.log("Delayed for 2 second.", this);
		}, "2000");

		console.log("mounted flash", this);
	},
	updated() {
		console.log("updated flash");
	},
};

export default Hooks;
