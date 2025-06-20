# AI Agent Instructions for Website Development

## 📌 Project Overview

This is a modern website project built using cutting-edge tools and best practices recommended by the Next.js community. The goal is to create a high-performance, scalable, and developer-friendly web application.

## 🧠 AI Agent Goals

You are an AI assistant who helps with:

- Code generation (following conventions and typing)
- Component creation (using Tailwind + ShadCN UI)
- Internationalization (using the `next-intl` structure)
- REST API integration (using `SWR`)
- State management (use `Zustand` when needed)
- Form creation and validation (using `React Hook Form` + `Zod`)
- Writing and maintaining test files (Jest + RTL + Playwright)
- Optimizing performance and SEO (using Next.js features)
- Keeping the codebase clean and modular

## ✅ Best Practices to Follow

- Use TypeScript for all code.
- Follow Next.js App Router architecture.
- Use functional components and React hooks only.
- All styles should use Tailwind CSS.
- Prefer server components unless interaction is required.
- Co-locate i18n messages with the page or component (using `next-intl`).
- Validate all user input using Zod schemas.
- Prefer composable, reusable components.
- Always add tests for new features.
- Ensure accessibility in UI components.

## 🚫 What to Avoid

- Do not use class-based React components.
- Do not use Redux or other global state libraries; use Zustand only.
- Do not use CSS Modules or styled-components.
- Avoid GraphQL (use only REST + SWR).
- Avoid complex side effects outside of hooks or state stores.

## 🗣️ Language & Style

- Use concise, readable TypeScript.
- Write self-documenting code with clear naming and structure.
- Use conventional commit messages (e.g., `feat: add login button`).

---

## 🔧 Rendering Strategy

- The current deployment uses **Static Site Generation (SSG)** only.
- All pages are pre-rendered at build time and deployed to **GitHub Pages**.
- In the future, **Server-Side Rendering (SSR)** can be enabled if a specific use case requires it.

## 🗂️ Asset Management Strategy

### 📁 File Placement

- Use an `assets/` directory for all **versioned assets** (e.g., images, documents, locale files).
  - These files should be imported directly in components or modules.
  - This ensures they are processed by Webpack/Turbopack and receive **automatic versioning** (content hashing).
  - Example:

    ```tsx
    import logo from '@/assets/logo.png';
    <Image src={logo} alt="Logo" />
    ```

- The `public/` folder should only be used for:
  - Files that **never change** (e.g., `robots.txt`, `favicon.ico`).
  - Static resources that are intended to bypass the bundler entirely.

### 🎯 Why This Matters

- Imported assets get **fingerprinted** and benefit from **long-term caching** with automatic cache busting.
- `public/` assets do not receive versioning and may cause stale content issues if updated without changing the file name.
- This strategy helps prevent caching problems and makes version control more predictable in production environments (e.g., GitHub Pages or Vercel).

> 📌 Summary: Prefer importing from `assets` for anything that might change. Only use `public/` for permanent, never-changing files.

## 🌍 Locale File Structure

- Locale files are stored in the `messages/` directory instead of the `public/` folder.
  - This allows for versioning, modular imports, and bundler integration.
  - Follows conventions used in `next-intl` official examples.
- Files may be organized by language and domain, for example:

messages/en/common.json
messages/zh/common.json

- Avoid placing locale files in `public/` to prevent stale content and missing type integration.

> 📌 Summary: Store all translatable messages in `messages/` and load them via imports or dynamic imports.

## Other documents to reference

- **README.md** – Includes purpose, how to start, and tech stack
- **CONTRIBUTING.md** – Follows a clear step-by-step GitHub flow.
