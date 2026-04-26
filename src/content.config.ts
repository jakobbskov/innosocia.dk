import { defineCollection, z } from "astro:content";
import { glob } from "astro/loaders";

const apps = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/apps" }),
  schema: z.object({
    title: z.string(),
    slug: z.string(),
    tagline: z.string(),
    summary: z.string(),
    status: z.enum(["idea", "prototype", "active", "stable"]),
    updatedAt: z.string(),
    featured: z.boolean().optional().default(false),

    why: z.string(),
    solves: z.array(z.string()).default([]),
    techDirection: z.array(z.string()).default([]),
    relatedApps: z.array(z.string()).default([]),

    repoUrl: z.string().url().optional(),
    license: z.string().optional(),
    screenshots: z.array(z.object({
      src: z.string(),
      alt: z.string(),
      title: z.string(),
      caption: z.string(),
    })).default([]),
  }),
});

const ideer = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/ideer" }),
  schema: z.object({
    title: z.string(),
    slug: z.string(),
    date: z.string(),
    description: z.string(),
    tags: z.array(z.string()).default([]),
    featured: z.boolean().optional().default(false),

    why: z.string(),
    relatedIdeer: z.array(z.string()).default([]),
  }),
});

const projekter = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/projekter" }),
  schema: z.object({
    title: z.string(),
    slug: z.string(),
    date: z.string(),
    status: z.enum(["idea", "active", "paused", "complete"]),
    summary: z.string(),
    featured: z.boolean().optional().default(false),

    why: z.string(),
    direction: z.array(z.string()).default([]),
    relatedProjects: z.array(z.string()).default([]),
  }),
});

export const collections = {
  apps,
  ideer,
  projekter,
};
