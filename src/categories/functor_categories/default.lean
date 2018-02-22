-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Tim Baumann, Stephen Morgan, Scott Morrison

import ..natural_transformation

open categories
open categories.isomorphism
open categories.functor
open categories.natural_transformation

namespace categories.functor_categories

universes u₁ u₂ u₃

instance FunctorCategory (C : Type (u₁+1)) [category C] (D : Type (u₂+1)) [category D] : category.{(max (u₁+1) u₂)} (C ↝ D) := {
  Hom := λ F G, F ⟹ G,
  identity := λ F, 1,
  compose  := λ _ _ _ α β, α ⊟ β
}

definition whiskering_on_left (C : Type (u₁+1)) [category C] (D : Type (u₂+1)) [category D] (E : Type (u₃+1)) [category E] : (C ↝ D) ↝ ((D ↝ E) ↝ (C ↝ E)) := {
  onObjects     := λ F, {
    onObjects     := λ G, F ⋙ G,
    onMorphisms   := λ _ _ α, whisker_on_left F α
 },
  onMorphisms   := λ F G τ, {
    components := λ H, {
      components := λ c, H &> (τ.components c)
   }
 }
}

definition whisker_on_left_functor {C : Type (u₁+1)} [category C] {D : Type (u₂+1)} [category D] (F : Functor C D) (E : Type (u₃+1)) [category E] : 
    Functor (Functor D E) (Functor C E) :=
  (whiskering_on_left C D E) F

definition whiskering_on_right (C : Type (u₁+1)) [category C] (D : Type (u₂+1)) [category D] (E : Type (u₃+1)) [category E] :
    Functor (Functor D E) (Functor (Functor C D) (Functor C E)) :=
{
  onObjects     := λ H, {
    onObjects     := λ F, FunctorComposition F H,
    onMorphisms   := λ _ _ α, whisker_on_right α H,
 },
  onMorphisms   := λ G H τ, {
    components := λ F, {
      components := λ c, τ.components (F c)
   }
 }
}

definition whisker_on_right_functor (C : Type (u₁+1)) [category C] {D : Type (u₂+1)} [category D] {E : Type (u₃+1)} [category E] (H : Functor D E) :
  Functor (Functor C D) (Functor C E) :=
(whiskering_on_right C D E) H

variable {C : Type (u₁+1)}
variable [category C]
variable {D : Type (u₂+1)}
variable [category D]
variable {E : Type (u₃+1)}
variable [category E]

@[ematch] lemma NaturalTransformation_to_FunctorCategory.components_naturality
  {F G : Functor C (Functor D E)}
  (T : NaturalTransformation F G) 
  (X : C)
  {Y Z : D}
  (f : Hom Y Z)
    : ((F X) &> f) ≫ ((T.components X).components Z) =
    ((T.components X).components Y) ≫ ((G X) &> f) :=
begin
  exact (T.components _).naturality _
end

@[ematch] lemma NaturalTransformation_to_FunctorCategory.naturality_components
  {F G : Functor C (Functor D E)}
  (T : NaturalTransformation F G) 
  (Z : D)
  {X Y : C}
  (f : Hom X Y)
  : ((F &> f).components Z) ≫ ((T.components Y).components Z) =
    ((T.components X).components Z) ≫ ((G &> f).components Z) :=
begin
  have p := T.naturality _,
  have q := congr_arg NaturalTransformation.components p,
  tidy,
end

end categories.functor_categories
