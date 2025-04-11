// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/*_web.ex",
    "../lib/*_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        brand: "#FD4F00",
        primary: {
          50: "#eff6ff",
          100: "#dbeafe",
          200: "#bfdbfe",
          300: "#93c5fd",
          400: "#60a5fa",
          500: "#3b82f6",
          600: "#2563eb",
          700: "#1d4ed8",
          800: "#1e40af",
          900: "#1e3a8a",
          950: "#172554"
        },
        // Light mode
        primaryBg: {
          light: "#ffffff",
          dark: "#1e293b"
        },
        secondaryBg: {
          light: "#f1f5f9",
          dark: "#0f172a"
        },
        primaryText: {
          light: "#0f172a",
          dark: "#f8fafc"
        },
        secondaryText: {
          light: "#64748b",
          dark: "#94a3b8"
        },
        primaryAccent: {
          light: "#3b82f6",
          dark: "#3b82f6"
        }
      },
      borderRadius: {
        "extra_large": "12px"
      }
    }
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addVariant }) => addVariant("phx-no-feedback", [".", "&", ".phx-no-feedback", ".phx-no-feedback &"])),
    plugin(({ addVariant }) => addVariant("phx-click-loading", [".", "&", ".phx-click-loading", ".phx-click-loading &"])),
    plugin(({ addVariant }) => addVariant("phx-submit-loading", [".", "&", ".phx-submit-loading", ".phx-submit-loading &"])),
    plugin(({ addVariant }) => addVariant("phx-change-loading", [".", "&", ".phx-change-loading", ".phx-change-loading &"])),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function({ matchComponents, theme }) {
      let iconsDir = path.join(__dirname, "../deps/heroicons/optimized")
      let values = {}
      let icons = [
        ["hero-", "-outline", "24"],
        ["hero-", "-solid", "24"],
        ["hero-", "-mini", "20"],
        ["hero-", "-micro", "16"]
      ]
      icons.forEach(([prefix, suffix, size]) => {
        fs.readdirSync(path.join(iconsDir, suffix.replace(/^-/, ""))).forEach(file => {
          if (file.includes(".svg")) {
            let name = path.basename(file, ".svg")
            values[prefix + name + suffix] = { name, fullPath: path.join(iconsDir, suffix.replace(/^-/, ""), file), size }
          }
        })
      })
      matchComponents({
        "icon": ({ name, fullPath, size }) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n/g, "")
          let svgSize = size === "16" ? "16" : "20"
          return {
            [`--icon-size-${svgSize}`]: "1em",
            "mask-image": `url('data:image/svg+xml;utf8,${content}')`,
            "mask-repeat": "no-repeat",
            "mask-size": "100%",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": `var(--icon-size-${svgSize})`,
            "height": `var(--icon-size-${svgSize})`
          }
        }
      }, { values })
    })
  ]
}
