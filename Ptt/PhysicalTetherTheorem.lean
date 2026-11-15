import Mathlib.Data.Set.Basic
import Mathlib.Data.Set.Image
import Mathlib.Order.Setoid.Basic
import Mathlib.Data.Quot
import Mathlib.Data.Real.Basic

set_option linter.style.header false

namespace PTT

/-! ## §1  Abstract framework (Definitions 1-10) -/

abbrev Q (R : Type*) (symA : Setoid R) : Type _ := Quotient symA

def q {R : Type*} (symA : Setoid R) : R → Q R symA := Quotient.mk symA

def ind {S R : Type*} (symA : Setoid R) (φ : S → R) : S → Q R symA :=
  fun s => Quotient.mk symA (φ s)

def indM {S R : Type*} (symA : Setoid R) (M : Set (S → R)) :
    Set (S → Q R symA) :=
  (ind symA) '' M

def equivMap {S R : Type*} (symA : Setoid R) (φ ψ : S → R) : Prop :=
  ind symA φ = ind symA ψ

abbrev AP (R : Type*) (symA : Setoid R) : Type _ := Q R symA → Bool

def Useful {S R : Type*} (symA : Setoid R) (M : Set (S → R)) : Prop :=
  M.Nonempty ∧
    ∀ (s : S) (P : AP R symA) ⦃φ ψ : S → R⦄,
      φ ∈ M → ψ ∈ M →
      P (ind symA φ s) = P (ind symA ψ s)

def Valid {S R : Type*} (symA : Setoid R) (M : Set (S → R)) : Prop :=
  Useful symA M

def Tethered {S R : Type*} (symA : Setoid R) (M : Set (S → R)) : Prop :=
  ∃ fbar : S → Q R symA,
    fbar ∈ indM symA M ∧ ∀ gbar, gbar ∈ indM symA M → gbar = fbar

/-! ## §2  Separation Lemma (Lemma 1) -/

theorem separation {R : Type*} (symA : Setoid R)
    (x y : Q R symA) (hxy : x ≠ y) :
    ∃ P : AP R symA, P x ≠ P y := by
  classical
  refine ⟨fun z => decide (z = x), ?_⟩
  have h1 : decide (x = x) = true  := by simp
  have h2 : decide (y = x) = false := by
    have hyx : y ≠ x := Ne.symm hxy
    simp [hyx]
  change decide (x = x) ≠ decide (y = x)
  rw [h1, h2]
  decide

/-! ## §3  Physical Tether Theorem (Theorem 1) -/

theorem physical_tether {S R : Type*} (symA : Setoid R) (M : Set (S → R)) :
    Useful symA M ↔ Tethered symA M := by
  constructor
  · rintro ⟨hne, hinv⟩
    obtain ⟨φ₀, hφ₀M⟩ := hne
    refine ⟨ind symA φ₀, ⟨φ₀, hφ₀M, rfl⟩, ?_⟩
    rintro gbar ⟨φ, hφM, rfl⟩
    funext s
    by_contra hne'
    obtain ⟨P, hP⟩ := separation symA _ _ hne'
    exact hP (hinv s P hφM hφ₀M)
  · rintro ⟨fbar0, hmem, huniq⟩
    obtain ⟨φ₀, hφ₀M, hfbar0⟩ := hmem
    refine ⟨⟨φ₀, hφ₀M⟩, ?_⟩
    intro s P φ ψ hφM hψM
    have hφ : ind symA φ = fbar0 := huniq _ ⟨φ, hφM, rfl⟩
    have hψ : ind symA ψ = fbar0 := huniq _ ⟨ψ, hψM, rfl⟩
    have hs : ind symA φ s = ind symA ψ s := by rw [hφ, hψ]
    rw [hs]

theorem valid_iff_tethered {S R : Type*} (symA : Setoid R) (M : Set (S → R)) :
    Valid symA M ↔ Tethered symA M :=
  physical_tether symA M

/-! ## §4  Thermodynamic premises (Assumptions 1-2, Theorem 2) -/

abbrev Field (Ω : Type*) : Type _ := Ω → ℝ

def NonEquilibrium {Ω : Type*} (T : Field Ω) : Prop :=
  ∃ x y : Ω, T x ≠ T y

theorem non_aggregation_pointwise {Ω : Type*} (T : Field Ω)
    (hne : NonEquilibrium T) :
    ¬ ∃ T_star : ℝ, ∀ x : Ω, T x = T_star := by
  rintro ⟨T_star, hall⟩
  obtain ⟨x, y, hxy⟩ := hne
  exact hxy ((hall x).trans (hall y).symm)

def RequiresGlobalScalar {S Ω : Type*} (fieldOf : S → Field Ω)
    (M : Set (S → ℝ)) : Prop :=
  ∀ φ ∈ M, ∀ s : S, ∃ T_star : ℝ,
    φ s = T_star ∧ ∀ x : Ω, fieldOf s x = T_star

theorem non_aggregation_empty {S Ω : Type*} (fieldOf : S → Field Ω)
    (s₀ : S) (hne : NonEquilibrium (fieldOf s₀))
    (M : Set (S → ℝ))
    (hreq : RequiresGlobalScalar fieldOf M) :
    M = ∅ := by
  ext φ
  simp only [Set.mem_empty_iff_false, iff_false]
  intro hφ
  obtain ⟨T_star, _, hall⟩ := hreq φ hφ s₀
  exact non_aggregation_pointwise (fieldOf s₀) hne ⟨T_star, hall⟩

/-! ## §5  Thermodynamic Application (Theorem 3, Corollary 1) -/

def eqSetoid (α : Type*) : Setoid α where
  r     := Eq
  iseqv := ⟨Eq.refl, Eq.symm, Eq.trans⟩

theorem thermodynamic_application {S Ω : Type*} (fieldOf : S → Field Ω)
    (s₀ : S) (hne : NonEquilibrium (fieldOf s₀))
    (M : Set (S → ℝ))
    (hreq : RequiresGlobalScalar fieldOf M) :
    ¬ Tethered (eqSetoid ℝ) M ∧ ¬ Valid (eqSetoid ℝ) M := by
  have hM : M = ∅ := non_aggregation_empty fieldOf s₀ hne M hreq
  refine ⟨?_, ?_⟩
  · rintro ⟨_fbar, ⟨φ, hφM, _⟩, _⟩
    rw [hM] at hφM
    simp [Set.mem_empty_iff_false] at hφM
  · rintro ⟨⟨φ, hφM⟩, _⟩
    rw [hM] at hφM
    simp [Set.mem_empty_iff_false] at hφM

theorem corollary_one {S Ω : Type*} (fieldOf : S → Field Ω)
    (s₀ : S) (hne : NonEquilibrium (fieldOf s₀))
    (M : Set (S → ℝ))
    (hreq : RequiresGlobalScalar fieldOf M) :
    ¬ Valid (eqSetoid ℝ) M :=
  (thermodynamic_application fieldOf s₀ hne M hreq).2

end PTT

#print axioms PTT.physical_tether
#print axioms PTT.thermodynamic_application

