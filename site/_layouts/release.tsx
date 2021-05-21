import React from "react"
import Page from "./page"
import HtmlSection from "../_includes/html-section"

export default function Release({
  version,
  summary,
  content,
  date,
}: Layout<Release>): React.ReactElement {
  const breadcrumbs = [
    {
      text: "ppl",
      href: "/",
    },
    {
      text: "releases",
      href: "/releases",
    },
    {
      text: version,
      href: `/releases/${version}`,
    },
  ]
  return (
    <Page title={`ppl version ${version}`} description={summary} breadcrumbs={breadcrumbs} date={date} itemType="Article">
      <HtmlSection>{content}</HtmlSection>
    </Page>
  )
}
