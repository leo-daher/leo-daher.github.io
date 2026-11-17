# Lyzer Collect

Collection and order preparation built for connected field operations.

**Published summary:** 1K+ downloads · Flutter · Android · iOS

Checked in July 2026.

## Shared case study: Lyzer Collect + Deliver

An operational suite connecting collection, order preparation, routes, and delivery.

## Context

Logistics · Portugal · Flutter · Android and iOS

## My role

Flutter engineering across the Lyzer suite's Android and iOS operational flows.

## Contribution

Picking and delivery flows built on a proprietary GetX-based engine, with barcode scanning, offline synchronization, and integrations designed for field operations.

## Order preparation within the logistics operation

Lyzer Collect belongs to a suite connecting order management, preparation, routes and delivery for retail and e-commerce operations. It focuses on collection and order preparation, where the operator's work needs to be reflected in the operation's state. The mobile application is one interface in that process, alongside backend services and the logistics backoffice.

My role included Flutter engineering across the suite's Android and iOS operational flows. Collect and Deliver are related products with different roles in the journey: Collect supports preparation, while Deliver supports delivery execution in the field. The experience across both products also involves integrations with the systems supporting that operation.

## Camera and barcode scanning: the first version

I implemented V1 of the camera-based barcode reader for Collect's picking flows. This experience connects capture on a phone with order preparation: the operator points the camera at a product, and the recognized code enters the flow that identifies the item and tracks its collection.

The Flutter scanning implementation uses the camera package to control the camera and supply images, alongside google_mlkit_barcode_scanning to recognize codes with Google ML Kit. The scanner is organized as a service and a widget in the shared engine, separating capture and detection from Collect's order-preparation logic.

Within the picking flow, scanning feeds code validation, product lookup in the order and handling of situations such as an already collected item or a code that does not belong to that order. This connection between camera and operation makes scanning a step in the operator's journey, with a result that the interface needs to explain and handle.

## Engine and design system in two private Flutter packages

Collect and Deliver share two private Flutter packages, maintained in their own repositories: engine and design_system. I worked with this common foundation when developing application flows. The separation supports reuse of infrastructure and visual components across products with different journeys, while maintaining shared conventions for the Lyzer suite.

The proprietary engine builds on GetX and goes beyond state management: it includes base controller classes, navigation, services, data access and reusable capabilities such as the scanner. The design system concentrates themes, colors, typography and interface components, organized according to Atomic Design. Each package has a distinct responsibility in building the applications.

The applications consume both packages as private Git dependencies. In practice, this connects Collect-specific flows with infrastructure shared with Deliver, while the interface uses the same visual foundations and components. My work on these flows needed to account for both order-preparation rules and the conventions of that shared foundation.

## Offline operation and synchronization

The suite includes offline operation and data synchronization to support field work. In this setting, the interface needs to represent both the user's action and the state of the data available on the device. Continuity of the flow and its subsequent integration with services are part of the engineering problem, alongside barcode scanning and the other preparation steps.

This work connects the mobile experience with the logistics operation. Preparing an order does not end on the operator's screen: it belongs to a journey followed by other parts of the product. Application flows therefore need to be understood together with the backend and backoffice.

## Backend and backoffice in the same product context

Beyond mobile, I worked on related logistics backoffice efforts, including reusable components, responsive interfaces and refactoring for maintainability and performance. That context included order management, preparation and delivery tracking, in collaboration with other parts of the team.

Another area was a .NET Backend for Frontend. It received Android/mobile application requests, queried the required microservices through GraphQL and HTTP, and composed a response for the client. Data composition was centralized in that layer, reducing complexity that would otherwise have to be handled by the application. These are related Lyzer experiences spanning more than one product in the suite.

## Error investigation and application evolution

The engineering work also included Flutter Agent Skills and Claude connected to Sentry through MCP to support Collect and Deliver investigations. It involved scheduled investigations and preparing Jira cards and pull requests with explanations, sources and tests for review. These tools formed part of application maintenance and development.

The screenshots and official links on this page provide access to the published products. Download figures retain their original observation date of July 2026. My contribution brings together mobile development, service integration and problem investigation, connecting flow development with monitoring the application in use.

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

[Portfolio page](https://leonedaher.com/apps/lyzer-collect/)
