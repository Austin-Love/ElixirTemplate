// Theme Toggle Hook
const ThemeToggle = {
  mounted() {
    // Check for saved theme preference or use system preference
    if (localStorage.getItem('color-theme') === 'dark' || 
        (!('color-theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      document.documentElement.classList.add('dark');
      this.showLightIcon();
    } else {
      document.documentElement.classList.remove('dark');
      this.showDarkIcon();
    }

    // Add click event
    this.el.addEventListener('click', () => this.toggleTheme());
  },

  toggleTheme() {
    // Toggle theme
    if (document.documentElement.classList.contains('dark')) {
      document.documentElement.classList.remove('dark');
      localStorage.setItem('color-theme', 'light');
      this.showDarkIcon();
    } else {
      document.documentElement.classList.add('dark');
      localStorage.setItem('color-theme', 'dark');
      this.showLightIcon();
    }
  },

  showDarkIcon() {
    document.getElementById('theme-toggle-dark-icon').classList.remove('hidden');
    document.getElementById('theme-toggle-light-icon').classList.add('hidden');
  },

  showLightIcon() {
    document.getElementById('theme-toggle-dark-icon').classList.add('hidden');
    document.getElementById('theme-toggle-light-icon').classList.remove('hidden');
  }
};

export default ThemeToggle;
