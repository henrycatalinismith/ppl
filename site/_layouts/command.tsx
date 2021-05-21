import React from "react"
import Page from "./page"
import CodeSection from "../_includes/code-section"
import HtmlSection from "../_includes/html-section"
import SeeAlso from "../_includes/see-also"

export default function Command({
  name,
  summary,
  content,
  synopsis,
  date,
  see_also,
}: Layout<Command>): React.ReactElement {
  const breadcrumbs = [
    {
      text: "ppl",
      href: "/",
    },
    {
      text: "commands",
      href: "/comands",
    },
    {
      text: name,
      href: `/comands/${name}`,
    },
  ]
  return (
    <Page title={`ppl ${name}`} description={summary} breadcrumbs={breadcrumbs} date={date}>
      <CodeSection>{synopsis}</CodeSection>
      <HtmlSection>{content}</HtmlSection>
      {see_also && <SeeAlso links={see_also} />}
    </Page>
  )
}
