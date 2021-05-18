import React from "react"

interface CodeSectionProps {
  children: string
}

export default function CodeSection({
  children,
}: CodeSectionProps): React.ReactElement {
  return (
    <section>
      <pre><code>{children}</code></pre>
    </section>
  )
}
