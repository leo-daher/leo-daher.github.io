import { createContext, useContext } from "react";
export const PortfolioContext = createContext(null);
export function usePortfolio() {
  return useContext(PortfolioContext);
}
export const basePath = import.meta.env.BASE_URL;
export function assetUrl(path) {
  return `${basePath}${path.replace(/^\//, "")}`;
}
export const contactLinks = {
  linkedin: "https://www.linkedin.com/in/leonedaher/",
  whatsapp: "https://wa.me/5521999997667",
  github: "https://github.com/leo-daher",
  schedule: "https://calendly.com/leonedaher/30min",
};
