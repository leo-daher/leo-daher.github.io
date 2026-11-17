# Lyzer Deliver

Routes, offline execution, and proof of delivery for field teams.

**Published summary:** 100+ downloads · Flutter · Android · iOS

Checked in July 2026.

## Shared case study: Lyzer Collect + Deliver

An operational suite connecting collection, order preparation, routes, and delivery.

## Context

Logistics · Portugal · Flutter · Android and iOS

## My role

Flutter engineering across the Lyzer suite's Android and iOS operational flows.

## Contribution

Picking and delivery flows built on a proprietary GetX-based engine, with barcode scanning, offline synchronization, and integrations designed for field operations.

## Delivery on the field operator's phone

Lyzer Deliver is the Lyzer suite's application for routes, field operation and proof of delivery. It connects with a logistics operation that also includes order management and preparation. While Collect supports preparation, Deliver follows the stage when an order travels to its destination and execution needs to be recorded by the operator.

I worked on Flutter engineering for the suite's Android and iOS operational flows. Work on Deliver connects with the experience of using the application during an operation, representing delivery state and integrating with product services. The interface and data need to make sense throughout a sequence of actions, beyond any individual screen.

## Engine and design system shared across the apps

Deliver and Collect share two private Flutter packages: engine and design_system, consumed as Git dependencies from their own repositories. I worked on building and evolving flows within this structure, connecting the interface with data and delivery-operation rules.

The proprietary engine is based on GetX and brings together state management, controllers, navigation, services and reusable capabilities. The design system provides themes and visual components organized using Atomic Design. This division keeps infrastructure and visual language shared while each application implements its own operational journey.

Working across both products provided a view of the path from preparation to delivery and of how information moves between applications and services. That experience involves developing flows on a common foundation, considering how shared conventions affect the suite's consistency and maintainability.

## Operational continuity with offline data

Field operations include situations where connectivity is unavailable. Work on offline flows and synchronization accounts for that reality: the application needs to handle data on the device and its integration with services. In Deliver, this context belongs to the product's route, execution and proof-of-delivery experience.

The challenge includes making the operation's state understandable to the person using the phone. The action performed in the application and the information reaching other systems belong to the same process. This relationship between the mobile experience and data was one dimension of my work on the suite's flows.

## Service integration and logistics tracking

My Lyzer experience also included a .NET Backend for Frontend. That layer received Android/mobile application requests, queried microservices through GraphQL and HTTP, and assembled the data into a response. Centralizing composition in the backend helped keep this logic outside the mobile client.

In related backoffice work, I developed reusable components, responsive interfaces and refactoring for performance and maintainability. The backoffice supported order management, preparation and delivery tracking. This work complemented my Flutter experience and broadened my view of the relationships between the application, services and operational tracking.

## Maintenance supported by investigation and review

To support Deliver and Collect development, I used Flutter Agent Skills and Claude with Sentry access through MCP in investigation workflows. The experience included scheduled investigations and preparing Jira cards and pull requests with explanations, sources and tests for review. The aim was to turn information about problems into engineering work the team could examine.

Deliver has public Android and iOS versions accessible through the official links above. The screenshots show the product and distinguish it from Collect. Download evidence is the snapshot checked in July 2026; this page explains my development and maintenance contribution within a collective effort.

## Stack

Flutter · Android · iOS · Proprietary GetX engine · Private Flutter design system · Offline-first · Barcode · .NET BFF · GraphQL

## Public proof

- [Lyzer Collect · Google Play](https://play.google.com/store/apps/details?id=tech.lyzer.collect): 1K+ downloads — Updated Jul 6, 2026 · Checked in July 2026.

- [Lyzer Collect · App Store](https://apps.apple.com/pt/app/lyzer-collect/id6738952338)

- [Lyzer Deliver · Google Play](https://play.google.com/store/apps/details?id=tech.lyzer.deliver): 100+ downloads — Updated Jul 14, 2026 · Checked in July 2026.

- [Lyzer Deliver · App Store](https://apps.apple.com/br/app/lyzer-deliver/id6748221787)

## Official store images

![Lyzer Collect · Screens published in the store 1](https://leonedaher.com/assets/apps/lyzer-collect-01.png)

![Lyzer Collect · Screens published in the store 2](https://leonedaher.com/assets/apps/lyzer-collect-02.png)

![Lyzer Deliver · Screens published in the store 1](https://leonedaher.com/assets/apps/lyzer-deliver-01.png)

![Lyzer Deliver · Screens published in the store 2](https://leonedaher.com/assets/apps/lyzer-deliver-02.png)

## Provenance and limits

- The 14-app count belongs to the Latitudde/Conkord inventory of Android and iOS deliveries. MAG Venda Digital is excluded; the count does not mean 14 individually authored products.
- Case studies describe Leone's role and contribution within teams. A store listing supports the existence of a published product, but does not establish sole authorship or responsibility for the entire product.
- Store metrics are snapshots checked in July 2026. Values with + and rounded summaries such as 11.5K+ are not exact counts or current measurements; ratings, downloads, and availability may change.

## Public sources

[Portfolio page](https://leonedaher.com/apps/lyzer-deliver/)
