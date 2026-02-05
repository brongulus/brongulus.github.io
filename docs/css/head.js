// Check previously chosen preference
if (localStorage.theme) document.documentElement.setAttribute("data-theme", localStorage.theme); // Blocking JS

// Flash free theme switch
document.addEventListener("DOMContentLoaded", function() {
    const toggleButton = document.querySelector('#dark-mode-button');
    const moonIcon = document.getElementById('moon-icon');
    const sunIcon = document.getElementById('sun-icon');
    
    // Set initial icon based on saved theme
    if (localStorage.theme === "dark") {
        moonIcon.style.display = 'none';
        sunIcon.style.display = 'block';
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
