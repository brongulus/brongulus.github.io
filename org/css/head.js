// Check previously chosen preference
if (localStorage.theme) document.documentElement.setAttribute("data-theme", localStorage.theme); // Blocking JS

// Flash free theme switch
document.addEventListener("DOMContentLoaded", function() {
    const toggleSwitch = document.querySelector('#dark-mode-button input[type="checkbox"]');
    if (localStorage.theme) {
        toggleSwitch.checked = localStorage.theme === "dark";
    }
    function switchTheme(e) {
        const theme = e.target.checked ? "dark" : "light";
        document.documentElement.setAttribute("data-theme", theme);
        localStorage.theme = theme;
    }
    toggleSwitch.addEventListener("change", switchTheme);
});
