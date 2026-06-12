# Dirac-Framework PlantUML Conventions

Source: `D:/github/dirac-framework/docs/diagrams/`

## Existing Diagrams

| Diagram | Type | Has PNG | Style |
|---------|------|---------|-------|
| `dirac-framework.puml` | C4 Context + Component | Yes | C4 stdlib, custom skinparams |
| `inter-platform.puml` | Component Diagram | No | Vanilla PlantUML, packages |
| `messaging-platform.puml` | Component Diagram | Yes | `!theme plain`, custom skinparams |

## Style Conventions (Mandatory)

### Theme & Typography

```plantuml
!theme plain
skinparam backgroundColor #FAFAFA
skinparam defaultFontName "Segoe UI"
skinparam defaultFontSize 13
skinparam packageStyle rectangle
skinparam shadowing false
```

### Layout Controls (C4)

```plantuml
skinparam WrapWidth 1500
skinparam MaxMessageSize 1500
skinparam NotePadding 20
skinparam RectanglePadding 20
skinparam NoteTextAlignment left
```

### Footer

```plantuml
footer Omnivoltaic [System Name] | %filename() rendered with PlantUML version %version()
```

## Code Structure Conventions

### Section Dividers

```plantuml
' ===== HEADING =====
```

ASCII-art dividers separate logical sections: STYLING, COMPONENTS, RELATIONSHIPS, ANNOTATIONS.

### Indentation

2-space indent everywhere. No tabs.

### Entity Aliasing

Every entity gets `as ALIAS`:
```plantuml
component "Full Name" as FN
package "Group" as G
```

This keeps relationship syntax clean:
```plantuml
FN --> G : connects to
```

## Relationship Arrow Convention

| Arrow | Meaning | Use Case |
|-------|---------|----------|
| `..>` | Dependency / loaded into | Context, skills, config |
| `-->` | Solid flow | Active communication, calls |
| `..` | Context / logical grouping | Implicit relationships |
| `BiRel_D(A, B, "label")` | Bidirectional (C4 only) | Two-way communication |

## Annotation Convention

```plantuml
note right of Component
  **Bold keyword**: description
  more detail
end note
```

Use `note right of` (preferred) or `note top of`. Keep notes tight — 2-3 lines max.

## MQTT Topic Convention (from messaging-platform)

For IoT/messaging diagrams:
```
dt/{dom}/{app}/{rt}/{fl}/{it}      IoT data
cmd/{dom}/{app}/{rt}/{fl}/{it}     Commands
emit/{dom}/{svc}/{res}/{id}/{evt}  Events
call/{dom}/{svc}/{res}/{id}/{verb} RPC
meta/{dom}/{app}/{rt}/{fl}/{it}    Metadata (retained)
```

## Rendering Pipeline

1. `.puml` source authored in `docs/diagrams/`
2. Rendered to `.png` externally (VS Code plugin or CLI `java -jar plantuml.jar`)
3. Both `.puml` and `.png` committed to repo
4. Markdown references `.png`: `![alt](path/diagram.png)`
5. No mkdocs PlantUML plugin currently in use

## Files in Repo

```
D:/github/dirac-framework/
├── docs/diagrams/
│   ├── dirac-framework.puml      (source)
│   ├── dirac-framework.png       (render)
│   ├── inter-platform.puml       (source, no PNG)
│   ├── messaging-platform.puml   (source)
│   └── messaging-platform.png    (render)
└── site/diagrams/                (build copies, do not edit)
    ├── dirac-framework.puml
    ├── inter-platform.puml
    └── messaging-platform.puml
```
