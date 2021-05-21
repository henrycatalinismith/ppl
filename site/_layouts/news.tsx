import React from "react"
import Page from "./page"
import HtmlSection from "../_includes/html-section"

export default function News({
  title,
  content,
  date,
}: Layout<News>): React.ReactElement {
  const breadcrumbs = [
    {
      text: "ppl",
      href: "/",
    },
    {
      text: "news",
      href: "/news",
    },
    {
      text: title,
      href: `/news/${title}`,
    },
  ]
  return (
    <Page title={title} description={""} breadcrumbs={breadcrumbs} date={date} itemType="Article">
      <HtmlSection>{content}</HtmlSection>
    </Page>
  )
}
