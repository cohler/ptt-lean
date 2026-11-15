# ptt-lean

Lean 4 formalization of the Physical Tether Theorem.

**Paper:** Cohler, J. *The Physical Tether Theorem.*
[papers.jcohler.com/ptt/](https://papers.jcohler.com/ptt/)

![Lean build](https://github.com/cohler/ptt-lean/actions/workflows/lean_action_ci.yml/badge.svg)

## What is verified

The file [`Ptt/PhysicalTetherTheorem.lean`](Ptt/PhysicalTetherTheorem.lean)
contains the Lean 4 formalization of the paper. The Lean kernel accepts
every proof. Verified items:

| Paper                                   | Lean name                       |
|-----------------------------------------|---------------------------------|
| Lemma 1  (Separation)                   | `separation`                    |
| Theorem 1  (Physical Tether)            | `physical_tether`               |
| Theorem 1 corollary `V ↔ T`             | `valid_iff_tethered`            |
| Theorem 2(a)  (Pointwise non-aggregation) | `non_aggregation_pointwise`   |
| Theorem 2(b)  (`M = ∅`)                 | `non_aggregation_empty`         |
| Theorem 3  (Thermodynamic application)  | `thermodynamic_application`     |
| Corollary 1                             | `corollary_one`                 |

Full paper-to-Lean mapping with line numbers and notation notes:
[`CORRESPONDENCE.md`](CORRESPONDENCE.md).

## Axioms

The two main theorems reduce to the three standard Lean kernel axioms
and nothing else:

```
'PTT.physical_tether'           depends on axioms: [propext, Classical.choice, Quot.sound]
'PTT.thermodynamic_application' depends on axioms: [propext, Classical.choice, Quot.sound]
```

`propext` is propositional extensionality. `Classical.choice` is classical
choice. `Quot.sound` is the soundness of quotient types. These are the
standard foundations of classical mathematics in Lean 4.

## What Lean certifies, and what the paper justifies outside Lean

The Lean formalization encodes the physics content of Theorem 2(a) as the
explicit hypothesis `RequiresGlobalScalar`. Lean then derives Theorem 2(b)
and Theorem 3 from this hypothesis together with `NonEquilibrium`.

The paper justifies `RequiresGlobalScalar` from the zeroth law and the
geometry of interface contact in the section on Theorem 2(a). Lean
certifies the implication; the paper justifies the premise.

See [`CORRESPONDENCE.md`](CORRESPONDENCE.md) for the full scope statement.

## Reproducing the verification

Install the Lean toolchain manager, clone this repository, pull the
Mathlib build cache, and run `lake build`:

```
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y
source $HOME/.elan/env
git clone https://github.com/cohler/ptt-lean.git
cd ptt-lean
lake exe cache get
lake build
```

Expected final line: `Build completed successfully`.

Every push to `main` also re-runs this build on a fresh GitHub Actions
Ubuntu runner with no cached state from the author. The badge at the top
reports the current status.

## Versioning

Tag `v1.0` pins this repository's state to the version referenced in the
paper. Subsequent revisions bump the tag.

## Toolchain

- Lean 4 (version pinned in [`lean-toolchain`](lean-toolchain))
- Mathlib (revision pinned in [`lake-manifest.json`](lake-manifest.json))
