import React from "react"

export default function Footer(): React.ReactElement {
  return (
    <footer>
      <p
        itemProp="creator"
        itemScope
        itemType="http://schema.org/Person">
        <a href="https://hen.cat/" target="_blank">
          <span itemProp="name">
            Henry Catalini Smith
          </span>
        </a>
      </p>
    </footer>
  )
}

