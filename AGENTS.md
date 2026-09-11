# 4D Form Tutorial — Agent Instructions

## What this repository is

A tutorial and worked example for designing forms in 4D. It contains a
runnable 4D project under `example/` that is used as the reference fixture
for form-design techniques.

This repository no longer carries its own 4D knowledge base.

## Where the form knowledge lives

The per-object form documentation that used to live in
`.github/instructions/` has moved to the standalone skillset:

	https://github.com/miyako/skills

It is now `4d-skills/skills/4dform/` in that repository -- a `SKILL.md`
with an authoring protocol and a route table, plus one reference file per
form object under `references/objects/`. The tool4d command-line material
became `4d-skills/skills/4dcli/`.

Nothing was lost in the move. The content was deduplicated against the
skills already in that repository, so rules about `.4dm` source code, 4D
command syntax, project layout, and tool provisioning are now owned by
`4dlsp`, `4dlang`, `4dproject` and `4dtools` rather than restated here.

Install that skillset in your agent host once and it applies to every 4D
project, including this one. It is deliberately project-independent: it
does not depend on this repository, and this repository does not vendor
it. Read `4d-skills/AGENTS.md` there for skill selection.

## Working in this repository

For any form work, use the `4dform` skill and follow its authoring
protocol. Do not reconstruct form knowledge by reading `example/` -- the
example illustrates the documentation, not the other way round.

## The example project

	example/
	  Project/
	    example.4DProject
	    Sources/
	      Forms/Inputs/            project form, form method, object methods
	      Classes/                 form class example
	      Methods/                 CLI startup methods (see below)
	      TableForms/1/            table input and output forms
	      catalog.4DCatalog        schema
	      lists.json               toolbox choice lists
	      menus.json, roles.json, styleSheets.css
	  Resources/
	    Images/                    test images: animated GIF, SVG, WEBP, @2x/@3x,
	                               dark-mode pairs, TIFF, BMP
	    en.lproj, fr.lproj, ja.lproj   XLIFF localization

`example.4DProject` declares `compatibilityVersion` 2101 (4D 21.1) and
does not set `tokenizedText`, so it defaults to the IDE's tokenized form.
Some methods here are tokenized (`:C643`, `:K37:94`) and some are plain;
both work.

## Startup methods: relationship to the `4dcli` skill

`example/Project/Sources/Methods/` contains the CLI entry points used to
render and test forms: `project_form_to_image`, `print_form_to_file`,
`run_project_form`, `dialog_screenshot`, `goto_page_then_screenshot`,
`screenshot_and_accept`.

All six are also shipped by the `4dcli` skill, as installable assets
for projects that do not have them. The two copies are **close but not
identical**, and the skill's are the maintained ones:

- The skill's assets are untokenized, for portability across projects.
  Some copies here are tokenized (`:C643`, `:K37:94`), because this
  project is IDE-maintained.
- Both now parse `--user-param` as `FormName:Page:Path` by rejoining
  everything after the second colon, so a Windows path such as
  `C:\out.png` survives rather than being truncated to `"C"`.

Treat the versions in `4dcli` as authoritative. If you change the ones
here, do not assume the skill should follow.

### Syntax checking: do not add a startup method

This project previously carried a `syntax_check` startup method that
called `Compile project` and wrote `syntax_errors.json`, plus a `test`
scratch method. Both were removed. They predate LSP integration and are
functionally superseded by the `4dlsp` skill, which checks syntax
directly and needs no startup method, no launch of the project, and no
data file:

```sh
tools/4dlsp/tool4d-lsp-stdio check-syntax --workspace Project/
```

Do not reintroduce syntax checking or test running by injecting a method
into this project. Use `4dlsp`.
