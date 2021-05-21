import React from "react"
import Page from "./_layouts/page"
import DefinitionList from "./_includes/definition-list"

export default function News({
  collections,
  date,
}: Layout): React.ReactElement {
  const breadcrumbs = [
    {
      text: "ppl",
      href: "/",
    },
    {
      text: "news",
      href: "/news",
    },
  ]
  return (
    <Page title="ppl news" description="Archive of all news posts" breadcrumbs={breadcrumbs} date={date}>
      <DefinitionList
        items={collections.news.map(post => ({
          termHref: post.fileSlug,
          termText: post.data.title,
          detailsText: post.data.date.toISOString(),
        }))}
      />
    </Page>
  )
}
