const fs = require("fs-extra")
const htmlmin = require("html-minifier")
const path = require("path")
const sass = require("sass")

function minifyHtml(html) {
  return htmlmin.minify(html, {
    useShortDoctype: true,
    removeComments: true,
    collapseWhitespace: true
  })
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

module.exports = function(eleventyConfig) {
  console.log("ppl docs")
  eleventyConfig.addPlugin(minifyPlugin)

  const input = "docs"

  const dir = {
    input,
  }

  return {
	  dir,
  }
}
