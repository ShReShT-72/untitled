import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// GitHub Pages project site: https://shresht-72.github.io/untitled/
export default defineConfig({
  base: "/untitled/",
  plugins: [react()],
});
