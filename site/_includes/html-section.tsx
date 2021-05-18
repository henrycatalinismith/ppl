import React from "react"

interface HtmlSectionProps {
  children: string
}

export default function HtmlSection({
  children,
}: HtmlSectionProps): React.ReactElement {
  return (
    <section dangerouslySetInnerHTML={{ __html: children }} />
  )
}
