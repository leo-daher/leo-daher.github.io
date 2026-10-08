export function Icon({ name, size = 24, ...props }) {
  const paths = {
    "arrow-right": "M5 12h14m-6-6 6 6-6 6",
    "arrow-left": "M19 12H5m6-6-6 6 6 6",
    external: "M7 17 17 7M7 7h10v10",
    close: "m6 6 12 12M6 18 18 6",
    "chevron-right": "m9 6 6 6-6 6",
    "chevron-left": "m15 6-6 6 6 6",
    "chevron-down": "m6 9 6 6 6-6",
    menu: "M4 6h16M4 12h16M4 18h16",
    sun: "M12 2v2m0 16v2M2 12h2m16 0h2M5 5l1.5 1.5m11 11L19 19M5 19l1.5-1.5m11-11L19 5",
    moon: "M20.5 13A9 9 0 0 1 11 3.5a9 9 0 1 0 9.5 9.5Z",
    chat: "M4 4h16v13H8l-4 4V4ZM8 8h8M8 12h6",
    calendar: "M5 5h14v16H5V5ZM8 3v4m8-4v4M5 10h14M8 14h2m4 0h2m-8 3h2",
    home: "m3 10 9-7 9 7M5 9v12h5v-7h4v7h5V9",
    apps: "M3 3h7v7H3V3Zm11 0h7v7h-7V3ZM3 14h7v7H3v-7Zm11 0h7v7h-7v-7Z",
    system: "M4 3h16v6H4V3ZM4 15h16v6H4v-6ZM12 9v6M8 6h.01M8 18h.01",
    clients: "M8 21v-8h8v8M3 21h18M4 13V3h16v10M8 7h1m6 0h1M8 10h1m6 0h1",
    certificate: "M4 3h16v14H4V3ZM8 7h8M8 10h5m-4 7-1 4 4-2 4 2-1-4",
    article: "M5 3h14v18H5V3ZM8 7h8M8 11h8M8 15h5",
    check: "m5 12 4 4L19 6",
    download: "M12 3v12m-5-5 5 5 5-5M4 17v4h16v-4",
    share: "M18 5 6 12l12 7",
    filter: "M4 5h16M7 12h10m-7 7h4",
    search: "m15.5 15.5 5 5",
  };
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="1.8"
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
      {...props}
    >
      <path d={paths[name] || paths.external} />
      {name === "sun" && <circle cx="12" cy="12" r="4" />}
      {name === "share" && (
        <>
          <circle cx="18" cy="5" r="3" />
          <circle cx="6" cy="12" r="3" />
          <circle cx="18" cy="19" r="3" />
        </>
      )}
      {name === "search" && <circle cx="10" cy="10" r="6" />}
    </svg>
  );
}
