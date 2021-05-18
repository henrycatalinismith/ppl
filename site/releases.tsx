import React from "react"
import Page from "./_layouts/page"
import DefinitionList from "./_includes/definition-list"

interface ReleasesProps {
  collections: any
  date: Date
}

export default function Releases({
  collections,
  date,
}: ReleasesProps): React.ReactElement {
  const breadcrumbs = [
    {
      text: "ppl",
      href: "/",
    },
    {
      text: "releases",
      href: "/releases",
    },
  ]
  return (
    <Page title="ppl releases" description="List of ppl versions and release notes for each one" breadcrumbs={breadcrumbs} date={date}>
      <DefinitionList
        items={collections.releases.reverse().map(release => ({
          termHref: release.url,
          termText: release.data.version,
          detailsText: release.data.summary,
        }))}
      />
    </Page>
  )
}
