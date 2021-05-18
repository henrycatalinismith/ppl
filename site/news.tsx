import React from "react"
import Page from "./_layouts/page"
import DefinitionList from "./_includes/definition-list"

interface NewsProps {
  collections: any
  date: Date
}

export default function News({
  collections,
  date,
}: NewsProps): React.ReactElement {
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
          termHref: post.url,
          termText: post.data.name,
          detailsText: post.data.summary,
        }))}
      />
    </Page>
  )
}
