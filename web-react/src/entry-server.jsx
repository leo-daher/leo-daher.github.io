import { renderToString } from "react-dom/server";
import App from "./App.jsx";

export function renderRoute(path, { locale = "en", certificates = [] } = {}) {
  return renderToString(
    <App
      initialPath={path}
      initialLocale={locale}
      initialCertificates={certificates}
      staticRender
    />,
  );
}
