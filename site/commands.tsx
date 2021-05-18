import React from "react"
import Page from "./_layouts/page"
import DefinitionList from "./_includes/definition-list"

interface CommandsProps {
  collections: any
  date: Date
}

export default function Commands({
  collections,
  date,
}: CommandsProps): React.ReactElement {
  const breadcrumbs = [
    {
      text: "ppl",
      href: "/",
    },
    {
      text: "commands",
      href: "/comands",
    },
  ]
  console.log(collections.commands)
  return (
    <Page title="commands" description="List of all available ppl commands" breadcrumbs={breadcrumbs} date={date}>
      <DefinitionList
        items={collections.commands.map(command => ({
          termHref: command.url,
          termText: command.data.name,
          detailsText: command.data.summary,
        }))}
      />
    </Page>
  )
}
