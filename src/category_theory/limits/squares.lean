-- Copyright (c) 2018 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Scott Morrison, Reid Barton, Mario Carneiro

import category_theory.limits.shape

open category_theory

namespace category_theory.limits

universes u v w

variables {C : Type u} [𝒞 : category.{u v} C]
include 𝒞

section pullback
variables {Y₁ Y₂ Z : C} {r₁ : Y₁ ⟶ Z} {r₂ : Y₂ ⟶ Z} 
structure is_pullback (t : square r₁ r₂) :=
(lift : ∀ (s : square r₁ r₂), s.X ⟶ t.X)
(fac₁ : ∀ (s : square r₁ r₂), (lift s ≫ t.π₁) = s.π₁ . obviously)
(fac₂ : ∀ (s : square r₁ r₂), (lift s ≫ t.π₂) = s.π₂ . obviously)
(uniq : ∀ (s : square r₁ r₂) (m : s.X ⟶ t.X) (w₁ : (m ≫ t.π₁) = s.π₁) (w₂ : (m ≫ t.π₂) = s.π₂), m = lift s . obviously)

restate_axiom is_pullback.fac₁
attribute [simp,search] is_pullback.fac₁_lemma
restate_axiom is_pullback.fac₂
attribute [simp,search] is_pullback.fac₂_lemma
restate_axiom is_pullback.uniq
attribute [search, back'] is_pullback.uniq_lemma

@[extensionality] lemma is_pullback.ext {t : square r₁ r₂} (P Q : is_pullback t) : P = Q :=
begin cases P, cases Q, obviously end

lemma is_pullback.univ {t : square r₁ r₂} (h : is_pullback t) (s : square r₁ r₂) (φ : s.X ⟶ t.X) : 
  (φ ≫ t.π₁ = s.π₁ ∧ φ ≫ t.π₂ = s.π₂) ↔ (φ = h.lift s) :=
begin
obviously
end

def is_pullback.of_lift_univ {t : square r₁ r₂}
  (lift : Π (s : square r₁ r₂), s.X ⟶ t.X)
  (univ : Π (s : square r₁ r₂) (φ : s.X ⟶ t.X), (φ ≫ t.π₁ = s.π₁ ∧ φ ≫ t.π₂ = s.π₂) ↔ (φ = lift s)) : 
  is_pullback t :=
{ lift := lift,
  fac₁ := λ s, ((univ s (lift s)).mpr (eq.refl (lift s))).left,
  fac₂ := λ s, ((univ s (lift s)).mpr (eq.refl (lift s))).right,
  uniq := begin obviously, apply univ_s_m.mp, obviously, end }

end pullback


section pushout
variables {Y₁ Y₂ Z : C}
structure is_pushout {r₁ : Z ⟶ Y₁} {r₂ : Z ⟶ Y₂} (t : cosquare r₁ r₂) :=
(desc : ∀ (s : cosquare r₁ r₂), t.X ⟶ s.X)
(fac₁ : ∀ (s : cosquare r₁ r₂), (t.ι₁ ≫ desc s) = s.ι₁ . obviously)
(fac₂ : ∀ (s : cosquare r₁ r₂), (t.ι₂ ≫ desc s) = s.ι₂ . obviously)
(uniq : ∀ (s : cosquare r₁ r₂) (m : t.X ⟶ s.X) (w₁ : (t.ι₁ ≫ m) = s.ι₁) (w₂ : (t.ι₂ ≫ m) = s.ι₂), m = desc s . obviously)

restate_axiom is_pushout.fac₁
attribute [simp,search] is_pushout.fac₁_lemma
restate_axiom is_pushout.fac₂
attribute [simp,search] is_pushout.fac₂_lemma
restate_axiom is_pushout.uniq
attribute [search, back'] is_pushout.uniq_lemma

@[extensionality] lemma is_pushout.ext {r₁ : Z ⟶ Y₁} {r₂ : Z ⟶ Y₂} {t : cosquare r₁ r₂} (P Q : is_pushout t) : P = Q :=
begin cases P, cases Q, obviously end

lemma is_pushout.univ {r₁ : Z ⟶ Y₁} {r₂ : Z ⟶ Y₂} {t : cosquare r₁ r₂} (h : is_pushout t) (s : cosquare r₁ r₂) (φ : t.X ⟶ s.X) : (t.ι₁ ≫ φ = s.ι₁ ∧ t.ι₂ ≫ φ = s.ι₂) ↔ (φ = h.desc s) :=
begin
obviously
end

def is_pushout.of_desc_univ {r₁ : Z ⟶ Y₁} {r₂ : Z ⟶ Y₂} {t : cosquare r₁ r₂}
  (desc : Π (s : cosquare r₁ r₂), t.X ⟶ s.X)
  (univ : Π (s : cosquare r₁ r₂) (φ : t.X ⟶ s.X), (t.ι₁ ≫ φ = s.ι₁ ∧ t.ι₂ ≫ φ = s.ι₂) ↔ (φ = desc s)) : is_pushout t :=
{ desc := desc,
  fac₁ := λ s, ((univ s (desc s)).mpr (eq.refl (desc s))).left,
  fac₂ := λ s, ((univ s (desc s)).mpr (eq.refl (desc s))).right,
  uniq := begin obviously, apply univ_s_m.mp, obviously, end }


end pushout


variable (C)

class has_pullbacks :=
(pullback : Π {Y₁ Y₂ Z : C} (r₁ : Y₁ ⟶ Z) (r₂ : Y₂ ⟶ Z), square r₁ r₂)
(is_pullback : Π {Y₁ Y₂ Z : C} (r₁ : Y₁ ⟶ Z) (r₂ : Y₂ ⟶ Z), is_pullback (pullback r₁ r₂) . obviously)

class has_pushouts :=
(pushout : Π {Y₁ Y₂ Z : C} (r₁ : Z ⟶ Y₁) (r₂ : Z ⟶ Y₂), cosquare r₁ r₂)
(is_pushout : Π {Y₁ Y₂ Z : C} (r₁ : Z ⟶ Y₁) (r₂ : Z ⟶ Y₂), is_pushout (pushout r₁ r₂) . obviously)

variable {C}


section
variables [has_pullbacks.{u v} C] {Y₁ Y₂ Z : C} (r₁ : Y₁ ⟶ Z) (r₂ : Y₂ ⟶ Z)

def pullback.square := has_pullbacks.pullback.{u v} r₁ r₂
def pullback := (pullback.square r₁ r₂).X
def pullback.π₁ : pullback r₁ r₂ ⟶ Y₁ := (pullback.square r₁ r₂).π₁
def pullback.π₂ : pullback r₁ r₂ ⟶ Y₂ := (pullback.square r₁ r₂).π₂
def pullback.universal_property : is_pullback (pullback.square r₁ r₂) := has_pullbacks.is_pullback.{u v} C r₁ r₂

@[extensionality] lemma pullback.hom_ext 
  {X : C} (f g : X ⟶ pullback r₁ r₂) 
  (w₁ : f ≫ pullback.π₁ r₁ r₂ = g ≫ pullback.π₁ r₁ r₂) 
  (w₂ : f ≫ pullback.π₂ r₁ r₂ = g ≫ pullback.π₂ r₁ r₂) : f = g :=
begin
  let s : square r₁ r₂ := ⟨ ⟨ X ⟩, f ≫ pullback.π₁ r₁ r₂, f ≫ pullback.π₂ r₁ r₂ ⟩,
  have q := (pullback.universal_property r₁ r₂).uniq s f,
  have p := (pullback.universal_property r₁ r₂).uniq s g,
  rw [q, ←p],
  obviously,
end

end 

end category_theory.limits
