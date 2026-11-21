# Paper ↔ Lean Correspondence

**Paper:** Cohler, J. *The Physical Tether Theorem.* The exact version this
file documents is [`paper/physical-tether-theorem.pdf`](paper/physical-tether-theorem.pdf)
in this repository. The current version is at papers.jcohler.com/ptt/.
**Formalization:** this repository, file `Ptt/PhysicalTetherTheorem.lean`.

Each numbered item in the paper maps to the Lean declaration named below.
Every mapping can be audited by comparing the paper's statement to the
cited Lean line. Line links open the Lean source in the same version of
this repository you are viewing.

## Framework (Definitions 1-10)

| Paper                                   | Lean declaration             | Line |
|-----------------------------------------|------------------------------|------|
| Def. 1  Physical state space `S ⊆ PR`   | `S : Type*` (implicit binder `{S R : Type*}`) | n/a  |
| Def. 2  Representation space `R_A`      | `R : Type*` (implicit binder `{S R : Type*}`) | n/a  |
| Def. 3  Admissible operational mappings | `M : Set (S → R)` (explicit argument) | first use [20](Ptt/PhysicalTetherTheorem.lean#L20) |
| Def. 4  Symmetry quotient `Q_A`         | `Q (R) (symA)`               | [13](Ptt/PhysicalTetherTheorem.lean#L13)   |
| Def. 4  Canonical quotient map `q_A`    | `q (symA)`                   | [15](Ptt/PhysicalTetherTheorem.lean#L15)   |
| Def. 5  Equivalence of mappings `≈_A`   | `equivMap`                   | [24](Ptt/PhysicalTetherTheorem.lean#L24)   |
| Def. 6  Induced quotient map `φ̄`        | `ind`                        | [17](Ptt/PhysicalTetherTheorem.lean#L17)   |
| Def. 6  Family `𝓜̄_A`                    | `indM`                       | [20](Ptt/PhysicalTetherTheorem.lean#L20)   |
| Def. 7  Admissible predicate            | `AP`                         | [27](Ptt/PhysicalTetherTheorem.lean#L27)   |
| Def. 8  Useful probe `U(A, PR; S)`      | `Useful`                     | [29](Ptt/PhysicalTetherTheorem.lean#L29)   |
| Def. 9  Valid probe `V(A, PR; S)`       | `Valid`                      | [35](Ptt/PhysicalTetherTheorem.lean#L35)   |
| Def. 10 Tethered `T(A, PR; S)`          | `Tethered`                   | [38](Ptt/PhysicalTetherTheorem.lean#L38)   |

**Reading notes.**

- Def. 3 (ii) (admissibility conditions) is carried by the external set
  `M`. The Lean formalization leaves the admissibility criterion as
  parameter data; what the paper calls "admissibility conditions" are
  whatever predicate selects the elements of `M`. The theorems hold for
  any such `M`.
- Def. 7's "every Boolean function on `Q_A`" (Remark 3) is captured
  directly by giving `AP` the type `Q R symA → Bool`, so every function
  of that type is admissible.
- Def. 10's "`|𝓜̄_A| = 1`" is written out as
  `∃ fbar, fbar ∈ indM symA M ∧ ∀ gbar, gbar ∈ indM symA M → gbar = fbar`
  on lines [39](Ptt/PhysicalTetherTheorem.lean#L39)-[40](Ptt/PhysicalTetherTheorem.lean#L40). Equivalent to "the set is a singleton" by definition.

## Lemma and theorems

| Paper                           | Lean declaration              | Line |
|---------------------------------|-------------------------------|------|
| Lemma 1  Separation             | `separation`                  | [44](Ptt/PhysicalTetherTheorem.lean#L44)   |
| Theorem 1  Physical Tether      | `physical_tether`             | [59](Ptt/PhysicalTetherTheorem.lean#L59)   |
| Theorem 1 corollary  `V ↔ T`    | `valid_iff_tethered`          | [79](Ptt/PhysicalTetherTheorem.lean#L79)   |
| Assumption 1  Non-equilibrium   | `NonEquilibrium`              | [87](Ptt/PhysicalTetherTheorem.lean#L87)   |
| Assumption 2  Aggregator needed | `RequiresGlobalScalar`        | [97](Ptt/PhysicalTetherTheorem.lean#L97)   |
| Theorem 2(a)  Pointwise         | `non_aggregation_pointwise`   | [90](Ptt/PhysicalTetherTheorem.lean#L90)   |
| Theorem 2(b)  `M = ∅`           | `non_aggregation_empty`       | [102](Ptt/PhysicalTetherTheorem.lean#L102)  |
| Theorem 3  Thermodynamic appl.  | `thermodynamic_application`   | [119](Ptt/PhysicalTetherTheorem.lean#L119)  |
| Corollary 1                     | `corollary_one`               | [133](Ptt/PhysicalTetherTheorem.lean#L133)  |

## Scope statement for Theorem 2

The paper's Theorem 2(a) is a physics argument. It uses the zeroth law of
thermodynamics and the Clausius form of the second law, applied to the
geometry of interface contact, to show that for a
macroscopic non-equilibrium system no scalar `T*` is a temperature of the
system.

The Lean formalization does not re-derive the physics inside the kernel.
It encodes the physics content as the explicit hypothesis
`RequiresGlobalScalar`:

> An admissible mapping for an intensive global construct must, in every
> state `s`, agree with a scalar `T_star` equal to the local intensive
> field at every point of `Ω`.

Theorem 2(b) in Lean (`non_aggregation_empty`) then follows from
`NonEquilibrium` plus `RequiresGlobalScalar` by simple inference:
if the field is non-constant, no such scalar exists, hence `M = ∅`.

**What Lean certifies:** the implication from `NonEquilibrium` and
`RequiresGlobalScalar` to `M = ∅`, and from there (via Theorem 1) to
`¬ Tethered` and `¬ Valid`.

**What the paper justifies outside Lean:** that `RequiresGlobalScalar`
is the correct reading of what an intensive global construct requires,
and that any such construct on a non-equilibrium system cannot satisfy
it. That argument is the proof of Theorem 2(a) in Section 3 of the
paper.

## Axioms

Running `#print axioms` on the two main theorems produces:

```
'PTT.physical_tether'         depends on axioms: [propext, Classical.choice, Quot.sound]
'PTT.thermodynamic_application' depends on axioms: [propext, Classical.choice, Quot.sound]
```

These are the three standard Lean kernel axioms: propositional
extensionality, classical choice, and well-definedness of quotient types.
Nothing beyond classical mathematics.

## Reproducing the verification

```
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y
source $HOME/.elan/env
git clone https://github.com/cohler/ptt-lean.git
cd ptt-lean
lake exe cache get
lake build
```

Expected final line: `Build completed successfully`. Every proof in
`Ptt/PhysicalTetherTheorem.lean` has been accepted by the Lean 4 kernel.

## Continuous verification

Every push to `main` re-runs `lake build` on a fresh GitHub Actions
Ubuntu runner with no cached state from this repository's author. Status:

![Lean build](https://github.com/cohler/ptt-lean/actions/workflows/lean_action_ci.yml/badge.svg)
