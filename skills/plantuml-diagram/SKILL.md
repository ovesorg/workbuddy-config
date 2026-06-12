---
name: plantuml-diagram
description: Generate PlantUML diagrams following OVES conventions. Use when the user asks for UML diagrams, architecture diagrams, sequence diagrams, class diagrams, or any PlantUML-based visualization of system structure.
triggers:
  - "plantuml"
  - "uml diagram"
  - "architecture diagram"
  - "archimate"
  - "component diagram"
  - "sequence diagram"
  - "class diagram"
  - "deployment diagram"
  - "C4 diagram"
  - "draw this as plantuml"
  - "generate plantuml"
  - "create a diagram"
  - "用PlantUML画"
  - "架构图"
---

# PlantUML Diagram

Generate PlantUML diagrams following OVES conventions established in
`D:/github/dirac-framework/docs/diagrams/`.

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
| **Architecture ideas (default)** | **ArchiMate Diagram** | **This is the default** |

**Rule of thumb:** Architecture → ArchiMate. Protocol/flow → Sequence Diagram.
Infrastructure → Deployment Diagram. Don't overcomplicate — pick one type per idea.

## OVES Conventions (from dirac-framework)

Every PlantUML diagram in OVES repos MUST follow these conventions:

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
- `as ALIAS` after every entity name (enables cleaner relationship syntax)
- `note right of` / `note top of` for annotations (use **bold** for keywords)
- Color packages with hex codes matching OVES palette (#FAFAFA backgrounds, #E6F1FB for data, #E1F5EE for services, #F1EFE8 for external)
- Relationship arrows: `..>` for dependencies, `-->` for data flow, `..` for context
- Title: `title **Bold text**` at top after `@startuml`
- NEVER use labels with special characters without quoting them

## Rendering Pipeline: Intent → Scaffold → Embed

The `.puml` file is the **intent artifact** (authoritative source). SVG conversion and
embedding are handled by the scaffold process — the same pattern used by Recharts
chart blocks in `oves-decks`.

### Pipeline

```
.puml file (intent)
  → java -jar plantuml.jar -tsvg  (scaffold step)
  → .svg output
  → embedded in deck/scroll HTML via <img> or inline SVG
```

### Commit Rule

Both `.puml` (source) and `.svg` (render) are committed together.
Colleagues without VS Code open the `.svg` in any browser.
Decks and scroll presentations reference the `.svg` at build time.

### Viewing in WorkBuddy

For quick review: VS Code `Alt+D` with PlantUML extension.
For sharing: distribute the `.svg` file or embed in HTML output.

## Standard Process for Architecture Diagrams

Given a natural language description of architecture:

1. **Analyze the idea** — identify actors, boundaries, layers, dependencies
2. **Choose diagram type** — ArchiMate is default for architecture
3. **Write .puml** (intent artifact) to `docs/diagrams/<name>.puml`
4. **Render .svg** via `java -jar plantuml.jar -tsvg` (scaffold step)
5. **Commit both** `.puml` + `.svg` to repo
6. **Embed** in deck/scroll HTML output

## Quality Checklist

Before considering a diagram complete, verify:

- [ ] Follows OVES styling (theme, skinparams, footer)
- [ ] Uses 2-space indent + ASCII section dividers
- [ ] Every entity has `as ALIAS`
- [ ] Every relationship has a label explaining what flows
- [ ] Notes explain WHY, not just WHAT
- [ ] No more than 4 layers of nesting
- [ ] Maximum ~12 components total (split into sub-diagrams if larger)
- [ ] Colors match OVES palette and are semantically meaningful

## References

- [plantuml-diagram-types.md](references/plantuml-diagram-types.md) — Full diagram type reference
- [dirac-framework-conventions.md](references/dirac-framework-conventions.md) — Detailed conventions from dirac-framework
- PlantUML official: https://plantuml.com/
- OVES PlantUML examples: `D:/github/dirac-framework/docs/diagrams/`
