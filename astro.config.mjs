import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";

export default defineConfig({
  site: "https://innosocia.dk",
  integrations: [sitemap()],
});
