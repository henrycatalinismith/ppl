import React from "react"
import Page from "./page"
import CodeSection from "../_includes/code-section"
import HtmlSection from "../_includes/html-section"
import SeeAlso from "../_includes/see-also"

export default function Setting({
  name,
  summary,
  content,
  example,
  date,
  see_also,
}: Layout<Setting>): React.ReactElement {
  const breadcrumbs = [
    {
      text: "ppl",
      href: "/",
    },
    {
      text: "settings",
      href: "/settings",
    },
    {
      text: `[${name}]`,
      href: "",
    },
  ]
  return (
    <Page title={`ppl [${name}] config`} description={summary} breadcrumbs={breadcrumbs} date={date} itemType="WebPage">
      <CodeSection>{example}</CodeSection>
      <HtmlSection>{content}</HtmlSection>
      {see_also && <SeeAlso links={see_also} />}
    </Page>
  )
}
