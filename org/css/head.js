// Check previously chosen preference, otherwise use system preference
if (localStorage.theme) {
    document.documentElement.setAttribute("data-theme", localStorage.theme);
} else {
    // Default to system preference
    const systemTheme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
    document.documentElement.setAttribute("data-theme", systemTheme);
}

// Flash free theme switch
document.addEventListener("DOMContentLoaded", function() {
    const toggleButton = document.querySelector('#dark-mode-button');
    const moonIcon = document.getElementById('moon-icon');
    const sunIcon = document.getElementById('sun-icon');
    
    // Set initial icon based on current theme
    const currentTheme = document.documentElement.getAttribute("data-theme");
    if (currentTheme === "dark") {
        moonIcon.style.display = 'none';
        sunIcon.style.display = 'block';
    } else {
        moonIcon.style.display = 'block';
        sunIcon.style.display = 'none';
    }
    
    function switchTheme() {
        const currentTheme = document.documentElement.getAttribute("data-theme");
        const newTheme = currentTheme === "dark" ? "light" : "dark";
        document.documentElement.setAttribute("data-theme", newTheme);
        localStorage.theme = newTheme;
        
        // Toggle icons
        if (newTheme === "dark") {
            moonIcon.style.display = 'none';
            sunIcon.style.display = 'block';
        } else {
            moonIcon.style.display = 'block';
            sunIcon.style.display = 'none';
        }
    }
    
    toggleButton.addEventListener("click", switchTheme);
});
