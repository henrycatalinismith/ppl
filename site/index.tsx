import React from "react"
import Base from "./_layouts/base"
import Breadcrumbs from "./_includes/breadcrumbs"
import Footer from "./_includes/footer"
import Ppl from "./_includes/ppl"

export default function Index(): React.ReactElement {
  return (
    <Base title="ppl" itemType="SoftwareApplication">

      <meta
        itemProp="applicationCategory"
        content="Address Book"
      />

      <meta
        itemProp="operatingSystem"
        content="Linux, macOS, Windows, BSD"
      />

      <article>
        <header>
          <h1>
            <span itemProp="name">
              ppl
            </span>
            <Ppl />
          </h1>
          <p itemProp="description">
            The command-line address book
          </p>

          <nav>
            <ol>
              <li><a href="/commands">Commands</a></li>
              <li><a href="/integrations">Integrations</a></li>
              <li><a href="/releases">Releases</a></li>
              <li><a href="/settings">Settings</a></li>
            </ol>
          </nav>
        </header>

        <section>
          <img
            alt="Animated demo showing Pippi Långstrump being added to a new address book"
            src="/casts/hero.svg"
          />
        </section>

        <Footer />
      </article>
    </Base>
  )
}

/*



<article>
  <header>
    <h1>
      <span itemprop="name">
        {{ title }}
      </span>
      {% include "ppl.tsx" %}
    </h1>
    <p itemprop="description">
      {{ description }}
    </p>

    <nav>
      <ol>
        <li><a href="{{ url }}/commands">Commands</a></li>
        <li><a href="{{ url }}/integrations">Integrations</a></li>
        <li><a href="{{ url }}/releases">Releases</a></li>
        <li><a href="{{ url }}/settings">Settings</a></li>
      </ol>
    </nav>
  </header>

  <section>
    <img
      alt="Animated demo showing Pippi Långstrump being added to a new address book"
      src="{{ url }}/casts/hero.svg"
    />
  </section>

  {% include "footer.tsx" %}

</article>


*/