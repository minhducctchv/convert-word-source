# them vao vite.config.js -> obj config : base: '/convert-word-deploy/',
npm run build
git add dist -f
git commit -m "adding dist"
git subtree push --prefix dist origin gh-pages