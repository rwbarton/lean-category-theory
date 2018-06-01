-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Stephen Morgan, Scott Morrison

import categories.products

open categories
open categories.functor
open categories.natural_transformation

namespace categories.products

universes u₁
variable (C : Type (u₁+1))
variable [large_category C]
variable (D : Type (u₁+1))
variable [large_category D]
variable (E : Type (u₁+1))
variable [large_category E]

-- PROJECT; by aggressively allowing "assumption" we could do this completely automatically
-- locally tag "assumption" with @[tidy]?
-- or define an aggressive version of tidy (perhaps "follow_your_nose"?)
definition ProductCategoryAssociator : ((C × D) × E) ↝ (C × (D × E)) :=
{ onObjects     := λ X, (X.1.1, (X.1.2, X.2)),
  onMorphisms   := λ _ _ f, (f.1.1, (f.1.2, f.2)) }

definition ProductCategoryInverseAssociator : (C × (D × E)) ↝ ((C × D) × E) :=
{ onObjects     := λ X, ((X.1, X.2.1), X.2.2),
  onMorphisms   := λ _ _ f, ((f.1, f.2.1), f.2.2) }

-- TODO prove the equivalence, now
-- TODO pentagon natural transformation? satisfying?

end categories.products
