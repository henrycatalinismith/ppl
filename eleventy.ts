import { rehypePlugin } from "@hendotcat/11tyhype"
import { sassPlugin } from "@hendotcat/11tysass"
import { reactPlugin } from "@hendotcat/11tysnap"
import { EleventyCollection, EleventyLayout } from "@hendotcat/11tytype"
import fs from "fs-extra"
import rehypeMinifyWhitespace from "rehype-minify-whitespace"
import rehypeUrls from "rehype-urls"

declare global {
  interface Link {
    href: string
    text: string
  }

  interface Command {
    name: string
    summary: string
    synopsis: string
    example: string
    see_also?: Link[]
  }

  interface Integration {
    name: string
    summary: string
  }

  interface News {
    title: string
    date: Date
  }

  interface Release {
    version: string
    summary: string
    date: Date
  }

  interface Setting {
    name: string
    summary: string
    example: string
    see_also?: Link[]
  }

  type Collections = {
    commands: EleventyCollection<Command>
    integrations: EleventyCollection<Integration>
    news: EleventyCollection<News>
    releases: EleventyCollection<Release>
    settings: EleventyCollection<Setting>
  }

  type Layout<Template = {}> = EleventyLayout<Template, Collections>
}

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
