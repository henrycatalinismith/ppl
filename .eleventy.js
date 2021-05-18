const { rehypePlugin } = require("@hendotcat/11tyhype")
const { sassPlugin } = require("@hendotcat/11tysass")
const { reactPlugin } = require("@hendotcat/11tysnap")
const { register } = require("esbuild-register/dist/node")
const fs = require("fs-extra")
const rehypeMinifyWhitespace = require("rehype-minify-whitespace")
const rehypeUrls = require("rehype-urls")

register()

module.exports = function(eleventyConfig) {
  console.log("ppl site")

  fs.ensureDirSync("_site")
  fs.emptyDirSync("_site")

  eleventyConfig.addPassthroughCopy("site/casts/*.svg")

  eleventyConfig.addCollection("commands", function(collectionApi) {
    return collectionApi.getFilteredByGlob("site/commands/*.md")
  })

  eleventyConfig.addCollection("integrations", function(collectionApi) {
    return collectionApi.getFilteredByGlob("site/integrations/*.md")
  })

  eleventyConfig.addCollection("news", function(collectionApi) {
    return collectionApi.getFilteredByGlob("site/news/*.md")
  })

  eleventyConfig.addCollection("releases", function(collectionApi) {
    return collectionApi.getFilteredByGlob("site/releases/*.*.*.md")
  })


  eleventyConfig.addCollection("settings", function(collectionApi) {
    return collectionApi.getFilteredByGlob("site/settings/*.md")
  })

  const siteUrl = process.env.GITHUB_ACTIONS ? "https://hen.cat/ppl/" : ""

  eleventyConfig.addPlugin(sassPlugin, {
    files: [{
      file: "site/style.scss",
      outFile: "style.[hash].css",
      outputStyle: "compressed",
    }],
    verbose: true,
  })

  eleventyConfig.addPlugin(rehypePlugin, {
    plugins: [
      [rehypeMinifyWhitespace],
      [rehypeUrls, url => {
        if (url.href.startsWith("/") && process.env.GITHUB_ACTIONS) {
          return `https://hen.cat/ppl/${url.href}`
        }
      }],
    ]
  })

  eleventyConfig.addPlugin(reactPlugin, {
    verbose: true,
  })

  const dir = {
    input: "site",
    includes: "_includes",
    layouts: "_layouts",
  }

  return {
	  dir,
  }
}
