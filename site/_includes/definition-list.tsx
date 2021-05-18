import React from "react"

interface DefinitionListProps {
  items: {
    termHref: string
    termText: string
    detailsText: string
  }[]
}

export default function DefinitionList({ items }: DefinitionListProps): React.ReactElement {
  return (
    <dl>
      {items.map(item => (
        <React.Fragment key={item.termText}>  
          <dt>
            <a href={item.termHref}>
              {item.termText}
            </a>
          </dt>
          <dd>
            {item.detailsText}
          </dd>
        </React.Fragment>
      ))}
    </dl>
  )
}
