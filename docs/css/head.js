// System preferences
if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
    document.documentElement.setAttribute("data-theme", "dark");
} else {
    document.documentElement.setAttribute("data-theme", "light");
}

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

// {{ if .Store.Get "hasMermaid" }}
//     <script type="module">
//     import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.esm.min.mjs';
// import elkLayouts from 'https://cdn.jsdelivr.net/npm/@mermaid-js/layout-elk/dist/mermaid-layout-elk.esm.min.mjs';

// mermaid.registerLayoutLoaders(elkLayouts);
// var config = {
//     startOnLoad: true,
//     // FIXME
//     theme: (localStorage.getItem('theme') === 'dark') ? 'dark' : 'default',
//     align: 'center',
//     // align:'{{ if site.Params.mermaid.align }}{{ site.Params.mermaid.align }}{{ else }}center{{ end }}',
// };
// mermaid.initialize(config);
// // Reload the webpage so that the mermaid diagrams are updated with the change in theme
// const toggleSwitch = document.querySelector('#dark-mode-button input[type="checkbox"]');
// toggleSwitch.addEventListener('click', () => {
//     window.location.reload();
// });
// </script>
