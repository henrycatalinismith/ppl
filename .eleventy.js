const { rehypePlugin } = require("@hendotcat/11tyhype")
const { sassPlugin } = require("@hendotcat/11tysass")
const fs = require("fs-extra")
const rehypeMinifyWhitespace = require("rehype-minify-whitespace")
const rehypeUrls = require("rehype-urls")

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

  eleventyConfig.addPlugin(rehypePlugin, {
    plugins: [
      [rehypeMinifyWhitespace],
      [rehypeUrls, url => {
        if (url.href.startsWith("/")) {
          return `${siteUrl}${url.href}`
        }
      }],
    ]
  })

  eleventyConfig.addPlugin(sassPlugin, {
    files: [{
      file: "site/style.scss",
      outFile: "style.[hash].css",
      outputStyle: "compressed",
    }],
    verbose: true,
  })

  const input = "site"

  const dir = {
    input,
  }

  return {
	  dir,
  }
}
