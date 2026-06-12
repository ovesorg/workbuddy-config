---
name: plantuml-diagram
description: Generate PlantUML diagrams following OVES conventions. Covers all model-driven diagram types (ArchiMate, Sequence, Deployment, Class, Activity, State, C4, Gantt). Use when the user asks for diagrams — distinct from data-driven charts (Recharts).
triggers:
  - "diagram"
  - "plantuml"
  - "uml"
  - "archimate"
  - "architecture diagram"
  - "component diagram"
  - "sequence diagram"
  - "class diagram"
  - "deployment diagram"
  - "state diagram"
  - "activity diagram"
  - "C4 diagram"
  - "gantt chart"
  - "draw a diagram"
  - "create a diagram"
  - "用PlantUML画"
  - "架构图"
  - "流程图"
---

# OVES Diagram Skill

## Terminology: Diagram vs Chart

OVES uses distinct terms for two fundamentally different expression types:

| Term | Domain | Tool | Source of Truth |
|------|--------|------|-----------------|
| **Diagram** | Logic, structure, relationships, behavior | PlantUML | `.puml` file |
| **Chart** | Data, quantities, comparisons, distributions | Recharts | JSON/CSV + block props |

### The Dependency Test (Decision Rule)

> Remove all relationships from the representation.
> If essential meaning is lost → **Diagram** (PlantUML).
> If data remains independently valid → **Chart** (Recharts).

### Audit: All Types Mapped

#### Diagram Types (PlantUML — model-driven)

| Type | Without relationships | Verdict |
|------|---------------------|---------|
| ArchiMate | Unconnected boxes, no topology | ✅ Diagram |
| Sequence | Participants, no interaction | ✅ Diagram |
| Deployment | Nodes, no infrastructure topology | ✅ Diagram |
| Class | Classes, no inheritance/association | ✅ Diagram |
| Activity | Disconnected steps, no process | ✅ Diagram |
| State | Isolated states, no state machine | ✅ Diagram |
| C4 | Unconnected containers | ✅ Diagram |
| Gantt | Flat list of dates, no project structure | ✅ Diagram |

#### Chart Types (Recharts — data-driven)

| Type | Without visual encoding | Verdict |
|------|------------------------|---------|
| Line | Same {x,y} pairs, intact | ✅ Chart |
| Bar | Same labeled values, intact | ✅ Chart |
| Pie | Same proportions, intact | ✅ Chart |
| Area | Same data points, intact | ✅ Chart |
| Scatter | Same (x,y) pairs, intact | ✅ Chart |
| Radar | Same axis values, intact | ✅ Chart |
| Venn | Same set memberships, intact | ✅ Chart |

## When to Use Each Diagram Type

| Need | Diagram Type | Syntax Keyword |
|------|-------------|----------------|
| **Architecture (default)** | **ArchiMate Diagram** | `archimate`, layers: `#Business`, `#Application`, `#Technology`, `#Motivation`, `#Strategy`, `#Physical`, `#Implementation` |
| Time-ordered interactions (API calls, protocols) | Sequence Diagram | `participant`, `->`, `-->` |
| Infrastructure topology (nodes, containers) | Deployment Diagram | `node`, `artifact` |
| Object-oriented class structure | Class Diagram | `class`, `interface` |
| Workflows, business processes | Activity Diagram | `:step;`, `if`/`else` |
| State transitions | State Diagram | `state`, `[*]` |
| C4 model (Context, Container, Component) | C4 via stdlib | `!include <C4/C4_Context>` |
| Project timelines, milestones, dependencies | Gantt Chart | `@startgantt` |

**Rule of thumb:** Architecture → ArchiMate. Protocol/flow → Sequence Diagram.
Infrastructure → Deployment Diagram. Process → Activity Diagram.

## OVES Conventions (from dirac-framework)

Every PlantUML diagram in OVES repos MUST follow these conventions.

### Required Styling

```plantuml
!theme plain
skinparam backgroundColor #FAFAFA
skinparam defaultFontName "Segoe UI"
skinparam defaultFontSize 13
skinparam packageStyle rectangle
skinparam shadowing false
```

### Required Footer

```plantuml
footer Omnivoltaic [System Name] | %filename() rendered with PlantUML version %version()
```

### Code Structure

```plantuml
@startuml Title of Diagram

' ===== STYLING =====
!theme plain
skinparam ... (above)

' ===== COMPONENTS =====
package "Group Name" as Alias #Color {
  component "Name" as Alias
}

' ===== RELATIONSHIPS =====
A ..> B : description
C --> D : description

' ===== ANNOTATIONS =====
note right of Component
  description
end note

footer ...

@enduml
```

### Conventions Checklist

- 2-space indentation
- `' ===== SECTION =====` ASCII-art dividers between logical sections
- `as ALIAS` after every entity name
- `note right of` / `note top of` for annotations (use **bold** for keywords)
- Color packages with hex codes matching OVES palette
- Relationship arrows: `..>` for dependencies, `-->` for data flow, `..` for context
- Title: `title **Bold text**` at top after `@startuml`

## Rendering Pipeline: Intent → Scaffold → Embed

The `.puml` file is the **intent artifact** (authoritative source). SVG conversion and
embedding are handled by the scaffold process.

```
.puml file (intent)
  → java -jar plantuml.jar -tsvg  (scaffold step)
  → .svg output
  → embedded in deck/scroll HTML via <img> or inline SVG
```

### Commit Rule

Both `.puml` (source) and `.svg` (render) are committed together.
Colleagues without VS Code open the `.svg` in any browser.

### Viewing

VS Code `Alt+D` with PlantUML extension.

## Standard Process

1. **Analyze** — identify actors, boundaries, layers, dependencies
2. **Choose type** — ArchiMate default for architecture
3. **Write .puml** (intent artifact) to `docs/diagrams/<name>.puml`
4. **Render .svg** via `java -jar plantuml.jar -tsvg`
5. **Commit both** `.puml` + `.svg`
6. **Embed** in deck/scroll HTML output

## Quality Checklist

- [ ] Follows OVES styling (theme, skinparams, footer)
- [ ] Uses 2-space indent + ASCII section dividers
- [ ] Every entity has `as ALIAS`
- [ ] Every relationship has a label
- [ ] Notes explain WHY, not just WHAT
- [ ] No more than 4 layers of nesting
- [ ] Maximum ~12 components total
- [ ] Colors match OVES palette and are semantically meaningful

## Follow-up: FlowDiagramBlock (#9)

The `flow-diagram` block in oves-decks currently uses custom rendering.
A process flow has dependencies — it fails the dependency test.
Evaluate migrating `flow-diagram` to PlantUML Activity Diagram.

## References

- [plantuml-diagram-types.md](references/plantuml-diagram-types.md) — Full type reference
- [dirac-framework-conventions.md](references/dirac-framework-conventions.md) — Conventions from dirac-framework
- PlantUML official: https://plantuml.com/
- OVES examples: `D:/github/dirac-framework/docs/diagrams/`
