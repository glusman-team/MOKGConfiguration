# MOKG Configuration

**Generated:** 2026-03-01
**Commit:** c8bb97a
**Purpose:** Tablassert TC3 table configurations for MicrobiomeKG and MultiomicsKG knowledge graphs

## OVERVIEW
YAML-based table configurations using TC3 format for extracting knowledge graph assertions from research publications. Configs are processed by Tablassert and deployed to NCATS Translator ecosystem via PloverDB.

## STRUCTURE
```
./
├── GRAPH/          # Graph-level orchestration configs
├── TABLE/          # Individual table configurations
│   ├── MBKG/        # MicrobiomeKG tables (53 files)
│   ├── MIGRATASSERT/  # Migration-related assertions (49 files)
│   ├── MOKG/         # MultiomicsKG tables (21 files)
│   └── V6/           # V6 build tables (7 files)
└── README.md
```

## WHERE TO LOOK
| Task | Location |
|------|----------|
| MicrobiomeKG tables | `TABLE/MBKG/` |
| Migration assertions | `TABLE/MIGRATASSERT/` |
| MultiomicsKG tables | `TABLE/MOKG/` |
| Graph orchestration | `GRAPH/V6/MOKGV6.yaml` |

## TC3 CONFIG FORMAT

**Required fields:**
```yaml
template:
  syntax: TC3
  source:
    kind: excel|text
    url: <download URL>
    local: <cached file path>
    sheet: <sheet name>         # excel only
    row_slice: [start, auto]       # optional
  statement:
    subject:
      method: column|value
      encoding: <column name or literal>
      prioritize: [Biolink categories]
      remove: [regex patterns]
      regex: [{pattern, replacement}]
    predicate: <Biolink predicate>
    object:
      method: column|value
      encoding: <column name or literal>
      prioritize: [Biolink categories]
  provenance:     # NOTE: spelled "provenance" in this project
    repo: PMC|PUBMED|DOI
    publication: <identifier>
    contributors:
      - kind: curation|validation|tool
        name: <curator name>
        date: <date>
  annotations:
    - annotation: <attribute name>
      method: column|value
      encoding: <column name or literal>
```

**NodeEncoding options:**
- `taxon: <int>` - NCBI Taxon ID for filtering (9606=human, 10090=mouse)
- `explode_by: <delimiter>` - Split delimited values into separate edges
- `fill: forward|backward|min|max|mean|zero|one` - Null handling strategy

## CONVENTIONS
- **Source URLs:** Point to PMC/DOI for published data
- **Local paths:** Relative to `./DATALAKE/` (not present in repo)
- **Provenance spelling:** Uses `provenance:` (not `provenance`)
- **Curation metadata:** Always include contributor with name + date + organization

## ANTI-PATTERNS
- Missing `provenance:` section → invalid configuration
- Using `provenance:` (standard spelling) instead of `provenance:`

## COMMANDS
No build/test commands - YAML files consumed directly by Tablassert.

## NOTES
- Configs use PMC article IDs for publication references
- Taxon filtering available via `taxon:` field
- Regex transformations apply in order
- Annotation examples: p-value, sample size, correction method, relationship strength
