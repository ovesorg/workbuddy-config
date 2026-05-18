# Agent Start Here

Use this repo when the task is about:

- WorkBuddy shared configuration for a team
- Setting up or onboarding to WorkBuddy connector configs
- Installing shared skills across machines
- Bootstrap script generation for new teammates
- MCP server configuration management

Read in this order:

1. `docs/context/capabilities.md`
2. `docs/context/workflows.md`
3. `docs/context/contracts.md`
4. `README.md`

Use this repo to answer:

- What connectors are available and how are they configured?
- How do I install shared skills on a new machine?
- How does the bootstrap workflow work?
- What environment variables are needed for each connector?
- How should a team member adopt this config package?

Do not use this repo to define:

- Individual credentials or secrets (those stay local, never in this repo)
- Per-user WorkBuddy settings (`~/.workbuddy/workbuddy.db`, session state)
