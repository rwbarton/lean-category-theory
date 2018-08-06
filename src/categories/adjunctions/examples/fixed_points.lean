-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Scott Morrison

import categories.adjunctions
import categories.full_subcategory

open category_theory
open category_theory.types

namespace category_theory.adjunctions

universe u

variable {C : Type (u+1)}
variable [large_category C]
variable {D : Type (u+1)}
variable [large_category D]

-- EXERCISE
-- cf Leinster 2.2.11
definition left_fixed_points  {L : C ↝ D} {R : D ↝ C} (A : Adjunction L R)
  : large_category (Σ X : C, is_Isomorphism (A.unit.components X)) := by apply_instance
definition right_fixed_points {L : C ↝ D} {R : D ↝ C} (A : Adjunction L R)
  : large_category (Σ X : D, is_Isomorphism (A.counit.components X)) := by apply_instance

-- Now we need to express the idea that functors restrict to a full subcategory with image in another full subcategory,
-- and that these restrictions give an equivalence.

end category_theory.adjunctions