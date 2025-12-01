import { defineConfig } from "vite";
// @ts-expect-error - No type definitions available
import laravel from "laravel-vite-plugin";
import path from "path";
// @ts-expect-error - No type definitions available
import dotenv from "dotenv";

// Load .env file
dotenv.config();

export default defineConfig({
    css: {
        preprocessorOptions: {
            scss: {
                silenceDeprecations: [
                    "import",
                    "mixed-decls",
                    "color-functions",
                    "slash-div",
                    "global-builtin",
                    "strict-unary",
                    "legacy-js-api",
                ], // Silence @import deprecation warnings
            },
        },
    },
    server: {
        host: "0.0.0.0",
        port: 1337,
        hmr: {
            host: "0.0.0.0",
            port: 1337,
        },
        proxy: {
            "/api": {
                target: process.env.APP_URL || "http://localhost:8008",
                changeOrigin: true,
                secure: false,
            },
        },
    },
    resolve: {
        alias: {
            "@": path.resolve(__dirname, "resources"),
            "~": path.resolve(__dirname, "node_modules"),
            "~font": path.resolve(__dirname, "resources/fonts"),
            "~bootstrap": path.resolve(__dirname, "node_modules/bootstrap"),
            "~@tkrotoff": path.resolve(__dirname, "node_modules/@tkrotoff"),
        },
    },
    //   build: {
    //     rollupOptions: {
    //       output: {
    //         entryFileNames: (chunkInfo) => {
    //           if (chunkInfo.name === "admin") {
    //             return "assets/admin.js";
    //           }
    //           return "assets/[name]-[hash].js";
    //         },
    //       },
    //     },
    //   },
    plugins: [
        laravel({
            input: [
                "resources/sass/dashboard.scss",
                "resources/js/dashboard.ts",
            ],
            refresh: true,
        }),
    ],
});
