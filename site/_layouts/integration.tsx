import React from "react"
import Page from "./page"
import HtmlSection from "../_includes/html-section"

interface IntegrationProps {
  name: string
  summary: string
  content: string
  date: Date
}

export default function Integration({
  name,
  summary,
  content,
  date,
}: IntegrationProps): React.ReactElement {
  const breadcrumbs = [
    {
      text: "ppl",
      href: "/",
    },
    {
      text: "integrations",
      href: "/integrations",
    },
    {
      text: name,
      href: `/integrations/${name}`,
    },
  ]
  return (
    <Page title={`ppl ${name} integration`} description={summary} breadcrumbs={breadcrumbs} date={date} itemType="WebPage">
      <HtmlSection>{content}</HtmlSection>
    </Page>
  )
}
