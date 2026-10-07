// Selected projection of the shared professional knowledge base.
import experiences from "./experiences.generated.json" with { type: "json" };

export const EXPERIENCES = experiences;
export const FEATURED_EXPERIENCES = EXPERIENCES.filter((item) => item.featured);
