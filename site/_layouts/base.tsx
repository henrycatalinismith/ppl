import React, { HTMLProps } from "react"

interface BaseProps {
  itemType: string
  title: string
  children: any
}

export default function Base({
  itemType,
  title,
  children,
}: BaseProps): React.ReactElement {
  const html: HTMLProps<HTMLHtmlElement> = {
    lang: "en",
    dir: "ltr",
  }
  if (itemType) {
    html.itemScope = true
    html.itemType = `http://schema.org/${itemType}`
  }
  return (
    <html {...html}>
      <head>
        <meta
          name="viewport"
          content="width=device-width,initial-scale=1"
        />
        <link
          rel="stylesheet"
          href="site/style.scss"
        />
        <title>
          {title}
        </title>
      </head>
      <body>
        {children}
      </body>
    </html>
  )
}
