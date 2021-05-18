import React from "react"
import Base from "./base"
import Breadcrumbs from "../_includes/breadcrumbs"
import Footer from "../_includes/footer"

interface PageProps {
  breadcrumbs: {
    href: string
    text: string
  }[]
  title: string
  itemType?: string
  date: Date
  description: string
  children: any
}

export default function Page({
  breadcrumbs,
  title,
  itemType,
  date,
  description,
  children,
}: PageProps): React.ReactElement {
  return (
    <Base title={title} itemType={itemType}>
      <Breadcrumbs links={breadcrumbs} />
      <article>
        <header>
          <h1 itemProp="headline">
            {title}
          </h1>
          {itemType === "Article" ? (
            <time itemProp="datePublished" dateTime={date.toISOString().slice(0, 10)}>
              {date.toISOString().slice(0, 10)}
            </time>
          ) : (
            <p itemProp="description">
              {description}
            </p>
          )}
        </header>
        {children}
        <Footer />
      </article>
    </Base>
  )
}
