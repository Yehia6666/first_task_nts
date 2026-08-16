---
name: project-design-system
description: Project-wide UI Design System and Clean Architecture rules for this Flutter app. Use whenever implementing, designing, or modifying any screen, widget, Cubit, State, Entity, Repository, Use Case, Model, or Data Source in this project (attendance logs, expenses, dashboard, etc.). Do not invent colors, fonts, spacing, radius, or file structure — follow this skill.
---

# NTS Flutter Project Skill

Source of truth for how this Flutter project must be built. Reference style:
**Attendance Logs** and **Expenses** screens — a modern, clean, premium
productivity-app look.

Two pillars:

1. **UI Design System** — every visual decision is centralized. Never invent a
   color, font size, spacing, radius, or icon style on the fly.
2. **Clean Architecture** — Presentation (Cubit) → Domain → Data. UI never
   touches data sources.

When asked to implement anything: **consult this skill first**, follow it
exactly, reuse the defined components, keep screens visually consistent.

---

## 1. UI Design System

### 1.1 Color Palette & Color Roles

All colors are centralized as semantic tokens (never hard-code hex in widgets).
Dark navy text on light/off-white background, white cards, one navy/purple
primary accent, green success, amber pending, soft red error.

| Token                     | Hex       | Role                                                                 |
| ------------------------- | --------- | -------------------------------------------------------------------- |
| `background`              | `#F4F5FA` | App scaffold background (light off-white)                            |
| `surface`                 | `#FFFFFF` | Cards, sheets, nav bars (white)                                      |
| `surfaceVariant`          | `#F0F1F7` | Search fields, unselected chips, input fills, hover fills            |
| `border`                  | `#E7E9F2` | Hairline card/list dividers, outline buttons, input borders          |
| `textPrimary`             | `#171B2E` | Dark navy — headlines, titles, primary content                       |
| `textSecondary`           | `#5A607A` | Body copy, metadata, subtitles                                       |
| `textMuted`               | `#9AA0B4` | Placeholders, disabled text, captions                                |
| `primary`                 | `#4F46E5` | Brand navy/purple accent — buttons, active states, key highlights    |
| `primaryDark`             | `#4338CA` | Pressed/emphasis state of `primary`                                  |
| `primaryContainer`        | `#E9E9FC` | Soft tinted background behind `primary` (selected chips, icon chips)  |
| `onPrimary`               | `#FFFFFF` | Text/icons on `primary` fills                                        |
| `success`                 | `#22C55E` | Present / approved / positive status                                 |
| `successContainer`        | `#E8F8EE` | Soft background behind `success` (badges, icons)                     |
| `warning` (pending)       | `#F59E0B` | Pending / in-progress / awaiting status                              |
| `warningContainer`        | `#FEF3E0` | Soft background behind `warning` (badges, icons)                     |
| `error`                   | `#EF4444` | Absent / rejected / errors / negative status                         |
| `errorContainer`          | `#FDE9E9` | Soft background behind `error` (badges, icons)                       |
| `infoBlue`                | `#3B82F6` | Info, attendance accent, secondary icon color                        |
| `infoBlueContainer`       | `#EAF1FE` | Soft background behind `infoBlue`                                    |
| `accentViolet`            | `#8B5CF6` | Expense accent — expense icons, expense summaries                    |
| `accentVioletContainer`   | `#F2ECFE` | Soft background behind `accentViolet`                                |
| `successDark`             | `#16A34A` | Darker success text (e.g. `+$1,250`)                                 |
| `errorDark`               | `#DC2626` | Darker error text                                                     |
| `warningDark`             | `#D97706` | Darker warning/pending text                                           |
| `shadow`                  | `#1A1D2E` | Shadow color, always used with low opacity (see 1.7)                  |

**Usage rules**

- Text on colored fills must use the matching container pair:
  `success` text → `successContainer` background; `error` → `errorContainer`;
  `warning` → `warningContainer`; `primary` → `primaryContainer`;
  `accentViolet` → `accentVioletContainer`.
- Icon colors mirror the same semantic tokens (a success icon is `success`).
- Never mix raw material palette colors (Colors.blue, Colors.red, etc.) into
  the UI. Only `Colors.white`/`Colors.black` are allowed for universal
  cases (scrims, shadows, truly neutral icons) and must go through tokens.
- Do NOT hard-code hex literals in widgets. All colors come from `AppColors`.

### 1.2 Typography

Default system font (Material 3 / Roboto). Single family; weight + size carry
the hierarchy. All text goes through `AppTextStyles` (never inline raw
`TextStyle` with arbitrary sizes).

| Token            | Size  | Weight | LetterSpacing | Use                                        |
| ---------------- | ----- | ------ | ------------- | ------------------------------------------ |
| `displayLarge`   | 32    | w700   | -0.5          | Screen hero numbers, big totals            |
| `headline`       | 24    | w700   | -0.3          | AppBar large titles, section hero          |
| `titleLarge`     | 20    | w700   | 0             | Card titles, screen titles (mobile)        |
| `titleMedium`    | 16    | w600   | 0             | Card subtitles, list item titles, nav text |
| `bodyLarge`      | 16    | w400   | 0             | Primary body copy                           |
| `bodyMedium`     | 14    | w400   | 0             | Secondary body, list metadata, descriptions|
| `labelLarge`     | 14    | w600   | 0             | Buttons, active chips, field labels        |
| `labelMedium`    | 12    | w600   | 0             | Small emphasized text, tab labels, badges  |
| `caption`        | 12    | w400   | 0             | Timestamps, captions, helper text          |
| `overline`       | 11    | w500   | 0.8           | Eyebrow labels above section titles        |

Line height ≈ 1.3–1.5× of size. Body copy never goes below 14 in cards.

**Usage rules**

- Headings always `textPrimary` navy.
- Body/metadata uses `textSecondary`, placeholders `textMuted`.
- Numbers/totals use `displayLarge`/`headline` with tabular feel, `w700`.
- Don't bold/italicize arbitrarily; stick to the tokens above.

### 1.3 Icons

- Library: **Material Icons**, **outlined** style by default (`Icons.…_outlined`).
- Sizes: `sm` 16, `md` 20 (default for list/icons in cards), `lg` 24
  (nav bar, FAB, AppBar actions), `xl` 32 (empty states, hero icons).
- Color: semantic (e.g. success/error/warning icon uses its color token).
  Generic icons on white cards use `textSecondary`, emphasis uses `primary`.
- Container behind icons in cards: 36–40px circle/square, tinted `…Container`
  token background, icon 20 at the matching solid token.

### 1.4 Spacing & Padding

Base unit **4**. Only these values (plus full-width page gaps) are allowed.

| Token  | Value | Use                                                              |
| ------ | ----- | ---------------------------------------------------------------- |
| `xs`   | 4     | Tiny gaps between inline elements                                 |
| `sm`   | 8     | Compact inner padding, icon-to-text gap                          |
| `md`   | 12    | Default gap between related elements, chip padding               |
| `lg`   | 16    | Standard card inner padding, page gap between cards              |
| `xl`   | 20    | Section spacing, card internal padding for rich cards            |
| `xxl`  | 24    | Between major sections, summary cards                            |
| `xxxl` | 32    | Screen top spacing, large section separation                     |

- Page horizontal padding: `16` mobile / `24` ≥600dp (see 1.9).
- Vertical list gaps between cards: `12`.
- Never use arbitrary padding values (e.g. 13, 18).

### 1.5 Border Radius

| Token   | Value | Use                                            |
| ------- | ----- | ---------------------------------------------- |
| `sm`    | 8     | Inputs, chips (rectangular variant), buttons   |
| `md`    | 12    | Search fields, small cards                     |
| `lg`    | 16    | **Standard cards**, bottom sheets              |
| `xl`    | 20    | Hero/summary cards, FABs, dialogs              |
| `full`  | 999   | Pills, chips, badges, status dots              |

Never mix different radii within one card. Card = `lg` (16) unless a hero card
uses `xl` (20).

### 1.6 Card Dimensions & Style

**Standard `AppCard`**
- Background `surface` (white), radius `lg` (16), inner padding `lg` (16).
- Height/content-driven; never fixed height (avoid overflow).
- Optional hairline `border` color, 1px, for separation on white backgrounds.

**Summary/Hero `SummaryCard`**
- Radius `xl` (20), padding `xl` (20).
- May be a soft-tinted background variant (e.g. `primaryContainer`,
  `accentVioletContainer`) or white with a colored leading icon.
- Big number uses `displayLarge`/`headline` in matching dark token.

**Card anatomy (standard)**
- `Row`: leading tinted icon container (36–40) → `Column(titleMedium/title,
  bodyMedium/caption metadata)` → trailing amount/status/chevron.
- Amounts: `titleMedium w700`, green for income/positive, `errorDark` for
  negative, `textPrimary` for neutral.

### 1.7 Shadows & Borders

- Shadows are **soft and low**: `BoxShadow(color: shadow @ 5–8% opacity,
  blurRadius 20, offset (0, 4))`. One elevation tier is enough for the app.
- Prefer hairline `border` (1px, `border` token) over heavy shadows for cards
  on white.
- No hard, high-opacity drop shadows. No inner shadows.

### 1.8 Buttons

| Type         | Style                                                                 |
| ------------ | --------------------------------------------------------------------- |
| `AppButton` (primary) | Fill `primary`, text `onPrimary` `labelLarge`, height 48, radius `md` (12), full-width on mobile. Pressed → `primaryDark`. |
| `AppButton` (secondary) | Outline 1px `border`, `textPrimary` text, height 48, radius `md`. |
| `AppButton` (text) | No fill/border, `primary` text, labelLarge.                      |
| Icon button   | 40px tappable, icon 20 `textSecondary` / `primary`.                   |

- Height 48 for full-size actions; 36 for compact/inline actions.
- Button text is never smaller than 13. Never use `TextButton`/`ElevatedButton`
  defaults with arbitrary styling — use the app button components.

### 1.9 Search Fields

- Background `surfaceVariant`, radius `md` (12), height 44–48, no visible
  border by default (optional 1px `border` when filled).
- Leading icon 20 `textMuted`, placeholder `textMuted`, input `textPrimary`.
- Optional trailing clear (✕) icon when non-empty.
- Padding inside: `h: 12, v: 8`.

### 1.10 Tabs / Filters / Chips

**Filter tabs (segmented pills)**
- Row of pills, horizontally scrollable; gap `sm` (8).
- Pill: radius `full`, padding `h: 12–16, v: 8`, text `labelMedium`.
- Unselected: `surfaceVariant` bg, `textSecondary` text.
- Selected: `primaryContainer` bg, `primary` text (w600). Optional 1–2px
  `primary` underline or dot accent.
- Support an "All" option first; filters control the list via Cubit state.

**Status badges/chips**
- Radius `full`, padding `h: 10, v: 4–6`, text `labelMedium` w600.
- Color = status pair: `success`/`successContainer`, `warning`/`warningContainer`,
  `error`/`errorContainer`, or `primary`/`primaryContainer`.
- Optional 6px status dot of the solid color before the label.

**Categories (expense/attendance types)**
- Small rounded chip `sm` (8) radius or pill, `surfaceVariant` bg,
  `textSecondary`, optional leading icon 16.

### 1.11 AppBar / Header

- Background `background` (or `surface`), no elevated shadow; hairline border
  optional.
- Large title style: `headline`/`titleLarge` `textPrimary` navy, left-aligned.
- Right actions: icon buttons 24 `textSecondary`.
- Optional leading back arrow 24.
- On tablet/desktop, the header shows a page eyebrow (`overline`) + title.

### 1.12 Bottom Navigation & Navigation

- **Mobile (<600dp):** `BottomAppBar`/`NavigationBar`, `surface` white,
  height 64 + safe area. 3–5 items, outlined icons 24, selected item uses
  `primary` with a pill highlight (`primaryContainer`), labels `labelMedium`.
- **Tablet (600–1024):** `NavigationRail` (or same bottom bar if portrait).
- **Desktop/Web (≥1024):** side `NavigationRail` / left nav, items 64px
  wide, selected `primaryContainer` pill + `primary` icon.
- Never use bottom nav on desktop; never use a rail on compact mobile.

### 1.13 Floating Action Button

- `FloatingActionButton.extended` when it has a label: fill `primary`, icon 24
  `onPrimary`, radius `xl` (20), label `labelLarge w600` `onPrimary`.
- Compact circular variant: 56px, `primary` fill, icon 24 `onPrimary`.
- Positioned above bottom nav with standard margins (16 + bottom nav inset).

### 1.14 Empty / Loading / Error States

- **Empty:** centered `Column` — icon 64 in `surfaceVariant` circle (or a soft
  container), `titleMedium w600` `textPrimary`, `bodyMedium` `textSecondary`
  helper line, optional primary `AppButton`. Padding `xxxl`.
- **Loading:** skeleton cards matching `AppCard` shape (surfaceVariant blocks,
  radius `lg`) or a subtle centered `CircularProgressIndicator` in `primary`.
- **Error:** same layout as empty, `error` icon + `errorContainer` circle,
  `errorDark` title, retry `AppButton` (primary).
- These come as reusable widgets; screens never hand-roll them.

### 1.15 Responsive Rules

Breakpoints: **mobile <600**, **tablet 600–1024**, **desktop/tablet-landscape ≥1024**.

| Aspect      | Mobile                | Tablet                | Desktop/Web                   |
| ----------- | --------------------- | --------------------- | ----------------------------- |
| Page padding| 16                    | 24                    | 24, centered max-width 1200   |
| Card lists  | Single column         | 2 columns (GridView)  | 3 columns (GridView)          |
| Summary cards | Stack full-width   | Row of 2–4            | Row of 4 within max width     |
| Typography  | Keep tokens; smaller display (32) | display 40 at most | display 40 at most   |
| Navigation  | Bottom nav            | NavigationRail/bottom | NavigationRail / left nav     |
| Spacing     | `md`–`lg`             | `lg`–`xl`             | `xl`–`xxl`                    |
| Inputs      | Full-width            | Half–third width      | Fixed 320–480 max width       |

**Rules**
- Never use fixed pixel widths for cards/buttons that could overflow on small
  screens — use flexible layout (`Expanded`, `Flexible`, `GridView`, max
  width constraints).
- Use `LayoutBuilder`/`MediaQuery` breakpoints via a helper, not inline
  conditions scattered everywhere.
- All dimensions come from the token system; responsive changes only swap
  tokens, never introduce new raw values.

### 1.16 Reusable Component Catalogue

**Design System primitives**
`AppColors`, `AppTextStyles`, `AppSpacing`, `AppRadius`, `AppShadows`,
`AppThemeData` (ThemeData builder), `AppResponsive` (breakpoint helpers).

**Generic widgets**
`AppButton`, `AppTextField`, `AppSearchField`, `AppCard`, `AppChip`,
`AppBadge` (status), `AppSectionTitle` (overline + title + optional "See all"),
`AppHeader`/`AppAppBar`, `AppBottomNavigation`, `AppFloatingActionButton`,
`AppEmptyState`, `AppLoadingState`, `AppErrorState`, `AppFilterTabs`,
`AppAmountText`, `AppStatusDot`.

**Domain cards**
`AttendanceCard`, `ExpenseCard`, `SummaryCard`, `FilterTabs` — built ONLY from
the primitives above, never with raw styling.

**Widget hierarchy (build order)**

```
Design System        AppColors, AppTextStyles, AppSpacing, AppRadius, AppShadows
    ↓
Reusable Components  AppButton, AppCard, AppSearchField, AppChip, AppBadge, ...
    ↓
Feature Widgets      AttendanceCard, ExpenseCard, SummaryCard, FilterTabs
    ↓
Screens              AttendanceScreen, ExpensesScreen (compose, never grow)
```

Screens = `Scaffold` + `AppHeader`/`AppAppBar` + `body` (lists/grids built from
domain cards) + optional `AppBottomNavigation`/`FAB`. Widgets stay small;
complex screens compose, they don't grow.

---

## 2. Clean Architecture

### 2.1 Layers & Data Flow

```
Presentation  (flutter_bloc: Cubit + UI State + Widgets/Screens)
      ↓  calls
Domain        (Entities, Repository Contracts, Use Cases)
      ↓  implemented by
Data          (Models, Repository Implementations, Data Sources)
```

Data flows **down** through abstractions; state flows **up** to UI via Cubit.

- Cubit belongs to the **Presentation** layer.
- Business logic must **NOT** live inside UI widgets.
- UI must **NOT** access Data Sources (or Data layer types) directly.
- Use Cases hold application/business logic and coordinate repositories.
- Repositories are accessed **through contracts (abstract classes)**.
- Data layer implements those contracts; swapping mock → API only touches the
  Data layer. **UI never changes.**

### 2.2 Directory Structure

```
lib/
├── main.dart
├── app.dart                       # MaterialApp + theme wiring
├── core/
│   ├── constants/                 # AppColors, AppSpacing, AppRadius, etc.
│   ├── theme/                     # AppTextStyles, AppThemeData, AppShadows
│   ├── utils/                     # AppResponsive, formatters
│   ├── widgets/                   # AppButton, AppCard, AppSearchField, ...
│   └── errors/                    # failure types, exception mapping
├── features/
│   ├── attendance/
│   │   ├── presentation/
│   │   │   ├── cubit/             # AttendanceCubit
│   │   │   ├── states/            # AttendanceState (sealed)
│   │   │   └── widgets/           # AttendanceScreen, AttendanceCard, ...
│   │   ├── domain/
│   │   │   ├── entities/          # AttendanceLog
│   │   │   ├── repository/        # AttendanceRepository (abstract)
│   │   │   └── usecases/          # GetAttendanceLogs, ToggleFilter, ...
│   │   └── data/
│   │       ├── models/            # AttendanceLogModel
│   │       ├── repositories/      # AttendanceRepositoryImpl
│   │       └── datasources/       # AttendanceLocalDataSource (mock now)
│   └── expenses/                  # same structure as attendance
│       ├── presentation/ …
│       ├── domain/ …
│       └── data/ …
```

### 2.3 Rules per Layer

**Domain**
- `Entities`: pure Dart classes (no Flutter imports) with fields + minimal
  helpers; equality where useful.
- `Repository contracts`: abstract classes defining the feature's data API.
- `Use Cases`: single-responsibility classes, one public method (e.g. `call()`);
  take repository contracts via constructor; return `Future`/`Stream` results.

**Data**
- `Models`: extend/map from entities, add JSON (de)serialization
  (`fromJson`/`toJson`) for future API.
- `Repository Implementations`: implement domain contracts; use Data Sources.
- `Data Sources`: initially **static/mock data** (in-memory lists with a small
  artificial `Future.delayed` to simulate latency). Later swap in remote
  sources **without touching domain or presentation**.

**Presentation**
- `Cubit` (flutter_bloc): holds UI state, calls Use Cases, emits states.
- `States`: sealed classes (`sealed class AttendanceState`) with subclasses
  like `AttendanceInitial`, `AttendanceLoading`, `AttendanceLoaded(List<…>)`,
  `AttendanceError`. Cubit only emits these.
- `Widgets`: screens listen to Cubit via `BlocBuilder`/`BlocProvider`; render
  loading/error/loaded states using the Design System widgets.

### 2.4 Mock Data & Future API Swap

- Start with mock data sources (see Data Sources above). Keep the mock inside
  `data/datasources/`.
- Repository interface + use cases are identical for mock and API — switching
  later means adding a new Data Source + changing the DI binding only.
- Use constructor injection for repositories; wire them in one place
  (e.g. a simple `ServiceLocator`/top-level `main` wiring, or `get_it` if
  added) so no screen constructs a repository itself.

### 2.5 Suggested Dependencies (add at implementation time)

- `flutter_bloc` — Cubit state management (presentation).
- `equatable` — value equality for states/entities (optional but recommended).
- `get_it` — optional simple DI (or manual wiring).
- Keep UI free of `dart:io`/HTTP; all async I/O stays in the Data layer.

---

## 3. Implementation Checklist (run whenever asked to build a screen)

1. **Consult this skill** — colors, typography, spacing, radius, icons, components.
2. Follow Clean Architecture:
   - Entity → Repository contract → Use Case → Model → Repo impl → Mock Data
     Source → Cubit → State → Screen/Widgets.
3. Wire Cubit at the feature root; never instantiate repositories in widgets.
4. Build UI only from the reusable components; screens stay small and responsive.
5. Keep all colors/text styles from `AppColors`/`AppTextStyles` — no inline hex.
6. Verify: `flutter analyze` passes; no fixed-size widgets that can overflow.
7. Keep the two reference screens (Attendance Logs, Expenses) as the style
   benchmark — new screens must look like they belong to the same app.
