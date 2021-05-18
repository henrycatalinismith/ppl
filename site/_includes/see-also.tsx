import React from "react"

interface SeeAlsoProps {
  links: {
    href: string
    text: string
  }[]
}

export default function SeeAlso({ links }: SeeAlsoProps): React.ReactElement {
  return (
    <section>
      <h2>
        See Also
      </h2>
      <ol className="see-also">
        {links.map(link => (
          <li key={link.href}>
            <a href={link.href}>
              {link.text}
            </a>
          </li>
        ))}
      </ol>
    </section>
  )
}
