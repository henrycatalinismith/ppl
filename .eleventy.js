const chokidar = require("chokidar")
const fs = require("fs-extra")
const htmlmin = require("html-minifier")
const sass = require("sass")

function minifyHtml(html) {
  return htmlmin.minify(html, {
    useShortDoctype: true,
    removeComments: true,
    collapseWhitespace: true
  })
}

function monkeypatch(cls, fn) {
  const orig = cls.prototype[fn.name][`_PS_original`] || cls.prototype[fn.name]
  function wrapped() {
    return fn.bind(this, orig).apply(this, arguments)
  }
  wrapped[`_PS_original`] = orig
  cls.prototype[fn.name] = wrapped
}

const minifyPlugin = {
  initArguments: {},
  configFunction: function(eleventyConfig) {
    eleventyConfig.addTransform(
      "htmlmin",
      function(content, outputPath) {
        if (outputPath && outputPath.endsWith(".html")) {
          return minifyHtml(content)
        }
        return content
      }
    )
  }
}

function compileSass() {
  const { css } = sass.renderSync({
    file: "site/style.scss",
  })
  fs.writeFileSync("_site/style.css", css)
}

module.exports = function(eleventyConfig) {
  console.log("ppl site")

  fs.ensureDirSync("_site")
  fs.emptyDirSync("_site")

  eleventyConfig.addPassthroughCopy("site/casts/*.svg")
  eleventyConfig.addPlugin(minifyPlugin)

  eleventyConfig.addCollection("commands", function(collectionApi) {
    return collectionApi.getFilteredByGlob("site/commands/*.md")
  })

  eleventyConfig.addCollection("integrations", function(collectionApi) {
    return collectionApi.getFilteredByGlob("site/integrations/*.md")
  })

  eleventyConfig.addCollection("releases", function(collectionApi) {
    return collectionApi.getFilteredByGlob("site/releases/*.*.*.md")
  })

  compileSass()

  if (process.argv.includes("--serve")) {
    setImmediate(function() {
      const Eleventy = require("@11ty/eleventy/src/Eleventy.js")
      if (Eleventy.prototype) {
        function watch(original) {
          const watcher = chokidar.watch(["./site/style.scss"], {
            persistent: true
          })
          const compileAndReload = eleventyInstance => () => {
            compileSass()
            this.eleventyServe.reload()
          }
          watcher.on("add", compileAndReload(this))
          watcher.on("change", compileAndReload(this))
          return original.apply(this)
        }
        monkeypatch(Eleventy, watch)
      }
    })
  }

  const input = "site"

  const dir = {
    input,
  }

  return {
	  dir,
  }
}
