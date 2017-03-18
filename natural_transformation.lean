-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Stephen Morgan, Scott Morrison

import .isomorphism
import .functor

open tqft.categories
open tqft.categories.isomorphism
open tqft.categories.functor

namespace tqft.categories.natural_transformation

structure NaturalTransformation { C D : Category } ( F G : Functor C D ) :=
  (components: Π X : C^.Obj, D^.Hom (F X) (G X))
  (naturality: ∀ { X Y : C^.Obj } (f : C^.Hom X Y),
     D^.compose (F^.onMorphisms f) (components Y) = D^.compose (components X) (G^.onMorphisms f))

attribute [ematch] NaturalTransformation.naturality

-- This defines a coercion so we can write `α X` for `components α X`.
instance NaturalTransformation_to_components { C D : Category } { F G : Functor C D } : has_coe_to_fun (NaturalTransformation F G) :=
{ F   := λ f, Π X : C^.Obj, D^.Hom (F X) (G X),
  coe := NaturalTransformation.components }

-- We'll want to be able to prove that two natural transformations are equal if they are componentwise equal.
@[pointwise] lemma NaturalTransformations_componentwise_equal
  { C D : Category }
  { F G : Functor C D }
  ( α β : NaturalTransformation F G )
  ( w : ∀ X : C^.Obj, α X = β X ) : α = β :=
  begin
    induction α with α_components α_naturality,
    induction β with β_components β_naturality,
    have hc : α_components = β_components, from funext w,
    by subst hc
  end

@[reducible] definition IdentityNaturalTransformation { C D : Category } (F : Functor C D) : NaturalTransformation F F :=
  {
    components := λ X, D^.identity (F X),
    naturality := ♮
  }

@[reducible] definition vertical_composition_of_NaturalTransformations
  { C D : Category }
  { F G H : Functor C D }
  ( α : NaturalTransformation F G )
  ( β : NaturalTransformation G H ) : NaturalTransformation F H :=
  {
    components := λ X, D^.compose (α X) (β X),
    naturality := ♮
  }

open tqft.categories.functor

@[reducible] definition horizontal_composition_of_NaturalTransformations
  { C D E : Category }
  { F G : Functor C D }
  { H I : Functor D E }
  ( α : NaturalTransformation F G )
  ( β : NaturalTransformation H I ) : NaturalTransformation (FunctorComposition F H) (FunctorComposition G I) :=
  {
    components := λ X : C^.Obj, E^.compose (β (F X)) (I^.onMorphisms (α X)),
    naturality := ♮
  }

@[reducible] definition whisker_on_left
  { C D E : Category }
  ( F : Functor C D )
  { G H : Functor D E }
  ( α : NaturalTransformation G H ) :
  NaturalTransformation (FunctorComposition F G) (FunctorComposition F H) :=
  horizontal_composition_of_NaturalTransformations (IdentityNaturalTransformation F) α

@[reducible] definition whisker_on_right
  { C D E : Category }
  { F G : Functor C D }
  ( α : NaturalTransformation F G )
  ( H : Functor D E ) :
  NaturalTransformation (FunctorComposition F H) (FunctorComposition G H) :=
  horizontal_composition_of_NaturalTransformations α (IdentityNaturalTransformation H)

-- To define a natural isomorphism, we'll define the functor category, and ask for an isomorphism there.
-- It's then a lemma that each component is an isomorphism, and vice versa.

@[reducible] definition FunctorCategory ( C D : Category ) : Category :=
{
  Obj := Functor C D,
  Hom := λ F G, NaturalTransformation F G,

  identity := λ F, IdentityNaturalTransformation F,
  compose  := @vertical_composition_of_NaturalTransformations C D,

  left_identity  := ♮,
  right_identity := ♮,
  associativity  := ♮
}

-- TODO This is pure boilerplate! How can we automatically form this lemma? Ideally we'd just annotate a field of FunctorCategory!
@[simp] lemma FunctorCategory_left_identity
  ( C D : Category )
  ( F G : Functor C D ) 
  ( α : NaturalTransformation F G ) : vertical_composition_of_NaturalTransformations (IdentityNaturalTransformation F) α = α := 
    (FunctorCategory C D)^.left_identity α

definition NaturalIsomorphism { C D : Category } ( F G : Functor C D ) := Isomorphism (FunctorCategory C D) F G

-- It's a pity we need to separately define this coercion.
-- Ideally the coercion from Isomorphism along .morphism would just apply here.
-- Somehow we want the definition above to be more transparent?
instance NaturalIsomorphism_coercion_to_NaturalTransformation { C D : Category } ( F G : Functor C D ) : has_coe (NaturalIsomorphism F G) (NaturalTransformation F G) :=
  { coe := Isomorphism.morphism }

open NaturalTransformation

definition is_NaturalIsomorphism { C D : Category } { F G : Functor C D } ( α : NaturalTransformation F G ) := @is_isomorphism (FunctorCategory C D) F G α

lemma IdentityNaturalTransformation_is_NaturalIsomorphism { C D : Category } ( F : Functor C D ) : is_NaturalIsomorphism (IdentityNaturalTransformation F) :=
  { inverse := IdentityNaturalTransformation F,
    witness_1 := ♮,
    witness_2 := ♮
  }


-- Getting this coercion to work is really painful. We shouldn't have to write
--     @components C D F G α X
-- below, but rather just:
--     α X
-- or at least
--     α^.components X


-- lemma components_of_NaturalIsomorphism_are_isomorphisms { C D : Category } { F G : Functor C D } { α : NaturalIsomorphism F G } { X : C^.Obj } :
--  Inverse (@components C D F G α X) :=
--   {
--     inverse := α^.inverse^.components X,
--     witness_1 := α^.witness_1, -- TODO we need to evaluate both sides of this equation at X.
--     witness_2 := sorry
  -- }

end tqft.categories.natural_transformation
