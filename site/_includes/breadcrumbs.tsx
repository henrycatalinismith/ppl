import React from "react"
import Ppl from "./ppl"

interface BreadcrumbsProps {
  links: {
    href: string
    text: string
  }[]
}

export default function Breadcrumbs({ links }: BreadcrumbsProps): React.ReactElement {
  return (
    <aside>
      <nav>
        <ol>
          {links.map(link => (
            <li key={link.href}>
              <a href={link.href}>
                {link.text === "ppl" ? (
                  <Ppl />
                ) : (
                  <>{link.text}</>
                )}
              </a>
            </li>
          ))}
        </ol>
      </nav>
    </aside>
  )
}
