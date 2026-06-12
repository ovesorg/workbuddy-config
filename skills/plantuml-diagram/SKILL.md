---
name: plantuml-diagram
description: Generate PlantUML diagrams following OVES conventions. Use when the user asks for UML diagrams, architecture diagrams, sequence diagrams, class diagrams, or any PlantUML-based visualization of system structure.
triggers:
  - "plantuml"
  - "uml diagram"
  - "architecture diagram"
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
| System components + dependencies (architecture) | Component Diagram | `component`, `package` |
| Time-ordered interactions (API calls, protocols) | Sequence Diagram | `participant`, `->`, `-->` |
| Infrastructure topology (nodes, containers) | Deployment Diagram | `node`, `artifact` |
| Object-oriented class structure | Class Diagram | `class`, `interface` |
| Workflows, business processes | Activity Diagram | `:step;`, `if`/`else` |
| State transitions | State Diagram | `state`, `[*]` |
| C4 model (Context, Container, Component) | C4 via stdlib | `!include <C4/C4_Context>` |
| **Architecture ideas (default)** | **Component Diagram** | **This is the default** |

**Rule of thumb:** Architecture → Component Diagram. Protocol/flow → Sequence Diagram.
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

## Rendering Workflow

### Option A: Online Server (quick preview)

```
http://www.plantuml.com/plantuml/svg/ENCODED
```

Encode the diagram text with PlantUML's encoder.
Tell the user to paste code at: https://www.plantuml.com/plantuml/uml/

### Option B: Save as .puml file (OVES standard)

1. Write `.puml` to `docs/diagrams/<name>.puml`
2. User renders to PNG via VS Code PlantUML extension or CLI:
   ```
   java -jar plantuml.jar docs/diagrams/<name>.puml
   ```
3. Reference in markdown: `![alt](path/to/<name>.png)`
4. Commit BOTH `.puml` (source) and `.png` (render)

### Option C: MkDocs Integration (future)

Add to `mkdocs.yml`:
```yaml
markdown_extensions:
  - plantuml_markdown
```

Then diagrams can be written inline in markdown fenced blocks.
Requires `pip install plantuml-markdown` and a running PlantUML server.

## Standard Process for Architecture Diagrams

Given a natural language description of architecture:

1. **Analyze the idea** — identify actors, boundaries, layers, dependencies
2. **Choose diagram type** — component diagram is default for architecture
3. **Write structure** — start with `@startuml`, add styling, group into packages
4. **Add relationships** — arrows between components showing dependencies
5. **Annotate** — notes explaining key concepts, decisions, or constraints
6. **Validate** — ensure every component has an alias, every relationship has a label
7. **Output** — deliver both the PlantUML code block AND the plantuml.com preview URL

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
