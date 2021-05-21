import React from "react"
import Page from "./_layouts/page"
import DefinitionList from "./_includes/definition-list"

export default function Integrations({
  collections,
  date,
}: Layout): React.ReactElement {
  const breadcrumbs = [
    {
      text: "ppl",
      href: "/",
    },
    {
      text: "integrations",
      href: "/integrations",
    },
  ]
  return (
    <Page title="ppl integrations" description="Information about integrating ppl with other software" breadcrumbs={breadcrumbs} date={date}>
      <DefinitionList
        items={collections.integrations.map(integration => ({
          termHref: integration.url,
          termText: integration.data.name,
          detailsText: integration.data.summary,
        }))}
      />
    </Page>
  )
}
