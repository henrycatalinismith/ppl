import React from "react"

export default function Ppl(): React.ReactElement {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      xmlnsXlink="http://www.w3.org/1999/xlink"
      viewBox="-1 0 12 8"
      strokeLinecap="round"
      strokeLinejoin="round"
      height="32px"
      width="64px">
      <defs>
        <path id="p" d="M0,6 L0,3 L2,3 L2,5 L0,5" />
        <path id="l" d="M0,3 L0,6 L2,6" />
      </defs>
      <use xlinkHref="#p" fill="none" stroke="#000000" stroke-width="2.8" x="0" y="0" />
      <use xlinkHref="#p" fill="none" stroke="#fff1e8" stroke-width="1" x="0" y="0" />
      <use xlinkHref="#p" fill="none" stroke="#000000" stroke-width="2.8" x="4" y="0" />
      <use xlinkHref="#p" fill="none" stroke="#fff1e8" stroke-width="1" x="4" y="0" />
      <use xlinkHref="#l" fill="none" stroke="#000000" stroke-width="2.8" x="8" y="0" />
      <use xlinkHref="#l" fill="none" stroke="#fff1e8" stroke-width="1" x="8" y="0" />
    </svg>
  )
}
