import React from "react"
import Page from "./_layouts/page"
import DefinitionList from "./_includes/definition-list"

interface SettingsProps {
  collections: any
  date: Date
}

export default function Settings({
  collections,
  date,
}: SettingsProps): React.ReactElement {
  const breadcrumbs = [
    {
      text: "ppl",
      href: "/",
    },
    {
      text: "settings",
      href: "/settings",
    },
  ]
  return (
    <Page title="ppl settingsn" description="Reference guide to all ppl's configuration options" breadcrumbs={breadcrumbs} date={date}>
      <DefinitionList
        items={collections.settings.reverse().map(setting => ({
          termHref: setting.url,
          termText: `[${setting.data.name}]`,
          detailsText: setting.data.summary,
        }))}
      />
    </Page>
  )
}
